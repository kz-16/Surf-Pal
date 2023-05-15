import Foundation

// MARK: - Welcome
struct Welcome: Codable {
  let latitude, longitude, generationtimeMS: Double
  let utcOffsetSeconds: Int
  let timezone, timezoneAbbreviation: String
  let elevation: Int
  let hourlyUnits: HourlyUnits
  let hourly: Hourly

  enum CodingKeys: String, CodingKey {
    case latitude, longitude
    case generationtimeMS = "generationtime_ms"
    case utcOffsetSeconds = "utc_offset_seconds"
    case timezone
    case timezoneAbbreviation = "timezone_abbreviation"
    case elevation
    case hourlyUnits = "hourly_units"
    case hourly
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
  let time, temperature2M, weathercode, windspeed10M: String
  let winddirection10M: String

  enum CodingKeys: String, CodingKey {
    case time
    case temperature2M = "temperature_2m"
    case weathercode
    case windspeed10M = "windspeed_10m"
    case winddirection10M = "winddirection_10m"
  }
}

