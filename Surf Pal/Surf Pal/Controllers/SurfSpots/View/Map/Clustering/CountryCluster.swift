import GoogleMapsUtils

final class CountryCluster: NSObject, GMUCluster {
  var id: Int
  var position: CLLocationCoordinate2D
  var items: [GMUClusterItem]
  var count: UInt

  init(id: Int, position: CLLocationCoordinate2D) {
    self.id = id
    self.position = position
    self.items = []
    self.count = 0
  }
}
