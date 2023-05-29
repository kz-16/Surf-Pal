import Foundation
import RxSwift
import RxAlamofire
import RxCocoa

final class NetworkService: APINetworkProtocol {
  static let shared = NetworkService()

  private init() {}

  func getForecast(
    body: ForecastRequestParameters
  ) -> Single<BaseResponse<Forecast>> {
    guard let url = URL(string: "https://api.open-meteo.com/v1/forecast") else {
      fatalError("URL is no longer valid")
    }

    return RxAlamofire.requestData(
      .get,
      url,
      parameters: body.toJSON()
    )
    .map { (result, data) in
        let decoder = JSONDecoder()
        let forecast = try decoder.decode(Forecast.self, from: data)

        return BaseResponse(
          result: forecast,
          errorCode: .none,
          errorMessage: nil
        )
    }.asSingle()

  }

  func getMarine(
    body: MarineRequestParameters
  ) -> Single<BaseResponse<Marine>> {
    guard let url = URL(string: "https://marine-api.open-meteo.com/v1/marine") else {
      fatalError("URL is no longer valid")
    }

    return RxAlamofire.requestData(
      .get,
      url,
      parameters: body.toJSON()
    )
    .map { (result, data) in
      let decoder = JSONDecoder()
      let marine = try decoder.decode(Marine.self, from: data)

      return BaseResponse(
        result: marine,
        errorCode: .none,
        errorMessage: nil
      )
    }.asSingle()
  }
}

struct ForecastRequestParameters: Encodable {
  let latitude: String
  let longitude: String
  let hourly: [ForecastInfoUnit] = [ .temperature, .weatherCode, .windSpeed, .windDirection ]
}

enum ForecastInfoUnit: String, Codable {
  case temperature = "temperature_2m"
  case weatherCode = "weathercode"
  case windSpeed = "windspeed_10m"
  case windDirection = "winddirection_10m"
}

struct MarineRequestParameters: Encodable {
  let latitude: String
  let longitude: String
  let hourly: [MarineInfoUnit] = [ .waveHeight ]
}

enum MarineInfoUnit: String, Codable {
  case waveHeight = "wave_height"
}
