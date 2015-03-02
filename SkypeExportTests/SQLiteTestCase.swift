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

class SQLiteTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        let dbPath="/Users/aleksandarkovacevic/Library/Application Support/Skype/gohanuskas/main.db"
        var checkValidation = NSFileManager.defaultManager()
        var dbExist=checkValidation.fileExistsAtPath(dbPath);
        var dbReadable=checkValidation.isReadableFileAtPath(dbPath);
//        let skypeDB=SkypeDB(pathToDB: dbPath, isBusyHandler)
//        skypeDB.getMessages(fromSkypeUser: "gohanuskas", withDialogPartner: "mjansari21")
        XCTAssert(true, "Pass")
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
