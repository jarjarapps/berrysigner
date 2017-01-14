//
//  Page.swift
//  berrysigner
//
//  Created by Maciej Gibas on 1/8/17.
//  Copyright © 2017 Maciej Gibas. All rights reserved.
//

import Foundation
import UIKit

class ProjectPage: UIDocument{
    private static let dataFileName: String  = "data.file"
    private static let imageFileName: String  = "image.file"
    private var documentWrapper: FileWrapper?
    
    var imageUrl: URL!
    var dataUrl: URL!
    
    override init(fileURL url: URL) {
        super.init(fileURL: url)
        self.imageUrl = self.fileURL.appendingPathComponent(ProjectPage.imageFileName)
        self.dataUrl = self.fileURL.appendingPathComponent(ProjectPage.dataFileName)
    }
    
    override func contents(forType typeName: String) throws -> Any {
        self.documentWrapper = FileWrapper(directoryWithFileWrappers: [:])
        
        let dataFileWrapper = FileWrapper(regularFileWithContents:Data())
        dataFileWrapper.preferredFilename = ProjectPage.dataFileName
        
        let imageWrapper = FileWrapper(regularFileWithContents: Data())
        imageWrapper.preferredFilename = ProjectPage.imageFileName
        
        self.documentWrapper?.addFileWrapper(dataFileWrapper)
        self.documentWrapper?.addFileWrapper(imageWrapper)
        return self.documentWrapper!
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        self.documentWrapper = contents as? FileWrapper
    }

}       
