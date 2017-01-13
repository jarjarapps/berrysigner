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
    var project: Project?
    var pageUrls: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadPages()
    }

    @IBAction func addPage(_ sender: Any) {
        let fileName = "\(UUID().uuidString).page"
        let documentUrl = self.project?.pagesUrl.appendingPathComponent(fileName)
        let page = ProjectPage(fileURL: documentUrl!, name: "New Page")
        page.save(to: documentUrl!,
                  for: UIDocumentSaveOperation.forCreating) { (success) in
                    if(success){
                        self.performSegue(withIdentifier: "showPage", sender: page)
                    }
                    
        }
    }
    
    func loadPages(){
        self.project = Project(fileURL: self.projectUrl, name:nil)
        self.project?.open { (success) in
            do{
                self.navigationItem.title = self.project?.name
                try self.pageUrls = FileManager.default.contentsOfDirectory(at: (self.project?.pagesUrl)!, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles) as [URL]
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
        let page = ProjectPage(fileURL: url, name:nil)
        page.open { (success) in
            cell.textLabel?.text =  page.name
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
