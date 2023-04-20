import Foundation

@objc protocol ListManagerProtocol {
  func indexPathIdentifier(for indexPath: IndexPath) -> String
  func itemIdentifier(for item: Any) -> String
  func headerIdentifier(for item: Any) -> String
  func item(for indexPath: IndexPath) -> Any?
  func headerItem(for section: Int) -> Any?

  @objc optional func height(for item: Any) -> CGFloat
  @objc optional func size(for item: Any) -> CGSize
}

class ListManager: NSObject, ListManagerProtocol {

  var willDisplay: ParameterBlock<Any>?

  func reloadData() {}

  var filteredItems: [[Any]] = [[]] {
    didSet {
      reloadData()
    }
  }

  var items: [[Any]] = [[]] {
    didSet {
      filteredItems = items
    }
  }

  var headerItems: [Any] = []

  func indexPathIdentifier(for indexPath: IndexPath) -> String {
    guard let item = item(for: indexPath) else {
      fatalError("item not found for certain indexPath")
    }
    return itemIdentifier(for: item)
  }

  func itemIdentifier(for item: Any) -> String {
    fatalError("override in child")
  }

  func headerIdentifier(for item: Any) -> String {
    fatalError("override in child")
  }

  func item(for indexPath: IndexPath) -> Any? {
    guard filteredItems.count > indexPath.section,
          filteredItems[indexPath.section].count > indexPath.row else {
      return nil
    }
    return filteredItems[indexPath.section][indexPath.row]
  }

  func headerItem(for section: Int) -> Any? {
    return headerItems[section]
  }

  func firstIndexPath(for item: AnyObject) -> IndexPath? {
    for (sectionIndex, section) in filteredItems.enumerated() {
      for (index, current) in section.enumerated()
      where item === (current as AnyObject) {
        return IndexPath(row: index, section: sectionIndex)
      }
    }
    return nil
  }

  @objc func height(for item: Any) -> CGFloat {
    return 52.0
  }

  @objc func size(for item: Any) -> CGSize {
    fatalError("should be implemented in child")
  }
}
