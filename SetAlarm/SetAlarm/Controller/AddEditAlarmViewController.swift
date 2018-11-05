//
//  AddAlarmViewController.swift
//  SetAlarm
//
//  Created by WonIk on 2018. 10. 7..
//  Copyright © 2018년 Walter. All rights reserved.
//

import UIKit
import MediaPlayer

class AddEditAlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var alarmname = ""
    var mode = ""
    var timeSelect = ""
    var ampm = ""
    
    var setIdx = 0
    var start = 0
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    let ud = UserDefaults.standard
    var setalarmlist = [[AlarmSetModel]]()
    
//    let segueInfo: SegueInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(mode)
        navigationItem.title = "\(alarmname) \(mode)"
        print("Add인덱스 확인: \(setIdx)")
        print("넘어온 start값: \(start)")
        print("모드 확인: \(mode)")
        // Do any additional setup after loading the view.
        if let data = ud.data(forKey: "setlist"){
            let list = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[AlarmSetModel]]
            self.setalarmlist = list!
        }
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
 
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
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addEditCell") as! AddEditCell
        if indexPath.section == 0{
            switch indexPath.row{
            case 0:
                cell.textLabel?.text = "사운드"
//                cell.detailTextLabel?.text = segueInfo.mediaLabel
                
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.section == 0{
            switch indexPath.row{
            case 0:
                print("사운드 선택")
                self.performSegue(withIdentifier: "MediaSoundSegue", sender: self)
                cell?.setSelected(true, animated: false)
                cell?.setSelected(false, animated: false)
            case 1:
                print("알람 이름선택")
                cell?.setSelected(true, animated: false)
                cell?.setSelected(false, animated: false)
            default:
                break
//                let cell = tableView.cellForRow(at: indexPath)
//                cell?.accessoryType = .checkmark
//                mediaLabel = cell?.textLabel?.text!
//                cell?.setSelected(true, animated: true)
//                cell?.setSelected(false, animated: true)
//                let cells = tableView.visibleCells
//                for c in cells{
//                    let section = tableView.indexPath(for: c)?.section
//                    if(section == indexPath.section && c != cell){
//                        c.accessoryType = .none
//                    }
//                }
            }
            //삭제 액션 고민  - 할까말까
//            esle if indexPath.section == 1{
//
//            }
        }
    }


    
    // MARK: - Navigation

 /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        switch segue.identifier {
        case Id.mediaSoundIdentifier:
        let dist = segue.destination as! MediaTableViewController
        dist.mediaID = SegueInfo.mediaID
        dist.mediaLabel = SegueInfo.mediaLabel
        default:
            break
        }
    }
*/

    /* 스토리보드에서 Exit로 연결하는 메뉴얼 세그웨이 */ 
    @IBAction func unwindFromMediaView(_ segue: UIStoryboardSegue) {
        let src = segue.source as! MediaTableViewController
//        segueInfo.mediaLabel = src.mediaLabel
//        segueInfo.mediaID = src.mediaID
        
    }
 
}


