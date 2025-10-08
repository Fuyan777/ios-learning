# SwiftUI初心者向け練習問題集

SwiftUIの基礎を実践的に学ぶための問題集です。
簡単なコードから始めて、徐々にスキルアップしていきましょう。

---

## 問題1: Spacerを使った配置

**作るもの**: 画面の上下に要素を離して配置する画面（ヘッダーとフッターのような配置）

**要件**:
1. 画面の構成：
   - 一番上に「トップ」という文字を配置
   - 一番下に「ボトム」という文字を配置
   - 真ん中は何も表示しない（空白のまま）
2. 配置の条件：
   - 「トップ」は画面の上端に寄せる
   - 「ボトム」は画面の下端に寄せる
   - 2つの文字の間は自動的に最大限離れるようにする
3. 使用する要素：
   - VStack（縦に並べる）
   - Spacer（空白を作る）
   - Text（文字を表示）

**ヒント**: Spacer()は利用可能な空間を自動的に埋める特別なビューです。VStackの中に入れると、他の要素を端に押しやります

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("トップ")
            Spacer()
            Text("ボトム")
        }
    }
}
```

**解説:**
- `Spacer()`: 利用可能なスペースを自動的に埋める特別なビューです
- VStackの中でSpacerを使うと、要素を画面の端に寄せることができます
- 複数のSpacerを使うと、均等に空白を分配します

</details>

---

## 問題2: 背景色とパディング

**作るもの**: カラフルなカード風の表示（よくあるカードUIのデザイン）

**要件**:
1. 基本の表示：
   - 画面の中央に「カード」という文字を表示
2. 装飾の追加（以下の順番で適用）：
   - まず、文字の周りに20ポイントの余白（パディング）を追加
   - 次に、余白も含めた全体に黄色の背景を設定
   - 最後に、背景の角を10ポイントの丸みをつける
3. 完成イメージ：
   - 黄色い角丸の四角形の中に「カード」という文字が余白を持って表示される
   - タップできそうなカードのような見た目になる

**ヒント**: 修飾子（.で始まる装飾）の適用順序が重要です。.padding()を先に適用してから.background()を適用すると、余白も含めて背景色がつきます

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("カード")
            .padding(20)
            .background(Color.yellow)
            .cornerRadius(10)
    }
}
```

**解説:**
- `.padding(20)`: ビューの周りに余白を追加します
- `.background(Color.yellow)`: 背景色を設定します
- `.cornerRadius(10)`: 角を丸くします
- 修飾子の順番が重要：paddingを先に適用してから背景を設定します

</details>

---

## 問題3: 色の変更とフォント

**作るもの**: タイトルとサブタイトルがある見出し（記事やセクションの見出しのようなデザイン）

**要件**:
1. テキストの配置：
   - 上段：「メインタイトル」という文字
   - 下段：「サブタイトルです」という文字
   - 2つの文字は縦に並べる（VStack使用）
2. テキストのスタイル：
   - メインタイトル：
     * サイズ：.largeTitle（大きめ）
     * 太さ：.bold()（太字）
     * 色：青色（.blue）
   - サブタイトル：
     * サイズ：.caption（小さめ）  
     * 色：灰色（.gray）
3. 配置の調整：
   - 2つのテキストは左側に揃える（中央や右ではなく）
   - 画面の横幅いっぱいを使いつつ、文字は左寄せにする

**ヒント**: VStackの引数でalignment: .leadingを指定すると中身が左寄せになります。さらに.frame(maxWidth: .infinity, alignment: .leading)で全体を左寄せにできます

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("メインタイトル")
                .font(.largeTitle.bold())
                .foregroundColor(.blue)
            
            Text("サブタイトルです")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}
