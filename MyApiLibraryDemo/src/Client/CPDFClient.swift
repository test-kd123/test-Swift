//
//  CPDFClient.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/17.
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

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

public class CPDFClient: NSObject {
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
    
    public convenience init(publicKey: String, secretKey: String) {
        self.init()
        
        self._publicKey = publicKey
        self._secretKey = secretKey
    }
    
    public func createTask(url: String, callback:@escaping (CPDFCreateTaskResult?)->Void) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] model in
                guard let _ = model else {
                    let _model = CPDFCreateTaskResult(dict: [:])
                    _model.errorDesc = "auth failure"
                    callback(_model)
                    return
                }
                
                self?.createTask(url: url, callback: callback)
            }
            return
        }
        
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_CREATE_TASK+url, headers: self.getRequestHeaderInfo()) { result, dataDict, error in
            guard let _dataDict = dataDict else {
                let model = CPDFCreateTaskResult(dict: [:])
                model.errorDesc = error
                callback(model)
                return
            }
            let model = CPDFCreateTaskResult(dict: _dataDict)
            callback(model)
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func createTask(url: String) async -> CPDFCreateTaskResult? {
        return await withCheckedContinuation({ continuation in
            self.createTask(url: url) { model in
                continuation.resume(returning: model)
            }
        })
    }
    
    public func auth(callback:@escaping ((CPDFOauthResult?)->Void)) {
        let options = [CPDFClient.Parameter.publicKey : self.publicKey ?? "", CPDFClient.Parameter.secretKey: self.secretKey ?? ""]
        CPDFHttpClient.POST(urlString: CPDFURL.API_V1_OAUTH_TOKEN, parameter: options) { [weak self] result, dataDict, error in
            if let _dataDict = dataDict {
                let model = CPDFOauthResult(dict: _dataDict)
                self?.accessToken = model.accessToken
                if let expiresIn = model.expiresIn, let data = Float(expiresIn) {
                    self?.expireTime = Date().timeIntervalSince1970*1000+Double(data*1000)
                }
                callback(model)
            } else {
                self?.accessToken = nil
                self?.expireTime = nil
                callback(nil)
            }
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func auth() async -> CPDFOauthResult? {
        return await withCheckedContinuation({ continuation in
            self.auth { model in
                continuation.resume(returning: model)
            }
        })
    }
    
    public func uploadFile(filepath: String, password: String? = nil, params:[String : Any], taskId: String, callback:@escaping ((CPDFUploadFileResult?)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] model in
                guard let _ = model else {
                    let _model = CPDFUploadFileResult()
                    _model.errorDesc = "auth failure"
                    callback(_model)
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
        
        CPDFHttpClient.UploadFile(urlString: CPDFURL.API_V1_UPLOAD_FILE, parameter: parameter, headers: self.getRequestHeaderInfo(), filepath: filepath) { result, dataDict, error in
            guard let _dataDict = dataDict else {
                let model = CPDFUploadFileResult(dict: [:])
                model.errorDesc = error
                callback(model)
                return
            }
            let model = CPDFUploadFileResult(dict: _dataDict)
            callback(model)
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func uploadFile(filepath: String, password: String? = nil, params:[String : Any], taskId: String) async ->CPDFUploadFileResult? {
        return await withCheckedContinuation({ continuation in
            self.uploadFile(filepath: filepath, password: password, params: params, taskId: taskId) { model in
                continuation.resume(returning: model)
            }
        })
    }
    
    public func resumeTask(taskId: String, callback:@escaping ((CPDFTaskInfoResult?)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] model in
                guard let _ = model else {
                    let _model = CPDFTaskInfoResult()
                    _model.errorDesc = "auth failure"
                    callback(_model)
                    return
                }
                self?.resumeTask(taskId: taskId, callback: callback)
            }
            return
        }
        
        self.processFiles(taskId: taskId) { [weak self] model in
            guard let _ = model?.taskId else {
                let _model = CPDFTaskInfoResult()
                _model.errorDesc = "Process Files failure"
                callback(_model)
                return
            }
            self?.getTaskInfo(taskId: taskId, callback: callback)
        }
    }
    
    public func processFiles(taskId: String, callback:@escaping ((CPDFCreateTaskResult?)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] model in
                guard let _ = model else {
                    let _model = CPDFCreateTaskResult(dict: [:])
                    _model.errorDesc = "auth failure"
                    callback(_model)
                    return
                }
                self?.processFiles(taskId: taskId, callback: callback)
            }
            return
        }
        
        var parameter: [String : String] = [:]
        parameter[CPDFClient.Parameter.taskId] = taskId
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_EXECUTE_TASK, parameter: parameter, headers: self.getRequestHeaderInfo()) { result, dataDict , error in
            guard let _dataDict = dataDict else {
                let model = CPDFCreateTaskResult(dict: [:])
                model.errorDesc = error
                callback(model)
                return
            }
            let model = CPDFCreateTaskResult(dict: _dataDict)
            callback(model)
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func processFiles(taskId: String) async -> CPDFCreateTaskResult? {
        return await withCheckedContinuation({ continuation in
            self.processFiles(taskId: taskId) { model in
                continuation.resume(returning: model)
            }
        })
    }
    
    public func getTaskInfoComplete(taskId: String, callback:@escaping ((_ isFinish: Bool, _ params: Any...)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] accessToken in
                guard let _ = accessToken else {
                    callback(false, "auth failure")
                    return
                }
                self?.getTaskInfoComplete(taskId: taskId, callback: callback)
            }
            return
        }
        
        var parameter: [String : String] = [:]
        parameter[CPDFClient.Parameter.taskId] = taskId
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_TASK_INFO, parameter: parameter, headers: self.getRequestHeaderInfo()) { result, dataDict , error in
            if let data = dataDict?[CPDFClient.Data.taskStatus] as? String, (data.elementsEqual("TaskProcessing") || data.elementsEqual("TaskWaiting")) {
                self.getTaskInfoComplete(taskId: taskId, callback: callback)
                return
            }
            var isFinish = false
            if let data = dataDict?[CPDFClient.Data.taskStatus] as? String, data.elementsEqual("TaskFinish") {
                isFinish = true
            }
            callback(isFinish, dataDict?[CPDFClient.Data.fileInfoDTOList] as Any)
        }
    }
    
    public func getTaskInfo(taskId: String, callback:@escaping ((CPDFTaskInfoResult?)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] model in
                guard let _ = model else {
                    let _model = CPDFTaskInfoResult()
                    _model.errorDesc = "auth failure"
                    callback(_model)
                    return
                }
                self?.getTaskInfo(taskId: taskId, callback: callback)
            }
            return
        }
        
        var parameter: [String : String] = [:]
        parameter[CPDFClient.Parameter.taskId] = taskId
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_TASK_INFO, parameter: parameter, headers: self.getRequestHeaderInfo()) { result, dataDict , error in
            guard let _dataDict = dataDict else {
                let model = CPDFTaskInfoResult(dict: [:])
                model.errorDesc = error
                callback(model)
                return
            }
            let model = CPDFTaskInfoResult(dict: _dataDict)
            callback(model)
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func getTaskInfo(taskId: String) async -> CPDFTaskInfoResult? {
        return await withCheckedContinuation({ continuation in
            self.getTaskInfo(taskId: taskId) { model in
                continuation.resume(returning: model)
            }
        })
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
