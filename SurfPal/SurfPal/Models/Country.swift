import Foundation

struct CameraPosition: Codable {
  let latitude: Double
  let longitude: Double
  let zoom: Float

  enum CodingKeys: String, CodingKey {
    case latitude
    case longitude
    case zoom
  }
}

extension CameraPosition {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.latitude = try container.decode(Double.self, forKey: .latitude)
    self.longitude = try container.decode(Double.self, forKey: .longitude)
    self.zoom = try container.decode(Float.self, forKey: .zoom)
  }
}

struct Country: Codable {
  let id: Int
  let name: String
  let flag: String
  let iconURL: String
  let airportCode: String
  let latitude: Double
  let longitude: Double
  let zoom: Float

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case flag
    case iconURL = "icon_url"
    case airportCode = "airport_code"
    case latitude
    case longitude
    case zoom
  }
}

extension Country {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decode(Int.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.flag = try container.decode(String.self, forKey: .flag)
    self.iconURL = try container.decode(String.self, forKey: .iconURL)
    self.airportCode = try container.decode(String.self, forKey: .airportCode)
    self.latitude = try container.decode(Double.self, forKey: .latitude)
    self.longitude = try container.decode(Double.self, forKey: .longitude)
    self.zoom = try container.decode(Float.self, forKey: .zoom)
  }
}

extension Country: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: Country, rhs: Country) -> Bool {
    return lhs.id == rhs.id
  }
}