```

**解説:**
- `.font(.largeTitle.bold())`: フォントサイズと太さを同時に設定
- `VStack(alignment: .leading)`: VStack内の要素を左寄せ
- `.frame(maxWidth: .infinity, alignment: .leading)`: 幅を最大にして左寄せ
- `.foregroundColor()`: テキストの色を変更

</details>

---

## 問題4: 計算機能を持つアプリ

**作るもの**: 2つの数を足し算する簡単な計算機（電卓アプリの簡易版）

**要件**:
1. 入力部分の作成：
   - 1つ目の数字を入力する欄（プレースホルダー：「数字1」）
   - 2つ目の数字を入力する欄（プレースホルダー：「数字2」）
   - 両方とも枠線付きのテキストフィールドにする
   - タップすると数字専用のキーボードが表示される（.keyboardType(.numberPad)）
2. 計算ボタン：
   - 入力欄の下に「計算」ボタンを配置
   - ボタンを押すと足し算を実行
3. 結果表示：
   - ボタンの下に計算結果を表示するエリアを用意
   - 「結果: ○○」という形式で表示（○○は合計値）
   - 初期状態では何も表示しない
4. 動作の流れ：
   - 例：「5」と「3」を入力 → 計算ボタンを押す → 「結果: 8」が表示される

**ヒント**: TextFieldに入力された文字列はInt()で数値に変換できます。変換に失敗した場合に備えて ?? 0を使います

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var number1 = ""
    @State private var number2 = ""
    @State private var result = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("数字1", text: $number1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            
            TextField("数字2", text: $number2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            
            Button("計算") {
                let num1 = Int(number1) ?? 0
                let num2 = Int(number2) ?? 0
                result = "結果: \(num1 + num2)"
            }
            
            Text(result)
                .font(.title2)
        }
        .padding()
    }
}
```

**解説:**
- `.keyboardType(.numberPad)`: 数字専用のキーボードを表示
- `Int(number1) ?? 0`: 文字列を数値に変換、失敗したら0を使用
- `spacing: 20`: VStack内の要素間の間隔を設定

</details>

---

## 問題5: アラート表示

**作るもの**: ボタンを押すとアラートが出るアプリ（確認ダイアログの実装）

**要件**:
1. メイン画面：
   - 画面の中央に「アラートを表示」というボタンを配置
2. アラートの内容：
   - タイトル：「確認」
   - メッセージ：「本当に実行しますか？」
   - 選択肢：「はい」ボタンと「いいえ」ボタン
3. 動作の仕組み：
   - @State変数（showAlert）でアラートの表示/非表示を管理
   - ボタンを押す → showAlertがtrueになる → アラートが表示される
   - 「はい」か「いいえ」を押す → アラートが閉じる
4. ボタンの役割：
   - 「はい」：今回は何もしない（後で処理を追加可能）
   - 「いいえ」：キャンセル扱い（.cancelロール）

**ヒント**: .alert()修飾子を使います。isPresented: $showAlertでアラートの表示状態を制御します

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var showAlert = false
    
    var body: some View {
        Button("アラートを表示") {
            showAlert = true
        }
        .alert("確認", isPresented: $showAlert) {
            Button("はい") {
                // はいが押されたときの処理
            }
            Button("いいえ", role: .cancel) {
                // いいえが押されたときの処理
            }
        } message: {
            Text("本当に実行しますか？")
        }
    }
}
```

**解説:**
- `@State private var showAlert`: アラートの表示状態を管理
- `.alert()`: アラートを表示する修飾子
- `isPresented: $showAlert`: showAlertがtrueになるとアラートが表示される
- `role: .cancel`: キャンセルボタンとして扱われる

</details>

---

## 問題6: タイマーアプリ

**作るもの**: シンプルなストップウォッチ（時間を計測するアプリ）

**要件**:
1. 表示部分：
   - 画面の中央に大きな数字で秒数を表示（サイズ: 60）
   - 初期値は「0」
2. 操作ボタン：
   - 数字の下に2つのボタンを横並びで配置
   - 左側：「スタート」ボタン
   - 右側：「リセット」ボタン
   - ボタンの間隔は20ポイント
3. ボタンの動作：
   - スタート：
     * 押すとタイマーが開始
     * 1秒ごとに表示される数字が1ずつ増える（0→1→2→3...）
     * 既にタイマーが動いている場合は新しいタイマーを作る（重複注意）
   - リセット：
     * タイマーを停止
     * 数字を0に戻す
4. 必要な変数：
   - seconds（秒数を保存）：@State
   - timer（タイマーオブジェクト）：@State、オプショナル型

**ヒント**: Timer.scheduledTimer(withTimeInterval: 1, repeats: true)で1秒ごとに繰り返すタイマーを作成。timer?.invalidate()でタイマーを停止

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var seconds = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 30) {
            Text("\(seconds)")
                .font(.system(size: 60))
            
            HStack(spacing: 20) {
                Button("スタート") {
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        seconds += 1
                    }
                }
                
                Button("リセット") {
                    timer?.invalidate()
                    timer = nil
                    seconds = 0
                }
            }
        }
    }
}
```

