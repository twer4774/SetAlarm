//
//  SetAlarmTableViewController.swift
//  SetAlarm
//
//  Created by WonIk on 2018. 10. 4..
//  Copyright © 2018년 Walter. All rights reserved.
//

import UIKit


class SetAlarmTableViewController: UITableViewController{
   
    var swIsOn = true
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var alarmname = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
        print(self.appDelegate.setalarmlist.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        // #warning Incomplete implementation, return the number of rows
        let count = self.appDelegate.setalarmlist.count
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.appDelegate.setalarmlist[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetAlarmCell", for: indexPath) as! SetAlarmCell
        
        cell.lbSetAlarmName?.text = row.title
        cell.swSet.isOn = row.swIs
        
        
        // Configure the cell...
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let ud = UserDefaults.standard
        let row = self.appDelegate.setalarmlist[indexPath.row]
        
        //셀을 누르면 setalarmlist에 alarmIdx, title, swIs 값 저장
        row.alarmIdx = indexPath.row
        print("Index: \(row.alarmIdx)")
        alarmname = row.title!
        ud.set(swIsOn, forKey: "sw\(alarmname)")
        row.swIs = swIsOn
        print("sw: \(row.swIs)")
        
        //Userdefaults로 스위치 값을 sw알람이름 으로 저장
        print(ud.string(forKey: "sw\(alarmname)"))
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Alarms") as? AlarmsTableViewController else{
            return
        }
        //이 방법으로 값을 넘기면 userdefault를 안써도 되지 않을까? 알람 추가를 만든 뒤 생각하기
//        vc.swIsOn = swIsOn
        vc.alarmname = alarmname
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

   
   
 
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier{
        case Id.addSetAlarmIdentifier:
            let addSet = segue.destination as! AddSetAlarmViewController
        default:
//            let alarmVC = segue.destination as! AlarmsTableViewController
//            alarmVC.alarmname = alarmname
            break
        }
        
        
        
    }
    

}
