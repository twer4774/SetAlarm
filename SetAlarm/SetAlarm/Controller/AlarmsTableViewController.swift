//
//  AlarmsTableViewController.swift
//  SetAlarm
//
//  Created by WonIk on 2018. 10. 4..
//  Copyright © 2018년 Walter. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmsTableViewController: UITableViewController{
    
    var swIsOn = true
    var alarmname = ""
    
    var setIdx = 0 //세트 인덱스
    
    let ud = UserDefaults.standard
    
    var setalarmlist = [[AlarmSetModel]]()
    
    @IBOutlet var btnAdd: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        print("세트 인덱스 \(setIdx)")
        
        navigationItem.title = alarmname
        
       tableView.allowsSelectionDuringEditing = true
        
        print("넘어온 스위치 값은?\(swIsOn)")
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let data = ud.data(forKey: "setlist"){
            let list = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[AlarmSetModel]]
            
            self.setalarmlist = list!
           
        }
        
        
        
        self.tableView.reloadData()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = self.setalarmlist[setIdx][0].setAlarms?.count
        return count!
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        
        if let row = self.setalarmlist[setIdx][0].setAlarms?[indexPath.row]{
            cell.mainTime.text = row.mainTime
            cell.ampm.text = row.ampm
            
        }
        
//        cell.btnSwitch.isOn = swIsOn
        
        // Configure the cell...

        return cell
    }
    
    @IBAction func btnModify(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = true
        self.btnAdd.title = "완료"
        
    }
   
    @IBAction func btnAdd(_ sender: UIBarButtonItem) {
        if self.tableView.isEditing == true{
            self.tableView.isEditing = false
            self.btnAdd.title = "추가"
        } else {
            self.performSegue(withIdentifier: "AddAlarmSegue", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing{
            
        }
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        return true
    }
    */
 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        var identfierName = self.setalarmlist[self.setIdx][0].setAlarms?[indexPath.row].mainTime
        if editingStyle == .delete {
           //  Delete the row from the data source
            //알람 해제 코드도 필요함
            /*
             SetAlarm에서와 다름 주의: 여기서는 for문을 하나만 쓰면서 identifier를 찾아야함
             identifierName을 주는 이유는 'self.setalarmlist[self.setIdx][0].setAlarms?[indexPath.row].mainTime'을 그대로 넣을 경우. 삭제 액션이 수행된 후의 setalarmlist값이 들어가기 때문에 indexPath.row의 값으로 가져오면 삭제된 알람 뒤의 알람이 꺼져버린다.
             그래서 identifierName으로 삭제되기 전의 알람 이름을 가져오기로 했다.
             */
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationrReqeusts) in
                var identifier:[String] = []
                for notification:UNNotificationRequest in notificationrReqeusts{
                    if notification.identifier == "\(identfierName)"{
                        print("저장되기전 idnefitiferName:\(identfierName)")
                        identifier.append(notification.identifier)
                        }
                    }
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifier)
                
            }
            
            self.setalarmlist[self.setIdx][0].setAlarms?.remove(at: indexPath.row)
            
            let encoded = NSKeyedArchiver.archivedData(withRootObject: self.setalarmlist)
            self.ud.set(encoded , forKey: "setlist")
            tableView.deleteRows(at: [indexPath], with: .fade)
           
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }

    }
    
   
    //Delete를 한글로 변경
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
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

    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addEditController = segue.destination as! AddEditAlarmViewController
        if segue.identifier == "AddAlarmSegue"{
            addEditController.mode = "추가"
            addEditController.alarmname = self.alarmname
            addEditController.setIdx = self.setIdx
            
        } else if segue.identifier == "EditAlarmSegue" {
            addEditController.mode = "수정"
            addEditController.alarmname = self.alarmname
            addEditController.setIdx = self.setIdx
        }
        
        //참고코드
        /*
        if segue.identifier == "sgDetail"{
            let cell = sender as! UITableViewCell
            let indexPath = self.tvListView.indexPath(for: cell)
            let detailView = segue.destination as! DetailViewController
            detailView.receiveItem(items[(indexPath?.row)!])
            
        }
    */
    }
   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let dist = segue.destination as! UINavigationController
        let addEditController = dist.topViewController as! AddEditAlarmViewController
        switch segue.identifier{
        case Id.addAlarmIdentifier:
            addEditController.navigationItem.title = "알람 추가"
            addEditController.segueInfo = SegueInfo(curCellindex: alarmsModel.count, isEditMode: false, weekday: [], mediaLabel: "사운드", mediaID: "")
        case Id.editAlarmIdentifier:
            addEditController.navigationItem.title = "알람 수정"
            addEditController.segueInfo = SegueInfo(curCellindex: alarmsModel.count, isEditMode: true, weekday: [], mediaLabel: "사운드", mediaID: "")
            addEditController.segueInfo = sender as! SegueInfo
        default:
            break
        }
        
    }
    */
}
