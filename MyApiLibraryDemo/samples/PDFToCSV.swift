//
//  PDFToCSV.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/21.
//

import Cocoa

private let public_key = "public_key_923a61e724db57c4f6706660a8121e6a"
private let secret_key = "secret_key_a3fd33db0ca1901688bd1582df08ac70"
class PDFToCSV: NSObject {
    private static var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
    
    class func entrance() {
        // Create a task
        self.client.createTask(url: CPDFConversion.PDF_TO_CSV) { taskModel in
            guard let taskId = taskModel?.taskId else {
                Swift.debugPrint(taskModel?.errorDesc ?? "")
                return
            }
            
            // upload File
            let group = DispatchGroup()
            group.enter()
//            let path = Bundle.main.path(forResource: "test", ofType: "pdf")
            let path = Bundle.main.path(forResource: "test_password", ofType: "pdf")
            self.client.uploadFile(filepath: path!, password: "1234", params: [CPDFFileUploadParameterKey.isCsvMerge.string() : "1"], taskId: taskId) { uploadFileModel in
                if let errorInfo = uploadFileModel?.errorDesc {
                    Swift.debugPrint(errorInfo)
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                // execute Task
                self.client.processFiles(taskId: taskId) { processFileModel in
                    if let errorInfo = processFileModel?.errorDesc {
                        Swift.debugPrint(errorInfo)
                    }
                    // get task processing information
                    self.client.getTaskInfo(taskId: taskId) { taskInfoModel in
                        guard let _model = taskInfoModel else {
                            Swift.debugPrint("error:....")
                            return
                        }
                        if (_model.isFinish()) {
                            _model.printInfo()
                        } else if (_model.isRuning()) {
                            Swift.debugPrint("Task incomplete processing")
//                            self.client.getTaskInfoComplete(taskId: taskId) { isFinish, params in
//                                Swift.debugPrint(params)
//                            }
                        } else {
                            Swift.debugPrint("error: \(_model.errorDesc ?? "")")
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
            let taskModel = await self.client.createTask(url: CPDFConversion.PDF_TO_CSV)
            let taskId = taskModel?.taskId ?? ""

            // upload File
            let path = Bundle.main.path(forResource: "test", ofType: "pdf")
            let uploadFileModel = await self.client.uploadFile(filepath: path ?? "",  password: "",params: [CPDFFileUploadParameterKey.isCsvMerge.string() : "1"], taskId: taskId)
            
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
