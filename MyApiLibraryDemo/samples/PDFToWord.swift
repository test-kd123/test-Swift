//
//  PDFToWord.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/21.
//

import Cocoa

private let public_key = "public_key_923a61e724db57c4f6706660a8121e6a"
private let secret_key = "secret_key_a3fd33db0ca1901688bd1582df08ac70"
class PDFToWord: NSObject {
    private static var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
    
    class func entrance() {
        // Create a task
        self.client.createTask(url: CPDFConversion.PDF_TO_WORD) { taskId, param in
            guard let _taskId = taskId else {
                return
            }
            
            // upload File
            let group = DispatchGroup()
            group.enter()
//            let path = Bundle.main.path(forResource: "test", ofType: "pdf")
            let path = Bundle.main.path(forResource: "test_password", ofType: "pdf")
            self.client.uploadFile(filepath: path!, password: "1234", params: [
                CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
                CPDFFileUploadParameterKey.isContainImg.string() : "1",
                CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
            ], taskId: _taskId) { filekey, fileUrl, _ in
                group.leave()
            }
            
            group.notify(queue: .main) {
                // execute Task
                self.client.processFiles(taskId: _taskId) { _ , _ in
                    // get task processing information
                    self.client.getTaskInfo(taskId: _taskId) { result, params in
                        if let dataDict = params.first as? [String : Any] {
                            let taskStatus = dataDict[CPDFClient.Data.taskStatus] as? String ?? ""
                            if (taskStatus == "TaskFinish") {
                                Swift.debugPrint(dataDict)
                            } else if (taskStatus == "TaskProcessing" || taskStatus == "TaskWaiting") {
                                Swift.debugPrint("Task incomplete processing")
//                                self.client.getTaskInfoComplete(taskId: _taskId) { isFinish, params in
//                                    Swift.debugPrint(params)
//                                }
                            } else {
                                Swift.debugPrint("error: \(dataDict)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    class func asyncEntrance() {
        Task { @MainActor in
            // Create a task
            let taskId = await self.client.createTask(url: CPDFConversion.PDF_TO_WORD) ?? ""

            // upload File
            let path = Bundle.main.path(forResource: "test", ofType: "pdf")
            let (fileKey, fileUrl, error) = await self.client.uploadFile(filepath: path ?? "", password: "", params: [
                CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
                CPDFFileUploadParameterKey.isContainImg.string() : "1",
                CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
            ], taskId: taskId)
            
            // execute Task
            let result = await self.client.processFiles(taskId: taskId)
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
