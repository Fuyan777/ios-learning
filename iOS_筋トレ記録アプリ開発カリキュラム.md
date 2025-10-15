# 初心者向け iOS アプリ開発カリキュラム
## 「筋トレ記録アプリ」を作ろう！

## 🎯 このカリキュラムの目標

SwiftUIを使って、実用的な「筋トレ記録管理アプリ」を作成しながら、iOSアプリ開発の基礎を習得します。

## 💪 作成するアプリについて

### アプリ名：「ジムメモ」

日々の筋トレを記録・管理できるアプリです。以下の機能を段階的に実装していきます

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

#### 🔍 実装の解説

これから作るのは「リスト形式で筋トレ記録を表示する画面」です。まずはサンプルデータを使って、画面の見た目だけを作っていきます。

**ContentView.swift**を以下のように修正：

```swift
import SwiftUI

struct ContentView: View {
    // サンプルデータ（後で本物のデータに置き換える仮のデータ）
    // タプル形式：(種目名, 回数, 重量, 部位)
    let sampleRecords = [
        ("ベンチプレス", 30, 60.0, "胸"),
        ("スクワット", 45, 80.0, "脚"),
        ("デッドリフト", 24, 100.0, "背中")
    ]
    
    var body: some View {
        NavigationView {  // ナビゲーションバーを表示するための枠組み
            List {  // iOSでよく見る縦スクロールのリスト
                // ForEachで配列の要素分だけ繰り返し表示
                ForEach(0..<sampleRecords.count, id: \.self) { index in
                    let record = sampleRecords[index]
                    HStack {  // 横並びのレイアウト
                        VStack(alignment: .leading) {  // 縦並びのレイアウト（左寄せ）
                            Text(record.0)  // 種目名を表示
                                .font(.headline)  // 太字の見出しフォント
                            Text("\(record.1)回 • \(record.2, specifier: "%.1f")kg")
                                .font(.caption)  // 小さめのフォント
                                .foregroundColor(.gray)  // 灰色の文字
                        }
                        
                        Spacer()  // 左右の要素を離して配置
                        
                        Text(record.3)  // 部位を表示
                            .font(.caption)
                            .padding(.horizontal, 8)  // 左右に余白
                            .padding(.vertical, 4)  // 上下に余白
                            .background(Color.blue.opacity(0.2))  // 薄い青の背景
                            .cornerRadius(8)  // 角を丸くする
                    }
                    .padding(.horizontal)  // 行全体に左右の余白
                }
            }
            .navigationTitle("ジムメモ")  // 画面上部のタイトル
        }
    }
}
```

#### 💡 ポイント解説

**1. SwiftUIの基本構造**
- `struct ContentView: View` - これが一つの画面（View）を表します
- `var body: some View` - この中に画面の見た目を書きます

**2. データの持ち方**
- `let sampleRecords` - 今は仮のデータを配列で持っています
- タプル`(種目名, 回数, 重量, 部位)`という形式でデータを格納

**3. レイアウトの組み立て方**
- `NavigationView` → `List` → `ForEach` → `HStack/VStack`という入れ子構造
- 大きな箱の中に小さな箱を入れていくイメージです

**4. 見た目の調整**
- `.font()` - 文字の大きさを変える
- `.foregroundColor()` - 文字の色を変える
- `.padding()` - 余白を追加する
- `.background()` - 背景色を設定する
- `.cornerRadius()` - 角を丸くする

### 1.3 実行確認

Command + Rでアプリを実行し、リストが表示されることを確認します。

---

## 第2章：データモデルの実装

### 2.1 フォルダ構成の準備

プロジェクトナビゲーターで右クリックし、「New Group」を選択して以下のフォルダを作成：
- Models
- Views

### 2.2 WorkoutRecordモデルの作成

#### 🔍 実装の解説

これから作るのは「データの設計図」です。筋トレ記録として保存したい情報（種目名、回数、重量など）をSwiftDataというデータベース機能を使って管理できるようにします。

