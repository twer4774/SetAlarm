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

/* 일단 없애
struct SetAlarmModel{
    var setIdx: Int? //데이터 식별 값
    var title: String? //알람이름 구분자 역할도 해보자
    var swIs: Bool = true //스위치 상태
//    init(setIdx: Int?, title: String?) {
//        self.setIdx = setIdx
//        self.title = title
//        self.swIs = true
//    }
//
//    //NSCoder
//    required convenience init(coder decoder: NSCoder){
//        guard let setIdx = decoder.decodeObject(forKey: "setIdx") as? Int,
//            let title = decoder.decodeObject(forKey: "title") as? String else{
//                return nil
//        }
//        self.init(setIdx: setIdx, title: title)
//
//    func encodeWithCoder(coder: NSCoder){
//        coder.encode(self.setIdx, forKey: "setIdx")
//        coder.encode(self.title, forKey: "title")
//    }
}

*/
struct AlarmTableModel{
    var alarms: [[AlarmsModel]] = [[]] //2차원배열로 선언
    
    
    var count: Int {
        return alarms.count
    }
}

class AlarmsModel: NSObject, NSCoding{

    var mainTime: String?
    var ampm: String?
//    var swIs: Bool = true
    
    
    init (mainTime: String, ampm: String){
        self.mainTime = mainTime
        self.ampm = ampm
    }
    //MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        mainTime = aDecoder.decodeObject(forKey: "mainTime") as? String
        ampm = aDecoder.decodeObject(forKey: "ampm") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.mainTime, forKey: "mainTime")
        aCoder.encode(self.ampm, forKey: "ampm")
    }
}



