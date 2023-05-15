import Foundation

enum ApiErrorType: Int, Codable, RawRepresentable, CaseIterable {
    case none = 0
    case jsonParsingFail = 1
    case fileNotFound = 2
}

extension ApiErrorType: Error {
    var errorMessage: String? {
        switch self {
        case .jsonParsingFail:
            return "Произошла ошибка обработки ответа с сервера"
        default:
            return nil
        }
    }
}
