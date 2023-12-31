//
//  PNGToPDF.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/22.
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

private let public_key = "x"
private let secret_key = "x"
class PNGToPDF: NSObject {
    private static var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
    
    class func entrance() {
        // Create a task
        self.client.createTask(url: CPDFConversion.PNG_TO_PDF) { taskModel in
            guard let taskId = taskModel?.taskId else {
                Swift.debugPrint(taskModel?.errorDesc ?? "")
                return
            }
            
            // upload File
            let group = DispatchGroup()
            group.enter()
            let path = Bundle.main.path(forResource: "test", ofType: "png")
            self.client.uploadFile(filepath: path!, params: [:], taskId: taskId) { uploadFileModel in
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
        let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
        
        Task { @MainActor in
            // Create a task
            let taskModel = await client.createTask(url: CPDFConversion.PNG_TO_PDF)
            let taskId = taskModel?.taskId ?? ""

            // upload File
            let path = Bundle.main.path(forResource: "test", ofType: "png")
            let uploadFileModel = await client.uploadFile(filepath: path ?? "", params: [:], taskId: taskId)
            
            // execute Task
            let _ = await client.processFiles(taskId: taskId)
            // get task processing information
            let taskInfoModel = await client.getTaskInfo(taskId: taskId)
            guard let _model = taskInfoModel else {
                Swift.debugPrint("error:....")
                return
            }
            if (_model.isFinish()) {
                _model.printInfo()
            } else if (_model.isRuning()) {
                Swift.debugPrint("Task incomplete processing")
                client.getTaskInfoComplete(taskId: taskId) { isFinish, params in
                    Swift.debugPrint(params)
                }
            } else {
                Swift.debugPrint("error: \(taskInfoModel?.errorDesc ?? "")")
            }
        }
    }
}
