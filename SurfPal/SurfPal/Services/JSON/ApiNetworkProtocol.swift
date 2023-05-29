import RxSwift

protocol APINetworkProtocol {
  func getCountryNamesList() -> Single<BaseResponse<[Country]>>
  func getSurfSpots() -> Single<BaseResponse<[SurfSpot]>>
  func getLocationZones() -> Single<BaseResponse<[LocationZone]>>
  func getArticle() -> Single<BaseResponse<Article>>
  func getForecast(body: ForecastRequestParameters) -> Single<BaseResponse<Forecast>>
  func getMarine(body: MarineRequestParameters) -> Single<BaseResponse<Marine>>
}

extension APINetworkProtocol {
  func getCountryNamesList() -> Single<BaseResponse<[Country]>> {
    .just(BaseResponse(result: nil, errorCode: .none, errorMessage: nil))
  }

  func getSurfSpots() -> Single<BaseResponse<[SurfSpot]>> {
    .just(BaseResponse(result: nil, errorCode: .none, errorMessage: nil))
  }

  func getLocationZones() -> Single<BaseResponse<[LocationZone]>> {
    .just(BaseResponse(result: nil, errorCode: .none, errorMessage: nil))
  }
  
  func getArticle() -> Single<BaseResponse<Article>> {
    .just(BaseResponse(result: nil, errorCode: .none, errorMessage: nil))
  }

  func getForecast(body: ForecastRequestParameters) -> Single<BaseResponse<Forecast>> {
    .just(BaseResponse(result: nil, errorCode: .none, errorMessage: nil))
  }

  func getMarine(body: MarineRequestParameters) -> Single<BaseResponse<Marine>> {
    .just(BaseResponse(result: nil, errorCode: .none, errorMessage: nil))
  }
}
