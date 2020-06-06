import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var preferences: Preferences
  @State var isPickingImage = false
  @State var isAddingStop = false

  var body: some View {
    List() {
      Section(header: Text("Wallpaper")) {
        Button(action: {
          self.isPickingImage = true
        }) {
          Text("Choose from Library...")
        }
          .sheet(isPresented: $isPickingImage) {
            ImagePickerView { image in
              self.preferences.wallpaper = image
              self.isPickingImage = false
            }
        }

        HStack {
          Spacer()

          Image(uiImage: preferences.wallpaper)
            .resizable()
            .scaledToFit()
            .frame(height: 200)

          Spacer()
        }
      }

      Section(header: Text("Public Transit Stops")) {
        //ForEach(self.preferences.publicTransitStops) { stop in
          //Text("stop.name")
        //}

        Button(action: {
          self.isAddingStop = true
        }) {
          Text("Add Stop...")
        }
          .sheet(isPresented: $isAddingStop) {
            NavigationView {
              AddStopView(onSelect: { stop in
                self.preferences.publicTransitStops.append(stop)
                self.isAddingStop = false
              })
                .navigationBarItems(leading: Button(action: {
                  self.isAddingStop = false
                }) { Text("Cancel") })
            }
            .navigationViewStyle(StackNavigationViewStyle())
          }
      }
    }
    .listStyle(GroupedListStyle())
    .navigationBarTitle("Settings", displayMode: .inline)
  }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
      NavigationView() {
        SettingsView()
          .environmentObject(Preferences())
      }
        .navigationViewStyle(StackNavigationViewStyle())
        .previewDevice("iPad Pro (10.5-inch)")
    }
}
