//
//  PostUsecase.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/10/11.
//

import Foundation

final class PostUsecase {
    var imageManager = ImageManager()
    func convertEntity(from visitDTO: VisitDTO) async -> VisitEntity {
        let entity = visitDTO.convertVisitEntity()
        if let imageURL = URL(string: visitDTO.imageURL) {
            let data = await imageManager.fetchImage(from: imageURL)
            entity.setImageData(from: data)
            return entity
        }
        return entity
    }
}

final class ImageManager {
    func fetchImage(from url: URL) async -> Data? {
        return await withUnsafeContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                continuation.resume(returning: data)
            }.resume()
        }
    }
}
