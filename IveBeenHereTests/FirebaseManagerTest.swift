//
//  FirebaseManagerTest.swift
//  IveBeenHereTests
//
//  Created by 김동준 on 2022/09/08.
//

@testable import IveBeenHere
import XCTest

class FirebaseManagerTest: XCTestCase {
    
    var firebaseManager: FirebaseManageable!

    func test_firebaseManager일때_readPlaceDTO를_호출하여_성공하고_Model을Mapping한다() throws {
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
}
