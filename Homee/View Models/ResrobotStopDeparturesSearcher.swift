import Foundation
import Combine

class ResrobotStopDeparturesSearcher: ObservableObject, Identifiable {
  @Published private(set) var departures: [ResrobotStopDeparture] = []

  let stop: ResrobotStop
  let limit: Int
  var id: String { stop.id }
  private var cancellable: AnyCancellable?
  private var timer: Timer?

  init(stop: ResrobotStop, limit: Int) {
    self.stop = stop
    self.limit = limit
  }

  func startUpdates() {
    if (timer != nil) { return }

    perform()
  }

  func stopUpdates() {
    self.timer = nil
  }

  private func perform() {
    cancellable = ResrobotStopDeparture.upcoming(at: stop, limit: limit)
      .receive(on: DispatchQueue.main)
      .sink { departures in
        self.cancellable = nil
        self.departures = departures

        let timer = Timer(
          fire: self.nextUpdate(with: departures), interval: 0, repeats: false
        ) { _ in
          self.perform()
        }
        RunLoop.main.add(timer, forMode: .default)
        self.timer = timer
      }
  }

  private func nextUpdate(with departures: [ResrobotStopDeparture]) -> Date {
    return [
      Date().advanced(by: 60 * 5),
      departures.first?.time.advanced(by: 60)
    ].compactMap { $0 }.min()!
  }
}
