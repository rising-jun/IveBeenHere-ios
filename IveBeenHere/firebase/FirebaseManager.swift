//
//  FirebaseManager.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol FirebaseManagable {
    func readPlaceDTO(completion: @escaping(Result<[PlaceDTO], FireBaseError>) -> Void)
    func writePlaceDTO(placeDTO: PlaceDTO, completion: @escaping(Result<FirebaseWriteResult, FireBaseError>) -> Void)
    func uploadImage(from data: Data) async throws -> URL?
    func writeVisitDTO(visitDTO: VisitDTO) async throws -> Result<Void, FireBaseError>
    func readVisitDTO() async -> Result<[VisitDTO], FireBaseError>
}

final class FirebaseManager {
    static let shared: FirebaseManagable = FirebaseManager()
    //    static func stub(testResult: Bool) -> FirebaseManagable {
    //        return FirebaseManagerStub(testResult: testResult)
    //    }
}

//final class FirebaseManagerStub: FirebaseManagable {
//    private let testResult: Bool
//    init(testResult: Bool) {
//        self.testResult = testResult
//    }
//    
//    func writePlaceDTO(placeDTO: PlaceDTO, completion: @escaping (Result<FirebaseWriteResult, FireBaseError>) -> Void) {
//        testResult ? completion(.success(.success)) : completion(.failure(.nilDataError))
//    }
//    
//    func readPlaceDTO(completion: @escaping (Result<[PlaceDTO], FireBaseError>) -> Void) {
//        testResult ? completion(.success([])) : completion(.failure(.nilDataError))
//    }
//}

extension FirebaseManager: FirebaseManagable {
    func uploadImage(from data: Data) async throws -> URL? {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH_mm_ss"
        var currentDate = formatter.string(from: Date())
        
        let storageRef = Storage.storage().reference().child("\(currentDate).png")
        return await withCheckedContinuation { continues in
            storageRef.putData(data) { metaData, error in
                storageRef.downloadURL { url, error in
                    guard let url = url else {
                        return
                    }
                    continues.resume(returning: url)
                }
            }.resume()
        }
    }
    
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
            .document("PlaceDTO")
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
            .document("PlaceDTO")
            .updateData(["PlaceDTO" : FieldValue.arrayUnion([resultJson])])
        completion(.success(.success))
    }
    
    func writeVisitDTO(visitDTO: VisitDTO) async throws -> Result<Void, FireBaseError> {
        return await withCheckedContinuation { continues in
            guard let jsonData = try? JSONEncoder().encode(visitDTO) else {
                return continues.resume(returning: .failure(.jsonParsingError))
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
                return continues.resume(returning: .failure(.jsonParsingError))
            }
            
            guard let resultJson = result as? [String: Any] else {
                return continues.resume(returning: .failure(.jsonParsingError))
            }
            
            Firestore.firestore()
                .collection("VisitData")
                .document("VisitDTO")
                .updateData(["VisitDTO" : FieldValue.arrayUnion([resultJson])])
            continues.resume(returning: .success(()))
        }
    }
    
    func readVisitDTO() async -> Result<[VisitDTO], FireBaseError> {
        return await withCheckedContinuation { continues in
            let documentSnapshotCompletion: ((DocumentSnapshot?, Error?) -> ()) = { document, error in
                guard let visitDTOJson = document?.data() else { return continues.resume(returning: .failure(.nilDataError)) }
                
                guard let visitDTOData = try? JSONSerialization.data(withJSONObject: visitDTOJson, options: .prettyPrinted) else {
                    return continues.resume(returning: .failure(.jsonParsingError))
                }
                
                guard let visitDTOs = try? JSONDecoder().decode(VisitSnap.self, from: visitDTOData).visitDTOs else {
                    return continues.resume(returning: .failure(.jsonParsingError))
                }
                continues.resume(returning: .success(visitDTOs))
            }
            Firestore.firestore()
                .collection("VisitData")
                .document("VisitDTO")
                .getDocument(completion: documentSnapshotCompletion)
        }
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

