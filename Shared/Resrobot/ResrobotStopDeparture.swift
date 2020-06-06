import Foundation
import Combine

fileprivate struct ResrobotStopDeparturesResponse: Codable {
  let departures: [ResrobotStopDeparture]

  private enum CodingKeys: String, CodingKey {
    case departures = "Departure"
  }
}

struct ResrobotStopDeparture: Codable, Identifiable {
  static let resrobotStopEndpoint = URLComponents(
    string: "https://api.resrobot.se/v2/departureBoard.json"
  )!

  var id: String { "\(line)\(direction)\(datePart)\(timePart)" }
  let line: String
  let direction: String
  var directionShort: String {
    do {
      let regex = try NSRegularExpression(pattern: "\\(.+\\)", options: [])
      return regex
        .stringByReplacingMatches(
          in: direction, options: [], range: NSMakeRange(0, direction.count), withTemplate: ""
        )
        .trimmingCharacters(in: .whitespacesAndNewlines)
    } catch {
      return ""
    }
  }
  var time: Date {
    dateFormatter.date(from: "\(datePart) \(timePart) Europe/Stockholm")!
  }
  private let datePart: String
  private let timePart: String

  private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
    return formatter
  }

  private enum CodingKeys: String, CodingKey {
    case line = "transportNumber"
    case direction = "direction"
    case datePart = "date"
    case timePart = "time"
  }

  static func upcoming(
    at stop: ResrobotStop, limit: Int = 20
  ) -> AnyPublisher<[ResrobotStopDeparture], Never> {
    return URLSession.shared.dataTaskPublisher(for: requestURL(querying: stop, limit: limit))
      .tryMap() { element -> Data in
        guard let httpResponse = element.response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return element.data
      }
      .decode(type: ResrobotStopDeparturesResponse.self, decoder: JSONDecoder())
      .map() { $0.departures }
      .catch() { failure -> Just<[ResrobotStopDeparture]> in
        NSLog("failure \(failure)")
        return Just([])
      }
      .eraseToAnyPublisher()
  }

  static private func requestURL(querying stop: ResrobotStop, limit: Int) -> URL {
    var requestURLComponents = resrobotStopEndpoint
    requestURLComponents.queryItems = [
      URLQueryItem(name: "key", value: Secrets.resrobotStolptidtabeller2Key),
      URLQueryItem(name: "id", value: stop.id),
      URLQueryItem(name: "format", value: "json"),
      URLQueryItem(name: "maxJourneys", value: String(limit))
    ]
    return requestURLComponents.url!
  }
}
