//
//  RTFToPDF.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/22.
//

import Cocoa

private let public_key = "public_key_923a61e724db57c4f6706660a8121e6a"
private let secret_key = "secret_key_a3fd33db0ca1901688bd1582df08ac70"
class RTFToPDF: NSObject {
    private static var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
    
    class func entrance() {
        // Create a task
        self.client.createTask(url: CPDFConversion.RTF_TO_PDF) { model in
            guard let _taskId = model?.taskId else {
                return
            }
            
            // upload File
            let group = DispatchGroup()
            group.enter()
            let path = Bundle.main.path(forResource: "test", ofType: "rtf")
            self.client.uploadFile(filepath: path!, params: [:], taskId: _taskId) { uploadFileModel in
                group.leave()
            }
            
            group.notify(queue: .main) {
                // execute Task
                self.client.processFiles(taskId: _taskId) { _ in
                    // get task processing information
                    self.client.getTaskInfo(taskId: _taskId) { taskInfoModel in
                        let taskStatus = taskInfoModel?.taskStatus ?? ""
                        if (taskStatus == "TaskFinish") {
                            Swift.debugPrint(taskInfoModel)
                        } else if (taskStatus == "TaskProcessing" || taskStatus == "TaskWaiting") {
                            Swift.debugPrint("Task incomplete processing")
                            //                                self.client.getTaskInfoComplete(taskId: _taskId) { isFinish, params in
                            //                                    Swift.debugPrint(params)
                            //                                }
                        } else {
                            Swift.debugPrint("error: \(taskInfoModel?.errorDesc ?? "")")
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
            let taskModel = await self.client.createTask(url: CPDFConversion.RTF_TO_PDF)
            let taskId = taskModel?.taskId ?? ""

            // upload File
            let path = Bundle.main.path(forResource: "test", ofType: "rtf")
            let uploadFileModel = await self.client.uploadFile(filepath: path ?? "", params: [:], taskId: taskId)
            
            // execute Task
            let success = await self.client.processFiles(taskId: taskId)
            // get task processing information
            let taskInfoModel = await self.client.getTaskInfo(taskId: taskId)
            let taskStatus = taskInfoModel?.taskStatus ?? ""
            if (taskStatus == "TaskFinish") {
                Swift.debugPrint(taskInfoModel as Any)
            } else if (taskStatus == "TaskProcessing" || taskStatus == "TaskWaiting") {
                Swift.debugPrint("Task incomplete processing")
                self.client.getTaskInfoComplete(taskId: taskId) { isFinish, params in
                    Swift.debugPrint(params)
                }
            } else {
               
                Swift.debugPrint("error: \(taskInfoModel?.errorDesc ?? "")")
            }
        }
    }
}
