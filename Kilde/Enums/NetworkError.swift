import Foundation

enum APIError: Error {
    case decodingError
    case errorCode(Int)
    case errorMessage(String)
    case unknown
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decodingError:
            return "ERROR: Something went wrong when decoding"
        case .errorCode(let code):
            return "Something went wrong: \(code)"
        case .unknown:
            return "Unkown error"
        case .errorMessage(let errorMessage):
            return "Something went wrong: \(errorMessage)"
        }
    }
}
