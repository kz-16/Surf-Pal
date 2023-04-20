import RxSwift
import RxCocoa

enum ZoomLevel {
  case country
  case zoom
  case surfSpot
}

class SurfSpotsMapViewModel: NSObject {

  let surfSpotService: SurfSpotService
  let countryService: CountryService

  var showDetails: ParameterBlock<SurfSpot>?

  var prevSurfSpot: SurfSpot?
  var currentSurfSpot: SurfSpot?
  var nextSurfSpot: SurfSpot?

  private let surfSpotsRelay = BehaviorRelay<[SurfSpot]?>(value: nil)
  var surfSpots: [SurfSpot]? {
    surfSpotsRelay.value
  }

  private let countriesRelay = BehaviorRelay<[Country]?>(value: nil)
  var countries: [Country]? {
    countriesRelay.value
  }

  var mapInfoObservable: Observable<([Country]?, [SurfSpot]?)> {
    Observable.combineLatest(countriesRelay, surfSpotsRelay)
  }

  let disposeBag = DisposeBag()

  init(surfSpotService: SurfSpotService = SurfSpotService.shared,
       countryService: CountryService = CountryService.shared) {
    self.surfSpotService = surfSpotService
    self.countryService = countryService
  }

  func setupViewModel() {
    surfSpotService.getSurfSpots()
      .subscribe(onSuccess: { [weak self] surfSpots in
        self?.surfSpotsRelay.accept(surfSpots)
      })
      .disposed(by: disposeBag)

    countryService.getCountryNames()
      .subscribe(onSuccess: { [weak self] countries in
        self?.countriesRelay.accept(countries)
      })
      .disposed(by: disposeBag)
  }
}

extension SurfSpotsMapViewModel: SurfSpotsMapDelegate {
  func getSurfSpot(for id: Int) -> SurfSpot? {
    return nil
//    if let currentSurfSpot = currentSurfSpot {
//      return currentSurfSpot
//    }
//
//    if let firstSurfSpot = surfSpots?.first(where: {
//      $0.countryId == id
//    }) {
//      currentSurfSpot = firstSurfSpot
//      if let lastSurfSpot = surfSpots?.last(where: {
//        $0.countryId == id
//      }) {
//        prevSurfSpot = lastSurfSpot
//      }
//      return firstSurfSpot
//    }
  }

  func setSurfSpots(prev: SurfSpot, current: SurfSpot, next: SurfSpot) {

  }
}
