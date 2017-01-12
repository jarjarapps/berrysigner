//
//  ProjectDocument.swift
//  berrysigner
//
//  Created by Maciej Gibas on 1/7/17.
//  Copyright © 2017 Maciej Gibas. All rights reserved.
//

import UIKit

class Project : UIDocument{
    private static let dataFileName: String  = "data.file"
    private static let pagesFileName: String = "pages.file"
    
    private var documentWrapper: FileWrapper?
    
    var name: String?
    var pagesUrl: URL!
    
    init(fileURL url: URL, name:String?) {
        self.name = name
        super.init(fileURL: url)
        self.pagesUrl = self.fileURL.appendingPathComponent(Project.pagesFileName)
    }
    
    override func contents(forType typeName: String) throws -> Any {
        self.documentWrapper = FileWrapper(directoryWithFileWrappers: [:])
        
        let dataContent = self.name!.data(using: String.Encoding.utf8)
        let dataFileWrapper = FileWrapper(regularFileWithContents: dataContent!)
        dataFileWrapper.preferredFilename = Project.dataFileName
        
        let pagesWrapper = FileWrapper(directoryWithFileWrappers: [:])
        pagesWrapper.preferredFilename = Project.pagesFileName
        
        self.documentWrapper?.addFileWrapper(dataFileWrapper)
        self.documentWrapper?.addFileWrapper(pagesWrapper)
        return self.documentWrapper!
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        self.documentWrapper = contents as? FileWrapper
        let dataFileWrapper = self.documentWrapper?.fileWrappers?[Project.dataFileName]
        self.name = String(data: (dataFileWrapper?.regularFileContents)!, encoding: String.Encoding.utf8)
    }
}
