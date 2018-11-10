//
//  AlarmModel.swift
//  SetAlarm
//
//  Created by WonIk on 2018. 10. 4..
//  Copyright © 2018년 Walter. All rights reserved.
//

import Foundation

class AlarmSetModel: NSObject, NSCoding{
   
    
    var title: String?
    var setIdx: Int?
    var swIs: Bool?
    var setAlarms: [AlarmsModel]?
    
    init(title: String, setIdx: Int, swIs:Bool){
        self.title = title
        self.setIdx = setIdx
        self.swIs = swIs
    }
    
    init(title: String, setIdx: Int, swIs:Bool, setAlarms: [AlarmsModel]){
        self.title = title
        self.setIdx = setIdx
        self.swIs = swIs
        self.setAlarms = setAlarms
    }
    
    init(setAlarms: [AlarmsModel]){
        self.setAlarms = setAlarms
    }
    
    //MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as? String
        setIdx = aDecoder.decodeObject(forKey: "setIdx") as? Int
        swIs = aDecoder.decodeObject(forKey: "swIs") as? Bool
        setAlarms = aDecoder.decodeObject(forKey: "alarms") as? [AlarmsModel]
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.setIdx, forKey: "setIdx")
        aCoder.encode(self.swIs, forKey: "swIs")
        aCoder.encode(self.setAlarms, forKey: "alarms")
    }
    
}

struct AlarmTableModel{
    var alarms: [[AlarmsModel]] = [[]] //2차원배열로 선언
    
    
    var count: Int {
        return alarms.count
    }
}

class AlarmsModel: NSObject, NSCoding{

    var mainTime: String?
    var ampm: String?
    var sound: URL?
    
    
    init (mainTime: String, ampm: String, sound: URL?){
        self.mainTime = mainTime
        self.ampm = ampm
        self.sound = sound
    }
    //MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        mainTime = aDecoder.decodeObject(forKey: "mainTime") as? String
        ampm = aDecoder.decodeObject(forKey: "ampm") as? String
        sound = aDecoder.decodeObject(forKey: "sound") as? URL
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.mainTime, forKey: "mainTime")
        aCoder.encode(self.ampm, forKey: "ampm")
        aCoder.encode(self.sound, forKey: "sound")
    }
}



