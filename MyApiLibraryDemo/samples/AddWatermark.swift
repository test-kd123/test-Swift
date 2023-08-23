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
            let group = DispatchGroup()
            group.enter()
            let path = Bundle.main.path(forResource: "test", ofType: "pdf")
            self.client.uploadFile(filepath: path!, params: [
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
            ], taskId: taskId) { filekey, fileUrl in
                group.leave()
            }
            
            group.notify(queue: .main) {
                self.client.resumeTask(taskId: taskId) { isFinish, downloadUrl, params in
                    Swift.debugPrint(params)
                }
            }
        }
    }
}