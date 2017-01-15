//
//  ActivityAlertViewController.swift
//  berrysigner
//
//  Created by Maciej Gibas on 1/14/17.
//  Copyright © 2017 Maciej Gibas. All rights reserved.
//

import UIKit

class ActivityAlertViewController: UIViewController {
    
    private var alert:UIAlertController?
    private var controller: UIViewController!
    
    init(forController controller: UIViewController){
        super.init(nibName: nil, bundle: nil)
        self.controller = controller
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func show(withTitle title:String){
        self.alert = UIAlertController(title: title ,message: nil, preferredStyle: .alert)
        self.controller.present(self.alert!, animated: true, completion: nil)
    }
    
    func dismiss(){
        self.alert?.dismiss(animated: true, completion: nil)
    }
}
