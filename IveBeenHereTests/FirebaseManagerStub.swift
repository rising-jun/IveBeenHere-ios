//
//  FirebaseManagerStub.swift
//  IveBeenHereTests
//
//  Created by 김동준 on 2022/09/08.
//

@testable import IveBeenHere
import Foundation

class FirebaseManagerStub: FirebaseManageable {
    var testResult: Bool
    
    init(testResult: Bool) {
        self.testResult = testResult
    }
    
    func readPlaceDTO(completion: @escaping(Result<[PlaceDTO], FireBaseError>) -> Void) {
        testResult ? completion(.success([PlaceDTO(latitude: 0.0, name: "", longitude: 0.0)])) : completion(.failure(.nilDataError))
    }
}

protocol FirebaseManageable {
    func readPlaceDTO(completion: @escaping(Result<[PlaceDTO], FireBaseError>) -> Void)
}
