//
//  TestViewController.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 18.03.2021.
//

import UIKit

class TestViewController: UIViewController {

    var x = 0;
    var a: () -> Void = {}
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTap(_ sender: Any) {
        a = {
            while (self.x < 100000000) {
                self.x = self.x + 1;
                if (self.x % 10000 == 0) {
                    DispatchQueue.main.async {
                        self.textLabel.text = "\(self.x / 100000)"
                    }
                }
            }
            self.x = 0;
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.a()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
