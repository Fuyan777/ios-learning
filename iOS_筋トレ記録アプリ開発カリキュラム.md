# 初心者向け iOS アプリ開発カリキュラム
## 「筋トレ記録アプリ」を作ろう！

## 🎯 このカリキュラムの目標

SwiftUIを使って、実用的な「筋トレ記録管理アプリ」を作成しながら、iOSアプリ開発の基礎を習得します。

## 💪 作成するアプリについて

### アプリ名：「ジムメモ」

日々の筋トレを記録・管理できるアプリです。以下の機能を段階的に実装していきます：

- 筋トレ種目の追加・削除
- 合計回数の記録
- 重量の記録
- 部位別の分類（胸、背中、脚など）
- トレーニング履歴の表示
- 統計表示

## 📚 カリキュラム構成（全5章）

### 第1章：基本的な画面表示（所要時間：2時間）
- プロジェクトの作成
- シンプルな記録リストの表示

### 第2章：データモデルの実装（所要時間：5時間）
- SwiftDataモデルの作成
- データの永続化

### 第3章：記録追加機能（所要時間：5時間）
- AddWorkoutViewの作成
- フォーム入力の実装

### 第4章：削除機能と統計画面（所要時間：5時間）
- 削除機能の実装
- StatisticsViewの作成

### 第5章：UI改善と仕上げ（所要時間：5時間）
- 今日の統計表示
- UIの調整

---

## 第1章：基本的な画面表示

### 1.1 プロジェクトの作成

#### 手順：

1. Xcodeを起動し、「Create New Project」を選択
2. 「iOS」タブから「App」を選択して「Next」
3. 以下の情報を入力：
   - **Product Name**: GymMemo
   - **Team**: None（後で設定可能）
   - **Organization Identifier**: com.example
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Storage**: SwiftData
4. 「Next」をクリックし、保存場所を選択して「Create」

### 1.2 最初の画面を作成

まず、シンプルな記録リストを表示する画面を作成します。

**ContentView.swift**を以下のように修正：

```swift
import SwiftUI

struct ContentView: View {
    // サンプルデータ
    let sampleRecords = [
        ("ベンチプレス", 30, 60.0, "胸"),
        ("スクワット", 45, 80.0, "脚"),
        ("デッドリフト", 24, 100.0, "背中")
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<sampleRecords.count, id: \.self) { index in
                    let record = sampleRecords[index]
                    HStack {
                        VStack(alignment: .leading) {
                            Text(record.0)
                                .font(.headline)
                            Text("\(record.1)回 • \(record.2, specifier: "%.1f")kg")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text(record.3)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("ジムメモ")
        }
    }
}
```

### 1.3 実行確認

Command + Rでアプリを実行し、リストが表示されることを確認します。

---

## 第2章：データモデルの実装

### 2.1 フォルダ構成の準備

プロジェクトナビゲーターで右クリックし、「New Group」を選択して以下のフォルダを作成：
- Models
- Views

### 2.2 WorkoutRecordモデルの作成

**Models/WorkoutRecord.swift**を新規作成：

```swift
import SwiftUI
import SwiftData

@Model
class WorkoutRecord {
    var id: UUID
    var exercise: String
    var totalReps: Int
    var weight: Double
    var bodyPartRaw: String
    var date: Date
    
    var bodyPart: BodyPart {
        get { BodyPart(rawValue: bodyPartRaw) ?? .chest }
        set { bodyPartRaw = newValue.rawValue }
    }
    
    init(exercise: String, totalReps: Int, weight: Double, bodyPart: BodyPart, date: Date = Date()) {
        self.id = UUID()
        self.exercise = exercise
        self.totalReps = totalReps
        self.weight = weight
        self.bodyPartRaw = bodyPart.rawValue
        self.date = date
    }
}

enum BodyPart: String, CaseIterable, Codable {
    case chest = "胸"
    case back = "背中"
    case legs = "脚"
    case shoulders = "肩"
    case arms = "腕"
    case abs = "腹筋"
    
    var color: Color {
        switch self {
        case .chest: return .red
        case .back: return .blue
        case .legs: return .green
        case .shoulders: return .orange
        case .arms: return .purple
        case .abs: return .yellow
        }
    }
}
```

### 2.3 GymMemoApp.swiftの更新

ModelContainerを設定します：

```swift
import SwiftUI
import SwiftData

@main
struct GymMemoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WorkoutRecord.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
```

