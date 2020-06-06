import SwiftUI

fileprivate struct StopView: View {
  @ObservedObject var departuresSearcher: ResrobotStopDeparturesSearcher
  let timeFormatter = DateFormatter(dateStyle: .none, timeStyle: .short)

  var body: some View {
    VStack {
      Text(departuresSearcher.stop.name)
        .font(.system(size: 20, weight: .regular))
        .padding(.bottom, 8)

      if (departuresSearcher.departures.isEmpty) {
        ActivityIndicator(isAnimating: .constant(true), style: .medium)
      } else {
        ForEach(departuresSearcher.departures) { departure in
          HStack {
            Text("\(departure.line)")
              .font(.largeTitle)
              .padding(8)
              .background(Color.gray)
              .foregroundColor(Color.white)
              .cornerRadius(8)

            Text(departure.directionShort)
              .font(.title)

            Spacer()

            Text("\(self.timeFormatter.string(from: departure.time))")
              .font(.title)
              .fontWeight(.semibold)
          }
          .padding(.vertical, 4)
        }
      }
    }
  }
}

struct PublicTransitPanel: View {
  @EnvironmentObject private var preferences: Preferences
  @State private var departuresSearchers: [ResrobotStopDeparturesSearcher] = []
  @State private var isVisible = false

  var body: some View {
    NSLog("Rendering \(self.departuresSearchers)")

    return DashboardPanel() {
      VStack(spacing: 32) {
        ForEach(self.departuresSearchers) { departuresSearcher in
          StopView(departuresSearcher: departuresSearcher)
        }
      }
    }
    .onAppear {
      self.isVisible = true
      self.updateSearchers(with: self.preferences.publicTransitStops)
    }
    .onDisappear() {
      self.isVisible = false
      self.departuresSearchers.forEach { $0.stopUpdates() }
    }
    .onReceive(preferences.$publicTransitStops) { stops in
      self.updateSearchers(with: stops)
    }
  }

  func updateSearchers(with stops: [ResrobotStop]) {
    departuresSearchers = stops.map { stop in
      let existing = departuresSearchers.first(where: { searcher in
        searcher.stop.id == stop.id
      })

      if let existing = existing {
        return existing
      } else {
        return ResrobotStopDeparturesSearcher(stop: stop, limit: 3)
      }
    }

    if isVisible {
      departuresSearchers.forEach { $0.startUpdates() }
    }
  }
}

struct PublicTransit_Previews: PreviewProvider {
  static var previews: some View {
    let preferences = Preferences()
    preferences.publicTransitStops = [ResrobotStop(id: "740029929", name: "Åre Pilgrimsvägen")]

    return PublicTransitPanel()
      .previewLayout(.fixed(width: 400, height: 400))
      .frame(maxHeight: .infinity)
      .padding(16)
      .background(Image("DefaultWallpaper").resizable())
      .environmentObject(preferences)
  }
}
