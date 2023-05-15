import UIKit
import GoogleMapsUtils
import GoogleMaps
import SnapKit
import RxCocoa
import RxSwift
import BottomSheet

class SurfSpotsMapViewController: UIViewController {

  private let infoButton = UIButton()
  let mapView = GMSMapView(frame: .zero, camera: GMSCameraPosition(latitude: 0, longitude: 0, zoom: 2))
  let backButton = UIButton()
  let nextButton = UIButton()
  let titleLabel = UILabel()
  
  let viewModel: SurfSpotsMapViewModel
  private var clusterManager: GMUClusterManager?

  private let disposeBag = DisposeBag()

  init(viewModel: SurfSpotsMapViewModel) {
    self.viewModel = viewModel

    super.init(nibName: nil, bundle: nil)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initialize()
    configureDynamics()
    configureClusterManager()
    viewModel.setupViewModel()
  }
  
  func createCameraPosition(latitude: Double, longitude: Double, zoom: Float) -> GMSCameraPosition {
    return GMSCameraPosition(latitude: latitude,
                             longitude: longitude,
                             zoom: zoom)
  }
}

extension SurfSpotsMapViewController {
  func configureMapView() {
    styleMap()
    mapView.clipsToBounds = true
    mapView.layer.cornerRadius = 30
    mapView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    mapView.accessibilityIdentifier = "map_view"
    mapView.accessibilityElementsHidden = false
  }

  func styleMap() {
    guard let url = Bundle.main.url(forResource: "google_maps_style", withExtension: "json") else {
      return
    }

    do {
      let data = try Data(contentsOf: url)
      if let styleString = String(data: data, encoding: .utf8) {
        mapView.mapStyle = try GMSMapStyle(jsonString: styleString)
      }
    } catch {
      return
    }
  }

  func configureMarkers(countries: [Country], surfSpots: [SurfSpot]) {
    surfSpots.forEach { surfSpot in
      let position = CLLocationCoordinate2D(latitude: surfSpot.latitude, longitude: surfSpot.longitude)

      if let country = countries.first(where: { $0.id == surfSpot.countryId }) {
        let item = SurfSpotsClusterItem(surfSpot: surfSpot,
                                        country: country,
                                        position: position)
        clusterManager?.add(item)
      }
    }
    clusterManager?.cluster()
  }

  func configureClusterManager() {
    let iconGenerator = GMUDefaultClusterIconGenerator()
    let algorithm = SurfSpotsMapClusterAlgorithm()
    let renderer = SurfSpotsMapClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
    renderer.delegate = self
    renderer.layoutDelegate = self
    clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
    clusterManager?.setDelegate(self, mapDelegate: self)
  }

  func configureDynamics() {
    viewModel.mapInfoObservable
      .subscribe(onNext: { [weak self] countries, surfSpot in
        guard let self = self, let countries = countries, let surfSpot = surfSpot else {
          return
        }

        if let latitude = countries.first?.latitude,
           let longitude = countries.first?.longitude {
          mapView.camera = self.createCameraPosition(
            latitude: latitude,
            longitude: longitude,
            zoom: 2)
        }
        self.configureMarkers(countries: countries, surfSpots: surfSpot)
      })
      .disposed(by: disposeBag)
  }
}

extension SurfSpotsMapViewController: InitializableElement {
  func addViews() {
    [backButton, titleLabel, nextButton, mapView, infoButton].forEach {
      view.addSubview($0)
    }
  }

  func configureLayout() {
    configureCountryModelLayout()

    infoButton.snp.remakeConstraints { make in
      make.width.height.equalTo(36)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8)
      make.trailing.equalToSuperview().inset(20)

    }
  }
  
  func configureAppearance() {
    view.backgroundColor = .beigeBackground
    
    configureMapView()

    infoButton.accessibilityIdentifier = "info_button"
    infoButton.setImage(.infoIcon, for: .normal)
    infoButton.rx.tap
      .bind { [weak self] in
        guard let self = self else {
          return
        }
        self.viewModel.showInfo?()
      }
      .disposed(by: disposeBag)

//    modePicker.accessibilityIdentifier = "mode_picker"
//    modePicker.backgroundColor = .beigeBackground
//    modePicker.selectedSegmentIndex = 0
//    setMapSegment()
//    setListSegment()
//    modePicker.accessibilityIdentifier = "mode_picker"

    titleLabel.textAlignment = .center
    titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
    titleLabel.numberOfLines = 0
    titleLabel.textColor = .matteBlack
    titleLabel.accessibilityIdentifier = "spot_name"

    backButton.setImage(.backImage?.withTintColor(.matteBlack.withAlphaComponent(0.6)), for: .normal)
    backButton.layer.borderColor = UIColor.matteBlack.withAlphaComponent(0.6).cgColor
    backButton.layer.borderWidth = 0.5
    backButton.layer.cornerRadius = 10
    backButton.accessibilityIdentifier = "back_button"
    backButton.rx.tap
      .bind { [weak self] in
        guard let self = self else {
          return
        }
        viewModel.goToPrevSurfSpot()

        if let current = viewModel.currentSurfSpot {
          titleLabel.text = current.name
          CATransaction.begin()
          CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
          self.mapView.animate(
            to: GMSCameraPosition(
              latitude: current.latitude,
              longitude: current.longitude,
              zoom: 10
            )
          )
          CATransaction.commit()
        }
      }
      .disposed(by: disposeBag)

    nextButton.setImage(.nextImage?.withTintColor(.matteBlack.withAlphaComponent(0.6)), for: .normal)
    nextButton.layer.borderColor = UIColor.matteBlack.withAlphaComponent(0.6).cgColor
    nextButton.layer.borderWidth = 0.5
    nextButton.layer.cornerRadius = 10
    nextButton.accessibilityIdentifier = "next_button"
    nextButton.rx.tap
      .bind { [weak self] in
        guard let self = self else {
          return
        }
        viewModel.goToNextSurfSpot()

        if let current = viewModel.currentSurfSpot {
          titleLabel.text = current.name
          CATransaction.begin()
          CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
          self.mapView.animate(
            to: GMSCameraPosition(
              latitude: current.latitude,
              longitude: current.longitude,
              zoom: 10
            )
          )
          CATransaction.commit()
        }
      }
      .disposed(by: disposeBag)

  }
}

