import Foundation

final class RequestService {

    static let shared = RequestService()

    static var dataProvider: APINetworkProtocol {
        return JSONDataService.shared
    }

    private init() {}
}
