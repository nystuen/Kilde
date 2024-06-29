import Foundation

extension Array {
    func toDictionary() -> [Int: Element] {
        self.enumerated().reduce(into: [Int: Element]()) { $0[$1.offset] = $1.element }
    }
}
