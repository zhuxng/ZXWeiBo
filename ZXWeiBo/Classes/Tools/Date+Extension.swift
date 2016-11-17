//
//  Date+Extension.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/17.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

extension Date {
    /// 格式化时间的方法
    static func createDate(_ timeStr: String, _ formatterStr: String) -> Date {
        //格式化时间
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        //指定区域
        formatter.locale = Locale(identifier: "en")
        //将拿到的时间格式化我们能看懂的时间
        return formatter.date(from: timeStr)!
    }
    /// 生成当前时间对应的字符串
    func descriptionStr() -> String{
        //格式化时间
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        // 创建一个日历类
        let calendar = Calendar.current
        var formatterStr = "HH:mm"
        if calendar.isDateInToday(self)
        {
            //比较时间差 NSDate()<当前时间>  createDate< 取到的时间>
            let interval = Int(NSDate().timeIntervalSince(self))
            
            if interval < 60
            {
                return "刚刚"
            }else if interval < 60 * 60
            {
                return "\(interval / 60)分钟前"
            }else if interval < 60 * 60 * 24
            {
                return "\(interval / (60 * 60))小时前"
            }
        }
        else if calendar.isDateInYesterday(self) {
            // 昨天
            formatterStr = "昨天 " + formatterStr
            
        }else {
            let comps = calendar.dateComponents([.year], from: self, to: Date())
            if comps.year! >= 1
            {
                // 更早时间
                formatterStr = "yyyy-MM-dd " + formatterStr
            }else
            {
                // 一年以内
                formatterStr = "MM-dd " + formatterStr
            }
        }
        formatter.dateFormat = formatterStr
        return formatter.string(from: self)
    }
}
