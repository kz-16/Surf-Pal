import Foundation

final class RequestService {

    static let shared = RequestService()

    static var dataProvider: APINetworkProtocol {
        return JSONDataService.shared
    }

  // MARK: Workaround while part of data from JSON file and other part from API requests
  static var networkProvider: APINetworkProtocol {
    return NetworkService.shared
  }

    private init() {}
}
