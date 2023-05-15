import RxSwift
import RxCocoa

struct SurfSpotsSectionViewModel {
  let title: NSAttributedString
  var cellViewModels: [SurfSpotTableViewCellModel]
}

class SurfSpotsListViewModel {

  let surfSpotService: SurfSpotService
  let countryService: CountryService
  let userStorage: UserStorage

  private let surfSpotsRelay = BehaviorRelay<[SurfSpot]?>(value: nil)
  private let countriesRelay = BehaviorRelay<[Country]?>(value: nil)

  var surfSpotsSectionViewModels: [SurfSpotsSectionViewModel] = []

  var surfSpotsSectionViewModelObservable: Observable<[SurfSpotsSectionViewModel]> {
    Observable.combineLatest(countriesRelay, surfSpotsRelay)
      .map { countries, surfSpots in
        guard let countries = countries, let surfSpots = surfSpots else {
          return []
        }

        let models: [SurfSpotsSectionViewModel] = countries.map { country in
          let surfSpotsModels: [SurfSpotTableViewCellModel] = surfSpots.compactMap { spot in
            if spot.countryId == country.id {
              return SurfSpotTableViewCellModel(
                surfSpot: spot,
                isFavorite: self.userStorage.favouriteSurfSpotIds.contains(spot.id)
              )
            } else {
              return nil
            }
          }

          let title = NSAttributedString(
            string: "\(country.flag) \(country.name)",
            attributes: [
              NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .light)
            ]
          )
          
          return SurfSpotsSectionViewModel(
            title: title,
            cellViewModels: surfSpotsModels
          )
        }
        self.surfSpotsSectionViewModels = models

        return models
      }
  }

  var surfSpotsDriver: Driver<[SurfSpot]?> {
    surfSpotsRelay.asDriver()
  }
  var countriesDriver: Driver<[Country]?> {
    countriesRelay.asDriver()
  }

  let disposeBag = DisposeBag()

  var showDetails: ParameterBlock<SurfSpot>?

  init(
    surfSpotService: SurfSpotService = .shared,
    countryService: CountryService = .shared,
    userStorage: UserStorage = .shared
  ) {
    self.surfSpotService = surfSpotService
    self.countryService = countryService
    self.userStorage = userStorage
  }

  func loadData() {
    surfSpotService.getSurfSpots()
      .subscribe(onSuccess: { [weak self] surfSpots in
        self?.surfSpotsRelay.accept(surfSpots)
      })
      .disposed(by: disposeBag)

    countryService.getCountryNames()
      .subscribe { [weak self] countries in
        self?.countriesRelay.accept(countries)
      }
      .disposed(by: disposeBag)
  }

  func getFavoriteSurfSpotsSectionViewModel() -> [SurfSpotsSectionViewModel] {
    guard let surfSpots = surfSpotsRelay.value, let countries = countriesRelay.value else {
      return []
    }

    let models: [SurfSpotsSectionViewModel] = countries.compactMap { country in
      let surfSpotsModels: [SurfSpotTableViewCellModel] = surfSpots.compactMap { spot in
        if spot.countryId == country.id && self.userStorage.favouriteSurfSpotIds.contains(spot.id) {
          return SurfSpotTableViewCellModel(
            surfSpot: spot,
            isFavorite: self.userStorage.favouriteSurfSpotIds.contains(spot.id)
          )
        } else {
          return nil
        }
      }

      let title = NSAttributedString(
        string: "\(country.flag) \(country.name)",
        attributes: [
          NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .light)
        ]
      )

      if surfSpotsModels.isEmpty {
        return nil
      } else {
        return SurfSpotsSectionViewModel(
          title: title,
          cellViewModels: surfSpotsModels
        )
      }
    }

    return models
  }
}
