//
//  ProjectDocument.swift
//  berrysigner
//
//  Created by Maciej Gibas on 1/7/17.
//  Copyright © 2017 Maciej Gibas. All rights reserved.
//

import UIKit

class Project : UIDocument{
    override func contents(forType typeName: String) throws -> Any {
        return Data()
           }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        
    }
}
