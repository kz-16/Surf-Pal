import Foundation
import RxSwift

class ForecastService {
  static let shared = ForecastService()

  private init() {}

  func getForecast(latitude: Double, longitude: Double) -> Single<ForecastModel> {
    let body = ForecastRequestParameters(
      latitude: String(latitude),
      longitude: String(longitude)
    )

    return RequestService.networkProvider
      .getForecast(body: body)
      .responseResult()
      .map {
        self.createForecastModel(from: $0)
      }
  }
}

private extension ForecastService {
  func createForecastModel(from forecast: Forecast) -> ForecastModel {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"

    var temperature: String?
    var windSpeed: String?
    var windDirection: String?
    forecast.hourly.time.enumerated().forEach {

      if let date = dateFormatter.date(from: $1), areDatesEqualDayAndHour(currentDate, date) {
        temperature = String(forecast.hourly.temperature2M[$0])
        windSpeed = String(forecast.hourly.windspeed10M[$0])
        windDirection = getWindDirection(from: forecast.hourly.winddirection10M[$0])
      }
    }

    return ForecastModel(
      temperature: temperature ?? "",
      windSpeed: windSpeed ?? "",
      windDirection: windDirection ?? ""
    )
  }

  func getWindDirection(from degree: Int) -> String {
    let normalizedDegree = (degree + 360) % 360

    switch normalizedDegree {
    case 0..<45:
      return "N"
    case 45..<90:
      return "NE"
    case 90..<135:
      return "E"
    case 135..<180:
      return "SE"
    case 180..<225:
      return "S"
    case 225..<270:
      return "SW"
    case 270..<315:
      return "W"
    default:
      return "NW"
    }
  }

  func areDatesEqualDayAndHour(_ date1: Date, _ date2: Date) -> Bool {
    let calendar = Calendar.current

    let components1 = calendar.dateComponents([.year, .month, .day, .hour], from: date1)
    let components2 = calendar.dateComponents([.year, .month, .day, .hour], from: date2)

    return components1.year == components2.year &&
    components1.month == components2.month &&
    components1.day == components2.day &&
    components1.hour == components2.hour
  }
}

struct ForecastModel {
  let temperature: String
  let windSpeed: String
  let windDirection: String
}
