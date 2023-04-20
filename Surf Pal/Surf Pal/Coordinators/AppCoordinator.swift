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
    let mapVC = SurfSpotsMapViewController(viewModel: mapVM)

    let listVM = SurfSpotsListViewModel()
    let listVC = SurfSpotsListViewController(viewModel: listVM)

    let view = SurfSpotsViewController(viewModel: viewModel,
                                       segmentedViewControllers: [ mapVC, listVC ])
    view.modalPresentationStyle = .fullScreen
    rootViewController.present(view, animated: false)
  }



  func showSurfSpotDetailsViewController(for surfSpot: SurfSpot) {
    let viewModel = SurfSpotDetailsViewModel(surfSpot: surfSpot)
    viewModel.onClose = { [weak self] in
      self?.appWindow?.rootViewController?.topVisibleViewController.dismiss(animated: true)
    }
    let vc = SurfSpotDetailsViewController(viewModel: viewModel)

    vc.modalPresentationStyle = .fullScreen
    appWindow?.rootViewController?.topVisibleViewController.present(vc, animated: true)
  }
}

extension AppCoordinator {
  var appWindow: UIWindow? {
    return UIApplication.shared.windows.first
  }
}