**Models/WorkoutRecord.swift**を新規作成：

```swift
import SwiftUI
import SwiftData

// @Modelをつけることで、このクラスがデータベースに保存できるようになる
@Model
class WorkoutRecord {
    var id: UUID                // 記録を識別するためのID（自動生成）
    var exercise: String         // 種目名（例：ベンチプレス）
    var totalReps: Int          // 合計回数（例：30回）
    var weight: Double          // 重量（例：60.0kg）
    var bodyPartRaw: String     // 部位を文字列として保存
    var date: Date              // 記録した日時
    
    // 部位の文字列をBodyPart型に変換するための計算プロパティ
    var bodyPart: BodyPart {
        get { BodyPart(rawValue: bodyPartRaw) ?? .chest }
        set { bodyPartRaw = newValue.rawValue }
    }
    
    // 新しい記録を作成するときに使う初期化メソッド
    init(exercise: String, totalReps: Int, weight: Double, bodyPart: BodyPart, date: Date = Date()) {
        self.id = UUID()  // 一意のIDを自動生成
        self.exercise = exercise
        self.totalReps = totalReps
        self.weight = weight
        self.bodyPartRaw = bodyPart.rawValue
        self.date = date  // デフォルトは現在時刻
    }
}

// 筋トレの部位を表す列挙型（選択肢を定義）
enum BodyPart: String, CaseIterable, Codable {
    case chest = "胸"
    case back = "背中"
    case legs = "脚"
    case shoulders = "肩"
    case arms = "腕"
    case abs = "腹筋"
    
    // 各部位に対応する色を定義
    var color: Color {
        switch self {
        case .chest: return .red        // 胸は赤
        case .back: return .blue        // 背中は青
        case .legs: return .green       // 脚は緑
        case .shoulders: return .orange // 肩はオレンジ
        case .arms: return .purple      // 腕は紫
        case .abs: return .yellow       // 腹筋は黄色
        }
    }
}
```

#### 💡 ポイント解説

**1. SwiftDataの基本**
- `@Model` - このマークをつけたクラスは自動的にデータベースに保存できるようになります
- アプリを終了してもデータが残る「永続化」が可能になります

**2. データモデルの設計**
- `class WorkoutRecord` - 筋トレ記録1件分のデータ構造を定義
- 必要な情報（種目名、回数、重量など）をプロパティとして定義

**3. enum（列挙型）の活用**
- `enum BodyPart` - 部位の選択肢を事前に定義
- 間違った値が入らないようにする仕組み
- 各部位に色を関連付けて、見た目もカスタマイズ

**4. 初期化メソッド（init）**
- 新しい記録を作るときの「作成手順書」
- `UUID()` - 各記録に一意のIDを自動で割り当て
- `Date()` - 現在時刻を自動で設定

### 2.3 GymMemoApp.swiftの更新

#### 🔍 実装の解説

アプリ全体でデータベースを使えるようにする設定を行います。これは「アプリの入り口」で、データを保存する仕組みを準備する重要な部分です。

ModelContainerを設定します：

```swift
import SwiftUI
import SwiftData

@main  // このアプリの起動ポイントを示すマーク
struct GymMemoApp: App {
    // データベースの設定（コンテナ = データの保管庫）
    var sharedModelContainer: ModelContainer = {
        // 保存するデータの種類を指定
        let schema = Schema([
            WorkoutRecord.self,  // WorkoutRecordを保存対象に追加
        ])
        // データの保存設定（isStoredInMemoryOnly: falseで永続保存）
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            // データベースコンテナを作成
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // エラーが起きたら、アプリを停止（通常は起きない）
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()  // 最初に表示する画面
        }
        .modelContainer(sharedModelContainer)  // 全画面でデータベースを使えるようにする
    }
}
```

#### 💡 ポイント解説

**1. アプリの構造**
- `@main` - アプリの起動ポイント（エントリーポイント）
- `App` プロトコル - iOSアプリの基本構造を定義

