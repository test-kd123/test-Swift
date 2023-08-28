//
//  PDFInsert.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/21.
//

import Cocoa

private let public_key = "public_key_923a61e724db57c4f6706660a8121e6a"
private let secret_key = "secret_key_a3fd33db0ca1901688bd1582df08ac70"
class PDFInsert: NSObject {
    private static var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
    
    class func entrance() {
        self.client.createTask(url: CPDFDocumentEditor.INSERT) { taskId, param in
            guard let _taskId = taskId else {
                Swift.debugPrint("创建 Task 失败")
                return
            }
            
            let group = DispatchGroup()
            group.enter()
//            let path = Bundle.main.path(forResource: "test", ofType: "pdf")
            let path = Bundle.main.path(forResource: "test_password", ofType: "pdf")
            self.client.uploadFile(filepath: path!, password: "1234", params: [
                CPDFFileUploadParameterKey.targetPage.string() : "2",
                CPDFFileUploadParameterKey.width.string() : "500",
                CPDFFileUploadParameterKey.height.string() : "800",
                CPDFFileUploadParameterKey.number.string() : "2"
            ], taskId: _taskId) { filekey, fileUrl, _ in
                group.leave()
            }
            
            group.notify(queue: .main) {
                self.client.processFiles(taskId: _taskId) { _ , _ in
                    self.client.getTaskInfo(taskId: _taskId) { result, params in
                        if let dataDict = params.first as? [String : Any] {
                            if let taskStatus = dataDict[CPDFClient.Data.taskStatus] as? String, taskStatus == "TaskFinish" {
                                Swift.debugPrint(dataDict)
                            } else {
                                Swift.debugPrint("Task incomplete processing")
                                // 获取处理结果 可以通过下面的方式
                                self.client.getTaskInfoComplete(taskId: _taskId) { isFinish, params in
                                    Swift.debugPrint(params)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    class func asyncEntrance() {
        Task { @MainActor in
            let taskId = await self.client.createTask(url: CPDFDocumentEditor.INSERT)
//
            let path = Bundle.main.path(forResource: "test", ofType: "pdf")
            let _ = await self.client.uploadFile(filepath: path ?? "", params: [
                CPDFFileUploadParameterKey.targetPage.string() : "2",
                CPDFFileUploadParameterKey.width.string() : "500",
                CPDFFileUploadParameterKey.height.string() : "800",
                CPDFFileUploadParameterKey.number.string() : "2"
            ], taskId: taskId ?? "")
            
            let _ = await self.client.processFiles(taskId: taskId ?? "")
            let dataDict = await self.client.getTaskInfo(taskId: taskId ?? "")
            if let taskStatus = dataDict?["taskStatus"] as? String, taskStatus == "TaskFinish" {
                Swift.debugPrint(dataDict as Any)
            } else if let taskStatus = dataDict?["taskStatus"] as? String, taskStatus == "TaskProcessing" {
                Swift.debugPrint("Task incomplete processing")
                // 获取处理结果 可以通过下面的方式
                self.client.getTaskInfoComplete(taskId: taskId ?? "") { isFinish, params in
                    Swift.debugPrint(params)
                }
            } else {
                Swift.debugPrint("出错了")
            }
        }
    }
}
