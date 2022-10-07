//
//  WriteUsecase.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/26.
//

import Foundation

final class WriteUsecase {
    var firebaseManagable: FirebaseManagable
    var viewModelResponse: WriteViewModelOutput?
    init() {
        firebaseManagable = FirebaseManager.shared
    }
}
extension WriteUsecase {
    func requestPlaces() {
        firebaseManagable.readPlaceDTO { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let places):
                self.viewModelResponse?.locationRelay.accept(value: places)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestUploadImage(imageData: Data) async throws -> URL? {
        try await firebaseManagable.uploadImage(from: imageData)
    }
    
    func requestWriteVisitDTO(from visitDTO: VisitDTO) async throws -> Result<Void, FireBaseError> {
        try await firebaseManagable.writeVisitDTO(visitDTO: visitDTO)
    }
}
