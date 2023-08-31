//
//  PDFMerge.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/21.
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

private let public_key = "x"
private let secret_key = "x"
class PDFMerge: NSObject {
    class func entrance() {
        let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
        
        //Create a task
        client.createTask(url: CPDFDocumentEditor.MERGE) { taskModel in
            guard let taskId = taskModel?.taskId else {
                Swift.debugPrint(taskModel?.errorDesc ?? "")
                return
            }
            
            // upload File
            let group = DispatchGroup()
            group.enter()
            let path = Bundle.main.path(forResource: "test", ofType: "pdf")
            client.uploadFile(filepath: path!, params: [CPDFFileUploadParameterKey.pageOptions.string():["1,2"]], taskId: taskId) { uploadFileModel  in
                if let errorInfo = uploadFileModel?.errorDesc {
                    Swift.debugPrint(errorInfo)
                }
                group.leave()
            }
            group.enter()
            client.uploadFile(filepath: path!, params: [CPDFFileUploadParameterKey.pageOptions.string():["1,2"]], taskId: taskId) { uploadFileModel  in
                if let errorInfo = uploadFileModel?.errorDesc {
                    Swift.debugPrint(errorInfo)
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                // execute Task
                client.processFiles(taskId: taskId) { processFileModel in
                    if let errorInfo = processFileModel?.errorDesc {
                        Swift.debugPrint(errorInfo)
                    }
                    // get task processing information
                    client.getTaskInfo(taskId: taskId) { taskInfoModel in
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
            let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
            
            //Create a task
            let taskModel = await client.createTask(url: CPDFDocumentEditor.MERGE)
            let taskId = taskModel?.taskId ?? ""

            // upload File
            let path = Bundle.main.path(forResource: "test", ofType: "pdf")
            let uploadFileModel = await client.uploadFile(filepath: path ?? "", params: [CPDFFileUploadParameterKey.pageOptions.string():["1,2"]], taskId: taskId)
            let uploadFileModel2 = await client.uploadFile(filepath: path ?? "", params: [CPDFFileUploadParameterKey.pageOptions.string():["1,2"]], taskId: taskId)
            
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
