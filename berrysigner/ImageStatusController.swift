//
//  ImageStatusController.swift
//  berrysigner
//
//  Created by Maciej Gibas on 1/15/17.
//  Copyright © 2017 Maciej Gibas. All rights reserved.
//

import Foundation
import UIKit

class ImageStatusController{
    var undoStack: NSMutableArray = NSMutableArray()
    var redoStack: NSMutableArray = NSMutableArray()
    
    var isUndoAvailable: Bool{
        get {
            return self.undoStack.count>0
        }
    }
    var isRedoAvailable: Bool{
        get {
            return self.redoStack.count>0
        }
    }
    func save(image: UIImage){
        self.undoStack.add(image)
    }
    func undo() -> UIImage{
        self.redoStack.add(self.undoStack.lastObject as! UIImage)
        self.undoStack.removeLastObject()
        
        if (self.undoStack.count==0){
            return UIImage()
        }
        return self.undoStack.lastObject as!UIImage
    }
    func redo() -> UIImage{
        let result = self.redoStack.lastObject as! UIImage
        self.redoStack.removeLastObject()
        self.undoStack.add(result)
        return result
    }
}
