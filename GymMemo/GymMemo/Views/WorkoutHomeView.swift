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
                    VStack {
                        Text("\(todaysRecords.count)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("種目")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    
                    VStack {
                        let totalReps = todaysRecords.reduce(0) { $0 + $1.totalReps }
                        Text("\(totalReps)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("合計回数")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding()
                
                // 記録リスト
                List {
                    ForEach(records) { record in
                        WorkoutRowView(record: record)
                    }
                    .onDelete(perform: deleteRecords)
                }
            }
            .navigationTitle("ジムメモ")
            .toolbar {
                Button(action: { showingAddWorkout = true }) {
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
