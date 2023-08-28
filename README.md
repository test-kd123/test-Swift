## ComPDFKit API in Swift

[ComPDFKit](https://api.compdf.com/api/docs/introduction) API provides a variety of Java API tools that allow you to create an efficient document processing workflow in a single API call. Try our various APIs for free — no credit card required.



## Requirements

Programming Environment: iOS/MacOS.

Dependencies: Xcode.



## Installation

Add the following dependency to your ***"pom.xml"***:

```
<dependency>
    <groupId>com.compdf</groupId>
    <artifactId>compdfkit-api-java</artifactId>
    <version>1.2.4</version>
</dependency>
```



## Create API Client

You can use your **publicKey** and **secretKey** to complete the authentication. You need to [sign in](https://api.compdf.com/login) your ComPDFKit API account to get your **publicKey** and **secretKey** at the [dashboard](https://api-dashboard.compdf.com/api/keys). If you are new to ComPDFKit, click here to [sign up](https://api.compdf.com/signup) for a free trial.

- Project public Key : You can find the public key in [Management Panel](https://api-dashboard.compdf.com/api/keys).

- Project secret Key : You can find the secret Key in [Management Panel](https://api-dashboard.compdf.com/api/keys).

```Swift
var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
```



## Create Task

A task ID is automatically generated for you based on the type of PDF tool you choose. You can provide the callback notification URL. After the task processing is completed, we will notify you of the task result through the callback interface. You can perform other operations according to the request result, such as checking the status of the task, uploading files, starting the task, or downloading the result file.

```Swift
// Create a client
var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

// Create a task
// Create an example of a PDF TO WORD task
client.createTask(url: CPDFConversion.PDF_TO_WORD) { taskId, param in
// Get a task id
    guard let _taskId = taskId else {
        return
    }
}

async version(macOS 10.15/iOS 13 Later)
Task { @MainActor in
    // Create a task
    let taskId = await self.client.createTask(url: CPDFConversion.PDF_TO_WORD) ?? ""
}
```



## Upload Files

Upload the original file and bind the file to the task ID. The field parameter is used to pass the JSON string to set the processing parameters for the file. Each file will generate automatically a unique filekey. Please note that a maximum of five files can be uploaded for a task ID and no files can be uploaded for that task after it has started.

```Swift
// Create a client
var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

// Create a task
// Create an example of a PDF TO WORD task
client.createTask(url: CPDFConversion.PDF_TO_WORD) { taskId, param in
// Get a task id
    guard let _taskId = taskId else {
        return
    }
            
    let group = DispatchGroup()
    group.enter()
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
// Upload files
    client.uploadFile(filepath: path!, params: [
        CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
        CPDFFileUploadParameterKey.isContainImg.string() : "1",
        CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
    ], taskId: _taskId) { filekey, fileUrl, _ in
        group.leave()
    }
            
    group.notify(queue: .main) {
                
    }
}

async version(macOS 10.15/iOS 13 Later)
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
}
```



## Execute the task & Get Task Info

After the file upload is completed, call this interface with the task ID to process the files.

```Swift
// Create a client
var client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

// Create a task
// Create an example of a PDF TO WORD task
client.createTask(url: CPDFConversion.PDF_TO_WORD) { taskId, param in
// Get a task id
    guard let _taskId = taskId else {
        Swift.debugPrint("创建 Task 失败")
        return
    }
            
// Upload files
    let group = DispatchGroup()
    group.enter()
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
    client.uploadFile(filepath: path!, params: [
        CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
        CPDFFileUploadParameterKey.isContainImg.string() : "1",
        CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
    ], taskId: _taskId) { filekey, fileUrl, _ in
        group.leave()
    }
            
    group.notify(queue: .main) {
// Execute Task & Query TaskInfo
        client.resumeTask(taskId: _taskId) { isFinish, params in
            var success = true
            var downloadUrl: String?
            if let datas = params.first as? [[String : Any]] {
                for data in datas {
                    let result = CPDFResultFileInfo(dict: data)
                    if (result.status == "failed") {
                        success = false
                        Swift.debugPrint("失败：fileName: \(result.fileName ?? ""), reason: \(result.failureReason ?? "")")
                    }
                    downloadUrl = result.downloadUrl
                }
            }
            if (success && downloadUrl != nil) {
                Swift.debugPrint("处理完成. downloadUrl: \(downloadUrl!)")
            }
        }
    }
}

async version(macOS 10.15/iOS 13 Later)
Task { @MainActor in
    // Create a task
    let taskId = await self.client.createTask(url: CPDFConversion.PDF_TO_WORD) ?? ""

    // upload File
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
    let (fileKey, fileUrl, error) = await self.client.uploadFile(filepath: path ?? "", params: [
            CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
            CPDFFileUploadParameterKey.isContainImg.string() : "1",
            CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
        ], taskId: taskId)
            
    // execute Task
    let result = await self.client.processFiles(taskId: taskId)
}
```


## Get Task Info

Request task status and file-related meta data based on the task ID.

```Swift

async version(macOS 10.15/iOS 13 Later)
Task { @MainActor in
    // Create a task
    let taskId = await self.client.createTask(url: CPDFConversion.PDF_TO_WORD) ?? ""

    // upload File
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
    let (fileKey, fileUrl, error) = await self.client.uploadFile(filepath: path ?? "", params: [
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
    } else if (taskStatus == "TaskProcessing") {
        Swift.debugPrint("Task incomplete processing")
        self.client.getTaskInfoComplete(taskId: taskId) { isFinish, params in
            Swift.debugPrint(params)
        }
    } else {
        Swift.debugPrint("error")
    }
}
```


## Samples

See ***"Samples"*** folder in this folder.



## Resources

* [ComPDFKit API Documentation](https://api.compdf.com/api/docs/introduction)

