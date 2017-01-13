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
    var page: ProjectPage?
    
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
        self.page = ProjectPage(fileURL: self.pageUrl, name:nil)
        self.page?.open { (success) in
            self.navigationItem.title = self.page?.name
        }
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
