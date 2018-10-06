//
//  AddSetAlarmViewController.swift
//  SetAlarm
//
//  Created by WonIk on 2018. 10. 6..
//  Copyright © 2018년 Walter. All rights reserved.
//

import UIKit

class AddSetAlarmViewController: UIViewController {
    @IBOutlet var addTextField: UITextField!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        let data = SetAlarmModel()
        data.title = self.addTextField.text!
        appdelegate.setalarmlist.append(data)
        _ = navigationController?.popViewController(animated: true)
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
