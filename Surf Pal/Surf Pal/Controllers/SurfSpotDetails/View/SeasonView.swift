import UIKit

class SeasonView: UIView {
  let titleLabel = UILabel()
  let valueLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    initialize()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with title: String, value: String) {
    titleLabel.text = title
    valueLabel.text = value
  }
}

extension SeasonView: InitializableElement {
  func addViews() {
    [
      titleLabel, valueLabel
    ].forEach {
      addSubview($0)
    }
  }

  func configureLayout() {
    titleLabel.snp.remakeConstraints { make in
      make.top.equalToSuperview().inset(8)
      make.leading.trailing.equalToSuperview().inset(12)
    }

    valueLabel.snp.remakeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).inset(-10)
      make.bottom.equalToSuperview().inset(18)
      make.leading.trailing.equalToSuperview().inset(12)
    }
  }

  func configureAppearance() {
    layer.cornerRadius = 20
    layer.borderColor = UIColor.matteBlack.cgColor
    layer.borderWidth = 2

    titleLabel.textColor = .matteBlack
    titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)

    valueLabel.textAlignment = .center
    valueLabel.textColor = .matteBlack
    valueLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
  }
}
