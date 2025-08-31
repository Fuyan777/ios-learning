# SwiftUI初心者向け学習問題

このドキュメントはSwiftUIを使ったiOSアプリ開発の基礎を学ぶための問題集です。
シンプルなコードで基本を学べるように設計されています。

---

## 1. 基本的なビュー

### 問題1-1: TextとButtonを使ってみよう

**作るもの**: 文字とボタンが表示される簡単な画面

**要件**:
1. 画面に「Hello」という文字を表示してください
2. その下に「押してね」というボタンを配置してください
3. ボタンを押したら、Xcodeのコンソール（下部の出力エリア）に「ボタンが押されました」と表示されるようにしてください

**ヒント**: VStackを使うと縦に並べることができます

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello")
            
            Button("押してね") {
                print("ボタンが押されました")
            }
        }
    }
}
```

**解説:**
- `Text("Hello")`: 文字を画面に表示する最も基本的なビューです
- `Button`: ユーザーがタップできるボタンです。第1引数にボタンのラベル、`{ }`の中にタップしたときの処理を書きます
- `print()`: コンソールに文字を出力します（Xcodeの下部に表示されます）

</details>

### 問題1-2: TextFieldとImageを追加しよう

**作るもの**: 名前入力欄とアイコンがある画面

**要件**:
1. 画面の上部に人物アイコン（person.circle）を大きく表示してください
2. その下に名前を入力できるテキストフィールドを配置してください
3. テキストフィールドには「名前を入力」というプレースホルダー（薄い文字のヒント）を表示してください
4. テキストフィールドの周りに枠線をつけてください

**ヒント**: @Stateを使って入力された文字を保存します

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var name = ""
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .font(.largeTitle)
            
            TextField("名前を入力", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
}
```

**解説:**
- `@State`: 画面の状態を保存する特別な変数です。値が変わると画面が自動的に更新されます
- `TextField`: ユーザーが文字を入力できる場所です。`text: $name`で入力された文字が`name`変数に保存されます
- `Image(systemName:)`: Appleが用意しているアイコンを表示します
- `.font(.largeTitle)`: 文字やアイコンのサイズを大きくします

</details>

---

## 2. レイアウト

### 問題2-1: VStackで縦に並べよう

**作るもの**: 3つの文字が縦に並んだ画面

**要件**:
1. 「上」という文字を一番上に表示してください
2. 「真ん中」という文字をその下に表示してください
3. 「下」という文字を一番下に表示してください
4. 3つの文字が縦一列に並ぶようにしてください

**ヒント**: VStackは中に入れたものを縦方向に並べます

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("上")
            Text("真ん中")
            Text("下")
        }
    }
}
```

**解説:**
- `VStack`: Vertical Stack（縦のスタック）の略で、中に入れたビューを縦に並べます
- 上から順番に表示されます

</details>

### 問題2-2: HStackで横に並べよう

**作るもの**: 2つのボタンが横に並んだ画面

**要件**:
1. 「左」というボタンを左側に配置してください
2. 「右」というボタンを右側に配置してください
3. 2つのボタンが横一列に並ぶようにしてください
4. それぞれのボタンを押したら、コンソールに「左のボタン」「右のボタン」と表示してください

**ヒント**: HStackは中に入れたものを横方向に並べます

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            Button("左") {
                print("左のボタン")
            }
            
            Button("右") {
                print("右のボタン")
            }
        }
    }
}
```

**解説:**
- `HStack`: Horizontal Stack（横のスタック）の略で、中に入れたビューを横に並べます
- 左から右へ順番に表示されます

</details>

### 問題2-3: ZStackで重ねよう

**作るもの**: 青い背景の上に白い文字が重なった画面

**要件**:
1. 青い四角形（幅200、高さ100）を背景として配置してください
2. その四角形の上に「SwiftUI」という文字を重ねてください
3. 文字の色は白にしてください
4. 文字のサイズは大きめ（.title）にしてください

