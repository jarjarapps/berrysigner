//
//  ProjectDetailsTableViewController.swift
//  berrysigner
//
//  Created by Maciej Gibas on 1/11/17.
//  Copyright © 2017 Maciej Gibas. All rights reserved.
//

import UIKit

class ProjectDetailsTableViewController: UITableViewController {
    
    var projectUrl: URL!
    var projectData: ProjectData?
    
    private var pageUrls: [URL] = []
    private var pageIndexPathToDelete: IndexPath?
    private var activityAlert: ActivityAlertViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityAlert = ActivityAlertViewController(forController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadPages()
    }
    
    @IBAction func addPage(_ sender: Any) {
        self.activityAlert?.show(withTitle: "Creating Page...")
        let project = Project(fileURL: self.projectUrl)
        let fileName = "\(UUID().uuidString).page"
        let documentUrl = project.pagesUrl.appendingPathComponent(fileName)
        let page = ProjectPage(fileURL: documentUrl)
        let pageData = ProjectPageData(fileURL: page.dataUrl!)
        pageData.name = "New Page"
        
        page.save(to: documentUrl, for: UIDocumentSaveOperation.forCreating) { (pageCreated) in
            if(pageCreated){
                pageData.save(to: pageData.fileURL, for: UIDocumentSaveOperation.forCreating, completionHandler: { (dataCreated) in
                    if(dataCreated){
                        self.activityAlert?.dismiss()
                        self.performSegue(withIdentifier: "showPage", sender: page)
                    }
                })
            }
        }
        
    }
    
    func loadPages(){
        let project = Project(fileURL: self.projectUrl)
        self.projectData = ProjectData(fileURL: project.dataUrl)
        self.projectData?.open { (success) in
            do{
                self.navigationItem.title = self.projectData?.name
                try self.pageUrls = FileManager.default.contentsOfDirectory(at: (project.pagesUrl)!, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles) as [URL]
                self.tableView.reloadData()
            }catch{
                print(error)
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pageUrls.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pageCell", for: indexPath)
        let url = self.pageUrls[indexPath.row]
        let page = ProjectPage(fileURL: url)
        let pageData = ProjectPageData(fileURL: page.dataUrl!)
        pageData.open { (success) in
            cell.textLabel?.text =  pageData.name
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PageViewController
        
        if let tableViewCell = sender as? UITableViewCell{
            destination.pageUrl = self.pageUrls[(self.tableView.indexPath(for: tableViewCell)?.row)!]
        }else if let page = sender as? ProjectPage{
            destination.pageUrl = page.fileURL
        }
    }
    
    func confirmDelete(){
        let alert = UIAlertController(title: "Delete Page",
                                      message: "Are you sure you want to permanently delete a page?",
                                      preferredStyle: .alert)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: self.handleDeletePage)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction) in
            self.pageIndexPathToDelete = nil
        })
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:1.0 , y:1.0, width:self.view.bounds.size.width / 2.0, height:self.view.bounds.size.height / 2.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeletePage(alertAction: UIAlertAction!) -> Void {
        do{
            if let indexPath = self.pageIndexPathToDelete {
                tableView.beginUpdates()
                
                try FileManager.default.removeItem(at: self.pageUrls[indexPath.item])
                self.pageUrls.remove(at: indexPath.item)
                tableView.deleteRows(at: [indexPath], with: .left)
                self.pageIndexPathToDelete = nil
                
                tableView.endUpdates()
            }
        }catch{
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.pageIndexPathToDelete = indexPath
            self.confirmDelete()
        }
    }
    
    @IBAction func editName(_ sender: Any) {
        let alert = UIAlertController(title: "Edit Project Name",
                                      message: nil,
                                      preferredStyle: .alert)
        
        var nameTextField: UITextField?
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(alert:UIAlertAction) in
            self.projectData?.name = nameTextField?.text
            self.navigationItem.title = self.projectData?.name
            self.projectData?.updateChangeCount(UIDocumentChangeKind.done)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            field.text = self.projectData?.name
            nameTextField = field
        }
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:1.0 , y:1.0, width:self.view.bounds.size.width / 2.0, height:self.view.bounds.size.height / 2.0)
        
        self.present(alert, animated: true, completion: nil)
    }
}
