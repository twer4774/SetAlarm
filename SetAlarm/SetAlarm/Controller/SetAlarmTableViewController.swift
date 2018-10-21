//
//  SetAlarmTableViewController.swift
//  SetAlarm
//
//  Created by WonIk on 2018. 10. 4..
//  Copyright © 2018년 Walter. All rights reserved.
//

import UIKit


class SetAlarmTableViewController: UITableViewController{
    
    var setIdx = 0
    var alarmname = ""
    var swIsOn = true
    
    let ud = UserDefaults.standard
    
    var setalarmlist = [[AlarmSetModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let data = ud.data(forKey: "setlist"){
            let list = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[AlarmSetModel]]
            
            self.setalarmlist = list!
        }
        
        print("SetAalrm 갯수: \(self.setalarmlist.count)")
        
        self.tableView.reloadData()
    }
    
  
   
    //IBAction
    @IBAction func chageSwitch(_ sender: UISwitch) {
        if sender.isOn{
            swIsOn = true
            print("on")
           
        } else {
            swIsOn = false
            print("off")
           
        }
        
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let count = self.setalarmlist.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetAlarmCell", for: indexPath) as! SetAlarmCell
        
        let row = self.setalarmlist[indexPath.row]
        
        cell.lbSetAlarmName.text = row[0].title
        
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("setAlarmDidselect \(indexPath.row)")

        
        setIdx = indexPath.row
        
        
        alarmname = self.setalarmlist[indexPath.row][0].title!
        
        
        
/* 이 코드도 실행은 됨. storyboardID를 가지고 전달하기
        let vc = storyboard?.instantiateViewController(withIdentifier: "Alarms") as! AlarmsTableViewController
        vc.start = self.start
        vc.alarmname = self.alarmname
        vc.setIdx = self.setIdx
        self.navigationController?.pushViewController(vc, animated: true)

*/
        
        //prepare 동작 시키는 코드
        self.performSegue(withIdentifier: "AlarmsSegue", sender: self)
        
        //Userdefaults로 스위치 값을 sw알람이름 으로 저장
//        print(ud.string(forKey: "sw\(alarmname)"))
        
      
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    //아이템 삭제
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.setalarmlist.remove(at: indexPath.row)
            let encoded = NSKeyedArchiver.archivedData(withRootObject: self.setalarmlist)
            
            ud.set(encoded , forKey: "setlist")
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    


   
 
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
//        switch segue.identifier{
//        case Id.addSetAlarmIdentifier:
//            let addSet = segue.destination as! AddSetAlarmViewController
//        default:
//            let alarmVC = segue.destination as! AlarmsTableViewController
//            alarmVC.alarmname = alarmname
//            alarmVC.setIdx = self.setIdx
//        }

        let dest = segue.destination
        switch segue.identifier{
        case Id.addAlarmIdentifier:
            guard let vc = dest as? AddSetAlarmViewController else {
                return
            }
            
        case Id.alarmsIdentifier:
            guard let vc = dest as? AlarmsTableViewController else {
                return
            }
            vc.alarmname = self.alarmname
            vc.setIdx = setIdx
        default:
            break
        }
        /*
        let dest = segue.destination
        guard let vc = dest as? AlarmsTableViewController else {
            return
        }

        vc.start = self.start
        vc.alarmname = self.alarmname
        vc.setIdx = self.setIdx
    */
    }
 
    

}