**ヒント**: ZStackは重ねて表示したいときに使います。最初に書いたものが奥、後に書いたものが手前になります

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 200, height: 100)
            
            Text("SwiftUI")
                .foregroundColor(.white)
                .font(.title)
        }
    }
}
```

**解説:**
- `ZStack`: Z軸方向（奥行き）にビューを重ねます。最初に書いたものが後ろ、後に書いたものが前に表示されます
- `Rectangle()`: 四角形を描きます
- `.fill(Color.blue)`: 四角形を青色で塗りつぶします
- `.frame(width:height:)`: 大きさを指定します
- `.foregroundColor(.white)`: 文字の色を白にします

</details>

---

## 3. 状態管理（@State）

### 問題3-1: カウンターを作ろう

**作るもの**: 数を数えるカウンターアプリ

**要件**:
1. 画面に現在の数字を大きく表示してください（初期値は0）
2. その下に「カウントアップ」というボタンを配置してください
3. ボタンを押すたびに、表示される数字が1ずつ増えるようにしてください
4. 例：0 → ボタンを押す → 1 → ボタンを押す → 2...

**ヒント**: @Stateで数字を保存し、ボタンが押されたら+1します

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var count = 0
    
    var body: some View {
        VStack {
            Text("\(count)")
                .font(.largeTitle)
            
            Button("カウントアップ") {
                count += 1
            }
        }
    }
}
```

**解説:**
- `@State private var count = 0`: 画面の状態を管理する変数です。初期値は0です
- `Text("\(count)")`: 変数の値を文字として表示します。`\( )`の中に変数を入れます
- `count += 1`: countに1を足します。@Stateがついているので、自動的に画面が更新されます

</details>

### 問題3-2: 表示/非表示を切り替えよう

**作るもの**: 文字の表示と非表示を切り替えるアプリ

**要件**:
1. 「見えています！」という文字を表示してください
2. その下に「切り替え」というボタンを配置してください
3. ボタンを押すと文字が消え、もう一度押すと文字が現れるようにしてください
4. 表示→非表示→表示...と繰り返し切り替えられるようにしてください

**ヒント**: @Stateでtrue/falseを管理し、if文で表示を制御します

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var isShowing = true
    
    var body: some View {
        VStack {
            if isShowing {
                Text("見えています！")
            }
            
            Button("切り替え") {
                isShowing.toggle()
            }
        }
    }
}
```

**解説:**
- `@State private var isShowing = true`: true/falseを保存する変数です
- `if isShowing { }`: isShowingがtrueのときだけ中身を表示します
- `.toggle()`: true/falseを切り替えます（trueならfalseに、falseならtrueに）

</details>

---

## 4. ユーザー入力

### 問題4-1: TextFieldとButtonの組み合わせ

**作るもの**: 挨拶してくれるアプリ

**要件**:
1. 名前を入力するテキストフィールドを配置してください（プレースホルダー：「名前を入力」）
2. その下に「挨拶する」というボタンを配置してください
3. ボタンの下に挨拶文を表示する場所を作ってください
4. ボタンを押すと「こんにちは、〇〇さん」と表示してください（〇〇は入力された名前）
5. 例：「太郎」と入力してボタンを押す→「こんにちは、太郎さん」と表示

**ヒント**: 2つの@State変数（入力用と表示用）を使います

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var name = ""
    @State private var greeting = ""
    
    var body: some View {
        VStack {
            TextField("名前を入力", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("挨拶する") {
                greeting = "こんにちは、\(name)さん"
            }
            
            Text(greeting)
                .padding()
        }
    }
}
```

**解説:**
- 2つの`@State`変数を使っています：`name`（入力用）と`greeting`（表示用）
- `$name`: $をつけることで、TextFieldと変数を連携させます
- ボタンを押すと、nameの値を使ってgreetingを更新します

</details>

### 問題4-2: Toggleでオン/オフ

**作るもの**: 通知設定の画面

**要件**:
1. 「通知を受け取る」というラベル付きのToggleスイッチを配置してください
2. スイッチの下に現在の状態を表示してください
3. スイッチがオンのとき：「通知はオンです」と表示
4. スイッチがオフのとき：「通知はオフです」と表示
5. スイッチを切り替えるたびに、表示が即座に変わるようにしてください

**ヒント**: Toggleの状態は@Stateのtrue/falseで管理します

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var isOn = false
    
    var body: some View {
        VStack {
            Toggle("通知を受け取る", isOn: $isOn)
                .padding()
            
            if isOn {
                Text("通知はオンです")
            } else {
                Text("通知はオフです")
            }
        }
    }
}
```

**解説:**
- `Toggle`: スイッチのようなUIです
- `isOn: $isOn`: Toggleの状態とisOn変数を連携させます
- if-else文で、オン/オフに応じて違うメッセージを表示します

</details>

### 問題4-3: Sliderで値を調整

**作るもの**: 音量調整のような値を調整する画面

**要件**:
1. 現在の値を「値: 50」のように表示してください（初期値は50）
2. その下にスライダーを配置してください
3. スライダーを動かすと0から100の範囲で値が変わるようにしてください
4. スライダーを動かすたびに、上の数字がリアルタイムで更新されるようにしてください
5. 表示する値は整数にしてください（小数点以下は表示しない）

**ヒント**: Sliderは小数を扱うので、Double型の変数を使います

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var value = 50.0
    
    var body: some View {
        VStack {
            Text("値: \(Int(value))")
            
            Slider(value: $value, in: 0...100)
                .padding()
        }
    }
}
```

