import SwiftUI

struct HeaderView: View {
    let recordCount: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("💪 ジムメモ")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("今日の記録: \(recordCount)件")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
    }
}