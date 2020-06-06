import UIKit

class Preferences: ObservableObject {
  @Published var wallpaper: UIImage
  @Published var publicTransitStops: [ResrobotStop] = []

  init() {
    wallpaper = UIImage(named: "DefaultWallpaper")!
  }
}
