//
//  CPDFResultMap.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/29.
//

import Cocoa

class CPDFResultMap: NSObject {
    var code: String?
    var msg: String?
    var data: Any?
    
    convenience init(dict: [String : Any]) {
        self.init()
        
        self.code = dict["code"] as? String
        self.msg = dict["msg"] as? String
        self.data = dict["data"]
    }
    
    func isSuccess() -> Bool {
        guard let _code = self.code else {
            return false
        }
        return _code == "200"
    }
}
