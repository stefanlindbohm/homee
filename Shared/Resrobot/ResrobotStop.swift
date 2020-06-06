import Foundation
import Combine

fileprivate struct ResrobotStopsResponse: Codable {
  let stops: [ResrobotStop]

  private enum CodingKeys: String, CodingKey {
    case stops = "StopLocation"
  }
}

struct ResrobotStop: Codable, Identifiable {
  static let resrobotStopEndpoint = URLComponents(
    string: "https://api.resrobot.se/v2/location.name"
  )!

  let id: String
  let name: String

  static func search(query: String) -> AnyPublisher<[ResrobotStop], Never> {
    return URLSession.shared.dataTaskPublisher(for: requestURL(querying: query))
      .tryMap() { element -> Data in
        guard let httpResponse = element.response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
          }

        return element.data
      }
      .decode(type: ResrobotStopsResponse.self, decoder: JSONDecoder())
      .map() { $0.stops }
      .catch() { failure -> Just<[ResrobotStop]> in
        NSLog("failure \(failure)")
        return Just([])
      }
      .eraseToAnyPublisher()
  }

  static private func requestURL(querying query: String) -> URL {
    var requestURLComponents = resrobotStopEndpoint
    requestURLComponents.queryItems = [
      URLQueryItem(name: "key", value: Secrets.resrobotReseplanerareKey),
      URLQueryItem(name: "input", value: "\(query)?"),
      URLQueryItem(name: "format", value: "json")
    ]
    return requestURLComponents.url!
  }
}
