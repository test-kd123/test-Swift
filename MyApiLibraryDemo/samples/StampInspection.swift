//
//  StampInspection.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/22.
//

import Cocoa

private let public_key = "public_key_923a61e724db57c4f6706660a8121e6a"
private let secret_key = "secret_key_a3fd33db0ca1901688bd1582df08ac70"
class StampInspection: NSObject {
    private static var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
    
    class func entrance() {
        self.client.createTask(url: CPDFDocumentAI.DETECTIONSTAMP) { taskId, param in
            guard let _taskId = taskId else {
                return
            }
            
            let group = DispatchGroup()
            group.enter()
            let path = Bundle.main.path(forResource: "test2", ofType: "jpg")
            self.client.uploadFile(filepath: path!, params: [:], taskId: _taskId) { filekey, fileUrl, _ in
                group.leave()
            }
            
            group.notify(queue: .main) {
                self.client.resumeTask(taskId: _taskId) { isFinish, params in
//                    Swift.debugPrint(params)
                    var success = true
                    var downloadUrl: String?
                    if let datas = params.first as? [[String : Any]] {
                        for data in datas {
                            let result = CPDFResultFileInfo(dict: data)
                            if (result.status == "failed") {
                                success = false
                                Swift.debugPrint("failure：fileName: \(result.fileName ?? ""), reason: \(result.failureReason ?? "")")
                            }
                            downloadUrl = result.downloadUrl
                        }
                    }
                    if (success && downloadUrl != nil) {
                        Swift.debugPrint("complete. downloadUrl: \(downloadUrl!)")
                    }
                }
            }
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    class func asyncEntrance() {
        Task { @MainActor in
            // Create a task
            let taskId = await self.client.createTask(url: CPDFDocumentAI.DETECTIONSTAMP) ?? ""

            // upload File
            let path = Bundle.main.path(forResource: "test2", ofType: "jpg")
            let (fileKey, fileUrl, error) = await self.client.uploadFile(filepath: path ?? "", params: [:], taskId: taskId)
            
            // execute Task
            let success = await self.client.processFiles(taskId: taskId)
            // get task processing information
            let dataDict = await self.client.getTaskInfo(taskId: taskId)
            let taskStatus = dataDict?[CPDFClient.Data.taskStatus] as? String ?? ""
            if (taskStatus == "TaskFinish") {
                Swift.debugPrint(dataDict as Any)
            } else if (taskStatus == "TaskProcessing" || taskStatus == "TaskWaiting") {
                Swift.debugPrint("Task incomplete processing")
                self.client.getTaskInfoComplete(taskId: taskId) { isFinish, params in
                    Swift.debugPrint(params)
                }
            } else {
                Swift.debugPrint("error: \(dataDict ?? [:])")
            }
        }
    }
}
