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

    let dbPath: String = "SkypeExportTests/skypeSampleDatabase/renesto.testing/main.db"
    let dbPathLocked: String = "SkypeExportTests/skypeSampleDatabase/mainLocked.db"
    
    
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
        
        let skypeDBfail:SkypeDB = SkypeDB(pathToDB: "",
            { (input: Int) -> Bool in
                busyResult=true;
                return true;
            },{ (error: SkypeDB.ERRORS) -> Void in
                errorResult=error;
        })
        
        XCTAssert(errorResult==SkypeDB.ERRORS.DB_FILE_NOT_FOUND, "Pass")
        
        let skypeDB:SkypeDB = SkypeDB(pathToDB: dbPath,
            { (input: Int) -> Bool in
                busyResult=true;
            return true;
            },{ (error: SkypeDB.ERRORS) -> Void in
                errorResult=error;
        })
        XCTAssert(busyResult==false, "Pass")
    }
    
    // TODO check if all chat messages are shown
    // TODO check if dialog_partner does not exist
    // TODO check if skype user does not exist
    // TODO check if path is incorrect
    // TODO check if
    
    func testGetSkypeContacts() {
        // This is an example of a functional test case.
//        let skypeDB=SkypeDB(pathToDB: dbPath, nil);
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
