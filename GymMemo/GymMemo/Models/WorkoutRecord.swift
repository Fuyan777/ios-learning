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