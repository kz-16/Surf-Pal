import UIKit

class WeatherView: UIView {
  let imageView = UIImageView()
  let valueLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    initialize()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with image: UIImage?, value: String) {
    imageView.image = image
    valueLabel.text = value
  }
}

extension WeatherView: InitializableElement {
  func addViews() {
    [
      imageView, valueLabel
    ].forEach {
      addSubview($0)
    }
  }

  func configureLayout() {
    imageView.snp.remakeConstraints { make in
      make.height.width.equalTo(32)
      make.leading.top.equalToSuperview().inset(10)
    }

    valueLabel.snp.remakeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).inset(5)
      make.leading.equalTo(imageView.snp.trailing)
      make.bottom.equalToSuperview().inset(10)
      make.trailing.equalToSuperview().inset(6)
    }
  }

  func configureAppearance() {
    backgroundColor = .oceanBlue
    layer.cornerRadius = 20

    valueLabel.textAlignment = .center
    valueLabel.textColor = .beigeBackground
    valueLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    valueLabel.adjustsFontSizeToFitWidth = true
  }
}

