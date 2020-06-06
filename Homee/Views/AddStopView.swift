import SwiftUI
import Combine

struct AddStopView: View {
  let onSelect: (ResrobotStop) -> Void
  @State var searchText = ""
  @ObservedObject var searcher = ResrobotStopSearcher()

  var body: some View {
    VStack() {
      SearchBar(text: self.$searchText) {
        self.searcher.search(query: self.searchText)
      }
      List() {
        ForEach(searcher.results) { stop in
          Button(action: {
            self.onSelect(stop)
          }) {
            Text(stop.name)
          }
        }
      }
    }
    .navigationBarTitle("Add Stop", displayMode: .inline)
  }
}

struct AddStopView_Previews: PreviewProvider {
    static var previews: some View {
      NavigationView() {
        AddStopView(onSelect: { stop in })
      }
        .navigationViewStyle(StackNavigationViewStyle())
        .previewDevice("iPad Pro (10.5-inch)")
    }
}
