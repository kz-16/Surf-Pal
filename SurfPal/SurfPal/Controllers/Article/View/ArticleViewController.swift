import UIKit
import RxSwift

class ArticleViewController: UIViewController {
  private let closeButton = UIButton()
  private let scrollView = UIScrollView()
  private let titleLabel = UILabel()
  private let articleTextView = UITextView()

  private let disposeBag = DisposeBag()

  let viewModel: ArticleViewModel

  init(viewModel: ArticleViewModel) {
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

  func configureDynamics() {
    viewModel.articleDriver
      .drive(onNext: { [weak self] article in
        guard let self = self, let article = article else {
          return
        }

        self.titleLabel.text = article.title
        self.articleTextView.text = article.article
      })
      .disposed(by: disposeBag)
  }
}


extension ArticleViewController: InitializableElement {
  func addViews() {
    [
      closeButton, scrollView
    ].forEach {
      view.addSubview($0)
    }

    [
      titleLabel, articleTextView
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

    scrollView.snp.remakeConstraints { make in
      make.top.equalTo(closeButton.snp.bottom).inset(-6)
      make.bottom.equalToSuperview()
      make.leading.trailing.bottom.equalToSuperview()
    }

    titleLabel.snp.remakeConstraints { make in
      make.top.equalToSuperview().inset(23)
      make.leading.trailing.equalTo(view).inset(34)
    }

    articleTextView.snp.remakeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).inset(-23)
      make.leading.trailing.equalTo(view).inset(34)
      make.bottom.equalToSuperview().inset(23)
    }
  }

  func configureAppearance() {
    view.backgroundColor = .beigeBackground
    view.accessibilityIdentifier = "article_view"

    scrollView.accessibilityIdentifier = "article_scroll_view"

    closeButton.setImage(.chevronDown, for: .normal)
    closeButton.rx.tap
      .bind { [weak self] in
        self?.viewModel.onClose?()
      }
      .disposed(by: disposeBag)

    titleLabel.numberOfLines = 0
    titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    titleLabel.textColor = .matteBlack

    articleTextView.font = UIFont.systemFont(ofSize: 16, weight: .light)
    articleTextView.textColor = .matteBlack
    articleTextView.isEditable = false
    articleTextView.isSelectable = true
    articleTextView.isScrollEnabled = false
    articleTextView.textContainerInset = .zero
    articleTextView.textContainer.maximumNumberOfLines = 0
    articleTextView.textContainer.lineFragmentPadding = .zero
    articleTextView.sizeToFit()
    articleTextView.backgroundColor = .clear
  }
}

