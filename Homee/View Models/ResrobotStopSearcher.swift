import Foundation
import Combine

class ResrobotStopSearcher: ObservableObject {
  @Published private(set) var results: [ResrobotStop] = []

  private var currentQuery: String = ""
  private var cancellable: AnyCancellable?
  private var updatePending: Bool = false

  func search(query: String) {
    currentQuery = query

    if cancellable == nil {
      performSearch()
    } else {
      updatePending = true
    }
  }

  private func performSearch() {
    cancellable = ResrobotStop.search(query: currentQuery)
      .receive(on: DispatchQueue.main)
      .sink { stops in
        self.cancellable = nil
        self.results = stops

        if (self.updatePending) {
          self.updatePending = false
          self.performSearch()
        }
      }
  }
}
