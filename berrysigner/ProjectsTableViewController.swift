//
//  ProjectsTableViewController.swift
//  berrysigner
//
//  Created by Maciej Gibas on 1/7/17.
//  Copyright © 2017 Maciej Gibas. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UITableViewController {
    
    private var documentsUrl: URL?
    private var projectUrls : [URL] = []
    private var projectIndexPathToDelete: IndexPath?
    private var activityAlert: ActivityAlertViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelectionDuringEditing = false
        self.activityAlert = ActivityAlertViewController(forController: self)

        self.documentsUrl = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last! as URL
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadProjects()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projectUrls.count
    }
    
    @IBAction func createProject(_ sender: Any) {
        self.activityAlert?.show(withTitle: "Creating Project...")
        let fileName = "\(UUID().uuidString).berryproj"
        let documentUrl = documentsUrl?.appendingPathComponent(fileName)
        let project = Project(fileURL: documentUrl!)
        let projectData = ProjectData(fileURL: project.dataUrl!)
        projectData.name = "New Project"
        
        project.save(to: documentUrl!, for: UIDocumentSaveOperation.forCreating) { (projectCreated) in
            if(projectCreated){
                projectData.save(to: projectData.fileURL, for: UIDocumentSaveOperation.forCreating, completionHandler: { (dataCreated) in
                    if(dataCreated){
                        self.activityAlert?.dismiss()
                        self.performSegue(withIdentifier: "showProject", sender: project)
                    }
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ProjectDetailsTableViewController
        
        if let tableViewCell = sender as? UITableViewCell{
            destination.projectUrl = self.projectUrls[(self.tableView.indexPath(for: tableViewCell)?.row)!]
        }else if let project = sender as? Project{
            destination.projectUrl = project.fileURL
        }
    }
    
    func loadProjects(){
        do{
            try self.projectUrls = FileManager.default.contentsOfDirectory(at: self.documentsUrl!, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles) as [URL]
            self.tableView.reloadData()
        }catch{
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath)
        let url = self.projectUrls[indexPath.row]
        let project = Project(fileURL: url)
        let projectData = ProjectData(fileURL: project.dataUrl!)
        projectData.open { (success) in
            cell.textLabel?.text =  projectData.name
        }
        return cell
    }
    
    private func createActivityIndicator(){
        self.view.addSubview(view)
//        let alert = UIAlertController(title: "Adding Project...",
//                                        message: nil,
//                                        preferredStyle: .alert)
//        let viewBack:UIView = UIView(frame: CGRect(x:83,y:0,width:100,height:100))
//        
//        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:50, y:10, width:37, height:37))
//        loadingIndicator.center = viewBack.center
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        loadingIndicator.startAnimating();
//        viewBack.addSubview(loadingIndicator)
//        viewBack.center = self.view.center
////        alert.setValue(viewBack, forKey: "accessoryView")
//        loadingIndicator.startAnimating()
//       self.present(alert, animated: true, completion: nil)
        
        
        
//        self.activityView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
//        self.activityView.center = self.tableView.center
//        self.activityView.backgroundColor = UIColor.white
//        self.activityView.layer.cornerRadius = 10
//        
//        self.activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        self.activityIndicatorView.startAnimating()
//        self.activityLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
//        self.activityLabel.text = "Adding Project..."
//        
//        self.activityView.addSubview(self.activityIndicatorView)
//        self.activityView.addSubview(self.activityLabel)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.projectIndexPathToDelete = indexPath
            self.confirmDelete()
        }
    }
    
    func confirmDelete(){
        let alert = UIAlertController(title: "Delete Project",
                                      message: "Are you sure you want to permanently delete project?",
                                      preferredStyle: .alert)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: self.handleDeleteProject)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.cancelDeleteProject)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:1.0 , y:1.0, width:self.view.bounds.size.width / 2.0, height:self.view.bounds.size.height / 2.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteProject(alertAction: UIAlertAction!) -> Void {
        do{
            if let indexPath = self.projectIndexPathToDelete {
                tableView.beginUpdates()
                
                try FileManager.default.removeItem(at: self.projectUrls[indexPath.item])
                self.projectUrls.remove(at: indexPath.item)
                tableView.deleteRows(at: [indexPath], with: .left)
                self.projectIndexPathToDelete = nil
                
                tableView.endUpdates()
            }
        }catch{
            print(error)
        }
    }
    
    func cancelDeleteProject(alertAction: UIAlertAction!) {
        self.projectIndexPathToDelete = nil
    }
}
