import Foundation

// MARK: - Forecast
struct Forecast: Codable {
  let latitude: Double
  let longitude: Double
  let generationTimeMS: Double
  let utcOffsetSeconds: Int
  let timezone: String
  let timezoneAbbreviation: String
  let elevation: Int
  let hourlyUnits: HourlyUnits
  let hourly: Hourly

  enum CodingKeys: String, CodingKey {
    case latitude
    case longitude
    case generationTimeMS = "generationtime_ms"
    case utcOffsetSeconds = "utc_offset_seconds"
    case timezone
    case timezoneAbbreviation = "timezone_abbreviation"
    case elevation
    case hourlyUnits = "hourly_units"
    case hourly
  }
}

extension Forecast {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.latitude = try container.decode(Double.self, forKey: .latitude)
    self.longitude = try container.decode(Double.self, forKey: .longitude)
    self.generationTimeMS = try container.decode(Double.self, forKey: .generationTimeMS)
    self.utcOffsetSeconds = try container.decode(Int.self, forKey: .utcOffsetSeconds)
    self.timezone = try container.decode(String.self, forKey: .timezone)
    self.timezoneAbbreviation = try container.decode(String.self, forKey: .timezoneAbbreviation)
    self.elevation = try container.decode(Int.self, forKey: .elevation)
    self.hourlyUnits = try container.decode(HourlyUnits.self, forKey: .hourlyUnits)
    self.hourly = try container.decode(Hourly.self, forKey: .hourly)
  }
}

// MARK: - Hourly
struct Hourly: Codable {
  let time: [String]
  let temperature2M: [Double]
  let weathercode: [Int]
  let windspeed10M: [Double]
  let winddirection10M: [Int]

  enum CodingKeys: String, CodingKey {
    case time
    case temperature2M = "temperature_2m"
    case weathercode
    case windspeed10M = "windspeed_10m"
    case winddirection10M = "winddirection_10m"
  }
}

// MARK: - HourlyUnits
struct HourlyUnits: Codable {
  let time: String
  let temperature2M: String
  let weathercode: String
  let windspeed10M: String
  let winddirection10M: String

  enum CodingKeys: String, CodingKey {
    case time
    case temperature2M = "temperature_2m"
    case weathercode
    case windspeed10M = "windspeed_10m"
    case winddirection10M = "winddirection_10m"
  }
}