**解説:**
- `Timer.scheduledTimer`: 一定間隔で処理を実行するタイマー
- `withTimeInterval: 1`: 1秒ごとに実行
- `timer?.invalidate()`: タイマーを停止
- `.font(.system(size: 60))`: フォントサイズを直接指定

</details>

---

## 問題7: 画像とテキストの組み合わせ

**作るもの**: プロフィールカード風の表示（SNSのプロフィールカードのようなデザイン）

**要件**:
1. アイコン部分：
   - システムアイコン「person.circle.fill」を使用
   - サイズ：幅100、高さ100
   - 色：青色
   - 画像は.resizable()で大きさ変更可能にする
2. テキスト部分：
   - アイコンの下に以下を順番に配置：
     * 「ユーザー名」（フォント：.title2、太字）
     * 「iOS開発者」（フォント：.caption、色：灰色）
   - テキスト同士の間隔は10ポイント
3. カードデザイン：
   - 全体に30ポイントの余白（パディング）を追加
   - 灰色の角丸枠線で囲む：
     * 角の丸み：15
     * 線の太さ：2
     * 線の色：灰色
4. 完成イメージ：
   - 角丸の枠の中に、プロフィール情報が整然と配置されたカード

**ヒント**: .overlay()を使うと、ビューの上に別のビューを重ねられます。RoundedRectangle().stroke()で枠線だけを描画できます

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("ユーザー名")
                .font(.title2)
                .bold()
            
            Text("iOS開発者")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(30)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 2)
        )
    }
}
```

**解説:**
- `.resizable()`: 画像のサイズを変更可能にする
- `.frame(width:height:)`: 具体的なサイズを指定
- `.overlay()`: ビューの上に別のビューを重ねる
- `RoundedRectangle().stroke()`: 角丸の枠線だけを描画

</details>

---

## 問題8: ProgressViewを使った読み込み表示

**作るもの**: データ読み込み中の表示を切り替えるアプリ（よくあるローディング画面）

**要件**:
1. 画面の中央に「データを読み込む」というボタンを配置してください
2. ボタンを押したときの動作：
   - くるくる回る円形のインジケーター（ProgressView）が表示される
   - その下に「読み込み中...」という文字が表示される
   - ボタンは押せない状態（グレーアウト）になる
3. 3秒経過後の動作：
   - くるくる回るインジケーターと「読み込み中...」の文字が消える
   - 代わりに緑色で「完了しました！」という文字が表示される
   - ボタンが再び押せる状態に戻る
4. 完了後、もう一度ボタンを押したら、同じ動作を繰り返せるようにしてください

**ヒント**: Task内でTask.sleepを使って3秒待機します。async/awaitという非同期処理の仕組みを使います

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var isLoading = false
    @State private var isCompleted = false
    
    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                ProgressView("読み込み中...")
            } else if isCompleted {
                Text("完了しました！")
                    .foregroundColor(.green)
            }
            
            Button("データを読み込む") {
                Task {
                    isLoading = true
                    isCompleted = false
                    
                    try? await Task.sleep(nanoseconds: 3_000_000_000) // 3秒
                    
                    isLoading = false
                    isCompleted = true
                }
            }
            .disabled(isLoading)
        }
        .padding()
    }
}
```

**解説:**
- `Task { }`: 非同期処理（時間のかかる処理）を実行するための特別なブロックです。中に書いた処理は順番に実行されますが、アプリが固まることはありません
- `await`: 「この処理が終わるまで待って」という意味です。awaitがついた処理は時間がかかることを示しています
- `Task.sleep(nanoseconds:)`: 指定した時間だけ待つ処理です。3_000_000_000ナノ秒 = 3秒です（アンダースコアは読みやすさのため）
- `try?`: エラーが起きても無視して続行します（今回はsleepでエラーは起きませんが、awaitを使うときは必要）
- 処理の流れ：ボタンを押す → Taskブロック開始 → isLoadingをtrueに → 3秒待つ → isLoadingをfalse、isCompletedをtrueに

</details>

---

## 問題9: Stepperで数値調整

**作るもの**: 商品の個数を選択する画面（ショッピングカートの数量選択のような機能）