**解説:**
- `@State private var value = 50.0`: Sliderは小数を扱うので、Double型（50.0）を使います
- `Slider(value: $value, in: 0...100)`: 0から100の範囲で値を調整できます
- `Int(value)`: 小数を整数に変換して表示します

</details>

### 問題4-4: Pickerで選択

**作るもの**: 色を選択する画面

**要件**:
1. 「選んだ色: 赤」のように、現在選択されている色を表示してください
2. その下に「赤」「青」「緑」の3つから選べるPickerを配置してください
3. Pickerはセグメント型（横に並んだボタン型）にしてください
4. 色を選ぶと、上の表示が即座に更新されるようにしてください
5. 初期値は「赤」にしてください

**ヒント**: ForEachを使って選択肢を作ります

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var selectedColor = "赤"
    let colors = ["赤", "青", "緑"]
    
    var body: some View {
        VStack {
            Text("選んだ色: \(selectedColor)")
            
            Picker("色を選ぶ", selection: $selectedColor) {
                ForEach(colors, id: \.self) { color in
                    Text(color)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
    }
}
```

**解説:**
- `let colors = ["赤", "青", "緑"]`: 選択肢のリストです
- `Picker`: 複数の選択肢から1つを選ぶUIです
- `ForEach`: リストの各要素に対して処理を繰り返します
- `.pickerStyle(SegmentedPickerStyle())`: セグメント型の見た目にします

</details>

---

## 5. リスト表示

### 問題5-1: 簡単なListを作ろう

**作るもの**: 果物の一覧を表示する画面

**要件**:
1. 以下の4つの果物をリスト形式で表示してください
   - りんご
   - バナナ
   - オレンジ
   - ぶどう
2. 各項目は1行ずつ表示してください
3. リストはスクロール可能にしてください（項目が多い場合に備えて）

**ヒント**: ListとForEachを組み合わせて使います

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    let fruits = ["りんご", "バナナ", "オレンジ", "ぶどう"]
    
    var body: some View {
        List {
            ForEach(fruits, id: \.self) { fruit in
                Text(fruit)
            }
        }
    }
}
```

**解説:**
- `List`: スクロール可能なリストを作ります
- `ForEach`: 配列の各要素に対してビューを作成します
- `id: \.self`: 各要素を識別するための設定です（文字列の場合は自分自身を使います）

</details>

### 問題5-2: 動的なリスト

**作るもの**: 項目を追加できるリスト

**要件**:
1. 初期状態で「項目1」「項目2」「項目3」の3つをリストに表示してください
2. リストの下に「項目を追加」というボタンを配置してください
3. ボタンを押すたびに「項目4」「項目5」...と番号が増えながら新しい項目が追加されるようにしてください
4. 追加された項目は即座にリストに表示されるようにしてください

**ヒント**: @Stateの配列を使い、.append()で要素を追加します

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var items = ["項目1", "項目2", "項目3"]
    
    var body: some View {
        VStack {
            List {
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
            }
            
            Button("項目を追加") {
                items.append("項目\(items.count + 1)")
            }
            .padding()
        }
    }
}
```

**解説:**
- `@State private var items`: 変更可能な配列にするために@Stateを使います
- `items.append()`: 配列に新しい要素を追加します
- `items.count + 1`: 現在の配列の要素数に1を足して、新しい番号を作ります

</details>

---

## 6. ナビゲーション

### 問題6-1: NavigationViewを使おう

**作るもの**: タイトルバー付きの画面

**要件**:
1. 画面の上部にナビゲーションバー（タイトルバー）を表示してください
2. タイトルは「ホーム」にしてください
3. 画面の中央に「メイン画面」という文字を表示してください

**ヒント**: NavigationViewで全体を囲み、.navigationTitle()でタイトルを設定します

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Text("メイン画面")
                .navigationTitle("ホーム")
        }
    }
}
```

**解説:**
- `NavigationView`: ナビゲーションバー（上部のタイトルバー）を表示します
- `.navigationTitle()`: ナビゲーションバーのタイトルを設定します

</details>

### 問題6-2: NavigationLinkで画面遷移

**作るもの**: 2つの画面を行き来できるアプリ

**要件**:
1. 最初の画面には「最初の画面」というタイトルを付けてください
2. 最初の画面に「次へ」というボタンを配置してください
3. ボタンを押すと2番目の画面に移動するようにしてください
4. 2番目の画面には「2番目」というタイトルを付けてください
5. 2番目の画面には「2番目の画面です」という文字を表示してください
6. 戻るボタンは自動的に表示されるので、作る必要はありません

**ヒント**: 2つ目の画面用に新しいView（SecondView）を作ります

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("次へ", destination: SecondView())
            }
            .navigationTitle("最初の画面")
        }
    }
}