### 2.4 ContentViewをSwiftDataに対応

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutRecord.date, order: .reverse) private var records: [WorkoutRecord]
    
    var body: some View {
        NavigationView {
            List {
                if records.isEmpty {
                    Text("記録がありません")
                        .foregroundColor(.gray)
                } else {
                    ForEach(records) { record in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(record.exercise)
                                    .font(.headline)
                                HStack {
                                    Text("\(record.totalReps)回")
                                    if record.weight > 0 {
                                        Text("• \(record.weight, specifier: "%.1f")kg")
                                    }
                                }
                                .font(.caption)
                                .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text(record.bodyPart.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(record.bodyPart.color.opacity(0.2))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("ジムメモ")
        }
    }
}
```

### 2.5 実行確認

この時点では「記録がありません」と表示されますが、SwiftDataの連携が完了しています。

---

## 第3章：記録追加機能

### 3.1 AddWorkoutViewの作成

**Views/AddWorkoutView.swift**を新規作成：

```swift
import SwiftUI
import SwiftData

struct AddWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    
    @State private var exercise = ""
    @State private var totalReps = 10
    @State private var weight = 40.0
    @State private var bodyPart: BodyPart = .chest
    
    var body: some View {
        NavigationView {
            Form {
                Section("基本情報") {
                    TextField("種目名", text: $exercise)
                    
                    Picker("部位", selection: $bodyPart) {
                        ForEach(BodyPart.allCases, id: \.self) { part in
                            Text(part.rawValue)
                                .tag(part)
                        }
                    }
                }
                
                Section("記録") {
                    Stepper("合計回数: \(totalReps)", value: $totalReps, in: 1...100)
                    
                    VStack(alignment: .leading) {
                        Text("重量: \(weight, specifier: "%.1f") kg")
                        Slider(value: $weight, in: 0...200, step: 2.5)
                    }
                }
            }
            .navigationTitle("新規記録")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveRecord()
                    }
                    .disabled(exercise.isEmpty)
                }
            }
        }
    }
    
    func saveRecord() {
        let newRecord = WorkoutRecord(
            exercise: exercise,
            totalReps: totalReps,
            weight: weight,
            bodyPart: bodyPart
        )
        modelContext.insert(newRecord)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save: \(error)")
        }
        isPresented = false
    }
}
```

### 3.2 ContentViewに追加ボタンを実装

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutRecord.date, order: .reverse) private var records: [WorkoutRecord]
    @State private var showingAddWorkout = false
    
    var body: some View {
        NavigationView {
            List {
                if records.isEmpty {
                    Text("記録がありません")
                        .foregroundColor(.gray)
                } else {
                    ForEach(records) { record in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(record.exercise)
                                    .font(.headline)
                                HStack {
                                    Text("\(record.totalReps)回")
                                    if record.weight > 0 {
                                        Text("• \(record.weight, specifier: "%.1f")kg")
                                    }
                                }
                                .font(.caption)
                                .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text(record.bodyPart.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(record.bodyPart.color.opacity(0.2))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("ジムメモ")
            .toolbar {
                Button(action: {
                    showingAddWorkout = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView(isPresented: $showingAddWorkout)
            }
        }
    }
}
```

### 3.3 実行確認

アプリを実行し、プラスボタンから記録を追加できることを確認します。

---

## 第4章：削除機能と統計画面

### 4.1 削除機能の追加

