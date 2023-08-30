//
//  CPDFTaskInfoResult.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/29.
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

class CPDFTaskInfoResult: NSObject {
    var taskId: String?
    var taskFileNum: Int64?
    var taskSuccessNum: Int64?
    var taskFailNum: Int64?
    var taskStatus: String?
    var assetTypeId: Int64?
    var taskCost: Int64?
    var taskTime: Int64?
    var sourceType: String?
    var targetType: String?
    var callbackUrl: String?
    var taskLanguage: String?
    var fileInfoDTOList: [CPDFFileInfo]?
    
    var errorDesc: String?
    private var dict: [String : Any] = [:]
    
    convenience init(dict: [String : Any]) {
        self.init()
            
        self.dict = dict
        self.taskId = dict["taskId"] as? String
        self.taskFileNum = dict["taskFileNum"] as? Int64
        self.taskSuccessNum = dict["taskSuccessNum"] as? Int64
        self.taskFailNum = dict["taskFailNum"] as? Int64
        
        self.taskStatus = dict["taskStatus"] as? String
        
        self.assetTypeId = dict["assetTypeId"] as? Int64
        self.taskCost = dict["taskCost"] as? Int64
        self.taskTime = dict["taskTime"] as? Int64
        self.sourceType = dict["sourceType"] as? String
        self.targetType = dict["targetType"] as? String
        self.callbackUrl = dict["callbackUrl"] as? String
        self.taskLanguage = dict["taskLanguage"] as? String
        
        self.fileInfoDTOList = []
        if let data = dict["fileInfoDTOList"] as? [[String:Any]] {
            for fileInfo in data {
                self.fileInfoDTOList?.append(CPDFFileInfo(dict: fileInfo))
            }
        }
    }
    
    func isFinish() -> Bool {
        guard let status = self.taskStatus else {
            return false
        }
        return status == "TaskFinish"
    }
    
    func isRuning() -> Bool {
        guard let status = self.taskStatus else {
            return false
        }
        return status == "TaskProcessing" || status == "TaskWaiting"
    }
    
    func printInfo() {
        Swift.debugPrint(self.dict)
    }
}
