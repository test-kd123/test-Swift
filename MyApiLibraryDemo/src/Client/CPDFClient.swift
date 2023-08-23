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

//class CPDFRequestTast: Operation {
//    fileprivate var _isCompletion = false
//    var callback: (([String : Any]?)->Void)?
//
//    fileprivate var accessToken: String?
//
//    override var isFinished: Bool {
//        return self._isCompletion
//    }
//
//    fileprivate func cpdf_finish() {
//        self.willChangeValue(forKey: "isFinished")
//        self._isCompletion = true
//        self.didChangeValue(forKey: "isFinished")
//    }
//}

//class CPDFAuthRequestTask: CPDFRequestTast {
//    var publicKey: String?
//    var secretKey: String?
//
//    override func start() {
//        let options = ["publicKey" : self.publicKey ?? "", "secretKey": self.secretKey ?? ""]
//
//        CPDFHttpClient.POST(urlString: CPDFURL.API_V1_OAUTH_TOKEN, parameter: options) { [weak self] result , dataDict, error in
//            self?.accessToken = dataDict?["accessToken"] as? String
//            if let data = self?.callback {
//                data(dataDict)
//            }
//
//            self?.cpdf_finish()
//        }
//    }
//}

//class CPDFCreateRequestTask: CPDFRequestTast {
//    var executeTypeUrl: String = ""
//
//    override func start() {
//        var headers: [String : String] = [:]
//        if let data = self.accessToken {
//            headers["Authorization"] = "Bearer \(data)"
//        }
//        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_CREATE_TASK+executeTypeUrl, headers: headers) { [weak self] result, dataDict, error in
//            guard let data = self?.callback else {
//                return
//            }
//            data(dataDict)
//
//            self?.cpdf_finish()
//        }
//    }
//}

//class CPDFUploadFileRequestTask: CPDFRequestTast {
//    var taskId: String?
//    override func start() {
//        var headers: [String : String] = [:]
//        if let data = self.accessToken {
//            headers["Authorization"] = "Bearer \(data)"
//        }
//        var parameter: [String : Any] = [:]
//        parameter["taskId"] = self.taskId!
//        parameter["password"] = ""
//        parameter["parameter"] = "{\"pageOptions\": \"['1']\"}"
//        let path = Bundle.main.path(forResource: "提取表格-常规1", ofType: "pdf")
//        let data = try?Data(contentsOf: URL(fileURLWithPath: path!))
//        parameter["file"] =  data
//
//        CPDFHttpClient.UploadFile2(urlString: CPDFURL.API_V1_UPLOAD_FILE, parameter: parameter, headers: headers) { [weak self] result , dataDict , error in
//            guard let data = self?.callback else {
//                return
//            }
//            data(dataDict)
//
//            self?.cpdf_finish()
//        }
//    }
//}

//class CPDFProcessFilesRequestTask: CPDFRequestTast {
//    var taskId: String?
//
//    override func start() {
//        var headers: [String : String] = [:]
//        if let data = self.accessToken {
//            headers["Authorization"] = "Bearer \(data)"
//        }
//
//        var parameter: [String : String] = [:]
//        parameter["taskId"] = self.taskId!
//        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_EXECUTE_TASK, parameter: parameter, headers: headers) { [weak self] result, dataDict , error in
//            guard let data = self?.callback else {
//                return
//            }
//            data(dataDict)
//
//            self?.cpdf_finish()
//        }
//    }
//}

//class CPDFGetTaskInfoRequestTask: CPDFRequestTast {
//    var taskId: String?
//
//    override func start() {
//        var headers: [String : String] = [:]
//        if let data = self.accessToken {
//            headers["Authorization"] = "Bearer \(data)"
//        }
//
//        var parameter: [String : String] = [:]
//        parameter["taskId"] = self.taskId!
//        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_TASK_INFO, parameter: parameter, headers: headers) { [weak self] result, dataDict , error in
//            guard let data = self?.callback else {
//                return
//            }
//            data(dataDict)
//
//            self?.cpdf_finish()
//        }
//    }
//}

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
    
    convenience init(publicKey: String, secretKey: String) {
        self.init()
        
        self._publicKey = publicKey
        self._secretKey = secretKey
    }
    
