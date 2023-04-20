import RxSwift

final class SectionHeaderView: UIView {

  private let disposeBag = DisposeBag()

  private let titleLabel = UILabel()
  private let actionButton = UIButton()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addViews()
    configureLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    addViews()
    configureLayout()
  }

  func addViews() {
    [titleLabel, actionButton].forEach {
      addSubview($0)
    }
  }

  func configureLayout() {
    titleLabel.snp.remakeConstraints { make in
      make.top.equalToSuperview().inset(14)
      make.leading.trailing.equalToSuperview().inset(20)
    }
    titleLabel.lastBaselineAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    actionButton.snp.remakeConstraints { make in
      make.bottom.equalToSuperview().inset(4)
      make.trailing.equalToSuperview().inset(20)
    }
  }
}

extension SectionHeaderView {

  func configure(with title: NSAttributedString,
                 buttonTitle: NSAttributedString? = nil,
                 action: EmptyBlock? = nil) {

    titleLabel.attributedText = title
    actionButton.setAttributedTitle(buttonTitle, for: .normal)

    actionButton.rx.tap
      .subscribe(onNext: {
        action?()
      })
      .disposed(by: disposeBag)
  }
}

