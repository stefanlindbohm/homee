import Foundation

struct Countdown {
  static let test = Countdown(
    target: Date(timeIntervalSince1970: 1611129600), description: "Inflyttning Sågvägen"
  )

  let target: Date
  let description: String
}
