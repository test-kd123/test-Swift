//
//  AppDelegate.swift
//  MyApiLibraryDemo
//
//  Created by tangchao on 2023/8/17.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
//        PDFDelete.entrance()
//        PDFMerge.entrance()
//        PDFSplit.entrance()
//        PDFRotation.entrance()
//        PDFInsert.entrance()
//        PDFExtract.entrance()
//        PDFToWord.entrance()
//        PDFToExcel.entrance()
//        PDFToPPT.entrance()
//        PDFToHTML.entrance()
//        PDFToTXT.entrance()
//        PDFToCSV.entrance()
//        PDFToRTF.entrance()
//        PDFToJPG.entrance()
//        PDFToPNG.entrance()
        WordToPDF.entrance()
//        ExcelToPDF.entrance()
//        PPTToPDF.entrance()
//        PNGToPDF.entrance()
//        TXTToPDF.entrance()
//        HTMLToPDF.entrance()
//        RTFToPDF.entrance()
//        CSVToPDF.entrance()
//        OCR.entrance()
//        LayoutAnalysis.entrance()
//        ImageSharpeningEnhancement.entrance()
//        FormRecognizer.entrance()
//        TrimCorrection.entrance()
//        StampInspection.entrance()
//        AddWatermark.entrance()
//        DeleteWatermark.entrance()
//        PDFCompression.entrance()
        
        if #available(macOS 10.15, iOS 13.0, *) {
//            PDFDelete.asyncEntrance()
//            PDFMerge.asyncEntrance()
//            PDFSplit.asyncEntrance()
//        PDFRotation.asyncEntrance()
//        PDFInsert.asyncEntrance()
//        PDFExtract.asyncEntrance()
//        PDFToWord.asyncEntrance()
//        PDFToExcel.asyncEntrance()
//        PDFToPPT.asyncEntrance()
//        PDFToHTML.asyncEntrance()
//        PDFToTXT.asyncEntrance()
//        PDFToCSV.asyncEntrance()
//        PDFToRTF.asyncEntrance()
//        PDFToJPG.asyncEntrance()
//        PDFToPNG.asyncEntrance()
//        WordToPDF.asyncEntrance()
//        ExcelToPDF.asyncEntrance()
//        PPTToPDF.asyncEntrance()
//        PNGToPDF.asyncEntrance()
//        TXTToPDF.asyncEntrance()
//        HTMLToPDF.asyncEntrance()
//        RTFToPDF.asyncEntrance()
//        CSVToPDF.asyncEntrance()
//        OCR.asyncEntrance()
//        LayoutAnalysis.asyncEntrance()
//        ImageSharpeningEnhancement.asyncEntrance()
//        FormRecognizer.asyncEntrance()
//        TrimCorrection.asyncEntrance()
//        StampInspection.asyncEntrance()
//        AddWatermark.asyncEntrance()
//        DeleteWatermark.asyncEntrance()
//            PDFCompression.asyncEntrance()
        } else {
            // Fallback on earlier versions
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

