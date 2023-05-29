import Foundation

public extension Encodable {
  
  func toJSON(with encoder: JSONEncoder = JSONEncoder()) -> [String: Any] {
    guard let data = try? encoder.encode(self) else {
      return [:]
    }
    
    guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
      return [:]
    }
    
    return json
  }
}
