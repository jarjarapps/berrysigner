
//  ProjectCreateViewController.swift
//  berrysigner
//
//  Created by Maciej Gibas on 1/7/17.
//  Copyright © 2017 Maciej Gibas. All rights reserved.
//

import UIKit

class ProjectCreateViewController: UIViewController {

    @IBOutlet weak var name: UITextField! = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createProject(_ sender: Any) {
        
        let documentsUrl = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
        
        
//        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
//        
//        if FileManager.default.fileExists(atPath: documentDirectoryPath!){
//            do {
//                try FileManager.default.createDirectory(atPath: documentDirectoryPath!, withIntermediateDirectories: false, attributes: nil)
//                
//            } catch let createDirectoryError as NSError {
//                print("Error with creating directory at path: \(createDirectoryError.localizedDescription)")
//            }
//            
//        }
//        
//        
//        
        
        var fileName = "Project\(Date.timeIntervalSinceReferenceDate).berryproj"
        
        var documentUrl = documentsUrl?.appendingPathComponent(fileName)
        let project = Project(fileURL: documentUrl!, name: "newProject")
         project.save(to: documentUrl!,
                      for: UIDocumentSaveOperation.forCreating) { (Bool) in
                        print("saved")
                        
        }
//        project.name = name.text
//        
//        let fileWrapper = FileWrapper(url: url!, options: FileWrapper.ReadingOptions.immediate)
//        fileWrapper.
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
