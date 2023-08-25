//
//  FormRecognizer.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/22.
//

import Cocoa

private let public_key = "public_key_923a61e724db57c4f6706660a8121e6a"
private let secret_key = "secret_key_a3fd33db0ca1901688bd1582df08ac70"
class FormRecognizer: NSObject {
    private static var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
    
    class func entrance() {
        self.client.createTask(url: CPDFDocumentAI.TABLEREC) { taskId, param in
            guard let _taskId = taskId else {
                Swift.debugPrint("创建 Task 失败")
                return
            }
            
            let group = DispatchGroup()
            group.enter()
            let path = Bundle.main.path(forResource: "IMG_00001(2)", ofType: "jpg")
            self.client.uploadFile(filepath: path!, params: [CPDFFileUploadParameterKey.lang.string():"auto"], taskId: _taskId) { filekey, fileUrl, _ in
                group.leave()
            }
            
            group.notify(queue: .main) {
//                self.client.processFiles(taskId: _taskId) { _ , _ in
//                    self.client.getTaskInfo(taskId: _taskId) { result, params in
//                        if let dataDict = params.first as? [String : Any] {
//                            if let taskStatus = dataDict[CPDFClient.Data.taskStatus] as? String, taskStatus == "TaskFinish" {
//                                Swift.debugPrint(dataDict)
//                            } else {
//                                Swift.debugPrint("Task incomplete processing")
//                                // 获取处理结果 可以通过下面的方式
//                                self.client.getTaskInfoComplete(taskId: _taskId) { isFinish, params in
//                                    Swift.debugPrint(params)
//                                }
//                            }
//                        }
//                    }
//                }
                self.client.resumeTask(taskId: _taskId) { isFinish, params in
//                    Swift.debugPrint(params)
                    var success = true
                    var downloadUrl: String?
                    if let datas = params.first as? [[String : Any]] {
                        for data in datas {
                            let result = CPDFResultFileInfo(dict: data)
                            if (result.status == "failed") {
                                success = false
                                Swift.debugPrint("失败：fileName: \(result.fileName ?? ""), reason: \(result.failureReason ?? "")")
                            }
                            downloadUrl = result.downloadUrl
                        }
                    }
                    if (success && downloadUrl != nil) {
                        Swift.debugPrint("处理完成. downloadUrl: \(downloadUrl!)")
                    }
                }
            }
        }
    }
}
