import Foundation
import RxSwift

class MarineService {
  static let shared = MarineService()

  private init() {}

  func getMarine(latitude: Double, longitude: Double) -> Single<MarineModel> {
    let body = MarineRequestParameters(
      latitude: String(latitude),
      longitude: String(longitude)
    )

    return RequestService.networkProvider
      .getMarine(body: body)
      .responseResult()
      .map {
        self.createMarineModel(from: $0)
      }
  }
}

extension MarineService {
  func createMarineModel(from marine: Marine) -> MarineModel {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"

    var nowWaveHeight: String?
    var oneHourWaveHeight: String?
    var threeHoursWaveHeight: String?
    marine.hourly.time.enumerated().forEach {

      if let date = dateFormatter.date(from: $1), areDatesEqualDay(currentDate, date) {

        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.hour], from: currentDate)
        let dateComponents = calendar.dateComponents([.hour], from: date)

        if dateComponents.hour == currentDateComponents.hour {
          nowWaveHeight = String(marine.hourly.waveHeight[$0])
        }
        if let currentHour = currentDateComponents.hour,
           dateComponents.hour == currentHour - 1 {
          oneHourWaveHeight = String(marine.hourly.waveHeight[$0])
        }
        if let currentHour = currentDateComponents.hour,
           dateComponents.hour == currentHour - 3 {
          threeHoursWaveHeight = String(marine.hourly.waveHeight[$0])
        }
      }
    }

    return MarineModel(
      nowWaveHeight: nowWaveHeight ?? "",
      oneHourWaveHeight: oneHourWaveHeight ?? "",
      threeHoursWaveHeight: threeHoursWaveHeight ?? ""
    )
  }

  func areDatesEqualDay(_ date1: Date, _ date2: Date) -> Bool {
    let calendar = Calendar.current

    let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
    let components2 = calendar.dateComponents([.year, .month, .day], from: date2)

    return components1.year == components2.year &&
    components1.month == components2.month &&
    components1.day == components2.day
  }
}

struct MarineModel {
  let nowWaveHeight: String
  let oneHourWaveHeight: String
  let threeHoursWaveHeight: String
}
