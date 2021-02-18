//
//  ViewController.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 18.02.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func buttonTap(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(identifier: "First") {
            //let vc = FirstTableViewController()
            //self.navigationController?.show(vc, sender: self)
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
}