//    public func auth(publicKey: String, secretKey: String) -> CPDFRequestTast {
//        let task = CPDFAuthRequestTask()
//        task.publicKey = publicKey
//        task.secretKey = secretKey
//        task.callback = { [weak self] info in
//            self?.accessToken = info!["accessToken"] as? String
//            self?.createTask?.accessToken = self?.accessToken
//        }
//        
//        self.taskQueue?.addOperation(task)
//        return task
//    }
//    
//    public func createTask(_ executeTypeUrl: String) -> CPDFRequestTast {
//        let task = CPDFCreateRequestTask()
//        task.executeTypeUrl = executeTypeUrl
//        self.taskQueue?.addOperation(task)
//        self.createTask = task
//        task.callback = { [weak self] info in
//            self?.uploadFileTask?.accessToken = self?.accessToken
//            self?.uploadFileTask?.taskId = info!["taskId"] as? String
//        }
//        return task
//    }
//    
//    public func uploadFile(_ taskId: String) -> CPDFRequestTast {
//        let task = CPDFUploadFileRequestTask()
//        self.taskQueue?.addOperation(task)
//        task.callback = { [weak self] _ in
//            self?.processFilesTask?.accessToken = self?.accessToken
//            self?.processFilesTask?.taskId = self?.uploadFileTask?.taskId
//            
//        }
//        self.uploadFileTask = task
//        return task
//    }
//    
//    public func processFiles() -> CPDFRequestTast {
//        let task = CPDFProcessFilesRequestTask()
//        self.taskQueue?.addOperation(task)
//        self.processFilesTask = task
//        task.callback = { [weak self] _ in
//            self?.getTaskInfoTask?.accessToken = self?.accessToken
//            self?.getTaskInfoTask?.taskId = self?.uploadFileTask?.taskId
//            
//        }
//        return task
//    }
//    
//    public func getTaskInfo() -> CPDFRequestTast {
//        let task = CPDFGetTaskInfoRequestTask()
//        self.taskQueue?.addOperation(task)
//        self.getTaskInfoTask = task
//        
//        task.callback = { [weak self] _ in
//            self?.getTaskInfoTask?.accessToken = self?.accessToken
//            self?.getTaskInfoTask?.taskId = self?.uploadFileTask?.taskId
//        }
//        return task
//    }
}

extension CPDFClient {
//    public func auth2() {
//        let options = ["publicKey" : self.publicKey!, "secretKey": self.secretKey!]
//        CPDFHttpClient.POST(urlString: CPDFURL.API_V1_OAUTH_TOKEN, parameter: options) { result , dataDict, error in
//            self.accessToken = dataDict?["accessToken"] as? String
//        }
//    }
    
//    public func createTask2(_ executeTypeUrl: String) {
//        var headers: [String : String] = [:]
//        if let data = self.accessToken {
//            headers["Authorization"] = "Bearer \(data)"
//        }
//        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_CREATE_TASK+executeTypeUrl, headers: headers) { result, dataDict, error in
//            Swift.debugPrint("")
//        }
//    }
    
    /**
     * @param filepath
     * @return CPDFFileResource
     */
    
//    public func addFile2(_ filepath: String) -> CPDFFileResource {
//        let fileSource = CPDFFileResource(filepath, self)
//        self.fileResources.append(fileSource)
//
//        return fileSource
//    }
}

extension CPDFClient {
    public func createTask(url: String, callback:@escaping (String, Any)->Void) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] accessToken in
