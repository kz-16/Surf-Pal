import GoogleMapsUtils

protocol SurfSpotsMapLayoutDelegate: NSObject {
  func configureCountryModelLayout()
  func configureSurfSpotsModelLayout()
  func changeCameraPosition(with position: GMSCameraPosition)
}

protocol SurfSpotsMapDelegate: NSObject {
  func getSurfSpot(for id: Int) -> SurfSpot?
  func setSurfSpots(prev: SurfSpot, current: SurfSpot, next: SurfSpot)
}

class SurfSpotsMapClusterRenderer: GMUDefaultClusterRenderer {
  var layoutDelegate: SurfSpotsMapLayoutDelegate?
  var modelDeleage: SurfSpotsMapDelegate?
  
  override func shouldRender(as cluster: GMUCluster, atZoom zoom: Float) -> Bool {
    guard let cluster = cluster as? CountryCluster,
          let countryZoom = (cluster.items.first as? SurfSpotsClusterItem)?.country.zoom else {
      return false
    }
    if zoom.rounded() < countryZoom {
      layoutDelegate?.configureCountryModelLayout()
      return true
    } else {
//      layoutDelegate?.configureSurfSpotsModelLayout()
      return false
    }
  }
}
