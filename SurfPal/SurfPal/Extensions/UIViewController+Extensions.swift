import UIKit

extension UIViewController {

  var topVisibleViewController: UIViewController {
    switch self {
    case let navController as UINavigationController:
      return navController.visibleViewController?.topVisibleViewController ?? navController

    case let tabController as UITabBarController:
      return tabController.selectedViewController?.topVisibleViewController ?? tabController

    default:
      return self.presentedViewController?.topVisibleViewController ?? self
    }
  }
}
