//
//  CPDFCreateTaskResult.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/29.
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

public class CPDFCreateTaskResult: NSObject {
    var taskId: String?
    var errorDesc: String?
    
    convenience init(dict: [String : Any]) {
        self.init()
        
        self.taskId = dict["taskId"] as? String
    }
}
