//
//  MediaTableViewController.swift
//  SetAlarm
//
//  Created by WonIk on 2018. 10. 26..
//  Copyright © 2018년 Walter. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation


class MediaTableViewController: UITableViewController {

    let numberOfRingtones = 2
    let mediaPicker = MPMediaPickerController(mediaTypes: .music)
    var mediaItem: MPMediaItem?
    var mediaLabel:[String]? = ["기본음"]
    
    var mediaID: String! //선택한 노래 저장하는 용도
    
    var mediaURL: [URL]? = [Bundle.main.url(forResource: "bell", withExtension: "mp3")!]
    
    var audioPlayer: AVAudioPlayer!
    var audioFile: URL!
    
    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioFile = mediaURL?[0]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       tableView.reloadData()
        if let data = ud.data(forKey: "mediaURL"){
            let decoded = NSKeyedUnarchiver.unarchiveObject(with: data) as? [URL]
            self.mediaURL = decoded!
            print("mediaURL: \(self.mediaURL)")
        }
        if let mediaLabel = ud.array(forKey: "mediaLabel"){
            self.mediaLabel = mediaLabel as! [String]
        }
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1
        } else{
            if mediaLabel == nil {
                return 1
            } else {
                return (mediaLabel?.count)!
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "알람음 선택"
        } else{
            return "노래"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath)
     
        if indexPath.section == 0{
            if indexPath.row == 0{
                cell.textLabel!.text = "노래 선택"
                cell.accessoryType = .disclosureIndicator
            }
        } else {
            cell.textLabel?.text = mediaLabel?[indexPath.row]
            if (mediaURL?.count)! != 1{
                if (mediaURL?.count)! == indexPath.row+1{
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mediaPicker = MPMediaPickerController(mediaTypes: .anyAudio)
        
        
        mediaPicker.delegate = self
        mediaPicker.prompt = "노래 선택!"
        mediaPicker.allowsPickingMultipleItems = false
        
        
        if indexPath.section == 0{
            if indexPath.row == 0{
                self.present(mediaPicker, animated: true, completion: nil)
            }
        } else if indexPath.section == 1{
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
            
            self.mediaID = mediaLabel?[indexPath.row]
            
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 2.0
            
            audioPlayer.play()
        }
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

extension MediaTableViewController: MPMediaPickerControllerDelegate{
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
//
//        if !mediaItemCollection.items.isEmpty{
//            let aMediaItem = mediaItemCollection.items[0]
//
//            self.mediaItem = aMediaItem
//            mediaID = self.mediaItem?.value(forProperty: MPMediaItemPropertyPersistentID) as! String
//
//
//        }
        let mc = mediaItemCollection.items[0]
        print("타이틀: \(mc.value(forProperty: MPMediaItemPropertyTitle) as! String)")
        mediaLabel?.append(mc.value(forProperty: MPMediaItemPropertyTitle) as! String)
        mediaURL?.append(mc.value(forProperty: MPMediaItemPropertyAssetURL) as! URL)
        audioFile = mc.value(forProperty: MPMediaItemPropertyAssetURL) as! URL

        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError{
            print("Error-initPlay: \(error)")
        }
       
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 2.0

        audioPlayer.play()
        
        tableView.reloadData()
        
        ud.set(self.mediaLabel, forKey: "mediaLabel")
        let encoded = NSKeyedArchiver.archivedData(withRootObject: mediaURL)
        print("\(encoded)")
        ud.set(encoded, forKey: "mediaURL")
        
        //mediaID도 저장
        mediaID = mc.value(forProperty: MPMediaItemPropertyTitle) as! String
        ud.set(mediaID, forKey: "mediaID")
        
        dismiss(animated: true, completion: nil)
      
    }
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MediaTableViewController: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
    }
}
