import Foundation
import RxCocoa
import RxRelay
import RxSwift

class ArticleViewModel {
  private let articleService: ArticleService
  private let disposeBag = DisposeBag()

  private let articleRelay = BehaviorRelay<Article?>(value: nil)

  var articleDriver: Driver<Article?> {
    articleRelay.asDriver()
  }
  var onClose: EmptyBlock?

  init(articleService: ArticleService = .shared) {
    self.articleService = articleService

    articleService.getArticle()
      .subscribe(onSuccess: { [weak self] article in
        self?.articleRelay.accept(article)
      })
      .disposed(by: disposeBag)
  }
}