extension SurfSpotsMapViewController: SurfSpotsMapLayoutDelegate {
  func changeCameraPosition(with position: GMSCameraPosition) {
    mapView.animate(to: position)
  }

  func configureCountryModelLayout() {
    mapView.snp.remakeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  func configureSurfSpotsModelLayout() {
    titleLabel.snp.remakeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
      //      make.width.equalTo(200)
      make.height.equalTo(55)
      make.centerX.equalToSuperview()
    }
    titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    backButton.snp.remakeConstraints { make in
      make.width.lessThanOrEqualTo(100)
      make.top.equalTo(titleLabel.snp.top)
      make.bottom.equalTo(titleLabel.snp.bottom)
      make.trailing.equalTo(titleLabel.snp.leading).offset(-20)
      make.leading.equalToSuperview().inset(20)
      make.centerY.equalTo(titleLabel.snp.centerY)
    }

    nextButton.snp.remakeConstraints { make in
      make.width.lessThanOrEqualTo(100)
      make.top.equalTo(titleLabel.snp.top)
      make.bottom.equalTo(titleLabel.snp.bottom)
      make.leading.equalTo(titleLabel.snp.trailing).inset(-20)
      make.trailing.equalToSuperview().inset(20)
      make.centerY.equalTo(titleLabel.snp.centerY)
    }

    mapView.snp.remakeConstraints { make in
      make.leading.top.trailing.equalToSuperview()
      make.bottom.equalTo(titleLabel.snp.top).offset(-20)
    }
  }
}

//extension SurfSpotsMapViewController {
//  func setMapSegment() {
//    modePicker.insertSegment(withTitle: "Map", at: 0, animated: true)
//  }
//  
//  func setListSegment() {
//    modePicker.insertSegment(withTitle: "List", at: 1, animated: true)
//  }
//}

extension SurfSpotsMapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//    configureCountryModelLayout()
  }
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    guard let clusterItem = marker.userData as? SurfSpotsClusterItem else {
      return false
    }
    let viewModel = SurfSpotSheetViewModel(surfSpot: clusterItem.surfSpot)
    viewModel.onDetails = { [weak self] in
      self?.viewModel.showDetails?(clusterItem.surfSpot)
    }

    let vc = SurfSpotSheetViewController(viewModel: viewModel)

    presentBottomSheet(
      viewController: vc,
      configuration: BottomSheetConfiguration(
        cornerRadius: 10,
        pullBarConfiguration: .visible(.init(height: 20)),
        shadowConfiguration: .init(backgroundColor: UIColor.black.withAlphaComponent(0.6))
      )
    )

    return true
  }

  func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
  }
}

extension SurfSpotsMapViewController: GMUClusterRendererDelegate {
  func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
    switch object {
    case let clusterItem as SurfSpotsClusterItem:
      let marker = AccessibleMarker(position: clusterItem.position)
      marker.icon = .surfSpotMapMarker?.resizeImage(with: CGSize(width: 31, height: 40))
      marker.userData = clusterItem
      marker.accessibilityIdentifier = "marker-\(clusterItem.surfSpot.id)"

      return marker

    case let cluster as CountryCluster:
      guard let clusterItem = cluster.items.first as? SurfSpotsClusterItem else {
        return nil
      }

      let cluster = CountryMarker(country: clusterItem.country)
      cluster.accessibilityIdentifier = "cluster-\(clusterItem.country.id)"

      return cluster
      
    default:
      return nil
    }
  }
}

extension SurfSpotsMapViewController: GMUClusterManagerDelegate {
  func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
    guard let cluster = cluster as? CountryCluster,
          let country = (cluster.items.first as? SurfSpotsClusterItem)?.country,
          let surfSpots = viewModel.surfSpots else {
      return false
    }

    if let current = surfSpots.filter({ $0.countryId == country.id }).first {
      viewModel.setSurfSpots(current: current)

      titleLabel.text = current.name
      let position = GMSCameraPosition(latitude: current.latitude,
                                       longitude: current.longitude,
                                       zoom: 10)
      CATransaction.begin()
      CATransaction.setValue(2.5, forKey: kCATransactionAnimationDuration)
      mapView.animate(to: position)
      CATransaction.commit()
    }

    configureSurfSpotsModelLayout()

    return true
  }
}
