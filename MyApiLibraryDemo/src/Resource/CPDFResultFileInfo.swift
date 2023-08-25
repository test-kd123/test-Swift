//
//  CPDFResultFileInfo.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/25.
//

import Cocoa

class CPDFResultFileInfo: NSObject {
    var fileKey: String?
    var taskId: String?
    var fileName: String?
    var fileUrl: String?
    var downloadUrl: String?
    var sourceType: String?
    var targetType: String?
    var fileSize: String?
    var convertSize: String?
    var convertTime: String?
    var status: String?
    var failureCode: String?
    var failureReason: String?
    var downFileName: String?
    var fileParameter: String?
    
    convenience init(dict: [String : Any]) {
        self.init()
        
        self.fileUrl        = dict["fileUrl"] as? String
        self.taskId         = dict["taskId"] as? String
        self.fileName       = dict["fileName"] as? String
        self.fileKey        = dict["fileKey"] as? String
        self.downloadUrl    = dict["downloadUrl"] as? String
        self.sourceType     = dict["sourceType"] as? String
        self.targetType     = dict["targetType"] as? String
        self.fileSize       = dict["fileSize"] as? String
        self.convertSize    = dict["convertSize"] as? String
        self.convertTime    = dict["convertTime"] as? String
        self.status         = dict["status"] as? String
        self.failureCode    = dict["failureCode"] as? String
        self.failureReason  = dict["failureReason"] as? String
        self.downFileName   = dict["downFileName"] as? String
        self.fileParameter  = dict["fileParameter"] as? String
    }
}
