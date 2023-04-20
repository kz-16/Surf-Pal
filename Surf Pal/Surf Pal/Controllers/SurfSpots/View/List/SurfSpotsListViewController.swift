import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SurfSpotsListViewController: UIViewController {

  private let searchBar = UISearchBar()
  private let tableView = UITableView(frame: .zero, style: .plain)
  private let tableManager = SurfSpotsListTableManager()
  private let disposeBag = DisposeBag()

  private let viewModel: SurfSpotsListViewModel

  var topConstraintItem: ConstraintItem?

  init(viewModel: SurfSpotsListViewModel) {
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
    viewModel.loadData()
  }

  func configureDynamics() {
    viewModel.surfSpotsSectionViewModelObservable
      .subscribe { [weak self] models in
        guard let self = self, !models.isEmpty else {
          return
        }
        self.configureTableView(with: models)
      }
      .disposed(by: disposeBag)
  }

  func configureTableView(with models: [SurfSpotsSectionViewModel]) {
    tableManager.sectionHeader = { sectionIndex in
      let headerView = SectionHeaderView(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: self.tableView.frame.width,
                                                       height: 36))

      headerView.configure(with: models[sectionIndex].title)

      headerView.autoresizingMask = .flexibleWidth
      headerView.backgroundColor = .beigeBackground

      return headerView
    }
    tableManager.reloadHeaders()

    tableManager.items = models.map { $0.cellViewModels }
//    tableManager.didSelect = { [weak self] item in
//      guard let self = self,
//            let model = item as? ThreadCellViewModel else {
//        return
//      }
//      self.viewModel.showThreadMessages?(model.thread)
//    }
    tableManager.reloadData()
  }
}

extension SurfSpotsListViewController: InitializableElement {
  func addViews() {
    [searchBar, tableView].forEach {
      view.addSubview($0)
    }
  }

  func configureLayout() {
    searchBar.snp.remakeConstraints { make in
      if let topConstraintItem = topConstraintItem {
        make.top.equalTo(topConstraintItem).offset(20)
      } else {
        make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
      }
      make.leading.trailing.equalToSuperview().inset(10)
    }

    tableView.snp.remakeConstraints { make in
      make.top.equalTo(searchBar.snp.bottom)
      make.leading.bottom.trailing.equalToSuperview()
    }
  }

  func configureAppearance() {
    view.backgroundColor = .beigeBackground
    tableManager.tableView = tableView

    searchBar.barTintColor = .beigeBackground
    searchBar.backgroundImage = UIImage()
    searchBar.placeholder = "Type desired location..."
    searchBar.delegate = self
//    searchBar.color

    tableView.showsHorizontalScrollIndicator = false
    if #available(iOS 15.0, *) {
      tableView.sectionHeaderTopPadding = .zero
    }
  }
}

extension SurfSpotsListViewController: UISearchBarDelegate {

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard !searchText.isEmpty else {
      configureTableView(with: viewModel.surfSpotsSectionViewModels)
      return
    }

    var newModels = [SurfSpotsSectionViewModel]()

    viewModel.surfSpotsSectionViewModels.forEach { item in
      let cellModels = item.cellViewModels.filter { model in
        model.title.capitalized.hasPrefix(searchText.capitalized)
      }

      if !cellModels.isEmpty {
        newModels.append(SurfSpotsSectionViewModel(title: item.title, cellViewModels: cellModels))
      }
    }

    configureTableView(with: newModels)
  }
}
