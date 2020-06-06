import SwiftUI

struct MainView: View {
  @State private var selection = 0

  var body: some View {
    TabView(selection: $selection) {
      DashboardView()
        .tabItem {
          Image(systemName: "star.fill")
          Text("Dashboard")
        }
        .tag(0)

      Text("You'll be able to control home accessories here later.")
        .font(.title)
        .tabItem {
          Image(systemName: "house.fill")
          Text("Home Control")
        }
        .tag(1)
    }
    .statusBar(hidden: true)
    .accentColor(.orange)
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
      .previewDevice("iPad Pro (10.5-inch)")
  }
}
