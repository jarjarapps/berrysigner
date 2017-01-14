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
    
    var pagesUrl: URL!
    var dataUrl: URL!
    
    override init(fileURL url: URL) {
        super.init(fileURL: url)
        self.pagesUrl = self.fileURL.appendingPathComponent(Project.pagesFileName)
        self.dataUrl = self.fileURL.appendingPathComponent(Project.dataFileName)
    }
    
    override func contents(forType typeName: String) throws -> Any {
        self.documentWrapper = FileWrapper(directoryWithFileWrappers: [:])
        
        let dataFileWrapper = FileWrapper(regularFileWithContents:Data())
        dataFileWrapper.preferredFilename = Project.dataFileName
        
        let pagesWrapper = FileWrapper(directoryWithFileWrappers: [:])
        pagesWrapper.preferredFilename = Project.pagesFileName
        
        self.documentWrapper?.addFileWrapper(dataFileWrapper)
        self.documentWrapper?.addFileWrapper(pagesWrapper)
        return self.documentWrapper!
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        self.documentWrapper = contents as? FileWrapper
    }
}
