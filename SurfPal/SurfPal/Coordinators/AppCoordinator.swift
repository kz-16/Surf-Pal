import UIKit

class AppCoordinator {

  static let shared = AppCoordinator()

  private(set) var navigationController: UINavigationController
  private var rootViewController: UIViewController

  private init() {
    navigationController = UINavigationController()
    rootViewController = RootViewController()
    rootViewController.view.backgroundColor = .white
    appWindow?.rootViewController = rootViewController
    appWindow?.makeKeyAndVisible()
  }

  func start() {
    showMapViewController()
  }

  func showMapViewController() {
//    let viewModel = MapViewModel()
//    let view = MapViewController(viewModel: viewModel)
    let viewModel = SurfSpotsViewModel()

    let mapVM = SurfSpotsMapViewModel()
    mapVM.showDetails = { [weak self] surfSpot in
      self?.showSurfSpotDetailsViewController(for: surfSpot)
    }

    mapVM.showInfo = { [weak self] in
      self?.showArticleViewController()
    }

    let mapVC = SurfSpotsMapViewController(viewModel: mapVM)

    let listVM = SurfSpotsListViewModel()
    listVM.showDetails = { [weak self] surfSpot in
      self?.showSurfSpotDetailsViewController(for: surfSpot)
    }
    let listVC = SurfSpotsListViewController(viewModel: listVM)

    let view = SurfSpotsViewController(viewModel: viewModel,
                                       segmentedViewControllers: [ mapVC, listVC ])
    view.modalPresentationStyle = .fullScreen
    rootViewController.present(view, animated: false)
  }

  func showArticleViewController() {
    let viewModel = ArticleViewModel()
    viewModel.onClose = { [weak self] in
      self?.appWindow?.rootViewController?.topVisibleViewController.dismiss(animated: true)
    }
    let vc = ArticleViewController(viewModel: viewModel)


    vc.modalPresentationStyle = .fullScreen
    appWindow?.rootViewController?.topVisibleViewController.present(vc, animated: true)
  }

  func showSurfSpotDetailsViewController(for surfSpot: SurfSpot) {
    let viewModel = SurfSpotDetailsViewModel(surfSpot: surfSpot)
    viewModel.onClose = { [weak self] in
      self?.appWindow?.rootViewController?.topVisibleViewController.dismiss(animated: true)
    }

    let vc = SurfSpotDetailsViewController(viewModel: viewModel)

    viewModel.onShare = { [weak self, weak vc] text in
      let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
//      activityViewController.accessibilityLabel = "share_activity_view_controller"
      activityViewController.view.accessibilityIdentifier = "share_activity_view_controller"
      activityViewController.popoverPresentationController?.sourceView = vc?.view
      self?.appWindow?.rootViewController?.topVisibleViewController.present(activityViewController, animated: true)
    }

    vc.modalPresentationStyle = .fullScreen
    appWindow?.rootViewController?.topVisibleViewController.present(vc, animated: true)
  }

  func showShareSheet(with text: String) {

    let textToShare = [ text ]
    let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
//    activityViewController.popoverPresentationController?.sourceView = self.view
    // exclude some activity types from the list (optional)
//    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

    appWindow?.rootViewController?.topVisibleViewController.present(activityViewController, animated: true)
  }
}

extension AppCoordinator {
  var appWindow: UIWindow? {
    return UIApplication.shared.windows.first
  }
}
