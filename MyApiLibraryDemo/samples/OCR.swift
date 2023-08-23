//
//  OCR.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/21.
//

import Cocoa

private let public_key = "public_key_923a61e724db57c4f6706660a8121e6a"
private let secret_key = "secret_key_a3fd33db0ca1901688bd1582df08ac70"
class OCR: NSObject {
    private static var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
    
    class func entrance() {
        self.client.createTask(url: CPDFDocumentAI.OCR) { taskId, param in
            let group = DispatchGroup()
            group.enter()
            let path = Bundle.main.path(forResource: "test", ofType: "png")
            self.client.uploadFile(filepath: path!, params: [CPDFFileUploadParameterKey.lang.string():"auto"], taskId: taskId) { filekey, fileUrl in
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