**要件**:
1. 表示部分：
   - 上段：「商品個数: 1個」と表示（フォント：.title2）
   - 中段：Stepper（+/-ボタン）を配置
   - 下段：「合計: 500円」と表示（フォント：.title、太字、青色）
   - 各要素の間隔は20ポイント
2. Stepperの設定：
   - 最小値：1個
   - 最大値：10個
   - 初期値：1個
   - +ボタンを押すと個数が1増える
   - -ボタンを押すと個数が1減る
   - Stepperのラベルは非表示（.labelsHidden()）
3. 金額計算：
   - 1個あたり500円
   - 個数が変わるたびに合計金額も自動で再計算
   - 例：3個選択 → 「合計: 1500円」と表示
4. 必要な変数：
   - quantity（個数）：@State、Int型、初期値：1
   - price（単価）：let定数、500
   - totalPrice（合計）：計算プロパティ

**ヒント**: Stepper(value: $quantity, in: 1...10)で値と範囲を指定。var totalPrice: Int { return quantity * price }で自動計算

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var quantity = 1
    let price = 500
    
    var totalPrice: Int {
        return quantity * price
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("商品個数: \(quantity)個")
                .font(.title2)
            
            Stepper("", value: $quantity, in: 1...10)
                .labelsHidden()
            
            Text("合計: \(totalPrice)円")
                .font(.title)
                .bold()
                .foregroundColor(.blue)
        }
        .padding()
    }
}
```

**解説:**
- `Stepper`: +/-ボタンで値を増減させるUI
- `in: 1...10`: 最小値1、最大値10の範囲を設定
- `var totalPrice: Int`: 計算プロパティで自動計算
- `.labelsHidden()`: Stepperのラベルを非表示

</details>

---

## 問題10: Sheetを使った画面表示

**作るもの**: 詳細画面をシート形式で表示するアプリ（モーダル画面の実装）

**要件**:
1. メイン画面（ContentView）：
   - 画面の中央に「詳細を見る」ボタンを配置
   - ボタンを押すとSheet（モーダル画面）が表示される
2. 詳細画面（DetailView）：
   - 別のView構造体として作成
   - 以下の要素を縦に配置（間隔：20ポイント）：
     * 「詳細画面」（フォント：.largeTitle、太字）
     * 「これは詳細情報です」（フォント：.body）
     * 「閉じる」ボタン（背景：青、文字：白、角丸：10）
3. Sheetの動作：
   - 下から上にスライドして表示される（iOS標準の動作）
   - 画面の上部にハンドル（横棒）が自動で表示される
   - 下にスワイプでも閉じられる
4. 状態管理：
   - メイン画面：@State showSheetでSheetの表示状態を管理
   - 詳細画面：@Binding showSheetで親の状態を受け取る
   - 「閉じる」ボタンを押す → showSheetをfalseに → Sheetが閉じる
5. 作成する構造体：
   - ContentView（メイン画面）
   - DetailView（詳細画面）

**ヒント**: .sheet(isPresented: $showSheet)でSheetを表示。Sheet内のViewに@Bindingで状態を渡し、内部から閉じられるようにします

<details>
<summary>回答を見る</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State private var showSheet = false
    
    var body: some View {
        Button("詳細を見る") {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            DetailView(showSheet: $showSheet)
        }
    }
}

struct DetailView: View {
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("詳細画面")
                .font(.largeTitle)
                .bold()
            
            Text("これは詳細情報です")
                .font(.body)
            
            Button("閉じる") {
                showSheet = false
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
```

**解説:**
- `.sheet()`: モーダル形式で別の画面を表示
- `isPresented: $showSheet`: シートの表示状態を管理
- `@Binding`: 親ビューの状態を子ビューから変更するために使用
- シートは下から上にスライドして表示される標準的なiOSのUI

</details>

---

## 学習のポイント

これらの問題を通じて学んだこと：

1. **Spacer**: レイアウトの調整に便利
2. **修飾子の順番**: 適用順序によって結果が変わる
3. **計算プロパティ**: 自動的に値を計算
4. **Timer**: 時間に関連する処理
5. **Alert**: ユーザーへの確認や警告
6. **ProgressView**: 読み込み状態の表示
7. **Stepper**: 数値の増減UI
8. **Sheet**: モーダル画面の表示

これらの基礎を組み合わせることで、より複雑なアプリケーションを作ることができます！