//                self?.accessToken = accessToken
                self?.createTask(url: url, callback: callback)
            }
            return
        }
        
        var headers: [String : String] = [:]
        if let data = self.accessToken {
            headers["Authorization"] = "Bearer \(data)"
        }
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_CREATE_TASK+url, headers: headers) { result, dataDict, error in
            callback(dataDict!["taskId"] as! String, "")
        }
    }
    
    public func auth(callback:@escaping ((String?)->Void)) {
        let options = ["publicKey" : self.publicKey ?? "", "secretKey": self.secretKey ?? ""]
        CPDFHttpClient.POST(urlString: CPDFURL.API_V1_OAUTH_TOKEN, parameter: options) { [weak self] result , dataDict, error in
            self?.accessToken = dataDict?["accessToken"] as? String
            if let expiresIn = dataDict?["expiresIn"] as? String, let data = Float(expiresIn) {
                self?.expireTime = Date().timeIntervalSince1970*1000+Double(data)
            }
            callback(dataDict?["accessToken"] as? String)
        }
    }
    
    public func uploadFile(filepath: String, params:[String : Any], taskId: String, callback:@escaping ((String?, String?)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] accessToken in
//                self?.accessToken = accessToken
                self?.uploadFile(filepath: filepath, params: params, taskId: taskId, callback: callback)
            }
            return
        }
        
        var headers: [String : String] = [:]
        if let data = self.accessToken {
            headers["Authorization"] = "Bearer \(data)"
        }
        var parameter: [String : Any] = [:]
        parameter["taskId"] = taskId
        parameter["password"] = ""
//        let dict = ["pageOptions" : ["1"], "rotation" : "90"] as [String : Any]
        if let data = try?JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed) {
            let jsonString = String(data: data, encoding: .utf8)
            parameter["parameter"] = jsonString
        }
//        parameter["parameter"] = "{\"pageOptions\": \"['1']\"}"
        
        let data = try?Data(contentsOf: URL(fileURLWithPath: filepath))
        parameter["file"] =  data
        
        CPDFHttpClient.UploadFile2(urlString: CPDFURL.API_V1_UPLOAD_FILE, parameter: parameter, headers: headers, filepath: filepath) { result , dataDict , error in
            callback(dataDict?["fileKey"] as? String, dataDict?["fileUrl"] as? String)
        }
    }
    
    public func resumeTask(taskId: String, callback:@escaping ((_ isFinish: Bool, _ downloadUrl: String?, _ params: Any...)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] accessToken in
                self?.resumeTask(taskId: taskId, callback: callback)
            }
            return
        }
        
        self.processFiles(taskId: taskId) { [weak self] isFinish, downloadUrl, params in
            self?.getTaskInfo(taskId: taskId, callback: callback)
        }
    }
    
    private func processFiles(taskId: String, callback:@escaping ((_ isFinish: Bool, _ downloadUrl: String?, _ params: Any...)->Void)) {
        var headers: [String : String] = [:]
        if let data = self.accessToken {
            headers["Authorization"] = "Bearer \(data)"
        }
        
        var parameter: [String : String] = [:]
        parameter["taskId"] = taskId
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_EXECUTE_TASK, parameter: parameter, headers: headers) { result, dataDict , error in
            callback(true, "")
        }
    }
    
    private func getTaskInfo(taskId: String, callback:@escaping ((_ isFinish: Bool, _ downloadUrl: String?, _ params: Any...)->Void)) {
        var headers: [String : String] = [:]
        if let data = self.accessToken {
            headers["Authorization"] = "Bearer \(data)"
        }
        
        var parameter: [String : String] = [:]
        parameter["taskId"] = taskId
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_TASK_INFO, parameter: parameter, headers: headers) { result, dataDict , error in
            if let data = dataDict?["taskStatus"] as? String, data.elementsEqual("TaskProcessing") {
                self.getTaskInfo(taskId: taskId, callback: callback)
                return
            }
            var isFinish = false
            if let data = dataDict?["taskStatus"] as? String, data.elementsEqual("TaskFinish") {
                isFinish = true
            }
            callback(isFinish, dataDict?["taskId"] as? String, dataDict?["fileInfoDTOList"] as Any)
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
}
