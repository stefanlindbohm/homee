import SwiftUI

struct DashboardView: View {
  static let timeFormat = DateFormatter(dateStyle: .none, timeStyle: .short)
  static let dateFormat = DateFormatter(dateStyle: .full, timeStyle: .none)

  @EnvironmentObject private var minuteTicker: MinuteTicker
  @EnvironmentObject private var preferences: Preferences
  @State private var showingSettings = false

  var body: some View {
    return VStack() {
      HStack(alignment: .firstTextBaseline) {
        Text(DashboardView.timeFormat.string(from: minuteTicker.currentMinute))
          .font(.system(size: 60, weight: .regular, design: .default))

        Text(DashboardView.dateFormat.string(from: minuteTicker.currentMinute))
          .font(.title)

        Spacer()

        Button(action: { self.showingSettings = true }) {
          Image(systemName: "gear").imageScale(.large)
        }
          .sheet(isPresented: $showingSettings) {
            NavigationView() {
              SettingsView()
                .environmentObject(self.preferences)
                .navigationBarItems(trailing: Button("Done") {
                  self.showingSettings = false
                })
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(.orange)
        }
      }
        .padding(.top)

      HStack(alignment: .top, spacing: 16) {
        VStack(spacing: 16) {
          CountdownPanel()
        }

        VStack(spacing: 16) {
          PublicTransitPanel()
        }
      }
      .frame(maxWidth: .infinity)

      Spacer()
    }
    .padding()
    .background(Image(uiImage: preferences.wallpaper).resizable().scaledToFill())
    .foregroundColor(.white)
    .edgesIgnoringSafeArea(.top)
    .onAppear(perform: {
      self.minuteTicker.start()
    })
    .onDisappear(perform: {
      self.minuteTicker.stop()
    })
  }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
      TabView() {
        DashboardView()
          .environmentObject(Preferences())
          .environmentObject(MinuteTicker())
      }
        .previewDevice("iPad Pro (10.5-inch)")
    }
}
