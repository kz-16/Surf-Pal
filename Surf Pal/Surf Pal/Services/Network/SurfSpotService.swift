import RxSwift

class SurfSpotService {
  static let shared = SurfSpotService()

  private init() {}
  
  func getSurfSpots() -> Single<[SurfSpot]> {
    return RequestService.dataProvider
      .getSurfSpots()
      .responseResult()
  }
}
