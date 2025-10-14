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