import SwiftUI

struct CountdownPanel: View {
  let countdown = Countdown.test

  var body: some View {
    DashboardPanel() {
      VStack(alignment: .center, spacing: 8) {
        Text(self.countdown.description)
          .font(.system(size: 20, weight: .regular))

        Text("\(self.daysToTarget()) days")
          .font(.system(size: 40))
      }
    }
  }

  func daysToTarget() -> Int {
    Calendar.current.dateComponents([.day], from: Date(), to: self.countdown.target).day!
  }
}

struct CountdownPanel_Previews: PreviewProvider {
  static var previews: some View {
    CountdownPanel()
      .previewLayout(.fixed(width: 400, height: 400))
      .frame(maxHeight: .infinity)
      .padding(16)
      .background(Image("DefaultWallpaper").resizable())
  }
}
