import UIKit

class SurfSpotsListTableManager: TableManager {

  override func registerCells() {
    [
      SurfSpotTableViewCell.self
    ].forEach {
      tableView.register($0, forCellReuseIdentifier: className($0))
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  override func itemIdentifier(for item: Any) -> String {
    return className(SurfSpotTableViewCell.self)
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let superCell = super.tableView(tableView, cellForRowAt: indexPath)

    if let cell = superCell as? SurfSpotTableViewCell {
      cell.contentView.backgroundColor = .beigeBackground
    }

    return superCell
  }
}
