import Foundation
import RxSwift

class SurfSpotDetailsViewModel {

  let userStorage: UserStorage
  let countryService: CountryService

  let surfSpot: SurfSpot
  var country: Country?

//  var onDetails: EmptyBlock?
  var onShare: ParameterBlock<String>?
  var onClose: EmptyBlock?

  private let disposeBag = DisposeBag()

  init(
    surfSpot: SurfSpot,
    userStorage: UserStorage = .shared,
    countryService: CountryService = .shared
  ) {
    self.surfSpot = surfSpot
    self.userStorage = userStorage
    self.countryService = countryService

    countryService.getCountryNames()
      .subscribe(onSuccess: { [weak self] countries in
        self?.country = countries.filter({ $0.id == surfSpot.countryId }).first
      })
      .disposed(by: disposeBag)
  }

  func isSurfSpotFavorite() -> Bool {
    let ids = userStorage.favouriteSurfSpotIds

    return ids.contains(surfSpot.id) ? true : false
  }

  func updateFavoriteStatus() {
    if isSurfSpotFavorite() {
      userStorage.removeFavouriteSurfSpotId(id: surfSpot.id)
    } else {
      userStorage.addFavouriteSurfSpotId(id: surfSpot.id)
    }
  }

  func getTextForSharing() -> String {
    return """
    Hi, I found cool place for surfing \(surfSpot.name)!
    Check it out on Google Maps:
    https://www.google.com/maps/search/?api=1&query=\(surfSpot.latitude),\(surfSpot.longitude)
    """
  }

  func openAviasales() {
    guard let country = country else {
      return
    }
    let calendar = Calendar.current
    let currentDate = Date()

    // Add a week to the current date
    guard let weekLaterDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate),
          let twoWeeksLaterDate = calendar.date(byAdding: .weekOfYear, value: 2, to: currentDate) else {
      return
    }

    let weekLaterString = DateFormatter.localizedString(from: weekLaterDate, dateStyle: .none, timeStyle: .none)
    let twoWeeksLaterString = DateFormatter.localizedString(from: twoWeeksLaterDate, dateStyle: .none, timeStyle: .none)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "ddMM"
    let weekLaterFormatted = dateFormatter.string(from: weekLaterDate)
    let twoWeeksLaterFormatted = dateFormatter.string(from: twoWeeksLaterDate)

    let url = "https://www.aviasales.ru/search/MOW\(weekLaterFormatted)\(country.airportCode)\(twoWeeksLaterFormatted)1"
    if let url = URL(string: url) {
      UIApplication.shared.open(url)
    }
  }
}
