//
//  CPDFHttpClient.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/17.
//

import Cocoa

class CPDFHttpClient: NSObject {
    private static let baseUrl = "https://api-server.compdf.com/server/"
    private static let boundary = "CPDFBoundary"
    
    public class func GET(urlString: String, parameter: [String : String]? = nil, headers: [String : String]? = nil, callback:@escaping ((Bool, [String : Any]?, Error?)->Void)) {
        var _urlString = "\(self.baseUrl)"+urlString
        if let data = parameter, !data.isEmpty {
            _urlString.append("?")
            var i = 0
            for (key, value) in data {
                _urlString.append("\(key)=\(value)")
                if (data.count > 1 && i != data.count-1) {
                    _urlString.append("&")
                }
                i += 1
            }
        }
        
        let url: URL = URL(string: _urlString)!
         
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        if let _headers = headers {
            for (key, value) in _headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        request.timeoutInterval = 60.0
        session.configuration.timeoutIntervalForRequest = 30.0
        
        let task: URLSessionDataTask = session.dataTask(with: request) { data , response, error in
            DispatchQueue.main.async {
                if let _ = error {
                    callback(false, nil, error)
                    return
                }
                // let string = String(data: _data, encoding: .utf8)
                guard let _data = data else {
                    callback(false, nil, error)
                    return
                }
                let result = self.JsonDataParse(data: _data)
                if let _result = result, let code = _result["code"] as? String, code == "200" {
                    callback(true, _result["data"] as? [String : Any], nil)
                    return
                }
                callback(false, nil, error)
            }
        }
        task.resume()
    }
    
    public class func POST(urlString: String, parameter: [String : String]? = nil, callback:@escaping ((Bool, [String : Any]?, Error?)->Void)) {
        let url: URL = URL(string: "\(self.baseUrl)"+urlString)!
         
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 60.0
        
        session.configuration.timeoutIntervalForRequest = 30.0
        
        if let data = parameter {
            let body = try?JSONSerialization.data(withJSONObject: data, options: [])
            request.httpBody = body
        }
        
        let task: URLSessionDataTask = session.dataTask(with: request) { data , response, error in
            DispatchQueue.main.async {
                if let _ = error {
                    callback(false, nil, error)
                    return
                }
                // let string = String(data: _data, encoding: .utf8)
                guard let _data = data else {
                    callback(false, nil, error)
                    return
                }
                let result = self.JsonDataParse(data: _data)
                if let _result = result, let code = _result["code"] as? String, code == "200" {
                    callback(true, _result["data"] as? [String : Any], nil)
                    return
                }
                callback(false, nil, error)
            }
        }
        task.resume()
        
    }
    
    public class func UploadFile(urlString: String, parameter: [String : Any]? = nil, headers: [String : String]? = nil, filepath: String, callback:@escaping ((Bool, [String : Any]?, Error?)->Void)) {
        let url = URL(string: self.baseUrl + urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        if let _headers = headers {
            for (key, value) in _headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        request.setValue("multipart/form-data; boundary=\(self.boundary)", forHTTPHeaderField: "Content-Type")
        
        var bodyString = ""
        if let data = parameter {
            for (key,value) in data {
                bodyString.append("--\(self.boundary)\r\n")
                if (value is String) {
                    bodyString.append("Content-disposition: form-data; name=\"\(key)\"")
                    bodyString.append("\r\n\r\n")
                    bodyString.append(value as! String)
                    bodyString.append("\r\n")
                } else {
                    // no things
                }
            }
        }
        
        let fileUrl = URL(fileURLWithPath: filepath)
        bodyString.append("--\(self.boundary)\r\n")
//        filepath.comp
        bodyString.append("Content-disposition: form-data; name=\"file\"; filename=\"\(fileUrl.lastPathComponent)\"")
        bodyString.append("\r\n")
        bodyString.append("Content-Type: application/octet-stream")
        bodyString.append("\r\n\r\n")
        
        var mdata = Data()
        mdata.append(bodyString.data(using: .utf8)!)
//        let path = Bundle.main.path(forResource: "test", ofType: "pdf")
        let data = try?Data(contentsOf: fileUrl)
        mdata.append(data!)
        mdata.append("\r\n".data(using: .utf8)!)
        mdata.append("--\(self.boundary)--".data(using: .utf8)!)
        
        let session = URLSession.shared
        request.timeoutInterval = 60*3

        request.httpBody = mdata
        let task = session.dataTask(with: request) {data , response, error in
            DispatchQueue.main.async {
                if let _ = error {
                    callback(false, nil, error)
                    return
                }
                guard let _data = data else {
                    callback(false, nil, error)
                    return
                }
                let result = self.JsonDataParse(data: _data)
                if let _result = result, let code = _result["code"] as? String, code == "200" {
                    callback(true, _result["data"] as? [String : Any], nil)
                    return
                }
                callback(false, nil, error)
            }
        }
        task.resume()
    }
    
    public class func UploadFile2(urlString: String, parameter: [String : Any]? = nil, headers: [String : String]? = nil, filepath: String, callback:@escaping ((Bool, [String : Any]?, Error?)->Void)) {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        var sessionManager = AFHTTPSessionManager.init(sessionConfiguration: configuration)
        sessionManager.securityPolicy = AFSecurityPolicy.default()
        
        if let _headers = headers {
            for (key, value) in _headers {
                sessionManager.requestSerializer.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        sessionManager.requestSerializer.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        sessionManager.requestSerializer.timeoutInterval = 60 * 3
        sessionManager.responseSerializer = AFJSONResponseSerializer()
        sessionManager.responseSerializer.acceptableContentTypes = ["application/json","text/html","text/json","text/javascript","text/plain","image/gif"]
        
        sessionManager.requestSerializer.setValue("Apifox/1.0.0 (https://www.apifox.cn)", forHTTPHeaderField: "User-Agent")

        sessionManager.post(self.baseUrl+urlString, parameters: parameter) { formData in
            let fileURL = URL(fileURLWithPath: filepath)
            try? formData.appendPart(withFileURL: fileURL, name: "file", fileName: fileURL.lastPathComponent, mimeType: "application/octet-stream")
        } progress: { progess in
            
        } success: { dataTask, data in
            if let _result = data as? [String : Any], let code = _result["code"] as? String, code == "200" {
                callback(true, _result["data"] as? [String : Any], nil)
                return
            }
            callback(false, nil, nil)
        } failure: { dataTask, error in
            callback(false, nil, error)
        };
    }
    
    
    class func buildBodyData() -> Data {
        
//        var bodyStr = "--" + boundary + "\r\n"
        var bodyStr = ""
        bodyStr.append("Content-disposition: form-data; name=\"file\"; filename=\"test.pdf\"")
        bodyStr.append("\r\n")
//        bodyStr.append("Content-Type: image/png")
        bodyStr.append("\r\n\r\n")
        var bodyData = bodyStr.data(using: String.Encoding.utf8)
        let path = Bundle.main.path(forResource: "提取表格-常规1", ofType: "pdf")
        if let imageData = try? Data(contentsOf: URL(fileURLWithPath: path!)) {
            bodyData?.append(imageData)
        }
//        let endStr = "\r\n--" + boundary + "--\r\n"
        let endStr = ""
        bodyData?.append(endStr.data(using: String.Encoding.utf8)!)
        
        return bodyData!
    }
    
    private class func JsonDataParse(data: Data) -> Dictionary<String,Any>? {
        let result = try?JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        return result as? Dictionary<String, Any>
    }

}
