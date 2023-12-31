## ComPDFKit API in Swift

[ComPDFKit](https://api.compdf.com/api/docs/introduction) API provides a variety of Java API tools that allow you to create an efficient document processing workflow in a single API call. Try our various APIs for free — no credit card required.



## Requirements

Programming Environment: iOS 10+/MacOS 10.13+.

Dependencies: Xcode 13+.



## Installation

Add the following dependency to your ***"Podfile"***:

```
pod 'MyApiLibraryDemo'
```



## Create API Client

You can use your **publicKey** and **secretKey** to complete the authentication. You need to [sign in](https://api.compdf.com/login) your ComPDFKit API account to get your **publicKey** and **secretKey** at the [dashboard](https://api-dashboard.compdf.com/api/keys). If you are new to ComPDFKit, click here to [sign up](https://api.compdf.com/signup) for a free trial.

- Project public Key : You can find the public key in [Management Panel](https://api-dashboard.compdf.com/api/keys).

- Project secret Key : You can find the secret Key in [Management Panel](https://api-dashboard.compdf.com/api/keys).

```Swift
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
```



## Create Task

A task ID is automatically generated for you based on the type of PDF tool you choose. You can provide the callback notification URL. After the task processing is completed, we will notify you of the task result through the callback interface. You can perform other operations according to the request result, such as checking the status of the task, uploading files, starting the task, or downloading the result file.

```Swift
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

// Create a task
client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english) { taskModel in
    guard let taskId = taskModel?.taskId else {
        Swift.debugPrint(taskModel?.errorDesc ?? "")
        return
    }
}

async version(macOS 10.15/iOS 13 Later)
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

Task { @MainActor in
    // Create a task
    let taskModel = await client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english)
    let taskId = taskModel?.taskId ?? ""
}
```



## Upload Files

Upload the original file and bind the file to the task ID. The field parameter is used to pass the JSON string to set the processing parameters for the file. Each file will generate automatically a unique filekey. Please note that a maximum of five files can be uploaded for a task ID and no files can be uploaded for that task after it has started.

```Swift
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

// Create a task
client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english) { taskModel in
    guard let taskId = taskModel?.taskId else {
        Swift.debugPrint(taskModel?.errorDesc ?? "")
        return
    }
            
    // upload File
    let group = DispatchGroup()
    group.enter()
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
    client.uploadFile(filepath: path!, password: "", language: .english, params: [
        CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
        CPDFFileUploadParameterKey.isContainImg.string() : "1",
        CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
    ], taskId: taskId) { uploadFileModel in
        if let errorInfo = uploadFileModel?.errorDesc {
            Swift.debugPrint(errorInfo)
        }
        group.leave()
    }
}

async version(macOS 10.15/iOS 13 Later)
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

Task { @MainActor in
    // Create a task
    let taskModel = await client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english)
    let taskId = taskModel?.taskId ?? ""

    // upload File
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
    let uploadFileModel = await client.uploadFile(filepath: path ?? "", password: "", language: .english, params: [
        CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
        CPDFFileUploadParameterKey.isContainImg.string() : "1",
        CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
    ], taskId: taskId)
}
```



## Execute the task 

After the file upload is completed, call this interface with the task ID to process the files.

```Swift
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

// Create a task
client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english) { taskModel in
    guard let taskId = taskModel?.taskId else {
        Swift.debugPrint(taskModel?.errorDesc ?? "")
        return
    }
            
    // upload File
    let group = DispatchGroup()
    group.enter()
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
    client.uploadFile(filepath: path!, password: "", language: .english, params: [
        CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
        CPDFFileUploadParameterKey.isContainImg.string() : "1",
        CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
    ], taskId: taskId) { uploadFileModel in
        if let errorInfo = uploadFileModel?.errorDesc {
            Swift.debugPrint(errorInfo)
        }
        group.leave()
    }
            
    group.notify(queue: .main) {
        // execute Task
        client.processFiles(taskId: taskId, language: .english) { processFileModel in
            if let errorInfo = processFileModel?.errorDesc {
                Swift.debugPrint(errorInfo)
            }
        }
    }
}

async version(macOS 10.15/iOS 13 Later)
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

Task { @MainActor in
    // Create a task
    let taskModel = await client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english)
    let taskId = taskModel?.taskId ?? ""

    // upload File
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
    let uploadFileModel = await client.uploadFile(filepath: path ?? "", password: "", language: .english, params: [
        CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
        CPDFFileUploadParameterKey.isContainImg.string() : "1",
        CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
    ], taskId: taskId)
    
    // execute Task
    let _ = await client.processFiles(taskId: taskId, language: .english)
}
```


## Get Task Info

Request task status and file-related meta data based on the task ID.

```Swift
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

// Create a task
client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english) { taskModel in
    guard let taskId = taskModel?.taskId else {
        Swift.debugPrint(taskModel?.errorDesc ?? "")
        return
    }
            
    // upload File
    let group = DispatchGroup()
    group.enter()
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
    client.uploadFile(filepath: path!, password: "", language: .english, params: [
        CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
        CPDFFileUploadParameterKey.isContainImg.string() : "1",
        CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
    ], taskId: taskId) { uploadFileModel in
        if let errorInfo = uploadFileModel?.errorDesc {
            Swift.debugPrint(errorInfo)
        }
        group.leave()
    }
            
    group.notify(queue: .main) {
        // execute Task
        client.processFiles(taskId: taskId, language: .english) { processFileModel in
            if let errorInfo = processFileModel?.errorDesc {
                Swift.debugPrint(errorInfo)
            }
            // get task processing information
            client.getTaskInfo(taskId: taskId, language: .english) { taskInfoModel in
                guard let _model = taskInfoModel else {
                    Swift.debugPrint("error:....")
                    return
                }
                if (_model.isFinish()) {
                    _model.printInfo()
                } else if (_model.isRuning()) {
                    Swift.debugPrint("Task incomplete processing")
                } else {
                    Swift.debugPrint("error: \(_model.errorDesc ?? "")")
                }
            }
        }
    }
}
        
async version(macOS 10.15/iOS 13 Later)
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

Task { @MainActor in
    // Create a task
    let taskModel = await client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english)
    let taskId = taskModel?.taskId ?? ""

    // upload File
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
    let uploadFileModel = await client.uploadFile(filepath: path ?? "", password: "", language: .english, params: [
        CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
        CPDFFileUploadParameterKey.isContainImg.string() : "1",
        CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
    ], taskId: taskId)
    
    // execute Task
    let _ = await client.processFiles(taskId: taskId, language: .english)
    // get task processing information
    let taskInfoModel = await client.getTaskInfo(taskId: taskId, language: .english)
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
```


## Samples

See ***"Samples"*** folder in this folder.



## Resources

* [ComPDFKit API Documentation](https://api.compdf.com/api/docs/introduction)