ContentView.swiftに削除機能を追加：

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutRecord.date, order: .reverse) private var records: [WorkoutRecord]
    @State private var showingAddWorkout = false
    
    var body: some View {
        NavigationView {
            List {
                if records.isEmpty {
                    Text("記録がありません")
                        .foregroundColor(.gray)
                } else {
                    ForEach(records) { record in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(record.exercise)
                                    .font(.headline)
                                HStack {
                                    Text("\(record.totalReps)回")
                                    if record.weight > 0 {
                                        Text("• \(record.weight, specifier: "%.1f")kg")
                                    }
                                }
                                .font(.caption)
                                .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text(record.bodyPart.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(record.bodyPart.color.opacity(0.2))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    .onDelete(perform: deleteRecords)
                }
            }
            .navigationTitle("ジムメモ")
            .toolbar {
                Button(action: {
                    showingAddWorkout = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView(isPresented: $showingAddWorkout)
            }
        }
    }
    
    func deleteRecords(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(records[index])
        }
    }
}
```

### 4.2 StatisticsViewの作成

**Views/StatisticsView.swift**を新規作成：

```swift
import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Query private var records: [WorkoutRecord]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(BodyPart.allCases, id: \.self) { part in
                    let partRecords = records.filter { $0.bodyPart == part }
                    HStack {
                        Text(part.rawValue)
                            .foregroundColor(part.color)
                        Spacer()
                        Text("\(partRecords.count)回")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("統計")
        }
    }
}
```

### 4.3 TabViewの実装

ContentView.swiftをTabView対応に変更：

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            WorkoutHomeView()
                .tabItem {
                    Label("ホーム", systemImage: "house.fill")
                }
            
            StatisticsView()
                .tabItem {
                    Label("統計", systemImage: "chart.bar.fill")
                }
        }
    }
}
```

### 4.4 WorkoutHomeViewの作成

**Views/WorkoutHomeView.swift**を新規作成（元のContentViewの内容を移動）：

```swift
import SwiftUI
import SwiftData

struct WorkoutHomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutRecord.date, order: .reverse) private var records: [WorkoutRecord]
    @State private var showingAddWorkout = false
    
    var body: some View {
        NavigationView {
            List {
                if records.isEmpty {
                    Text("記録がありません")
                        .foregroundColor(.gray)
                } else {
                    ForEach(records) { record in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(record.exercise)
                                    .font(.headline)
                                HStack {
                                    Text("\(record.totalReps)回")
                                    if record.weight > 0 {
                                        Text("• \(record.weight, specifier: "%.1f")kg")
                                    }
                                }
                                .font(.caption)
                                .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text(record.bodyPart.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(record.bodyPart.color.opacity(0.2))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    .onDelete(perform: deleteRecords)
                }
            }
            .navigationTitle("ジムメモ")
            .toolbar {
                Button(action: {
                    showingAddWorkout = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView(isPresented: $showingAddWorkout)
            }
        }
    }
    
    func deleteRecords(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(records[index])
        }
    }
}
```

### 4.5 実行確認

タブ切り替えと統計表示が動作することを確認します。

---

## 第5章：UI改善と仕上げ

### 5.1 WorkoutRowViewの作成

リストの行を独立したViewにします。

**Views/WorkoutRowView.swift**を新規作成：

```swift
import SwiftUI

struct WorkoutRowView: View {
    let record: WorkoutRecord
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(record.exercise)
                    .font(.headline)
                HStack {
                    Text("\(record.totalReps)回")
                    if record.weight > 0 {
                        Text("• \(record.weight, specifier: "%.1f")kg")
                    }
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(record.bodyPart.rawValue)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(record.bodyPart.color.opacity(0.2))
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}
```

### 5.2 今日の統計表示を追加

WorkoutHomeView.swiftを更新して今日の統計を表示：

```swift
import SwiftUI
import SwiftData

struct WorkoutHomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutRecord.date, order: .reverse) private var records: [WorkoutRecord]
    @State private var showingAddWorkout = false
    
    var todaysRecords: [WorkoutRecord] {
        let calendar = Calendar.current
        let today = Date()
        return records.filter { calendar.isDate($0.date, inSameDayAs: today) }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 今日の統計
                HStack(spacing: 20) {
                    StatCard(
                        value: "\(todaysRecords.count)",
                        label: "種目",
                        color: .blue
                    )
                    
                    StatCard(
                        value: "\(todaysRecords.reduce(0) { $0 + $1.totalReps })",
                        label: "合計回数",
                        color: .green
                    )
                }
                .padding()
                
                // 記録リスト
                List {
                    if records.isEmpty {
                        Text("記録がありません")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(records) { record in
                            WorkoutRowView(record: record)
                        }
                        .onDelete(perform: deleteRecords)
                    }
                }
            }
            .navigationTitle("ジムメモ")
            .toolbar {
                Button(action: {
                    showingAddWorkout = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView(isPresented: $showingAddWorkout)
            }
        }
    }
    
    func deleteRecords(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(records[index])
        }
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}
```

### 5.3 最終調整

アプリ全体の動作を確認し、必要に応じてUIを調整します。

---

## 🎉 おめでとうございます！

各章を通じて、以下のスキルを習得しました

### 第1章で学んだこと
✅ SwiftUIの基本的なView構造
✅ NavigationViewとListの使い方

### 第2章で学んだこと
✅ SwiftDataによるデータモデル定義
✅ @Query、@Environmentの使い方

### 第3章で学んだこと
✅ フォーム入力の実装
✅ シート表示とデータ保存

### 第4章で学んだこと
✅ データの削除機能
✅ TabViewによる画面切り替え

### 第5章で学んだこと
✅ Viewの分割とコンポーネント化
✅ 計算プロパティの活用

### 学習リソース：

- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [SwiftData Documentation](https://developer.apple.com/documentation/swiftdata)
- [Hacking with Swift](https://www.hackingwithswift.com/100/swiftui)

楽しみましょう！💪