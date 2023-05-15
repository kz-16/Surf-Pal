import GoogleMaps
import GoogleMapsUtils
import Kingfisher
import SVGKit

final class AccessibleMarker: GMSMarker, UIAccessibilityIdentification {
  var accessibilityIdentifier: String?
}

final class CountryMarker: GMSMarker, UIAccessibilityIdentification {
  let country: Country
  let imageView = UIImageView()

  var accessibilityIdentifier: String?

  init(country: Country) {
    self.country = country
    super.init()

    imageView.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
    imageView.layer.cornerRadius = 22.5

    if let url = URL(string: country.iconURL) {
      imageView.kf.setImage(with: url,
                            placeholder: nil,
                            options: [ .processor(SVGImageProcessor()) ],
                            progressBlock: nil)
    }

    self.iconView = imageView
  }
}
