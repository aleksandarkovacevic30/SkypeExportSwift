//
//  Config.swift
//  SkypeExport
//
//  Created by Aleksandar Kovacevic on 5/17/15.
//  Copyright (c) 2015 Aleksandar Kovacevic. All rights reserved.
//

import Foundation

public class SkypeConfig {
    var skypeName:String!
    
    init(){
        self.skypeName=""
    }
    
    public func getLocalSkypeUsers()->[String]{
        let skypePath:String = "\(getAppSupportDir()!)/Skype"
        let (filenamesOpt, errorOpt) = contentsOfDirectoryAtPath(skypePath)
        var result:[String]=[]
        if let filenames=filenamesOpt?.filter(isSkypeUserName) {
            for item:(filename: String, isDir: Bool) in filenames {
                result+=[item.filename]
            }
        }
        return result
    }
    func contentsOfDirectoryAtPath(path: String) -> (filenames: [(filename: String, isDir: Bool)]?, error: NSError?) {
        
        var error: NSError?
        var result: [(filename: String, isDir: Bool)] = []
        let fileManager = NSFileManager.defaultManager()
        
        let contents = fileManager.contentsOfDirectoryAtPath(path, error: &error)
        if contents != nil  {
            let filenames = contents as! [String]
            for filename in filenames {
                result += [(filename: filename, isDir: isDir(path+"/"+filename))]
            }
        }
        return (result,nil);
    }
    func isSkypeUserName(text: String, isDir:Bool) -> Bool {
        return isDir && !text.hasPrefix("shared_") && text != "Upgrade" && text != "DataRv"
    }
    func isDir(path: String) -> Bool {
        var error: NSError?
        var isDirectory: ObjCBool = ObjCBool(false)
        NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDirectory);
        return isDirectory.boolValue
    }

}
