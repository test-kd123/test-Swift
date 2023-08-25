//
//  CPDFClient.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/17.
//

import Cocoa

enum CPDFFileUploadParameterKey: String {
    case pageOptions         = "pageOptions"
    case rotation            = "rotation"
    case targetPage          = "targetPage"
    case width               = "width"
    case height              = "height"
    case number              = "number"
    
    case isContainAnnot      = "isContainAnnot"
    case isContainImg        = "isContainImg"
    case isFlowLayout        = "isFlowLayout"
    
    case contentOptions      = "contentOptions"
    case worksheetOptions    = "worksheetOptions"
    
    case isCsvMerge          = "isCsvMerge"
    
    case imgDpi              = "imgDpi"
    
    case lang                = "lang"
    
    case type                = "type"
    case scale               = "scale"
    case opacity             = "opacity"
    case targetPages         = "targetPages"
    case vertalign           = "vertalign"
    case horizalign          = "horizalign"
    case xoffset             = "xoffset"
    case yoffset             = "yoffset"
    case content             = "content"
    case textColor           = "textColor"
    case front               = "front"
    case fullScreen          = "fullScreen"
    case horizontalSpace     = "horizontalSpace"
    case verticalSpace       = "verticalSpace"
    case cpdfExtension       = "extension"
    
    case quality             = "quality"
    
    func string() -> String {
        return self.rawValue
    }
}

extension CPDFClient.Parameter {
    static let publicKey        = "publicKey"
    static let secretKey        = "secretKey"
    
    static let taskId           = "taskId"
    static let password         = "password"
    static let parameter        = "parameter"
    static let file             = "file"
}

extension CPDFClient.Data {
    static let accessToken      = "accessToken"
    static let expiresIn        = "expiresIn"
    
    static let taskId           = "taskId"
    
    static let fileKey          = "fileKey"
    static let fileUrl          = "fileUrl"
    
    static let taskStatus       = "taskStatus"
    static let fileInfoDTOList  = "fileInfoDTOList"
}

class CPDFClient: NSObject {
    private var _publicKey: String?
    var publicKey: String? {
        get {
            return self._publicKey
        }
    }
    private var _secretKey: String?
    var secretKey: String? {
        get {
            return self._secretKey
        }
    }
    
    private var accessToken: String?
    private var expireTime: TimeInterval?
    
    struct Parameter {

    }
    
    struct Data {
        
    }
    
    convenience init(publicKey: String, secretKey: String) {
        self.init()
        
        self._publicKey = publicKey
        self._secretKey = secretKey
    }
    
    public func createTask(url: String, callback:@escaping (String?, Any)->Void) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] accessToken in
                guard let _ = accessToken else {
                    callback(nil, "auth failure")
                    return
                }
                
                self?.createTask(url: url, callback: callback)
            }
            return
        }
        
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_CREATE_TASK+url, headers: self.getRequestHeaderInfo()) { result, dataDict, error in
            callback(dataDict?[CPDFClient.Data.taskId] as? String, error.debugDescription)
        }
    }
    
    public func auth(callback:@escaping ((String?)->Void)) {
        let options = [CPDFClient.Parameter.publicKey : self.publicKey ?? "", CPDFClient.Parameter.secretKey: self.secretKey ?? ""]
        CPDFHttpClient.POST(urlString: CPDFURL.API_V1_OAUTH_TOKEN, parameter: options) { [weak self] result, dataDict, error in
            self?.accessToken = dataDict?[CPDFClient.Data.accessToken] as? String
            if let expiresIn = dataDict?[CPDFClient.Data.expiresIn] as? String, let data = Float(expiresIn) {
                self?.expireTime = Date().timeIntervalSince1970*1000+Double(data)
            }
            callback(dataDict?[CPDFClient.Data.accessToken] as? String)
        }
    }
    
    public func uploadFile(filepath: String, password: String? = nil, params:[String : Any], taskId: String, callback:@escaping ((String?, String?, Any...)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] accessToken in
                guard let _ = accessToken else {
                    callback(nil, nil, "auth failure")
                    return
                }
                
                self?.uploadFile(filepath: filepath, params: params, taskId: taskId, callback: callback)
            }
            return
        }
        
        var parameter: [String : Any] = [:]
        parameter[CPDFClient.Parameter.taskId] = taskId
        if let data = password {
            parameter[CPDFClient.Parameter.password] = data
        }
        
        if let data = try?JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed) {
            let jsonString = String(data: data, encoding: .utf8)
            parameter[CPDFClient.Parameter.parameter] = jsonString
        }
        
//        let data = try?Data(contentsOf: URL(fileURLWithPath: filepath))
//        parameter["file"] =  data
        
        CPDFHttpClient.UploadFile(urlString: CPDFURL.API_V1_UPLOAD_FILE, parameter: parameter, headers: self.getRequestHeaderInfo(), filepath: filepath) { result, dataDict, error in
            callback(dataDict?[CPDFClient.Data.fileKey] as? String, dataDict?[CPDFClient.Data.fileUrl] as? String, error.debugDescription)
        }
    }
    
    public func resumeTask(taskId: String, callback:@escaping ((_ isFinish: Bool, _ params: Any...)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] accessToken in
                guard let _ = accessToken else {
                    callback(false, "auth failure")
                    return
                }
                self?.resumeTask(taskId: taskId, callback: callback)
            }
            return
        }
        
        self.processFiles(taskId: taskId) { [weak self] isFinish, params in
            if (!isFinish) {
                callback(false, "Process Files failure")
                return
            }
            self?.getTaskInfo(taskId: taskId, callback: callback)
        }
    }
    
    private func processFiles(taskId: String, callback:@escaping ((_ isFinish: Bool, _ params: Any...)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] accessToken in
                guard let _ = accessToken else {
                    callback(false, "auth failure")
                    return
                }
                self?.processFiles(taskId: taskId, callback: callback)
            }
            return
        }
        
        var parameter: [String : String] = [:]
        parameter[CPDFClient.Parameter.taskId] = taskId
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_EXECUTE_TASK, parameter: parameter, headers: self.getRequestHeaderInfo()) { result, dataDict , error in
            callback(result)
        }
    }
    
    private func getTaskInfo(taskId: String, callback:@escaping ((_ isFinish: Bool, _ params: Any...)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] accessToken in
                guard let _ = accessToken else {
                    callback(false, "auth failure")
                    return
                }
                self?.getTaskInfo(taskId: taskId, callback: callback)
            }
            return
        }
        
        var parameter: [String : String] = [:]
        parameter[CPDFClient.Parameter.taskId] = taskId
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_TASK_INFO, parameter: parameter, headers: self.getRequestHeaderInfo()) { result, dataDict , error in
            if let data = dataDict?[CPDFClient.Data.taskStatus] as? String, data.elementsEqual("TaskProcessing") {
                self.getTaskInfo(taskId: taskId, callback: callback)
                return
            }
            var isFinish = false
            if let data = dataDict?[CPDFClient.Data.taskStatus] as? String, data.elementsEqual("TaskFinish") {
                isFinish = true
            }
            callback(isFinish, dataDict?[CPDFClient.Data.fileInfoDTOList] as Any)
        }
    }
    
    private func accessTokenIsValid() -> Bool {
        guard let _ = self.accessToken else {
            return false
        }
        guard let _expireTime = self.expireTime else {
            return false
        }
        return _expireTime >= Date().timeIntervalSince1970 * 1000
    }
    
    private func getRequestHeaderInfo() -> [String : String] {
        var headers: [String : String] = [:]
        if let data = self.accessToken {
            headers["Authorization"] = "Bearer \(data)"
        }
        return headers
    }
}
