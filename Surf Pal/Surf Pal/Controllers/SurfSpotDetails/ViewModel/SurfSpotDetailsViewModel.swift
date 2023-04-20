import Foundation

class SurfSpotDetailsViewModel {
  let surfSpot: SurfSpot
//  var onDetails: EmptyBlock?
  var onClose: EmptyBlock?

  init(surfSpot: SurfSpot) {
    self.surfSpot = surfSpot
  }
}
