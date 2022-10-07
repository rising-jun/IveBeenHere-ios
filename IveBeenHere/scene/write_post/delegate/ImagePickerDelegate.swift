//
//  ImagePickerDelegate.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/10/06.
//

import UIKit

final class ImagePickerDelegate: NSObject {
    var imageRelay: PublishRelay<Data>?
}
extension ImagePickerDelegate: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let originalImageSize = image.size
        (originalImageSize.height > UIImage.MAXSIZE || originalImageSize.width > UIImage.MAXSIZE) ? acceptResizedImage(value: image) : acceptImage(value: image)
        picker.dismiss(animated: true)
    }
    
    private func acceptResizedImage(value originalImage: UIImage) {
        guard let resizedImage = resizeImage(image: originalImage, newWidth: UIImage.MAXSIZE) else { return }
        guard let resizedImageData = resizedImage.pngData() else { return }
        imageRelay?.accept(value: resizedImageData)
    }
    
    private func acceptImage(value originalImage: UIImage) {
        guard let imageData = originalImage.pngData() else { return }
        imageRelay?.accept(value: imageData)
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width // 새 이미지 확대/축소 비율
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIImage {
    static let MAXSIZE = 512.0
}
