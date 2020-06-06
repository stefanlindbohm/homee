import SwiftUI

struct DashboardPanel<Content: View>: View {
  let content: () -> Content

  var body: some View {
    Group() {
      content()
    }
      .frame(maxWidth: .infinity)
      .padding(16)
      .background(VisualEffectView(effect: UIBlurEffect(style: .extraLight)))
      .cornerRadius(8)
      .foregroundColor(.black)
  }
}

struct DashboardPanel_Previews: PreviewProvider {
  static var previews: some View {
    DashboardPanel() {
      Text("Hello!")
    }
    .previewLayout(.fixed(width: 400, height: 100))
    .frame(maxHeight: .infinity)
    .padding(16)
    .background(Image("DefaultWallpaper").resizable())
  }
}
