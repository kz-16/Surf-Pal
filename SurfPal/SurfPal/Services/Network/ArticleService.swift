import RxSwift

class ArticleService {
  static let shared = ArticleService()

  private init() {}

  func getArticle() -> Single<Article> {
    return RequestService.dataProvider
      .getArticle()
      .responseResult()
  }
}