**2. ModelContainerの役割**
- データベースの「保管庫」のようなもの
- アプリ全体で共有して使う
- `isStoredInMemoryOnly: false` - データを永続的に保存（アプリを終了しても残る）

**3. エラーハンドリング**
- `do-try-catch` - エラーが起きた時の対処法
- この設定でエラーが起きることはまれですが、念のため記述

### 2.4 ContentViewをSwiftDataに対応

#### 🔍 実装の解説

サンプルデータから本物のデータベースに切り替えます。SwiftDataの機能を使って、保存された記録を自動的に画面に表示できるようにします。

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    // データベースにアクセスするための「窓口」
    @Environment(\.modelContext) private var modelContext
    
    // データベースから記録を自動取得（新しい順に並べる）
    @Query(sort: \WorkoutRecord.date, order: .reverse) private var records: [WorkoutRecord]
    
    var body: some View {
        NavigationView {
            List {
                // 記録が空の場合の表示
                if records.isEmpty {
                    Text("記録がありません")
                        .foregroundColor(.gray)
                } else {
                    // ForEachで各記録を表示（recordはWorkoutRecord型）
                    ForEach(records) { record in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(record.exercise)  // 種目名
                                    .font(.headline)
                                HStack {
                                    Text("\(record.totalReps)回")
                                    if record.weight > 0 {  // 重量が0より大きい場合のみ表示
                                        Text("• \(record.weight, specifier: "%.1f")kg")
                                    }
                                }
                                .font(.caption)
                                .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            // 部位をタグ風に表示（色付き）
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

#### 💡 ポイント解説

**1. SwiftDataの重要な機能**
- `@Environment(\.modelContext)` - データベースへアクセスする「窓口」
- `@Query` - データベースから自動でデータを取得して画面に反映
- `sort: \.date, order: .reverse` - 日付の新しい順に自動ソート

**2. データの自動更新**
- `@Query`を使うと、データが追加・削除されたら画面が自動で更新される
- 手動で更新処理を書く必要がない（これがSwiftDataの便利な点）

**3. 条件分岐の使い方**
- `if records.isEmpty` - データが0件の時の表示を分ける
- `if record.weight > 0` - 重量が設定されている場合のみ表示

**4. データバインディング**
- `ForEach(records)` - データベースの記録数だけ自動でリストを生成
- サンプルデータから本物のデータへの移行がスムーズ

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

#### 🔍 実装の解説

メイン画面に「＋」ボタンを追加し、タップすると記録追加画面がモーダル（下からスライドして表示）で開くようにします。

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutRecord.date, order: .reverse) private var records: [WorkoutRecord]
    
    // 追加画面の表示状態を管理（false = 非表示、true = 表示）
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
            .toolbar {  // ナビゲーションバーにボタンを追加
                Button(action: {
                    showingAddWorkout = true  // ボタンをタップで追加画面を表示
                }) {
                    Image(systemName: "plus")  // ＋アイコン
                }
            }
            .sheet(isPresented: $showingAddWorkout) {  // モーダル画面の表示
                AddWorkoutView(isPresented: $showingAddWorkout)
            }
        }
    }
}
```

#### 💡 ポイント解説

**1. 画面遷移の仕組み**
- `@State private var showingAddWorkout` - 画面表示のON/OFFを管理
- `.sheet()` - モーダル表示（下からスライドして出てくる画面）
- `$showingAddWorkout` - Binding（親子間で変数を共有）

**2. ツールバーの使い方**
- `.toolbar` - ナビゲーションバーにボタンを配置
- `Image(systemName: "plus")` - システムアイコンを使用

**3. 画面間のデータ受け渡し**
- `isPresented: $showingAddWorkout` - 子画面に表示状態を渡す
- 子画面から`false`にすると、画面が閉じる

### 3.3 実行確認

アプリを実行し、プラスボタンから記録を追加できることを確認します。

---

## 第4章：削除機能と統計画面

### 4.1 削除機能の追加

#### 🔍 実装の解説

リストの項目を左にスワイプして削除できる機能を追加します。iOS標準の削除操作で、直感的に使えるようにします。

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
                    .onDelete(perform: deleteRecords)  // スワイプ削除を有効化
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
    
    // 削除処理を行う関数
    func deleteRecords(at offsets: IndexSet) {
        // 指定された位置の記録を削除
        for index in offsets {
            modelContext.delete(records[index])  // データベースから削除
        }
    }
}
```

#### 💡 ポイント解説

**1. スワイプ削除の仕組み**
- `.onDelete()` - Listの各行にスワイプ削除を追加
- 左スワイプで削除ボタンが表示される
- iOS標準のUIパターンでユーザーに馴染みやすい

**2. 削除処理の流れ**
1. ユーザーが行を左スワイプ
2. 削除ボタンをタップ
3. `deleteRecords()`関数が呼ばれる
4. `modelContext.delete()`でデータベースから削除
5. 画面が自動更新（@Queryの効果）

**3. IndexSetとは**
- 削除する行の位置情報
- 複数選択削除にも対応可能

### 4.2 StatisticsViewの作成

#### 🔍 実装の解説

各部位ごとのトレーニング回数を集計して表示する統計画面を作成します。どの部位をどれだけトレーニングしたか一目で分かるようにします。

**Views/StatisticsView.swift**を新規作成：

```swift
import SwiftUI
import SwiftData

struct StatisticsView: View {
    // データベースから全記録を取得
    @Query private var records: [WorkoutRecord]
    
    var body: some View {
        NavigationView {
            List {
                // 全部位をループで表示
                ForEach(BodyPart.allCases, id: \.self) { part in
                    // その部位の記録だけをフィルタリング
                    let partRecords = records.filter { $0.bodyPart == part }
                    
                    HStack {
                        Text(part.rawValue)  // 部位名
                            .foregroundColor(part.color)  // 部位ごとの色
                        Spacer()
                        Text("\(partRecords.count)回")  // 回数を表示
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("統計")
        }
    }
}
```

#### 💡 ポイント解説

**1. データの集計処理**
- `records.filter { $0.bodyPart == part }` - 特定部位の記録を抽出
- `.count` - 配列の要素数を取得
- リアルタイムで集計結果が更新される

**2. enumの活用**
- `BodyPart.allCases` - 全部位のリストを自動取得
- `CaseIterable`プロトコルの効果
- 部位が増えても自動的に対応

**3. 色分け表示**
- `part.color` - 各部位に割り当てた色を使用
- 視覚的に分かりやすいUI

### 4.3 TabViewの実装

#### 🔍 実装の解説

画面下部にタブバーを追加し、ホーム画面と統計画面を切り替えられるようにします。iPhoneアプリでよく見るナビゲーションパターンです。

ContentView.swiftをTabView対応に変更：

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {  // タブで複数画面を切り替え
            WorkoutHomeView()  // ホーム画面
                .tabItem {  // タブバーの項目
                    Label("ホーム", systemImage: "house.fill")  // アイコンとラベル
                }
            
            StatisticsView()  // 統計画面
                .tabItem {
                    Label("統計", systemImage: "chart.bar.fill")  // グラフアイコン
                }
        }
    }
}
```

#### 💡 ポイント解説

**1. TabViewの構造**
- `TabView` - 複数画面をタブで切り替えるUI
- `.tabItem` - 各タブの見た目を設定
- `Label` - アイコンとテキストを組み合わせ

**2. システムアイコンの使用**
- `systemImage` - Apple提供のアイコンを使用
- "house.fill" - 家のアイコン
- "chart.bar.fill" - グラフのアイコン

**3. 画面の分割**
- ContentView - ナビゲーションの管理
- WorkoutHomeView - ホーム画面の内容
- StatisticsView - 統計画面の内容

### 4.4 WorkoutHomeViewの作成

#### 🔍 実装の解説

元のContentViewの内容を別ファイルに分離します。これにより、各画面の役割が明確になり、コードが整理されます。

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

#### 🔍 実装の解説

リストの各行を独立したコンポーネントとして分離します。これにより、コードの再利用性が高まり、保守がしやすくなります。

**Views/WorkoutRowView.swift**を新規作成：

```swift
import SwiftUI

