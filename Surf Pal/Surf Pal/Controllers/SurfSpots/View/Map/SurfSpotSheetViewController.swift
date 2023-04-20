import UIKit
import RxSwift

extension SurferLevel {
  var backgroundColor: UIColor {
    switch self {
    case .beginner:
      return .bronze
    case .intermediate:
      return .silver
    case .advanced:
      return .gold
    case .expert:
      return .gold
    }
  }
}

class RatingBadgeView: UIView {
  let badgeStackView = UIStackView()

  override init(frame: CGRect) {
    super.init(frame: .zero)

    initialize()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with level: SurferLevel) {
    for _ in 0...level.id {
//      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//      imageView.image = .wavesIcon?.resizeImage(with: CGSize(width: 35, height: 26))
      let imageView = UIImageView(image: .wavesIcon?.resizeImage(with: CGSize(width: 18, height: 13)))
//      imageView.frame.size = CGSize(width: 25, height: 25)
//      imageView.layer.cornerRadius = 25 / 2
//      imageView.backgroundColor = level.backgroundColor
      let view = UIView()
      view.backgroundColor = level.backgroundColor
      view.addSubview(imageView)

      imageView.snp.remakeConstraints { make in
        make.center.equalToSuperview()
        make.height.equalTo(13)
        make.width.equalTo(18)
      }

      view.snp.remakeConstraints { make in
        make.height.width.equalTo(25)
      }
      view.layer.cornerRadius = 25 / 2

      badgeStackView.addArrangedSubview(view)
    }
  }
}

extension RatingBadgeView: InitializableElement {
  func addViews() {
    addSubview(badgeStackView)
  }

  func configureLayout() {
    badgeStackView.snp.remakeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  func configureAppearance() {
    badgeStackView.axis = .horizontal
    badgeStackView.spacing = 2
    badgeStackView.distribution = .equalSpacing
  }
}

class SurfSpotSheetViewController: UIViewController {

  let viewModel: SurfSpotSheetViewModel

  let ratingView = RatingBadgeView()
  let titleLabel = UILabel()
  let descriptionLabel = UILabel()
  let detailsButton = UIButton()

  private let disposeBag = DisposeBag()

  init(viewModel: SurfSpotSheetViewModel) {
    self.viewModel = viewModel

    super.init(nibName: nil, bundle: nil)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    initialize()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    var height: CGFloat = 0
    height += titleLabel.bounds.height
    height += descriptionLabel.bounds.height
    height += detailsButton.bounds.height
    height += 95

    preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: height)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    titleLabel.text = viewModel.surfSpot.name
    descriptionLabel.text = viewModel.surfSpot.description
    if let level = viewModel.surfSpot.surferLevel.last {
      ratingView.configure(with: level)
    }
  }
}

extension SurfSpotSheetViewController: InitializableElement {
  func addViews() {
    [titleLabel, ratingView, descriptionLabel, detailsButton].forEach {
      view.addSubview($0)
    }
  }

  func configureLayout() {
    titleLabel.snp.remakeConstraints { make in
      make.top.equalToSuperview().inset(40)
      make.leading.equalToSuperview().inset(34)
    }
    titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)

    ratingView.snp.remakeConstraints { make in
      make.centerY.equalTo(titleLabel)
      make.leading.equalTo(titleLabel.snp.trailing).inset(-16)
      make.trailing.lessThanOrEqualToSuperview().inset(34)
    }

    descriptionLabel.snp.remakeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).inset(-20)
      make.leading.trailing.equalToSuperview().inset(34)
    }

    detailsButton.snp.remakeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(34)
      make.height.equalTo(50)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
    }

  }

  func configureAppearance() {
    view.backgroundColor = .beigeBackground

    titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
    titleLabel.textColor = .matteBlack
//    titleLabel.backgroundColor = .orange

    descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
    descriptionLabel.textColor = .matteBlack
    descriptionLabel.numberOfLines = 0
//    descriptionLabel.backgroundColor = .blue

    detailsButton.backgroundColor = .oceanBlue
    detailsButton.layer.cornerRadius = 10
    detailsButton.setTitle("Show details", for: .normal)
    detailsButton.setTitleColor(.beigeBackground, for: .normal)
    detailsButton.rx.tap
      .bind { [weak self] in
        self?.dismiss(animated: true) {
          self?.viewModel.onDetails?()
        }
      }
      .disposed(by: disposeBag)
  }
}

