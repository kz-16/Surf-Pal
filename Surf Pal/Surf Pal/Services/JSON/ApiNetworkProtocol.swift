import RxSwift

protocol APINetworkProtocol {
  func getCountryNamesList() -> Single<BaseResponse<[Country]>>
  func getSurfSpots() -> Single<BaseResponse<[SurfSpot]>>
  func getLocationZones() -> Single<BaseResponse<[LocationZone]>>
}
