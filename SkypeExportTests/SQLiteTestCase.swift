//
//  SQLiteTestCase.swift
//  SkypeExport
//
//  Created by Aleksandar Kovacevic on 2/24/15.
//  Copyright (c) 2015 Aleksandar Kovacevic. All rights reserved.
//

import Cocoa
import Foundation
import XCTest
import SkypeExport

class SQLiteTestCase: XCTestCase {

    
    var skypeDB: SkypeDB = SkypeDB(skypeUser: "renesto.testing",
        isBusyHandler: { (input: Int) -> Bool in
            return true;
        },errorHandler: { (error: SkypeDB.ERRORS) -> Void in
        },debugPath: "Resources/main.db")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSkypeDummyConnect() {
        var busyResult: Bool = false
        var errorResult: SkypeDB.ERRORS=SkypeDB.ERRORS.NONE
        
        let skypeDBfail:SkypeDB = SkypeDB(skypeUser: "renesto.testing",
            isBusyHandler: { (input: Int) -> Bool in
                busyResult=true;
                return true;
            },errorHandler: { (error: SkypeDB.ERRORS) -> Void in
                errorResult=error;
        },debugPath: "falsePath")
        
        XCTAssert(skypeDBfail.lastError==SkypeDB.ERRORS.DB_FILE_NOT_FOUND, "Pass")
    }
    
    func testGetSkypeContacts() {
        
        var expected:[String]=[]
        expected += ["echo123"]
        expected += ["gohanuskas"]
        var result:[String]=[]
        //Test regular case
        XCTAssert(skypeDB.lastError==SkypeDB.ERRORS.NONE, "Pass")

        result=skypeDB.getSkypeContacts()

        XCTAssert(result==expected, "Pass")
        
    }
    
    // TODO check if all chat messages are shown
    // TODO check if dialog_partner does not exist
    // TODO check if skype user does not exist
    // TODO check if path is incorrect
    // TODO check if
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
