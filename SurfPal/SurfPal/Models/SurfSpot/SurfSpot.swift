import Foundation

struct SurfSpot: Codable {
  let id: Int
  let countryId: Int
  let name: String
  let description: String
  let imageURL: String
  let latitude: Double
  let longitude: Double
  let surferLevel: [SurferLevel]
  let goodSeason: SurferSeason
  let bestSeason: SurferSeason

  enum CodingKeys: String, CodingKey {
    case id
    case countryId = "country_id"
    case name
    case description
    case imageURL = "image_url"
    case latitude
    case longitude
    case surferLevel = "surfer_level"
    case goodSeason = "good_season"
    case bestSeason = "best_season"
  }
}

extension SurfSpot {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decode(Int.self, forKey: .id)
    self.countryId = try container.decode(Int.self, forKey: .countryId)
    self.name = try container.decode(String.self, forKey: .name)
    self.description = try container.decode(String.self, forKey: .description)
    self.imageURL = try container.decode(String.self, forKey: .imageURL)
    self.latitude = try container.decode(Double.self, forKey: .latitude)
    self.longitude = try container.decode(Double.self, forKey: .longitude)
    self.surferLevel = try container.decode([SurferLevel].self, forKey: .surferLevel)
    self.goodSeason = try container.decode(SurferSeason.self, forKey: .goodSeason)
    self.bestSeason = try container.decode(SurferSeason.self, forKey: .bestSeason)
  }
}

extension SurfSpot: Equatable {
  static func == (lhs: SurfSpot, rhs: SurfSpot) -> Bool {
    lhs.id == rhs.id
  }
}


struct LocationZone: Codable {
  let id: Int
  let name: String
  let cameraPosition: CameraPosition

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case cameraPosition = "camera_position"
  }
}

extension LocationZone {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decode(Int.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.cameraPosition = try container.decode(CameraPosition.self, forKey: .cameraPosition)
  }
}

enum SurferLevel: String, Codable {
  case beginner = "BEGINNER"
  case intermediate = "INTERMEDIATE"
  case advanced = "ADVANCED"
  case expert = "EXPERT"

  var id: Int {
    switch self {
    case .beginner:
      return 0
    case .intermediate:
      return 1
    case .advanced:
      return 2
    case .expert:
      return 3
    }
  }
}

