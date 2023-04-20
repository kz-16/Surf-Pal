import RxSwift
import RxCocoa

struct SurfSpotsSectionViewModel {
  let title: NSAttributedString
  var cellViewModels: [TableListCellViewModel]

//  init(title: NSAttributedString,
//       cellViewModels: [TableListCellViewModel]) {
//    self.title = title
//    self.cellViewModels = cellViewModels
//  }
}

class SurfSpotsListViewModel {
//  typealias SurfSpotsSectionViewModel = (title: NSAttributedString,
//                                         cellViewModels: [TableListCellViewModel])

  let surfSpotService: SurfSpotService
  let countryService: CountryService

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
          let surfSpotsModels: [TableListCellViewModel] = surfSpots.compactMap { spot in
            if spot.countryId == country.id {
              return TableListCellViewModel(title: spot.name)
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

  init(surfSpotService: SurfSpotService = SurfSpotService.shared,
       countryService: CountryService = CountryService.shared) {
    self.surfSpotService = surfSpotService
    self.countryService = countryService
  }

  func loadData() {
    surfSpotService.getSurfSpots()
      .subscribe(onSuccess: { [weak self] surfSpots in
        //        let models = surfSpots.map {
        //          return TableListCellViewModel(title: $0.name)
        //        }
        self?.surfSpotsRelay.accept(surfSpots)
      })
      .disposed(by: disposeBag)

    countryService.getCountryNames()
      .subscribe { [weak self] countries in
        //        let titles = countries.map {
        //          return NSAttributedString(string: "\($0.flag) \($0.name)")
        //        }
        self?.countriesRelay.accept(countries)
      }
      .disposed(by: disposeBag)
  }
}
