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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.pageData?.open { (success) in
            self.navigationItem.title = self.pageData?.name
        }
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
