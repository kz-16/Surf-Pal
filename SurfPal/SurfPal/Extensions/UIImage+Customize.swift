import UIKit

extension UIImage {
  static let backImage = UIImage(named: "back_image")
  static let nextImage = UIImage(named: "next_image")
  static let chevronDown = UIImage(named: "chevron_down")

  static let surfSpotMapMarker = UIImage(named: "surf_spot_map_marker")
  static let wavesIcon = UIImage(named: "waves_icon")

  static let infoIcon = UIImage(named: "info_icon")
  static let favoriteIcon = UIImage(named: "favorite_icon")
  static let shareIcon = UIImage(named: "share_icon")
  static let favoriteSelectedIcon = UIImage(named: "favorite_selected_icon")
  static let weatherSunnyIcon = UIImage(named: "weather_sunny_icon")
  static let weatherWindspeedIcon = UIImage(named: "weather_windspeed_icon")
  static let weatherWinddirectionIcon = UIImage(named: "weather_winddirection_icon")

//  static let australiaFlagImage = UIImage(named: "australia_flag_image")
}

extension UIImage {
  func resizeImage(with newSize: CGSize) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }
}
