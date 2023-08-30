//
//  CPDFDocumentAI.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/21.
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

class CPDFDocumentAI: NSObject {
    static let OCR              = "documentAI/ocr"
    static let MAGICCOLOR       = "documentAI/magicColor"
    static let TABLEREC         = "documentAI/tableRec"
    static let LAYOUTANALYSIS   = "documentAI/layoutAnalysis"
    static let DEWARP           = "documentAI/dewarp"
    static let DETECTIONSTAMP   = "documentAI/detectionStamp"
}
