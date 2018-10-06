//
//  AlarmModel.swift
//  SetAlarm
//
//  Created by WonIk on 2018. 10. 4..
//  Copyright © 2018년 Walter. All rights reserved.
//

import Foundation

class SetAlarmModel{
    var alarmIdx: Int? //데이터 식별 값
    var title: String? //알람이름
    var swIs: Bool? //스위치 상태
}

class AlarmsModel{
    var alarmsIdx: Int?
    var mainTime: String?
    var ampm: String?
    var swIs: Bool?
}

