import RxSwift

class LocationZoneService {
  static let shared = LocationZoneService()

  private init() {}

  func getLocationZones() -> Single<[LocationZone]> {
    return RequestService.dataProvider
      .getLocationZones()
      .responseResult()
  }
}
