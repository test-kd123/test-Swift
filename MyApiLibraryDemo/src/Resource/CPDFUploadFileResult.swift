//
//  CPDFUploadFileResult.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/29.
//

import Cocoa

class CPDFUploadFileResult: NSObject {
    var fileKey: String?
    var fileUrl: String?
    
    var errorDesc: String?
    
    convenience init(dict: [String : Any]) {
        self.init()
        
        self.fileKey = dict["fileKey"] as? String
        self.fileUrl = dict["fileUrl"] as? String
    }
}
