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

        /*
        var data = AlarmsModel()
        
//        data.setIdx = setIdx
//        data.alarmName = alarmname
        data.mainTime = timeSelect
        data.ampm = ampm
        
        //초기리스트가 빈값이라면 [data]로 넣어 추가하고, 빈 값이 아니라면 [setIdx]에 append한다.
        
        if start == 0 {
//        if appdelegate.alarms2dlist.isEmpty{
//            appdelegate.alarms2dlist.append([data])
            appdelegate.alarms2dlist[setIdx][0] = data
           
            
            start = 1
        } else {
            appdelegate.alarms2dlist[setIdx].append(data)
        }

//        if start == 0{
//            appdelegate.alarms2dlist[setIdx][0] = data
//        } else {
//            appdelegate.alarms2dlist[setIdx].append(data)
//        }
        print("add된 알람들 \(appdelegate.alarms2dlist)")
        print("ADD [0] \(appdelegate.alarms2dlist[0])")
        print("start: \(start)")
       
      
        */
        
        //알람 저장
        var data = AlarmsModel(mainTime: self.timeSelect, ampm: self.ampm)
        print("이거가 빈값?? \(self.setalarmlist[setIdx][0])") //이거가 빈값이라고??
        self.setalarmlist[setIdx][0].setAlarms?.append(data)
        
        
        print("data \(data)")
        print("setalarmlist \(self.setalarmlist[setIdx][0].setAlarms)")
        
//        self.setalarmlist[setIdx][0].setAlarms?.sorted(by: { (a,b) -> Bool in
//            if a.ampm == "오후"{
//                print(Int(a.mainTime) + 12)
//            }
//        })
        
      
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.setalarmlist)
        print("encodedData \(encodedData)")
        ud.set(encodedData, forKey: "setlist")
        
//       navigationController?.pushViewController(vc, animated: true)
 
        self.navigationController?.popViewController(animated: true)
    }
 
 
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
