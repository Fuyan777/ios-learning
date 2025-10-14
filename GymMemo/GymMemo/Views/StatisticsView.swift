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