struct WorkoutRowView: View {
    let record: WorkoutRecord  // 親画面から受け取った記録データ
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(record.exercise)  // 種目名
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
            
            // 部位タグ
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

#### 💡 ポイント解説

**1. コンポーネント化のメリット**
- コードの再利用が可能
- 変更が容易（一箇所を直せば全体に反映）
- テストがしやすい
- コードの見通しが良くなる

**2. Viewの分割方法**
- 表示内容がまとまりを持つ部分を切り出す
- 引数で必要なデータを受け取る
- 元の画面ではこのViewを呼び出すだけ

**3. プロパティの受け渡し**
- `let record: WorkoutRecord` - 親からデータを受け取る
- `let`なので変更不可（読み取り専用）

### 5.2 今日の統計表示を追加

#### 🔍 実装の解説

ホーム画面の上部に「今日のトレーニング統計」を表示します。今日何種目やったか、合計何回やったかが一目で分かるようにします。

WorkoutHomeView.swiftを更新して今日の統計を表示：

```swift
import SwiftUI
import SwiftData

struct WorkoutHomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutRecord.date, order: .reverse) private var records: [WorkoutRecord]
    @State private var showingAddWorkout = false
    
    // 今日の記録だけをフィルタリングする計算プロパティ
    var todaysRecords: [WorkoutRecord] {
        let calendar = Calendar.current  // カレンダー機能を使用
        let today = Date()  // 現在日時
        // 同じ日付の記録を抽出
        return records.filter { calendar.isDate($0.date, inSameDayAs: today) }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 今日の統計カード
                HStack(spacing: 20) {
                    StatCard(
                        value: "\(todaysRecords.count)",  // 今日の種目数
                        label: "種目",
                        color: .blue
                    )
                    
                    StatCard(
                        // reduceで合計回数を計算
                        value: "\(todaysRecords.reduce(0) { $0 + $1.totalReps })",
                        label: "合計回数",
                        color: .green
                    )
                }
                .padding()
                
                // 記録リスト（下半分）
                List {
                    if records.isEmpty {
                        Text("記録がありません")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(records) { record in
                            WorkoutRowView(record: record)  // 切り出したコンポーネントを使用
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

// 統計カードのコンポーネント
struct StatCard: View {
    let value: String  // 表示する数値
    let label: String  // ラベル（「種目」「合計回数」など）
    let color: Color   // カードの色
    
    var body: some View {
        VStack {
            Text(value)
                .font(.largeTitle)  // 大きめのフォント
                .fontWeight(.bold)  // 太字
            Text(label)
                .font(.caption)     // 小さめのフォント
        }
        .frame(maxWidth: .infinity)  // 幅を最大に
        .padding()
        .background(color.opacity(0.1))  // 薄い色の背景
        .cornerRadius(10)  // 角を丸く
    }
}
```

#### 💡 ポイント解説

**1. 計算プロパティの活用**
- `var todaysRecords` - 値が自動で計算されるプロパティ
- データが変わるたびに再計算される
- `Calendar.current` - 日付操作のためのAPI

**2. reduce関数の使い方**
- `reduce(0) { $0 + $1.totalReps }` - 配列の全要素を集計
- `$0` - 現在の合計値
- `$1` - 現在処理中の要素
- 全記録の`totalReps`を合計

**3. VStackとHStackの組み合わせ**
- `VStack(spacing: 0)` - 縦方向に並べる（間隔なし）
- `HStack(spacing: 20)` - 横方向に並べる（20ptの間隔）
- 統計カードとリストを上下に配置

**4. カスタムコンポーネント**
- `StatCard` - 再利用可能な統計カード
- 引数で見た目をカスタマイズ
- 他の統計情報も簡単に追加可能

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