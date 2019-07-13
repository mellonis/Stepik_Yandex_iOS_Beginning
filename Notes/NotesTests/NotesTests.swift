//
//  NotesTests.swift
//  NotesTests
//
//  Created by Ruslan Gilmullin on 14/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import XCTest
@testable import Notes

class NotesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let note = Note(title: "title", content: "content", importance: .usual)
        
        XCTAssert(note.title == "title")
        XCTAssert(note.content == "content")
        XCTAssert(note.importance == .usual)
        XCTAssert(note.selfDestructDate == nil)
        XCTAssert(note.color == .white)
        
        let note2 = Note(title: "title", content: "content", importance: .critical)
        
        XCTAssert(note.uid != note2.uid)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
