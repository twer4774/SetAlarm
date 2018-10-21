//
//  AddSetAlarmViewController.swift
//  SetAlarm
//
//  Created by WonIk on 2018. 10. 6..
//  Copyright © 2018년 Walter. All rights reserved.
//

import UIKit

class AddSetAlarmViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var addTextField: UITextField!
    
    let ud = UserDefaults.standard
    
    var setIdx = 0
    
    var setalarmlist = [[AlarmSetModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTextField.becomeFirstResponder() //First Responder로 등록
        addTextField.delegate = self //델리게이트 설정
        
        if let data = ud.data(forKey: "setlist"){
            let list = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[AlarmSetModel]]
           
            self.setalarmlist = list!
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.isEqual(self.addTextField)){
            textFieldDidEndEditing(self.addTextField)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder() //First Responder 해제
    }
    
    
    
    
    @IBAction func addAction(_ sender: UIButton) {
        
        /*
         let data = AlarmSetModel(title: self.addTextField.text!, setIdx: 1, swIs: true)
         let encodedData = NSKeyedArchiver.archivedData(withRootObject: data)
         ud.set(encodedData, forKey: "setalarmlist")
         print(encodedData)
         print(ud.data(forKey: "setalarmlist"))
         */
        
        
        let data = [AlarmSetModel(title: addTextField!.text!, setIdx: setIdx, swIs: true, setAlarms: [])]
        self.setalarmlist.append(data)
        
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.setalarmlist)
        print("encodedData \(encodedData)")
        ud.set(encodedData, forKey: "setlist")
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //        let setalarmcontroller = segue.destination as! SetAlarmTableViewController
        //        setalarmcontroller.alarmname = self.addTextField.text!
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}
