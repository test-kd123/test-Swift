//
//  CPDFOauthResult.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/29.
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

class CPDFOauthResult: NSObject {
    var tokenType: String?
    var expiresIn: String?
    var accessToken: String?
    var projectName: String?
    var scope: String?
    
    convenience init(dict: [String : Any]) {
        self.init()
        
        self.tokenType = dict["tokenType"] as? String
        self.expiresIn = dict["expiresIn"] as? String
        self.accessToken = dict["accessToken"] as? String
        self.projectName = dict["projectName"] as? String
        self.scope = dict["scope"] as? String
    }
}
