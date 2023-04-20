import UIKit
import SnapKit
import RxCocoa
import RxSwift

class SurfSpotsViewModel {
  var currentIndex: Int?
}

class SurfSpotsViewController: UIViewController {

  private let modePicker = UISegmentedControl()
  private let segmentedViewControllers: [UIViewController]

  private let viewModel: SurfSpotsViewModel

  var showDetails: ParameterBlock<SurfSpot>?

  init(viewModel: SurfSpotsViewModel,
       segmentedViewControllers: [UIViewController]) {

    self.segmentedViewControllers = segmentedViewControllers
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    initialize()
  }
}

extension SurfSpotsViewController: InitializableElement {
  func addViews() {
    [modePicker].forEach {
      view.addSubview($0)
    }
  }
  func configureLayout() {
    modePicker.snp.remakeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
      make.width.equalTo(200)
      make.centerX.equalToSuperview()
    }
  }

  func configureAppearance() {
    view.backgroundColor = .beigeBackground

    setMapSegment()
    setListSegment()
    modePicker.backgroundColor = .beigeBackground
    modePicker.selectedSegmentIndex = 0
    modePicker.addTarget(self, action: #selector(segmentSelected), for: .valueChanged)
    displaySegmentViewController(0)
  }
}

extension SurfSpotsViewController {
  func setMapSegment() {
    modePicker.insertSegment(withTitle: "Map", at: 0, animated: true)
  }

  func setListSegment() {
    modePicker.insertSegment(withTitle: "List", at: 1, animated: true)
  }

  @objc func segmentSelected(_ segmentControl: UISegmentedControl) {
    var lastDisplayedIndex: Int?

    if let index = viewModel.currentIndex {
      lastDisplayedIndex = index
    }

    displaySegmentViewController(segmentControl.selectedSegmentIndex)

    if let j = lastDisplayedIndex {
      hideSegmentViewController(j)
    }
  }

  func displaySegmentViewController(_ segmentViewControllerIndex: Int) {
    let viewController =  segmentedViewControllers[segmentViewControllerIndex]

    addChild(viewController)
    view.addSubview(viewController.view)

    viewController.view.snp.remakeConstraints { make in
      make.edges.equalToSuperview()
    }

    if let listVC = viewController as? SurfSpotsListViewController {
      listVC.topConstraintItem = modePicker.snp.bottom
      listVC.configureLayout()
    }

    viewController.didMove(toParent: self)

    viewModel.currentIndex = modePicker.selectedSegmentIndex
    view.bringSubviewToFront(modePicker)
  }

  func hideSegmentViewController(_ segmentViewControllerIndex: Int) {
    let viewController = segmentedViewControllers[segmentViewControllerIndex]

    viewController.willMove(toParent: nil)
    viewController.view.removeFromSuperview()
    viewController.removeFromParent()
  }
}
