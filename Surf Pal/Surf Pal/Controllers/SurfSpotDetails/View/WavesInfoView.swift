import UIKit

class WavesInfoView: UIView {
  let imageView = UIImageView()
  let stackView = UIStackView()

  override init(frame: CGRect) {
    super.init(frame: frame)

    initialize()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with values: [String : String]) {
    imageView.image = .wavesIcon?.resizeImage(with: CGSize(width: 27, height: 36))

    values.forEach {
      let topLabel = UILabel()
      topLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
      topLabel.textColor = .beigeBackground
      topLabel.textAlignment = .center
      topLabel.text = $0.key

      let bottomLabel = UILabel()
      bottomLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
      bottomLabel.textColor = .beigeBackground
      bottomLabel.textAlignment = .center
      bottomLabel.text = $0.value

      let stack = UIStackView()
      stack.axis = .vertical
      stack.spacing = 2
      stack.addArrangedSubview(topLabel)
      stack.addArrangedSubview(bottomLabel)

      stackView.addArrangedSubview(stack)
    }
  }
}

extension WavesInfoView: InitializableElement {
  func addViews() {
    [
      imageView, stackView
    ].forEach {
      addSubview($0)
    }
  }

  func configureLayout() {
    imageView.snp.remakeConstraints { make in
      make.width.equalTo(36)
      make.height.equalTo(27)
      make.leading.top.bottom.equalToSuperview().inset(24)
    }

    stackView.snp.remakeConstraints { make in
      make.centerY.equalTo(imageView)
      make.leading.equalTo(imageView.snp.trailing).inset(-21)
      make.trailing.equalToSuperview().inset(36)
    }
  }

  func configureAppearance() {
    backgroundColor = .oceanBlue
    layer.cornerRadius = 20

    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
  }
}
