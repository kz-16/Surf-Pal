import Foundation

struct ApiError: Error {
    let errorType: ApiErrorType?
    let message: String?
}
