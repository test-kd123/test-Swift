//
//  PDFDelete.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/17.
//

import Cocoa

private let public_key = "public_key_923a61e724db57c4f6706660a8121e6a"
private let secret_key = "secret_key_a3fd33db0ca1901688bd1582df08ac70"

class PDFDelete: NSObject {
    private static var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
    
    class func entrance() {
        self.client.createTask(url: CPDFDocumentEditor.DELETE) { taskId, _ in
            guard let _taskId = taskId else {
                Swift.debugPrint("创建 Task 失败")
                return
            }
            
            let group = DispatchGroup()
            group.enter()
            let path = Bundle.main.path(forResource: "test", ofType: "pdf")
            self.client.uploadFile(filepath: path!, params: [CPDFFileUploadParameterKey.pageOptions.string():["1"]], taskId: _taskId) { fileKey, fileUrl, _  in
                group.leave()
            }
            
            group.notify(queue: .main) {
                self.client.resumeTask(taskId: _taskId) { isFinish, params in
                    Swift.debugPrint(params)
                }
            }
        }
    }
}
