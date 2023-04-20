import RxCocoa
import RxSwift
import RxKeyboard
import UIKit

class TableManager: ListManager, UITableViewDataSource, UITableViewDelegate {

  var didSelect: ParameterBlock<Any>?
  var didScroll: ParameterBlock<UITableView>?
  var willBeginDecelerating: ParameterBlock<UITableView>?
  var sectionHeader: Block<Int, UIView?>?
  var sectionFooter: Block<Int, UIView?>?
  var additionalKeyboardOffset: CGFloat = 0

  var tableView: UITableView! {
    didSet {
      tableView.dataSource = self
      tableView.delegate = self
      tableView.backgroundColor = .beigeBackground

      initialBottomInset = tableView.contentInset.bottom

      disposeBag = DisposeBag()
      RxKeyboard.instance.visibleHeight
        .drive(onNext: { [weak self, tableView] keyboardVisibleHeight in
          guard let tableView = tableView else {
            return
          }
          let initialBottomInset = self?.initialBottomInset ?? 0
          var keyboardIsShowing = true
          var inset = tableView.contentInset
          if inset.bottom > keyboardVisibleHeight {
            keyboardIsShowing = false
          }

          UIView.animate(withDuration: 0.2, animations: {
            inset.bottom = keyboardIsShowing ? keyboardVisibleHeight : 0
            inset.bottom += initialBottomInset
            tableView.contentInset = inset
          })

          guard keyboardIsShowing,
                let firstResponder = tableView.firstResponder, let firstSuperview = firstResponder.superview else {
            return
          }

          let responderFrame = firstResponder.frame
          let minY = firstSuperview.convert(responderFrame, to: tableView).minY
          UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
            guard let self = self else {
              return
            }

            var offset = tableView.contentOffset
            offset.y = minY - 30 - self.additionalKeyboardOffset
            tableView.contentOffset = offset
          }, completion: nil)
        })
        .disposed(by: disposeBag)

      registerCells()
    }
  }

  private var disposeBag = DisposeBag()
  private var initialBottomInset: CGFloat = 0

  @objc func resignFirstResponder() {
    tableView.endEditing(true)
  }

  func registerCells() {}

  override func reloadData() {
    super.reloadData()

    tableView.reloadData()
  }

  func smoothReload() {
    if #available(iOS 11.0, *) {
      tableView.performBatchUpdates({})
    } else {
      tableView.beginUpdates()
      tableView.endUpdates()
    }
  }

  // MARK: - UITableViewDataSource

  func numberOfSections(in tableView: UITableView) -> Int {
    return filteredItems.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredItems[section].count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let item = item(for: indexPath) else {
      fatalError("item not found for certain indexPath")
    }
    let cellId = itemIdentifier(for: item)
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            as? ConfigurableTableViewCell else {
      fatalError("TableManager required working with cells type of ConfigurableCell")
    }
    cell.configure(with: item)

    return cell
  }

  private var headers = [Int: UIView]()

  private func header(for section: Int) -> UIView? {
    var header = headers[section]
    if header == nil {
      header = sectionHeader?(section)
      headers[section] = header
    }
    header?.layoutIfNeeded()

    return header
  }

  func reloadHeaders() {
    headers = [:]
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return header(for: section)
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard let header = header(for: section) else {
      return 0
    }
    header.layoutIfNeeded()

    return header.bounds.height
  }

  private var footers = [Int: UIView]()

  private func footer(for section: Int) -> UIView? {
    var footer = sectionFooter?(section)
    footer?.layoutIfNeeded()

    return footer
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return footer(for: section)
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return footer(for: section)?.bounds.height ?? 0
  }

  // MARK: - UITableViewDelegate

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let item = item(for: indexPath) else {
      return 0
    }
    return height(for: item)
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 92
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let item = item(for: indexPath) {
      didSelect?(item)
    }
    tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let item = item(for: indexPath) else {
      return
    }
    willDisplay?(item)
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    didScroll?(tableView)
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      willBeginDecelerating?(tableView)
    }
  }

  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    willBeginDecelerating?(tableView)
  }
}

class ConfigurableTableViewCell: UITableViewCell {
  func configure(with _: Any) {}
}

extension UIView {
  var firstResponder: UIView? {
    guard !isFirstResponder else {
      return self
    }

    for subview in subviews {
      if let firstResponder = subview.firstResponder {
        return firstResponder
      }
    }

    return nil
  }
}

