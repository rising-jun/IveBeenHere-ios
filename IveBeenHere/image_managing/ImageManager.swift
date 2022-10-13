//
//  ImageManager.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/10/13.
//

import Foundation

final class ImageManager { }
extension ImageManager: ImageManagable {
    func fetchImage(from url: URL) async -> Data? {
        return await withUnsafeContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                continuation.resume(returning: data)
            }.resume()
        }
    }
}
protocol ImageManagable {
    func fetchImage(from url: URL) async -> Data?
}
