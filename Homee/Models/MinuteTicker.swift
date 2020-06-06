import UIKit
import Combine

class MinuteTicker: ObservableObject {
  @Published var currentMinute: Date

  private static let gregorianCalendar = Calendar(identifier: .gregorian)
  private static var zeroSeconds = DateComponents(second: 0)

  private var timer: Timer?
  private let significantTimeChangePublisher = NotificationCenter.default.publisher(
    for: UIApplication.significantTimeChangeNotification
  )
  private var significantTimeChangeSubscriber: AnyCancellable?

  init() {
    currentMinute = Self.currentMinute()
  }

  deinit {
    stop()
  }

  func start() {
    currentMinute = Self.currentMinute()

    self.scheduleTimer()

    self.significantTimeChangeSubscriber = significantTimeChangePublisher.sink { _ in
      self.currentMinute = Self.currentMinute()
      self.timer?.invalidate()
      self.scheduleTimer()
    }
  }

  func stop() {
    self.timer?.invalidate()
    self.significantTimeChangeSubscriber?.cancel()
  }

  private static func currentMinute() -> Date {
    return Self.gregorianCalendar.nextDate(
      after: Date(), matching: Self.zeroSeconds, matchingPolicy: .nextTime, direction: .backward
    )!
  }

  private static func nextMinute() -> Date {
    Self.gregorianCalendar.nextDate(
      after: Date(), matching: Self.zeroSeconds, matchingPolicy: .nextTime, direction: .forward
    )!
  }

  private func scheduleTimer() {
    let timer = Timer(fire: Self.nextMinute(), interval: 60, repeats: true) { _ in
      let now = Date()
      let startOfMinute = Self.gregorianCalendar.dateInterval(of: .minute, for: now)!.start
      let currentSeconds = now.timeIntervalSince(startOfMinute)
      let roundedSeconds = (currentSeconds / 60).rounded() * 60

      self.currentMinute = startOfMinute.addingTimeInterval(roundedSeconds)
    }

    RunLoop.main.add(timer, forMode: .default)
    self.timer = timer
  }
}
