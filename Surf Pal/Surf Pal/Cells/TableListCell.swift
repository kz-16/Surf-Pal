import RxSwift
//import TableKit
//import LeadKit

final class TableListCell: ConfigurableTableViewCell {
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
    guard let item = item as? TableListCellViewModel else {
      assertionFailure("Wrong cell item")
      return
    }
    configure(with: item)
  }

  func configure(with model: TableListCellViewModel) {
    titleLabel.text = model.title
  }

}

extension TableListCell: InitializableElement {
  func addViews() {
    contentView.addSubview(titleLabel)
  }

  func configureAppearance() {
    titleLabel.textColor = .matteBlack
  }

  func configureLayout() {
    titleLabel.snp.remakeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(20)
      make.top.bottom.equalToSuperview().inset(10)
    }
  }
}
