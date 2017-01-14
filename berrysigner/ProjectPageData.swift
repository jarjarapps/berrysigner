//
//  ProjectPageData.swift
//  berrysigner
//
//  Created by Maciej Gibas on 1/13/17.
//  Copyright © 2017 Maciej Gibas. All rights reserved.
//

import Foundation
import UIKit

class ProjectPageData : UIDocument{
    private var data: Data?
    
    var name: String?
    
    override func contents(forType typeName: String) throws -> Any {
        self.data = self.name!.data(using: String.Encoding.utf8)
        return self.data ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        self.data = contents as? Data
        self.name = String(data: self.data!, encoding: String.Encoding.utf8)
    }
}
