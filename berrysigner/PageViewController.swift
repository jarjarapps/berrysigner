//
//  PageViewController.swift
//  berrysigner
//
//  Created by Maciej Gibas on 1/11/17.
//  Copyright © 2017 Maciej Gibas. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
    var pageUrl: URL!
    var pageData: ProjectPageData!
    var pageImage: ProjectPageImage!
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 3.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    private var imageStatus: ImageStatusController?
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var undoButton: UIBarButtonItem!
    @IBOutlet weak var redoButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageStatus = ImageStatusController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnTap = true
        self.loadPage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnTap = false
    }
    
    func loadPage(){
        let page = ProjectPage(fileURL: self.pageUrl)
        self.pageData = ProjectPageData(fileURL: page.dataUrl)
        self.pageImage = ProjectPageImage(fileURL: page.imageUrl)
        self.pageData?.open { (success) in
            self.navigationItem.title = self.pageData?.name
        }
        self.pageImage?.open(completionHandler: { (success) in
            self.imageView.image = self.pageImage.image
        })
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pageImage.image = self.imageView.image
        self.pageImage.updateChangeCount(UIDocumentChangeKind.done)
        
        self.imageStatus?.save(image: self.pageImage.image!)
        self.redoButton.isEnabled = (self.imageStatus?.isRedoAvailable)!
        self.undoButton.isEnabled = (self.imageStatus?.isUndoAvailable)!
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            draw(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    func draw(fromPoint: CGPoint, toPoint: CGPoint) {
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        imageView.image?.draw(in : CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        imageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    @IBAction func undo(_ sender: Any) {
        self.imageView.image = self.imageStatus?.undo()
        self.pageImage.image = self.imageView.image
        self.pageImage.updateChangeCount(UIDocumentChangeKind.done)
        self.redoButton.isEnabled = (self.imageStatus?.isRedoAvailable)!
        self.undoButton.isEnabled = (self.imageStatus?.isUndoAvailable)!
    }
    @IBAction func redo(_ sender: Any) {
        self.imageView.image = self.imageStatus?.redo()
        self.pageImage.image = self.imageView.image
        self.pageImage.updateChangeCount(UIDocumentChangeKind.done)
        self.redoButton.isEnabled = (self.imageStatus?.isRedoAvailable)!
        self.undoButton.isEnabled = (self.imageStatus?.isUndoAvailable)!
    }
    @IBAction func editName(_ sender: Any) {
        let alert = UIAlertController(title: "Edit Page Name",
                                      message: nil,
                                      preferredStyle: .alert)
        var nameTextField: UITextField?
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(alert: UIAlertAction!) in
            self.pageData?.name = nameTextField?.text
            self.navigationItem.title = self.pageData?.name
            self.pageData?.updateChangeCount(UIDocumentChangeKind.done)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            field.text = self.pageData?.name
            nameTextField = field
        }
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:1.0 , y:1.0, width:self.view.bounds.size.width / 2.0, height:self.view.bounds.size.height / 2.0)
        
        self.present(alert, animated: true, completion: nil)
    }
}
