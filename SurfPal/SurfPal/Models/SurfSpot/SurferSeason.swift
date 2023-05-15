import Foundation

struct SurferSeason: Codable {
let startMonth: String
let endMonth: String

enum CodingKeys: String, CodingKey {
  case startMonth = "start_month"
  case endMonth = "end_month"
}
}

extension SurferSeason {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.startMonth = try container.decode(String.self, forKey: .startMonth)
    self.endMonth = try container.decode(String.self, forKey: .endMonth)
  }
}

