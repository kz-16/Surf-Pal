import Foundation
import RxSwift

final class JSONDataService: APINetworkProtocol {

  static let shared = JSONDataService()

  let decoder = JSONDecoder()

  private init() {}

  func getCountryNamesList() -> Single<BaseResponse<[Country]>> {
    guard let url = Bundle.main.url(forResource: "country_names_list", withExtension: "json") else {
      return Single.just(
        BaseResponse(
          result: nil,
          errorCode: .fileNotFound,
          errorMessage: nil
        )
      )
    }

    do {
      let data = try Data(contentsOf: url)
      let response = try decoder.decode(BaseResponse<[Country]>.self, from: data)
      return Single.just(
        BaseResponse(
          result: response.result,
          errorCode: .none,
          errorMessage: nil
        )
      )
    } catch {
      return Single.just(
        BaseResponse(
          result: nil,
          errorCode: .jsonParsingFail,
          errorMessage: nil
        )
      )
    }
  }

  func getSurfSpots() -> Single<BaseResponse<[SurfSpot]>> {
    guard let url = Bundle.main.url(forResource: "surf_spots_list", withExtension: "json") else {
      return Single.just(
        BaseResponse(
          result: nil,
          errorCode: .fileNotFound,
          errorMessage: nil
        )
      )
    }

    do {
      let data = try Data(contentsOf: url)
      let response = try decoder.decode(BaseResponse<[SurfSpot]>.self, from: data)
      return Single.just(
        BaseResponse(
          result: response.result,
          errorCode: .none,
          errorMessage: nil
        )
      )
    } catch {
      return Single.just(
        BaseResponse(
          result: nil,
          errorCode: .jsonParsingFail,
          errorMessage: nil
        )
      )
    }
  }

  func getLocationZones() -> Single<BaseResponse<[LocationZone]>> {
    guard let url = Bundle.main.url(forResource: "location_zones_list", withExtension: "json") else {
      return Single.just(
        BaseResponse(
          result: nil,
          errorCode: .fileNotFound,
          errorMessage: nil
        )
      )
    }

    do {
      let data = try Data(contentsOf: url)
      let response = try decoder.decode(BaseResponse<[LocationZone]>.self, from: data)
      return Single.just(
        BaseResponse(
          result: response.result,
          errorCode: .none,
          errorMessage: nil
        )
      )
    } catch {
      return Single.just(
        BaseResponse(
          result: nil,
          errorCode: .jsonParsingFail,
          errorMessage: nil
        )
      )
    }
  }
}
