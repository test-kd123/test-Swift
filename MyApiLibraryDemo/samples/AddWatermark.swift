//
//  AddWatermark.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/22.
//

import Cocoa

private let public_key = "public_key_923a61e724db57c4f6706660a8121e6a"
private let secret_key = "secret_key_a3fd33db0ca1901688bd1582df08ac70"
class AddWatermark: NSObject {
    private static var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
    
    class func entrance() {
        self.client.createTask(url: CPDFDocumentEditor.ADD_WATERMARK) { taskId, param in
            guard let _taskId = taskId else {
                Swift.debugPrint("创建 Task 失败")
                return
            }
            
            let group = DispatchGroup()
            group.enter()
//            let path = Bundle.main.path(forResource: "test", ofType: "pdf")
            let path = Bundle.main.path(forResource: "test_password", ofType: "pdf")
            self.client.uploadFile(filepath: path!, password: "1234", params: [
                CPDFFileUploadParameterKey.textColor.string():"#59c5bb",
                CPDFFileUploadParameterKey.type.string():"text",
                CPDFFileUploadParameterKey.content.string():"text",
                CPDFFileUploadParameterKey.scale.string():"1",
                CPDFFileUploadParameterKey.opacity.string():"0.5",
                CPDFFileUploadParameterKey.rotation.string():"0.785",
                CPDFFileUploadParameterKey.targetPages.string():"1-2",
                CPDFFileUploadParameterKey.vertalign.string():"center",
                CPDFFileUploadParameterKey.horizalign.string():"left",
                CPDFFileUploadParameterKey.xoffset.string():"100",
                CPDFFileUploadParameterKey.yoffset.string():"100",
                CPDFFileUploadParameterKey.fullScreen.string():"1",
                CPDFFileUploadParameterKey.horizontalSpace.string():"10",
                CPDFFileUploadParameterKey.verticalSpace.string():"10"
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
}
