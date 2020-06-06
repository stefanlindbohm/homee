import SwiftUI

struct SearchBar: UIViewRepresentable {
  @Binding var text: String
  let onTextChange: () -> Void

  func makeCoordinator() -> SearchBar.Coordinator {
    Coordinator(self)
  }

  func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
    let searchBar = UISearchBar(frame: .zero)
    searchBar.delegate = context.coordinator
    return searchBar
  }

  func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
    uiView.text = text
  }

  final class Coordinator: NSObject, UISearchBarDelegate {
    @Binding var text: String
    let onTextChange: () -> Void

    init(_ searchBar: SearchBar) {
      _text = searchBar.$text
      onTextChange = searchBar.onTextChange
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      text = searchText
      onTextChange()
    }
  }
}

struct SearchBar_Previews: PreviewProvider {
  static var previews: some View {
    SearchBar(text: .constant(""), onTextChange: { })
  }
}
