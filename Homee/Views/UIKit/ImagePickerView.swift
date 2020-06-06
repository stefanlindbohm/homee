import SwiftUI
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
  let onImagePicked: (UIImage) -> Void

  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }

  func makeUIViewController(context: Context) -> UIImagePickerController {
    let controller = UIImagePickerController()
    controller.allowsEditing = true
    controller.delegate = context.coordinator
    return controller
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
  }

  final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    private let onImagePicked: (UIImage) -> Void

    init(_ imagePickerView: ImagePickerView) {
      self.onImagePicked = imagePickerView.onImagePicked
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
      onImagePicked(image)
    }
  }
}
