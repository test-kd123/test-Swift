//
//  CPDFConversion.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/17.
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

class CPDFConversion: NSObject {
    static let PDF_TO_WORD      = "pdf/docx"
    static let PDF_TO_EXCEL     = "pdf/xlsx"
    static let PDF_TO_PPT       = "pdf/pptx"
    static let PDF_TO_TXT       = "pdf/txt"
    static let PDF_TO_PNG       = "pdf/png"
    static let PDF_TO_HTML      = "pdf/html"
    static let PDF_TO_RTF       = "pdf/rtf"
    static let PDF_TO_CSV       = "pdf/csv"
    static let PDF_TO_JPG       = "pdf/jpg"

    static let DOC_TO_PDF       = "doc/pdf"
    static let DOCX_TO_PDF      = "docx/pdf"
    static let XLSX_TO_PDF      = "xlsx/pdf"
    static let XLS_TO_PDF       = "xls/pdf"
    static let PPT_TO_PDF       = "ppt/pdf"
    static let PPTX_TO_PDF      = "pptx/pdf"
    static let TXT_TO_PDF       = "txt/pdf"
    static let PNG_TO_PDF       = "png/pdf"
    static let HTML_TO_PDF      = "html/pdf"
    static let CSV_TO_PDF       = "csv/pdf"
    static let RTF_TO_PDF       = "rtf/pdf"
}
