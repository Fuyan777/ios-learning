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
                TextField("種目名", text: $exercise)
                
                Picker("部位", selection: $bodyPart) {
                    ForEach(BodyPart.allCases, id: \.self) { part in
                        Text(part.rawValue)
                            .tag(part)
                    }
                }
                
                Stepper("合計回数: \(totalReps)", value: $totalReps, in: 1...100)
                
                VStack(alignment: .leading) {
                    Text("重量: \(weight, specifier: "%.1f") kg")
                    Slider(value: $weight, in: 0...200, step: 2.5)
                }
            }
            .navigationTitle("新規記録")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") { isPresented = false }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
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
                    .disabled(exercise.isEmpty)
                }
            }
        }
    }
}