import KeychainAccess

protocol LSStorage {
  func exists(for key: String) -> Bool
  func save<T>(_ value: T?, key: String)
  func saveArray<T>(_ value: [T]?, key: String)
  func get<T>(key: String) -> T?
  func getArray<T>(key: String) -> [T]?
  func remove(for key: String)
}

extension LSStorage {
  func saveArray<T>(_ value: [T]?, key: String) {}
  func getArray<T>(key: String) -> [T]? { return nil }
}

extension UserDefaults: LSStorage {
  func exists(for key: String) -> Bool {
    return object(forKey: key) != nil
  }

  func save<T>(_ value: T?, key: String) {
    set(value, forKey: key)
  }

  func saveArray<T>(_ value: [T]?, key: String) {
    set(value, forKey: key)
  }

  func get<T>(key: String) -> T? {
    return object(forKey: key) as? T
  }

  func getArray<T>(key: String) -> [T]? {
    return object(forKey: key) as? [T]
  }

  func remove(for key: String) {
    removeObject(forKey: key)
  }
}

extension Keychain: LSStorage {
  func exists(for key: String) -> Bool {
    return (try? contains(key)) ?? false
  }

  func save<T>(_ value: T?, key: String) {
    let accessibilityKey: Accessibility = .whenPasscodeSetThisDeviceOnly

    switch value {
    case let value as String:
      try? accessibility(accessibilityKey).set(value, key: key)

    case let value as Data:
      try? accessibility(accessibilityKey).set(value, key: key)

    default:
      fatalError("Unexpected value")
    }
  }

  func get<T>(key: String) -> T? {
    switch T.self {
    case is String.Type:
      return try? getString(key) as? T

    case is Data.Type:
      return try? getData(key) as? T

    default:
      fatalError("Unexpected value")
    }
  }

  func remove(for key: String) {
    try? remove(key)
  }
}
