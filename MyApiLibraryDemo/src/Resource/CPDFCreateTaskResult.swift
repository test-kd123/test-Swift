//
//  CPDFCreateTaskResult.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/29.
//

import Cocoa

class CPDFCreateTaskResult: NSObject {
    var taskId: String?
    var errorDesc: String?
    
    convenience init(dict: [String : Any]) {
        self.init()
        
        self.taskId = dict["taskId"] as? String
    }
}
