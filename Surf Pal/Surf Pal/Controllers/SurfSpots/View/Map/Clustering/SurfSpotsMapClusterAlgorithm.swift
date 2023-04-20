import GoogleMapsUtils

class SurfSpotsMapClusterAlgorithm: NSObject, GMUClusterAlgorithm {
  var items = [SurfSpotsClusterItem]()

  func add(_ items: [GMUClusterItem]) {
    guard let items = items as? [SurfSpotsClusterItem] else {
      return
    }
    self.items.append(contentsOf: items)
  }

  func remove(_ item: GMUClusterItem) {
    guard let item = item as? SurfSpotsClusterItem else {
      return
    }
    self.items = self.items.filter { $0 != item }
  }

  func clearItems() {
    self.items.removeAll()
  }

  func clusters(atZoom zoom: Float) -> [GMUCluster] {
    var clusters: [GMUCluster] = []

    items.forEach {
      var clusterAdded = false
      for cluster in clusters {
        if let cluster = cluster as? CountryCluster {
          if let id = (cluster.items.first as? SurfSpotsClusterItem)?.country.id,
             id == $0.country.id {
            cluster.items.append($0)
            clusterAdded = true
            break
          }
        }
      }

      if !clusterAdded {
        let cluster = CountryCluster(
          id: $0.country.id,
          position: CLLocationCoordinate2D(latitude: $0.country.latitude, longitude: $0.country.longitude)
        )
        cluster.items.append($0)
        clusters.append(cluster)
      }
    }

    return clusters.count == items.count ? [] : clusters
  }
}
