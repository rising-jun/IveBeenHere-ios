//
//  FirebaseManagerStub.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/10/13.
//

import Foundation

final class FirebaseManagerStub: FirebaseManagable {
    
    private var testResult: Bool
    init(testResult: Bool) {
        self.testResult = testResult
    }
    
    func uploadImage(from data: Data) async throws -> URL? {
        testResult ? URL(string: "") : nil
    }
    
    func writeVisitDTO(visitDTO: VisitDTO) async throws -> Result<Void, FireBaseError> {
        testResult ? .success(()) : .failure(.nilDataError)
    }
    
    func readVisitDTO() async -> Result<[VisitDTO], FireBaseError> {
        testResult ? .success([VisitDTO(place: PlaceDTO(latitude: 0.0, name: "name", longitude: 0.0), date: "2022-10-13", title: "", content: "", imageURL: "imageURL", userId: "userId")]) : .failure(.nilDataError)
    }
    
    func writePlaceDTO(placeDTO: PlaceDTO, completion: @escaping (Result<FirebaseWriteResult, FireBaseError>) -> Void) {
        testResult ? completion(.success(.success)) : completion(.failure(.nilDataError))
    }

    func readPlaceDTO(completion: @escaping (Result<[PlaceDTO], FireBaseError>) -> Void) {
        testResult ? completion(.success([])) : completion(.failure(.nilDataError))
    }
}
