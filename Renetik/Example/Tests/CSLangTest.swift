//
// Created by Rene Dohan on 2019-01-20.
// Copyright (c) 2019 Renetik Software. All rights reserved.
//

import Nimble
import Quick
import Renetik
import XCTest

class TestClass: NSObject {
    var testString = ""

    init(_ testString: String) {
        self.testString = testString
    }
}

class CSLangTest: XCTestCase {
    let nonOptionalString: String = "initial"
    let optionalStringWithValue: String? = "initial"
    let optionalStringWithNil: String? = nil

    let nonOptionalTestClass: TestClass = .init("initial")
    let optionalTestClassWithValue: TestClass? = TestClass("initial")
    let optionalTestClassWithNil: TestClass? = nil

    func testIsNil() {
        XCTAssertFalse(nonOptionalString.isNil)
        XCTAssertFalse(optionalStringWithValue.isNil)
        XCTAssertTrue(optionalStringWithNil.isNil)
    }

    func testNotNil() {
        XCTAssertTrue(nonOptionalString.notNil)
        XCTAssertTrue(optionalStringWithValue.notNil)
        XCTAssertFalse(optionalStringWithNil.notNil)
    }

    func testAsString() {
        XCTAssertEqual("initial", nonOptionalString.asString)
        XCTAssertEqual("initial", optionalStringWithValue.asString)
        XCTAssertEqual("", optionalStringWithNil.asString)
    }

    func testApply() {
        XCTAssertEqual("initial", nonOptionalTestClass.testString)
        XCTAssertEqual("other", nonOptionalTestClass.apply { $0.testString = "other" }.testString)

        XCTAssertEqual("initial", optionalTestClassWithValue?.testString)
        XCTAssertEqual("other", optionalTestClassWithValue?.apply { $0.testString = "other" }.testString)

        XCTAssertNil(optionalTestClassWithNil?.testString)
        XCTAssertNil(optionalTestClassWithNil?.apply { $0.testString = "other" }.testString)
    }

    func testThen() {
        XCTAssertEqual("initial", nonOptionalTestClass.testString)
        nonOptionalTestClass.then { $0.testString = "other" }
        XCTAssertEqual("other", nonOptionalTestClass.testString)

        XCTAssertEqual("initial", optionalTestClassWithValue?.testString)
        optionalTestClassWithValue?.apply { $0.testString = "other" }
        XCTAssertEqual("other", optionalTestClassWithValue?.testString)

        XCTAssertNil(optionalTestClassWithNil?.testString)
        optionalTestClassWithNil?.apply { $0.testString = "other" }
        XCTAssertNil(optionalTestClassWithNil?.testString)
    }

    func testGet() {
        XCTAssertEqual("initial", nonOptionalTestClass.testString)
        XCTAssertEqual("returned", nonOptionalTestClass.get {
            $0.testString = "other"
            return "returned"
        })
        XCTAssertEqual("other", nonOptionalTestClass.testString)

        XCTAssertEqual("initial", optionalTestClassWithValue?.testString)
        XCTAssertEqual("returned", optionalTestClassWithValue?.get {
            $0.testString = "other"
            return "returned"
        })
        XCTAssertEqual("other", optionalTestClassWithValue?.testString)

        XCTAssertNil(optionalTestClassWithNil?.testString)
        XCTAssertNil(optionalTestClassWithNil?.get {
            $0.testString = "other"
            return "returned"
        })
        XCTAssertNil(optionalTestClassWithNil?.testString)
    }

    func testCast() {
        let array: NSMutableArray? = NSMutableArray()
        array?.add("test string 1")
        array?.add("test string 2")
        let stringArray = [String].cast(array)
        XCTAssertEqual("test string 2", stringArray[1])
    }
}
