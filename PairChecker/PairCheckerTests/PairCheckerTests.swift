//
//  PairCheckerTests.swift
//  PairCheckerTests
//
//  Created by Yunjae Kim on 2022/02/11.
//

import XCTest
@testable import PairChecker

class PairCheckerTests: XCTestCase {
    
    func testReturnFalseWhenInvalidHangeulIsInput() {
        let string = "가나1a"
        XCTAssertFalse(NameChecker.shared.checkValidHangeul(input: string))
    }
    
    func testReturnTrueWhenValidHangeulIsInput() {
        let string = "홍길동"
        XCTAssertTrue(NameChecker.shared.checkValidHangeul(input: string))
    }
    
    func testHangeulSlicedCollectly() {
        let string = "홍길동"
        let expectedBehavior = [["ㅎ","ㅗ","ㅇ"],["ㄱ","ㅣ","ㄹ"],["ㄷ","ㅗ","ㅇ"]]
        
        XCTAssertEqual(expectedBehavior, NameChecker.shared.sliceHangeul(hangeul: string))
    }
        
    func testNameJum() {
        let person1 = "홍길동"
        let person2 = "김영빈"
        
        XCTAssertEqual(11, NameChecker.shared.calculate(person1: person1, person2: person2))
    }

}
