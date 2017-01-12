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
    
    var name: String?
    
    init(fileURL url: URL, name:String?) {
        self.name = name
        super.init(fileURL: url)
    }
    
    override func contents(forType typeName: String) throws -> Any {
        self.documentWrapper = FileWrapper(directoryWithFileWrappers: [:])
        
        let dataContent = self.name!.data(using: String.Encoding.utf8)
        let dataFileWrapper = FileWrapper(regularFileWithContents: dataContent!)
        dataFileWrapper.preferredFilename = ProjectPage.dataFileName
        
        self.documentWrapper?.addFileWrapper(dataFileWrapper)
        return self.documentWrapper!
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        self.documentWrapper = contents as? FileWrapper
        let dataFileWrapper = self.documentWrapper?.fileWrappers?[ProjectPage.dataFileName]
        self.name = String(data: (dataFileWrapper?.regularFileContents)!, encoding: String.Encoding.utf8)
    }

}       
