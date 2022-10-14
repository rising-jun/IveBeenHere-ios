//
//  FirebaseManagerTest.swift
//  IveBeenHereTests
//
//  Created by 김동준 on 2022/09/08.
//

@testable import IveBeenHere
import XCTest

class FirebaseManagerTest: XCTestCase {
    
    var firebaseManager: FirebaseManagable!
    
    func test_firebaseManager일때_readPlaceDTO를_호출하여_성공하고_Model을_Mapping한다() throws {
        //give
        firebaseManager = FirebaseManagerStub(testResult: true)
        let didFinish = expectation(description: #function)
        var modelCount = 0
        var expectCount = 1
        var testResult = false
        
        //when
        firebaseManager.readPlaceDTO { result in
            switch result {
            case .success(let places):
                modelCount = places.count
                testResult = true
            case .failure(let error):
                testResult = false
            }
            didFinish.fulfill()
        }
        wait(for: [didFinish], timeout: 1.0)
        
        // then
        XCTAssertEqual(modelCount, expectCount)
        XCTAssertEqual(testResult, true)
    }
    
    func test_firebaseManager일때_readPlaceDTO를_호출하여_실패하면_failure을호출한다() throws {
        //give
        firebaseManager = FirebaseManagerStub(testResult: false)
        let didFinish = expectation(description: #function)
        var testResult = false
        
        //when
        firebaseManager.readPlaceDTO { result in
            switch result {
            case .success(let places):
                testResult = false
            case .failure(let error):
                testResult = true
            }
            didFinish.fulfill()
        }
        wait(for: [didFinish], timeout: 1.0)
        
        // then
        XCTAssertEqual(testResult, true)
    }
    
    func test_firebaseManager일때_writePlaceDTO를_호출하여_성공한다() throws {
        // give
        firebaseManager = FirebaseManagerStub(testResult: true)
        let didFinish = expectation(description: #function)
        var testResult = false
        
        //when
        firebaseManager.writePlaceDTO(placeDTO: PlaceDTO(latitude: 0.0, name: "", longitude: 0.0)) { result in
            switch result {
            case .success(_):
                testResult = true
            case .failure(_):
                testResult = false
            }
            didFinish.fulfill()
        }
        
        wait(for: [didFinish], timeout: 1.0)
        
        // then
        XCTAssertEqual(testResult, true)
    }
    
    func test_firebaseManager일때_writePlaceDTO를_호출하여_실패하고_writeError를_반환한다() throws {
        // give
        firebaseManager = FirebaseManagerStub(testResult: false)
        let didFinish = expectation(description: #function)
        var testResult = false
        var testError: FireBaseError = .nilDataError
        
        //when
        firebaseManager.writePlaceDTO(placeDTO: PlaceDTO(latitude: 0.0, name: "", longitude: 0.0)) { result in
            switch result {
            case .success(_):
                testResult = false
            case .failure(let firebaseError):
                testResult = true
                testError = firebaseError
            }
            didFinish.fulfill()
        }
        
        wait(for: [didFinish], timeout: 1.0)
        
        // then
        XCTAssertEqual(testResult, true)
        XCTAssertEqual(testError, .writeError)
    }
    
    func test_firebaseManager일때_writeVisitDTO를_호출하여_성공한다() async throws {
        //give
        firebaseManager = FirebaseManagerStub(testResult: true)
        let didFinish = expectation(description: #function)
        var testResult = false
        
        //when
        let result = try await firebaseManager.writeVisitDTO(visitDTO: VisitDTO(place: PlaceDTO(latitude: 0.0, name: "", longitude: 0.0), date: "", title: "", content: "", imageURL: "", userId: ""))
        switch result {
        case .success(_):
            testResult = true
        case .failure(_):
            testResult = false
        }
        didFinish.fulfill()
        
        wait(for: [didFinish], timeout: 1.0)
        
        // then
        XCTAssertEqual(testResult, true)
    }
    
    func test_firebaseManager일때_readVisitDTO를_호출하여_성공하고_Model을_Mapping한다() async throws {
        firebaseManager = FirebaseManagerStub(testResult: true)
        let didFinish = expectation(description: #function)
        var testResult = false
        var modelCount = 0
        
        //when
        let result = try await firebaseManager.readVisitDTO()
        switch result {
        case .success(let dtos):
            testResult = true
            modelCount = dtos.count
        case .failure(_):
            testResult = false
        }
        didFinish.fulfill()
        
        wait(for: [didFinish], timeout: 1.0)
        
        // then
        XCTAssertEqual(testResult, true)
        XCTAssertGreaterThan(modelCount, 0)
    }
    
    func test_firebaseManager일때_writeVisitDTO를_호출하여_실패하고_write에러를_반환한다() async throws {
        //give
        firebaseManager = FirebaseManagerStub(testResult: false)
        let didFinish = expectation(description: #function)
        var testResult = false
        var testError: FireBaseError = .nilDataError
        //when
        let result = try await firebaseManager.writeVisitDTO(visitDTO: VisitDTO(place: PlaceDTO(latitude: 0.0, name: "", longitude: 0.0), date: "", title: "", content: "", imageURL: "", userId: ""))
        switch result {
        case .success(_):
            testResult = false
        case .failure(let error):
            testResult = true
            testError = error
        }
        didFinish.fulfill()
        
        wait(for: [didFinish], timeout: 1.0)
        
        // then
        XCTAssertEqual(testResult, true)
        XCTAssertEqual(testError, .writeError)
    }
}
