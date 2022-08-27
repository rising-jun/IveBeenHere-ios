//
//  FirebaseManager.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/24.
//

import Foundation
import FirebaseFirestore

protocol FirebaseManagable {
    func readPlaceDTO(completion: @escaping(Result<[PlaceDTO], FireBaseError>) -> Void)
    func writePlaceDTO(placeDTO: PlaceDTO, completion: @escaping(Result<FirebaseWriteResult, FireBaseError>) -> Void)
}

final class FirebaseManager {
    static let shared: FirebaseManagable = FirebaseManager()
    static func stub(testResult: Bool) -> FirebaseManagable {
        return FirebaseManagerStub(testResult: testResult)
    }
}

final class FirebaseManagerStub: FirebaseManagable {
    private let testResult: Bool
    init(testResult: Bool) {
        self.testResult = testResult
    }
    
    func writePlaceDTO(placeDTO: PlaceDTO, completion: @escaping (Result<FirebaseWriteResult, FireBaseError>) -> Void) {
        testResult ? completion(.success(.success)) : completion(.failure(.nilDataError))
    }
    
    func readPlaceDTO(completion: @escaping (Result<[PlaceDTO], FireBaseError>) -> Void) {
        testResult ? completion(.success([])) : completion(.failure(.nilDataError))
    }
}

extension FirebaseManager: FirebaseManagable {
    func readPlaceDTO(completion: @escaping (Result<[PlaceDTO], FireBaseError>) -> Void) {
        let documentSnapshotCompletion: ((DocumentSnapshot?, Error?) -> ()) = { document, error in
            DispatchQueue.global().async {
                guard let placeDTOJson = document?.data() else { return completion(.failure(.nilDataError)) }
                
                guard let placeDTOData = try? JSONSerialization.data(withJSONObject: placeDTOJson, options: .prettyPrinted) else {
                    return completion(.failure(.jsonParsingError))
                }
                
                guard let placeDTOs = try? JSONDecoder().decode(SnapInfo.self, from: placeDTOData).placeDTOS else {
                    return completion(.failure(.jsonParsingError))
                }
                
                completion(.success(placeDTOs))
            }
        }
        
        Firestore.firestore()
            .collection("VisitData")
            .document("PlaceDTOs")
            .getDocument(completion: documentSnapshotCompletion)
    }
    
    func writePlaceDTO(placeDTO: PlaceDTO, completion: @escaping (Result<FirebaseWriteResult, FireBaseError>) -> Void) {
        guard let jsonData = try? JSONEncoder().encode(placeDTO) else {
            return completion(.failure(.jsonParsingError))
        }
        
        guard let result = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
            return completion(.failure(.jsonParsingError))
        }

        guard let resultJson = result as? [String: Any] else { return completion(.failure(.jsonParsingError)) }
        
        Firestore.firestore()
            .collection("VisitData")
            .document("PlaceDTOs")
            .updateData(["placeDTOs" : FieldValue.arrayUnion([resultJson])])
        completion(.success(.success))
    }
}

enum FireBaseError: Error{
    case snapError
    case writeError
    case nilDataError
    case jsonParsingError
}

enum FirebaseWriteResult{
    case success
    case failed(error: FireBaseError)
}
