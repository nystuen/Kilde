import Foundation

enum Source_old: String, CaseIterable, Identifiable {
    case vg, e24, tek
    
    var displayName: String {
        switch self {
        case .vg: return "VG"
        case .tek: return "Tek"
        case .e24: return "E24"
        }
    }
    
    var id: String { rawValue }
}

struct Source: Hashable, Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let link: String
    
    static func ==(lhs: Source, rhs: Source) -> Bool {
        return lhs.name == rhs.name
    }
}
