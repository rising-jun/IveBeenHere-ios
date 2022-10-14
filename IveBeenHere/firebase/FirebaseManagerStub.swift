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
    
    private func loadJSON(_ fileName: String) -> Data? {
        guard let path = Bundle.init(for: FirebaseManagerStub.self).path(forResource: fileName, ofType: "json") else {
            print("--- file not found : \(fileName).json")
            return nil
        }
        let fileURL = URL(fileURLWithPath: path)
        guard let data = try? Data.init(contentsOf: fileURL) else {
            print("--- can not access the file : \(fileName).json")
            return nil
        }
        return data
    }
    
    func uploadImage(from data: Data) async throws -> URL? {
        testResult ? URL(string: "") : nil
    }
    
    func writeVisitDTO(visitDTO: VisitDTO) async throws -> Result<Void, FireBaseError> {
        testResult ? .success(()) : .failure(.writeError)
    }
    
    func readVisitDTO() async -> Result<[VisitDTO], FireBaseError> {
        let mockData = loadJSON("MockVisitDTOs")
        if let visitDTOs = try? JSONDecoder().decode(VisitSnap.self, from: mockData!).visitDTOs {
            return testResult ? .success(visitDTOs) : .failure(.nilDataError)
        }
        return .failure(.jsonParsingError)
    }
    
    func writePlaceDTO(placeDTO: PlaceDTO, completion: @escaping (Result<FirebaseWriteResult, FireBaseError>) -> Void) {
        testResult ? completion(.success(.success)) : completion(.failure(.writeError))
    }

    func readPlaceDTO(completion: @escaping (Result<[PlaceDTO], FireBaseError>) -> Void) {
        let mockData = loadJSON("MockPlaceDTOs")
        if let placeDTOs = try? JSONDecoder().decode(SnapInfo.self, from: mockData!).placeDTOS {
            testResult ? completion(.success(placeDTOs)) : completion(.failure(.nilDataError))
        }
    }
}
