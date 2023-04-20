import UIKit
import RxSwift

class SurfSpotDetailsViewController: UIViewController {

  let viewModel: SurfSpotDetailsViewModel

  let closeButton = UIButton()
  let scrollView = UIScrollView()
  let imageView = UIImageView()
  let ratingView = RatingBadgeView()
  let titleLabel = UILabel()
  let descriptionLabel = UILabel()
  let goodSeasonView = SeasonView()
  let bestSeasonView = SeasonView()
  let weatherView = WeatherView()
  let windSpeedView = WeatherView()
  let windDirectionView = WeatherView()
  let wavesInfoView = WavesInfoView()

  private let disposeBag = DisposeBag()

  init(viewModel: SurfSpotDetailsViewModel) {
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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if let url = URL(string: viewModel.surfSpot.imageURL) {
      imageView.kf.setImage(with: url)
    }

    titleLabel.text = viewModel.surfSpot.name
    descriptionLabel.text = viewModel.surfSpot.description

    if let level = viewModel.surfSpot.surferLevel.last {
      ratingView.configure(with: level)
    }

    goodSeasonView.configure(
      with: "Good season",
      value: "\(viewModel.surfSpot.goodSeason.startMonth) - \(viewModel.surfSpot.goodSeason.endMonth)"
    )
    bestSeasonView.configure(
      with: "Best season",
      value: "\(viewModel.surfSpot.bestSeason.startMonth) - \(viewModel.surfSpot.bestSeason.endMonth)"
    )

    weatherView.configure(with: .weatherSunnyIcon, value: "31.5")
    windSpeedView.configure(with: .weatherWindspeedIcon, value: "10.3")
    windDirectionView.configure(with: .weatherWinddirectionIcon, value: "NNW")

    wavesInfoView.configure(
      with: ["now" : "25.5", "1h" : "26.5", "3h" : "29"]
    )
  }
}

extension SurfSpotDetailsViewController: InitializableElement {
  func addViews() {
    [
      closeButton, scrollView
    ].forEach {
      view.addSubview($0)
    }

    [
      imageView, titleLabel, ratingView, descriptionLabel, goodSeasonView, bestSeasonView,
      weatherView, windSpeedView, windDirectionView, wavesInfoView
    ].forEach {
      scrollView.addSubview($0)
    }
  }

  func configureLayout() {
    closeButton.snp.remakeConstraints { make in
      make.height.width.equalTo(25)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8)
      make.trailing.equalToSuperview().inset(40)
    }

    scrollView.snp.remakeConstraints { make in
      make.top.equalTo(closeButton.snp.bottom).inset(-12)
      make.bottom.equalToSuperview()
      make.leading.trailing.bottom.equalToSuperview()
    }

    imageView.snp.remakeConstraints { make in
      make.top.equalToSuperview().inset(12)
      make.leading.trailing.equalTo(view).inset(16)
      make.height.equalTo(imageView.snp.width)

    }
    titleLabel.snp.remakeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).inset(-23)
      make.leading.equalTo(view).inset(34)
    }

    ratingView.snp.remakeConstraints { make in
      make.centerY.equalTo(titleLabel)
      make.leading.equalTo(titleLabel.snp.trailing).inset(-16)
      make.trailing.greaterThanOrEqualToSuperview().inset(34)
    }

    descriptionLabel.snp.remakeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).inset(-20)
      make.leading.trailing.equalTo(view).inset(34)
    }

    goodSeasonView.snp.remakeConstraints { make in
      make.top.equalTo(descriptionLabel.snp.bottom).inset(-20)
      make.leading.equalTo(view).inset(34)
    }

    bestSeasonView.snp.remakeConstraints { make in
      make.top.equalTo(descriptionLabel.snp.bottom).inset(-20)
      make.leading.equalTo(goodSeasonView.snp.trailing).inset(-16)
      make.trailing.equalTo(view).inset(34)
      make.width.equalTo(goodSeasonView)
    }

    weatherView.snp.remakeConstraints { make in
      make.top.equalTo(goodSeasonView.snp.bottom).inset(-20)
      make.leading.equalTo(view).inset(34)
    }

    windSpeedView.snp.remakeConstraints { make in
      make.top.equalTo(goodSeasonView.snp.bottom).inset(-16)
      make.leading.equalTo(weatherView.snp.trailing).inset(-10)
      make.bottom.equalTo(weatherView.snp.bottom)
      make.width.equalTo(weatherView)
    }

    windDirectionView.snp.remakeConstraints { make in
      make.top.equalTo(goodSeasonView.snp.bottom).inset(-20)
      make.leading.equalTo(windSpeedView.snp.trailing).inset(-10)
      make.trailing.equalTo(view).inset(34)
      make.bottom.equalTo(weatherView.snp.bottom)
      make.width.equalTo(weatherView)
    }

    wavesInfoView.snp.remakeConstraints { make in
      make.top.equalTo(weatherView.snp.bottom).inset(-16)
      make.leading.trailing.equalTo(view).inset(34)
      make.bottom.equalToSuperview().inset(20)
    }
  }

  func configureAppearance() {
    view.backgroundColor = .beigeBackground

    closeButton.setImage(.chevronDown, for: .normal)
    closeButton.rx.tap
      .bind { [weak self] in
        self?.viewModel.onClose?()
      }
      .disposed(by: disposeBag)

    scrollView.showsVerticalScrollIndicator = false

    imageView.layer.cornerRadius = 10
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill

    titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
    titleLabel.textColor = .matteBlack

    descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
    descriptionLabel.textColor = .matteBlack
    descriptionLabel.numberOfLines = 0
  }
}
