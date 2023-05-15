import Foundation
import CoreLocation
import GoogleMapsUtils

class SurfSpotsClusterItem: NSObject, GMUClusterItem {
  let position: CLLocationCoordinate2D
  let surfSpot: SurfSpot
  let country: Country

  init(surfSpot: SurfSpot,
       country: Country,
       position: CLLocationCoordinate2D) {
    self.surfSpot = surfSpot
    self.country = country
    self.position = position
  }
}
