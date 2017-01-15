//
//  ProjectPageImage.swift
//  berrysigner
//
//  Created by Maciej Gibas on 1/8/17.
//  Copyright © 2017 Maciej Gibas. All rights reserved.
//

import Foundation
import UIKit

class ProjectPageImage : UIDocument{
    var image: UIImage?
    
    override func contents(forType typeName: String) throws -> Any {
        let data = UIImagePNGRepresentation(self.image!)
        return data ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        let data = contents as? Data
        self.image = UIImage(data: data!)
    }
}
