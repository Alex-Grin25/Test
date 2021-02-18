//
//  ViewController.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 18.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func buttonTap(_ sender: Any) {
        let login = loginTextField.text
        let password = passwordTextField.text
        
        var authorized = false
        for data in authData {
            if (data.login == login && data.password == password) {
                authorized = true
                break
            }
        }
        if authorized {
            if let vc = self.storyboard?.instantiateViewController(identifier: "Main") {
                //let vc = FirstTableViewController()
                //self.navigationController?.show(vc, sender: self)
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.navigationController?.setViewControllers([vc], animated: true)
            }
        }
        else {
            errorLabel.isHidden = false
        }
    }
}

