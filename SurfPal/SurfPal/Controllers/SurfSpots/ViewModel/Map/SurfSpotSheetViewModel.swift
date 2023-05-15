import UIKit

class SurfSpotSheetViewModel {
  let surfSpot: SurfSpot
  var onDetails: EmptyBlock?

  init(surfSpot: SurfSpot) {
    self.surfSpot = surfSpot
  }
}
