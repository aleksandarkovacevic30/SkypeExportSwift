//
//  SkypeSQLiteDao.swift
//  SkypeExport
//
//  Created by Aleksandar Kovacevic on 2/12/15.
//  Copyright (c) 2015 Aleksandar Kovacevic. All rights reserved.
//

import Foundation
import SQLite

public class SkypeDB {
    public enum ERRORS {
        case DATABASE_NOT_LOADED
        case DB_FILE_NOT_FOUND
        case DB_NON_EXISTING_SKYPENAME
        case NONE
    }
    var skypeUser: String
    var errorHandler: (ERRORS -> Void)
    public var lastError: ERRORS
    var db: Database?;
    
    public init(skypeUser skypeuser: String, isBusyHandler: (Int -> Bool), errorHandler: (ERRORS -> Void),debugPath: String) {
        self.skypeUser=skypeuser
        self.errorHandler=errorHandler
        self.lastError=ERRORS.NONE
        var userDirPath=getAppSupportDir()

        var path: String
        if debugPath != "" {
           path = debugPath
        } else {
            path = "\(userDirPath!)/Skype/\(skypeuser)/main.db"
        }
        
        
        if (NSFileManager.defaultManager().fileExistsAtPath(path)){
            self.db = Database(path, readonly: true)
            if let dbase = self.db {
                dbase.busy(isBusyHandler)
            } else {
                self.lastError=ERRORS.DATABASE_NOT_LOADED
                errorHandler(ERRORS.DATABASE_NOT_LOADED)
            }
        } else {
            self.lastError=ERRORS.DB_FILE_NOT_FOUND
            errorHandler(ERRORS.DB_FILE_NOT_FOUND)
        }
    }
    
}