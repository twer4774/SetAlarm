//
//  AlarmsTableViewController.swift
//  SetAlarm
//
//  Created by WonIk on 2018. 10. 4..
//  Copyright © 2018년 Walter. All rights reserved.
//

import UIKit

class AlarmsTableViewController: UITableViewController{
    
    var swIsOn = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var alarmname = ""
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
       print("알람 이름\(alarmname)")
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ud = UserDefaults.standard
//        let row = appDelegate.alarmslist[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        print("alarmtable: \(swIsOn)")
       
        cell.btnSwitch.isOn = swIsOn
        
        if ud.string(forKey: "sw\(alarmname)") == "0"{
            swIsOn = false
        } else {
            swIsOn = true
        }
        cell.btnSwitch.isOn = swIsOn

        // Configure the cell...

        return cell
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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let setAlarmViewController = segue.destination as! SetAlarmTableViewController
        //SetAlarm -> Alarms
//        setAlarmViewController.delegate = self
        setAlarmViewController.swIsOn = swIsOn
        
    }
    */
}
