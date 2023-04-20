import RxSwift

class CountryService {
  static let shared = CountryService()
  
  private init() {}
  
  func getCountryNames() -> Single<[Country]> {
    return RequestService.dataProvider
      .getCountryNamesList()
      .responseResult()
  }
}
