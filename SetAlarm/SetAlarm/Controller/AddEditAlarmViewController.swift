//
//  AddAlarmViewController.swift
//  SetAlarm
//
//  Created by WonIk on 2018. 10. 7..
//  Copyright © 2018년 Walter. All rights reserved.
//

import UIKit

class AddEditAlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var alarmname = ""
    var mode = ""
    var timeSelect = ""
    var ampm = ""
    
    var setIdx = 0
    var start = 0
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
//    var alarmsTable = AlarmTableModel()
    
    let ud = UserDefaults.standard
    var setalarmlist = [[AlarmSetModel]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(mode)
        navigationItem.title = "\(alarmname) \(mode)"
        print("Add인덱스 확인: \(setIdx)")
        print("넘어온 start값: \(start)")
        // Do any additional setup after loading the view.
        if let data = ud.data(forKey: "setlist"){
            let list = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[AlarmSetModel]]
            self.setalarmlist = list!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if let data = ud.data(forKey: "setlist"){
//            let list = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[AlarmSetModel]]
//            self.setalarmlist = list!
//        }
    }
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        let picker = sender
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        timeSelect = formatter.string(from: picker.date)
        print(timeSelect)
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "aa"
        ampm = formatter2.string(from: picker.date)
        
        if ampm == "AM"{
            ampm = "오전"
        } else{
            ampm = "오후"
        }
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
   
    
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        
        //알람 저장
        var data = AlarmsModel(mainTime: self.timeSelect, ampm: self.ampm)
        self.setalarmlist[setIdx][0].setAlarms?.append(data)
        
        
//        self.setalarmlist[setIdx][0].setAlarms?.sorted(by: { (a,b) -> Bool in
//            if a.ampm == "오후"{
//                print(Int(a.mainTime) + 12)
//            }
//        })
        
//        sortAlarm(alarms: self.setalarmlist[setIdx][0].setAlarms!)
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.setalarmlist)
        print("encodedData \(encodedData)")
        ud.set(encodedData, forKey: "setlist")
        
        if self.setalarmlist[setIdx][0].swIs == true{
            let setalarm = SetAlarmTableViewController()
            setalarm.setalarmlist = self.setalarmlist
            setalarm.localNotification(index: setIdx)
            
        }
        self.navigationController?.popViewController(animated: true)
    }
 /*
    //정렬
    func sortAlarm(alarms: [AlarmsModel]){
        var sortedAlarm = [AlarmsModel]()
        for str in alarms{
            let strTime = str.mainTime?.components(separatedBy: ":")
            let strAP = str.ampm
            print("ampm\(strAP)")
            
            if strAP == "오후"{
                strTime[0]
            }
            

        }
        self.setalarmlist[setIdx][0].setAlarms = sortedAlarm
    }
 */
 
    func numberOfSections(in tableView: UITableView) -> Int {
        if mode == "추가"{
            return 1
        } else {
            return 2
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addEditCell") as! AddEditCell
        if indexPath.section == 0{
            switch indexPath.row{
            case 0:
                cell.textLabel?.text = "사운드"
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                
            case 1:
                cell.textLabel?.text = "알람이름"
                cell.accessoryType = .disclosureIndicator
            default:
                break
            }
        }else if indexPath.section == 1{
            cell.textLabel?.text = "삭제"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
        }
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
//         let vc = storyboard?.instantiateViewController(withIdentifier: "Alarms") as! AlarmsTableViewController
//        vc.start = self.start
//
//        let vc2 = storyboard?.instantiateViewController(withIdentifier: "SetAlarms") as! SetAlarmTableViewController
//        vc2.start = self.start
//
        
//        let alarmController = segue.destination as! AlarmsTableViewController
//        if segue.identifier == "AlarmAddedSegue"{
//            alarmController.start = self.start
//            navigationController?.popViewController(animated: true)
//        }
//
        
    }
    */
}
