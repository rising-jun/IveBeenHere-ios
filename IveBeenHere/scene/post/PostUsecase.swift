//
//  PostUsecase.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/10/11.
//

import Foundation

final class PostUsecase {
    var imageManager: ImageManagable?
}
extension PostUsecase: PostManagable {
    func convertEntity(from visitDTO: VisitDTO) async -> VisitEntity {
        let entity = visitDTO.convertVisitEntity()
        if let imageURL = URL(string: visitDTO.imageURL) {
            let data = await imageManager?.fetchImage(from: imageURL)
            entity.setImageData(from: data)
            return entity
        }
        return entity
    }
}

protocol PostManagable {
    func convertEntity(from visitDTO: VisitDTO) async -> VisitEntity
}
