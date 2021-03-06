//
//  SetAlarmTableViewController.swift
//  SetAlarm
//
//  Created by WonIk on 2018. 10. 4..
//  Copyright © 2018년 Walter. All rights reserved.
//

import UIKit
import UserNotifications


class SetAlarmTableViewController: UITableViewController{
    
    var setIdx = 0
    var alarmname = ""
    var swIsOn = false
    
    let ud = UserDefaults.standard
    
    var setalarmlist = [[AlarmSetModel]]()
    
    var selectSound: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
//        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let data = ud.data(forKey: "setlist"){
            let list = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[AlarmSetModel]]
            
            self.setalarmlist = list!
        }
        
        print("SetAalrm 갯수: \(self.setalarmlist.count)")
/*
        //주의사항 코드 추가해야됨 맨처음 앱 실행하면 저게 없거덩
        if let selectMusic = ud.url(forKey: "selectMusic"){
//            self.selectMusic = selectMusic
//            print("selectMusic: \(selectMusic)")
            let strMusic = "\(selectMusic)"
            let sepaMusic = strMusic.components(separatedBy: "/")
            self.selectSound = sepaMusic.last!
//            let strMusic = selectMusic as! String
//            let sepa = strMusic.components(separatedBy: "/")
//            print("제발:\(sepa.last)")
        }
*/
        
        self.tableView.reloadData()
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SetAlarmCell", for: indexPath) as! SetAlarmCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetAlarmCell") as! UITableViewCell
        let row = self.setalarmlist[indexPath.row]
        

        cell.textLabel?.font = UIFont.init(name:"Helvetica", size: 30)
        cell.textLabel?.text = row[0].title
       
        var btnSwitch = UISwitch()
        btnSwitch.isOn = row[0].swIs!
        btnSwitch.tag = indexPath.row
//        btnSwitch.setOn(true, animated: false)
        btnSwitch.addTarget(self, action: #selector(switchChangedValue(sender: )), for: .valueChanged)
        cell.accessoryView = btnSwitch
        
        
        
        return cell
    }
    func saveSwitchStatus(index: Int){
        self.setalarmlist[index][0].swIs = self.swIsOn
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.setalarmlist)
        print("encodedData \(encodedData)")
        ud.set(encodedData, forKey: "setlist")
    }
    @objc func switchChangedValue(sender: UISwitch!){
        if sender.isOn{
            swIsOn = true
            print("on")
            print(sender.tag)
            localNotification(index: sender.tag)
//            saveSwitchStatus(index: sender.tag)
        } else {
            swIsOn = false
            print("off")
            //알람 제거
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            offLocoalNotification(index: sender.tag)
//            saveSwitchStatus(index: sender.tag)
        }
        saveSwitchStatus(index: sender.tag)
       
    }
    func localNotification(index: Int){
        
        //push 알람 객체 생성
        let center = UNUserNotificationCenter.current()
        if #available(iOS 12.0, *) {
            let options: UNAuthorizationOptions = [.alert, .sound, .badge, .criticalAlert]
            center.requestAuthorization(options: options) { (didAllow, error) in
            }
        } else {
            // Fallback on earlier versions
            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
            center.requestAuthorization(options: options) { (didAllow, error) in
            }
        }
        
        //알람 등록
//        center.requestAuthorization(options: options) { (didAllow, error) in
//
//        }
        
        let localContent = UNMutableNotificationContent()
        let setalarm = self.setalarmlist[index][0]
        localContent.title = setalarm.title!
//        localContent.sound = UNNotificationSound(named: "Bell.mp3")
//        localContent.sound = UNNotificationSound(named: "\(selectMusic)")
//        localContent.sound = UNNotificationSound(named: "\(self.selectSound!)")
        
        
      
//        if let selectMusic = self.selectMusic{
//            let sound = NSURL(fileURLWithPath: "\(selectMusic)")
//            print("sound: \(sound)")
//        }
 
        //발송 조건 정의
        let alarmcount = self.setalarmlist[index][0].setAlarms?.count as! Int
        print("알람갯수: \(alarmcount)")
        for i in 0 ..< alarmcount{

            if let str = self.setalarmlist[index][0].setAlarms?[i]{
                let strTime = str.mainTime?.components(separatedBy: ":")
                let strAP = str.ampm
                
                let selectSound = "\(str.sound)".components(separatedBy: "/")
                let strSound = selectSound.last!.trimmingCharacters(in: [")"])
                print("strSound: \(strSound)")
//                localContent.sound = UNNotificationSound(named: "\(strSound)")
                if #available(iOS 12.0, *) {
                    localContent.sound = UNNotificationSound.criticalSoundNamed("\(strSound)", withAudioVolume: 1.0)
                    
                } else {
                    // Fallback on earlier versions
                    localContent.sound = UNNotificationSound(named: "\(strSound)")

                }
                print("ampm\(strAP)")

                var newDate = DateComponents()
                //오전 12시는 00시, 오후 12시는 12시
                if strAP == "오후" && Int((strTime?[0])!)! != 12{
                    newDate.hour = Int((strTime?[0])!)! + 12
                    print(newDate.hour)
                } else if strAP == "오전" && Int((strTime?[0])!)! == 12{
//                    newDate.hour = Int((strTime?[0])!)! - 12
                    newDate.hour = 00
                    print(newDate.hour)
                } else if strAP == "오전" && Int((strTime?[0])!)! != 12{
                    newDate.hour = Int((strTime?[0])!)!
                    print(newDate.hour)
                } else if strAP == "오후" && Int((strTime?[0])!)! == 12{
                    newDate.hour = Int((strTime?[0])!)!
                    print(newDate.hour)
                }
                
                newDate.minute = Int((strTime?[1])!)
                print(newDate.minute)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: newDate, repeats: true)
                localContent.body = "\(self.setalarmlist[index][0].setAlarms?[i].mainTime as! String) 알람"
                let request = UNNotificationRequest(identifier: "\(index)\(strAP)\(self.setalarmlist[index][0].setAlarms?[i].mainTime)", content: localContent, trigger: trigger)
                
                //노티피케이션 센터에 추가
                UNUserNotificationCenter.current().add(request){
                    (_) in
                }
            }
        }
    }
    
    //알람 끄기
    func offLocoalNotification(index: Int){
        let alarmcount = self.setalarmlist[index][0].setAlarms?.count as! Int
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests{
                for i in 0 ..< alarmcount{
                    if let str = self.setalarmlist[index][0].setAlarms?[i]{
                        let strTime = str.mainTime?.components(separatedBy: ":")
                        let strAP = str.ampm
                        print("ampm\(strAP)")
                    if notification.identifier == "\(index)\(strAP)\(self.setalarmlist[index][0].setAlarms?[i].mainTime)"{
                        identifiers.append(notification.identifier)
                        }
                    }
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("setAlarmDidselect \(indexPath.row)")

        
        self.setIdx = indexPath.row
        
        
        alarmname = self.setalarmlist[indexPath.row][0].title!
        self.setalarmlist[indexPath.row][0].swIs = self.swIsOn
        let encode = NSKeyedArchiver.archivedData(withRootObject: self.setalarmlist)
        ud.set(encode, forKey:"setlist")
        print("switch \(swIsOn)")
        
        
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
            offLocoalNotification(index: indexPath.row)
            self.setalarmlist.remove(at: indexPath.row)
            let encoded = NSKeyedArchiver.archivedData(withRootObject: self.setalarmlist)
            
            ud.set(encoded , forKey: "setlist")
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    //Delete를 한글로 변경
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
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
            vc.swIsOn = swIsOn
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
