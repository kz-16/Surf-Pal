import Foundation

// MARK: - Marine
struct Marine: Codable {
  let latitude: Double
  let longitude: Double
  let generationtimeMS: Double
  let utcOffsetSeconds: Int
  let timezone: String
  let timezoneAbbreviation: String
  let hourlyUnits: MarineHourlyUnits
  let hourly: MarineHourly

  enum CodingKeys: String, CodingKey {
    case latitude, longitude
    case generationtimeMS = "generationtime_ms"
    case utcOffsetSeconds = "utc_offset_seconds"
    case timezone
    case timezoneAbbreviation = "timezone_abbreviation"
    case hourlyUnits = "hourly_units"
    case hourly
  }
}

// MARK: - MarineHourly
struct MarineHourly: Codable {
  let time: [String]
  let waveHeight: [Double]

  enum CodingKeys: String, CodingKey {
    case time
    case waveHeight = "wave_height"
  }
}

// MARK: - MarineHourlyUnits
struct MarineHourlyUnits: Codable {
  let time: String
  let waveHeight: String

  enum CodingKeys: String, CodingKey {
    case time
    case waveHeight = "wave_height"
  }
}
