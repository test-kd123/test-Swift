//
//  CPDFUploadFileResult.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/29.
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

public class CPDFUploadFileResult: NSObject {
    public var fileKey: String?
    public var fileUrl: String?
    
    public var errorDesc: String?
    
    convenience init(dict: [String : Any]) {
        self.init()
        
        self.fileKey = dict["fileKey"] as? String
        self.fileUrl = dict["fileUrl"] as? String
    }
}
