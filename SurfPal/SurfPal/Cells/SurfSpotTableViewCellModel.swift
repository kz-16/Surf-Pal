import Foundation

class SurfSpotTableViewCellModel {
  let surfSpot: SurfSpot
  let title: String
  let isFavorite: Bool

  init(
    surfSpot: SurfSpot,
    isFavorite: Bool
  ) {
    self.surfSpot = surfSpot
    self.isFavorite = isFavorite
    self.title = surfSpot.name
  }
}
