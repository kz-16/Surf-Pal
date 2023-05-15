import RxSwift
//import TableKit
//import LeadKit

final class SurfSpotTableViewCell: ConfigurableTableViewCell {
//  private let messageView = UIView()
//  private let infoLabel = UILabel()
//  private let moreButton = UIButton()
//  private let titleLabel = UILabel()
//  private let messageLabel = UITextView()
//  private var figuresStack = UIStackView()
//  private var filesStack = UIStackView()
//
//  private var moreAction: EmptyBlock?

  private let titleLabel = UILabel()
  private let favoriteImageView = UIImageView()

  private var disposeBag = DisposeBag()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialize()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  override func configure(with item: Any) {
    guard let item = item as? SurfSpotTableViewCellModel else {
      assertionFailure("Wrong cell item")
      return
    }
    configure(with: item)
  }

  func configure(with model: SurfSpotTableViewCellModel) {
    titleLabel.text = model.title

    if model.isFavorite {
      favoriteImageView.image = .favoriteSelectedIcon
    } else {
      favoriteImageView.image = nil
    }
  }

}

extension SurfSpotTableViewCell: InitializableElement {
  func addViews() {
    [ titleLabel, favoriteImageView ].forEach {
      contentView.addSubview($0)
    }
  }

  func configureAppearance() {
    titleLabel.textColor = .matteBlack
  }

  func configureLayout() {
    titleLabel.snp.remakeConstraints { make in
      make.leading.equalToSuperview().inset(20)
      make.top.bottom.equalToSuperview().inset(10)
    }

    favoriteImageView.snp.remakeConstraints { make in
      make.height.width.equalTo(23)
      make.centerY.equalToSuperview()
      make.leading.equalTo(titleLabel.snp.trailing).inset(-20)
      make.trailing.equalToSuperview().inset(20)
    }
  }
}
