//
//  MediaTableViewController.swift
//  SetAlarm
//
//  Created by WonIk on 2018. 10. 26..
//  Copyright © 2018년 Walter. All rights reserved.
//

import UIKit
import AVFoundation


class MediaTableViewController: UITableViewController {

    let numberOfRingtones = 2
    var mediaLabel:[String]? = ["기본음", "자전거 패달소리", "바람빠지는 소리", "나무치는 소리", "시계 알림음", "쇠 치는 소리", "디지털 시계음", "경적소리", "구슬 굴러가는 소리", "떨어지는 소리", "징글벨", "디너 벨", "경고음", "드럼치기"]
    
    var mediaID: String! //선택한 노래 저장하는 용도
    
    
    //URL을 쓰는 이유는 audiFile에서 오디오 재생을 할때 URL로 접근하기 때문
    var mediaURL: [URL]? = [Bundle.main.url(forResource: "Bell", withExtension: "mp3")!, Bundle.main.url(forResource: "Bicycle_Pedaling", withExtension: "mp3")!, Bundle.main.url(forResource: "Siren_Whistle", withExtension: "mp3")!, Bundle.main.url(forResource: "Hitting_a_Woodblock", withExtension: "mp3")!, Bundle.main.url(forResource: "Mechanical_Clock_Ring", withExtension: "mp3")!, Bundle.main.url(forResource: "Metal_Strike", withExtension: "mp3")!, Bundle.main.url(forResource: "Digital_Watch_Alarm_Long", withExtension: "mp3")!, Bundle.main.url(forResource: "Clown_Horn", withExtension: "mp3")!, Bundle.main.url(forResource: "Cowbell_Ringing", withExtension: "mp3")!, Bundle.main.url(forResource: "Falling_whistle", withExtension: "mp3")!, Bundle.main.url(forResource: "Jingle_Bells", withExtension: "mp3")!, Bundle.main.url(forResource: "Dinner_Bell_Triangle", withExtension: "mp3")!, Bundle.main.url(forResource: "Spaceship_Alarm", withExtension: "mp3")!, Bundle.main.url(forResource: "Crash_Layer_Drumset", withExtension: "mp3")!]
 
    
    var audioPlayer: AVAudioPlayer!
    var audioFile: URL!
    
    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioFile = mediaURL?[0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor =  UIColor.gray
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .left
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if mediaLabel == nil {
            return 1
        } else {
            return (mediaLabel?.count)!
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        return "알람음 선택"
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath)
        cell.textLabel?.text = mediaLabel?[indexPath.row]
//        if (mediaURL?.count)! != 1{
//            if (mediaURL?.count)! == indexPath.row+1{
//                cell.accessoryType = .checkmark
//            } else {
//                cell.accessoryType = .none
//            }
//        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        cell?.setSelected(true, animated: true)
        cell?.setSelected(false, animated: true)
        
        do{
            audioFile = mediaURL?[indexPath.row]
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError{
            print("Error-initPlay: \(error)")
        }
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 2.0
        
        self.mediaID = mediaLabel?[indexPath.row]
        ud.set(mediaID, forKey: "mediaID")
        ud.set(mediaURL?[indexPath.row], forKey: "selectMusic")
        
        audioPlayer.play()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
       
        audioPlayer.stop()
        cell?.accessoryType = .none
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
    }
    */

}

extension MediaTableViewController: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
    }
}
