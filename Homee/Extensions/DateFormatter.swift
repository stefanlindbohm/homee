import Foundation

extension DateFormatter {
  convenience public init(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) {
    self.init()
    self.dateStyle = dateStyle
    self.timeStyle = timeStyle
  }
}
