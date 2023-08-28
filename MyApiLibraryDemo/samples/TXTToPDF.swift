//
//  TXTToPDF.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/22.
//

import Cocoa

private let public_key = "public_key_923a61e724db57c4f6706660a8121e6a"
private let secret_key = "secret_key_a3fd33db0ca1901688bd1582df08ac70"
class TXTToPDF: NSObject {
    private static var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
    
    class func entrance() {
        self.client.createTask(url: CPDFConversion.TXT_TO_PDF) { taskId, param in
            guard let _taskId = taskId else {
                Swift.debugPrint("创建 Task 失败")
                return
            }
            
            let group = DispatchGroup()
            group.enter()
            let path = Bundle.main.path(forResource: "test", ofType: "txt")
            self.client.uploadFile(filepath: path!, params: [:], taskId: _taskId) { filekey, fileUrl, _ in
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
//                                self.client.getTaskInfoComplete(taskId: _taskId) { isFinish, params in
//                                    Swift.debugPrint(params)
//                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    class func asyncEntrance() {
        Task { @MainActor in
            // Create a task
            let taskId = await self.client.createTask(url: CPDFConversion.TXT_TO_PDF) ?? ""

            // upload File
            let path = Bundle.main.path(forResource: "test", ofType: "txt")
            _ = await self.client.uploadFile(filepath: path ?? "", params: [:], taskId: taskId)
            
            // execute Task
            _ = await self.client.processFiles(taskId: taskId)
            // get task processing information
            let dataDict = await self.client.getTaskInfo(taskId: taskId)
            if let taskStatus = dataDict?["taskStatus"] as? String, taskStatus == "TaskFinish" {
                Swift.debugPrint(dataDict as Any)
            } else if let taskStatus = dataDict?["taskStatus"] as? String, taskStatus == "TaskProcessing" {
                Swift.debugPrint("Task incomplete processing")
                // 获取处理结果 可以通过下面的方式
                self.client.getTaskInfoComplete(taskId: taskId) { isFinish, params in
                    Swift.debugPrint(params)
                }
            } else {
                Swift.debugPrint("出错了")
            }
        }
    }
}
