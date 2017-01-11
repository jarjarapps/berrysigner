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
    private var activityView: UIView!
    private var activityIndicatorView: UIActivityIndicatorView!
    private var activityLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        createActivityIndicator()
        
        
        self.documentsUrl = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last! as URL
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadProjects()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projectUrls.count
    }
    
    @IBAction func createProject(_ sender: Any) {
        self.view.addSubview(activityView)
        let fileName = "\(UUID().uuidString).berryproj"
        let documentUrl = documentsUrl?.appendingPathComponent(fileName)
        let project = Project(fileURL: documentUrl!, name: "New Project")
        project.save(to: documentUrl!,
                     for: UIDocumentSaveOperation.forCreating) { (success) in
                        if(success){
                            self.performSegue(withIdentifier: "showProject", sender: project)
                        }
                        self.activityView.removeFromSuperview()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ProjectDetailsCollectionViewController
        
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
        let project = Project(fileURL: url, name:nil)
        project.open { (success) in
            cell.textLabel?.text =  project.name
        }
        
        return cell
     }
    
    private func createActivityIndicator(){
        self.activityView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        self.activityView.center = CGPoint(x: self.view.bounds.size.width  / 2, y:self.view.bounds.size.height / 2)
        self.activityView.backgroundColor = UIColor.white
        self.activityView.layer.cornerRadius = 10
        
        self.activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.activityIndicatorView.color = UIColor.black
        self.activityIndicatorView.hidesWhenStopped = false
        
        
        self.activityLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        self.activityLabel.text = "Adding Project..."
        
        self.activityView.addSubview(self.activityIndicatorView)
        self.activityView.addSubview(self.activityLabel)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
