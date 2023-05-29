import UIKit
import RxSwift

class SurfSpotDetailsViewController: UIViewController {

  let viewModel: SurfSpotDetailsViewModel

  let closeButton = UIButton()
  let favoriteButton = UIButton()
  let shareButton = UIButton()
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
  let ticketButton = UIButton()

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
    configureDynamics()
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
  }

  func configureDynamics() {
    viewModel.forecastDriver
      .drive(onNext: { [weak self] forecast in
        guard let self = self, let forecast = forecast else {
          return
        }

        self.weatherView.configure(with: .weatherSunnyIcon, value: forecast.temperature)
        self.windSpeedView.configure(with: .weatherWindspeedIcon, value: forecast.windSpeed)
        self.windDirectionView.configure(with: .weatherWinddirectionIcon, value: forecast.windDirection)
      })
      .disposed(by: disposeBag)

    viewModel.marineDriver
      .drive(onNext: { [weak self] marine in
        guard let self = self, let marine = marine else {
          return
        }

        self.wavesInfoView.configure(
          with: [
            "now" : marine.nowWaveHeight,
            "1h" : marine.oneHourWaveHeight,
            "3h" : marine.threeHoursWaveHeight
          ]
        )
      })
      .disposed(by: disposeBag)
  }
}

extension SurfSpotDetailsViewController: InitializableElement {
  func addViews() {
    [
      closeButton, favoriteButton, shareButton, scrollView
    ].forEach {
      view.addSubview($0)
    }

    [
      imageView, titleLabel, ratingView, descriptionLabel, goodSeasonView, bestSeasonView,
      weatherView, windSpeedView, windDirectionView, wavesInfoView, ticketButton
    ].forEach {
      scrollView.addSubview($0)
    }
  }

  func configureLayout() {
    closeButton.snp.remakeConstraints { make in
      make.height.width.equalTo(36)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)//.inset(8)
      make.trailing.equalToSuperview().inset(30)
    }

    favoriteButton.snp.remakeConstraints { make in
      make.height.width.equalTo(36)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)//.inset(8)
      make.leading.equalToSuperview().inset(30)
    }

    shareButton.snp.remakeConstraints { make in
      make.height.width.equalTo(36)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)//.inset(8)
      make.leading.equalTo(favoriteButton.snp.trailing).inset(-12)
    }

    scrollView.snp.remakeConstraints { make in
      make.top.equalTo(closeButton.snp.bottom).inset(-6)
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
      make.top.equalTo(goodSeasonView.snp.bottom).inset(-20)
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
    }

    ticketButton.snp.remakeConstraints { make in
      make.height.equalTo(45)
      make.top.equalTo(wavesInfoView.snp.bottom).inset(-16)
      make.leading.trailing.equalTo(view).inset(34)
      make.bottom.equalToSuperview().inset(20)
    }
  }

  func configureAppearance() {
    view.backgroundColor = .beigeBackground
    view.accessibilityIdentifier = "surf_spot_full_details_view"

    scrollView.accessibilityIdentifier = "surf_spot_full_details_scroll_view"

    closeButton.accessibilityIdentifier = "surf_spot_full_details_view_close_button"
    closeButton.setImage(.chevronDown, for: .normal)
    closeButton.rx.tap
      .bind { [weak self] in
        self?.viewModel.onClose?()
      }
      .disposed(by: disposeBag)

    favoriteButton.accessibilityIdentifier = "surf_spot_full_details_view_favorite_button"
    favoriteButton.setImage(.favoriteIcon, for: .normal)
    favoriteButton.setImage(.favoriteSelectedIcon, for: .selected)
    favoriteButton.isSelected = viewModel.isSurfSpotFavorite() ? true : false

    favoriteButton.rx.tap
      .bind { [weak self] in
        self?.viewModel.updateFavoriteStatus()
        if let isFavorite = self?.viewModel.isSurfSpotFavorite() {
          self?.favoriteButton.isSelected = isFavorite ? true : false
        }
      }
      .disposed(by: disposeBag)

    shareButton.accessibilityIdentifier = "surf_spot_full_details_view_share_button"
    shareButton.setImage(.shareIcon, for: .normal)
    shareButton.rx.tap
      .bind { [weak self] in
        guard let self = self else {
          return
        }
        self.viewModel.onShare?(self.viewModel.getTextForSharing())
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

    ticketButton.accessibilityIdentifier = "ticket_button"
    ticketButton.backgroundColor = .oceanBlue
    ticketButton.layer.cornerRadius = 10
    ticketButton.setTitleColor(.beigeBackground, for: .normal)
    ticketButton.setTitle("Find tickets", for: .normal)
    ticketButton.rx.tap
      .bind { [weak self] in
        self?.viewModel.openAviasales()
      }
      .disposed(by: disposeBag)
  }
}
