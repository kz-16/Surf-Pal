import Foundation
import KeychainAccess

class UserStorage {
  private var defaults: LSStorage
  private var keychain: LSStorage

  static let shared = UserStorage(
    defaults: UserDefaults.standard,
    keychain: Keychain()
  )

  private init(defaults: LSStorage, keychain: LSStorage) {
    self.defaults = defaults
    self.keychain = keychain
  }

  private enum Keys {
    static let favoriteCountryId = "favoriteCountryId"
    static let favouriteSurfSpotIds = "favouriteSurfSpotIds"
  }

  private enum DefaultValue {
    static let favoriteCountryId = 1
//    static let favouriteSurfSpotIds: [Int] =
  }

  var favoriteCountryId: Int {
    get {
      guard let id: Int = defaults.get(key: Keys.favoriteCountryId) else {
        return DefaultValue.favoriteCountryId
      }
      return id
    }
    set {
      defaults.save(newValue, key: Keys.favoriteCountryId)
    }
  }

  var favouriteSurfSpotIds: Set<Int> {
    get {
      let array: [Int] = defaults.getArray(key: Keys.favouriteSurfSpotIds) ?? [Int]()
      let ids: Set<Int> = Set(array)
      return ids
    }
  }
}

extension UserStorage {
  func addFavouriteSurfSpotId(id: Int) {
    var newFavouriteSurfSpotIds = favouriteSurfSpotIds
    newFavouriteSurfSpotIds.insert(id)

    let array = Array(newFavouriteSurfSpotIds)

    defaults.save(array, key: Keys.favouriteSurfSpotIds)
  }

  func removeFavouriteSurfSpotId(id: Int) {
    let newValue = Array(favouriteSurfSpotIds.filter { $0 != id })

    defaults.save(newValue, key: Keys.favouriteSurfSpotIds)
  }
}