struct SecondView: View {
    var body: some View {
        Text("2番目の画面です")
            .navigationTitle("2番目")
    }
}
```

**解説:**
- `NavigationLink`: タップすると別の画面に移動するボタンです
- `destination:`: 移動先の画面を指定します
- `SecondView`: 別の画面用に新しいViewを作ります
- 戻るボタンは自動的に表示されます

</details>

---

## 7. データバインディング（$記号）

### 問題7-1: 親子ビューでデータ共有

**作るもの**: 入力した文字が別のビューにも反映されるアプリ

**要件**:
1. 親ビュー（ContentView）にテキストフィールドを配置してください
2. その下に子ビュー（ChildView）を配置してください
3. 子ビューには「入力された文字:」というラベルと、入力された文字を大きく表示してください
4. テキストフィールドに文字を入力すると、リアルタイムで子ビューの表示も更新されるようにしてください
5. 例：「Hello」と入力→子ビューにも「Hello」が即座に表示される

**ヒント**: 親ビューは@State、子ビューは@Bindingを使います。$記号でデータを渡します

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var text = ""
    
    var body: some View {
        VStack {
            TextField("文字を入力", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            ChildView(text: $text)
        }
    }
}

struct ChildView: View {
    @Binding var text: String
    
    var body: some View {
        VStack {
            Text("入力された文字:")
            Text(text)
                .font(.title)
        }
    }
}
```

**解説:**
- `@Binding`: 親ビューから渡されたデータを受け取る特別な変数です
- `$text`: $をつけて子ビューに渡すことで、双方向のデータ共有ができます
- 親ビューで入力した文字が、リアルタイムで子ビューにも反映されます

</details>

### 問題7-2: Toggleの状態を共有

**作るもの**: スイッチの状態を別のビューと共有するアプリ

**要件**:
1. 親ビュー（ContentView）に「スイッチ」というラベル付きのToggleを配置してください
2. その下に子ビュー（StatusView）を配置してください
3. 子ビューでは以下のように表示してください：
   - Toggleがオンのとき：緑色で「オンです」
   - Toggleがオフのとき：赤色で「オフです」
4. Toggleを切り替えると、子ビューの表示も即座に切り替わるようにしてください

**ヒント**: Bool型の@Bindingで状態を共有します

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var isOn = false
    
    var body: some View {
        VStack {
            Toggle("スイッチ", isOn: $isOn)
                .padding()
            
            StatusView(isOn: $isOn)
        }
    }
}

struct StatusView: View {
    @Binding var isOn: Bool
    
    var body: some View {
        if isOn {
            Text("オンです")
                .foregroundColor(.green)
        } else {
            Text("オフです")
                .foregroundColor(.red)
        }
    }
}
```

**解説:**
- 親ビューのToggleの状態（isOn）を子ビューと共有しています
- `@Binding var isOn: Bool`: Bool型（true/false）のBindingを受け取ります
- Toggleを切り替えると、子ビューの表示も自動的に変わります

</details>

---

## まとめ

SwiftUIの基本を学びました！覚えておくべきポイント：

1. **ビュー**: Text、Button、TextField、Imageが基本
2. **レイアウト**: VStack（縦）、HStack（横）、ZStack（重ねる）
3. **@State**: 画面の状態を管理する
4. **$記号**: データを双方向で連携させる
5. **List**: 複数のデータを表示する
6. **Navigation**: 画面間を移動する
7. **@Binding**: 親子ビューでデータを共有する

これらの基本を組み合わせることで、様々なアプリを作ることができます！