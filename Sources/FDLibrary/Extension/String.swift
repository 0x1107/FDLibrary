//
//  srm+String.swift
//  srm
//
//  Created by 范东 on 2023/2/8.
//

import Foundation
import SwiftDate
import UIKit

public extension String {    
    
    /// 日期转换（由TZ转换为正常时间含秒）
    var dateTimessString: String {
        if self.count == 0 {
            return "--"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = self.toISODate()
        return dateFormatter.string(from: date?.date ?? Date())
    }
    
    /// 日期转换（由TZ转换为正常时间不含秒）
    var dateTimeString: String {
        if self.count == 0 {
            return "--"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = self.toISODate()
        return dateFormatter.string(from: date?.date ?? Date())
    }
    
    var dateString: String {
        if self.count == 0 {
            return "--"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = self.toISODate()
        return dateFormatter.string(from: date?.date ?? Date())
    }
    
    var date: Date? {
        if self.count == 0 {
            return Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
    
    /// 国际化
    var i18n: String {
        NSLocalizedString(self, comment: "")
    }
    
    /// 文本高度
    func textHeight(maxWidth: CGFloat, maxHeight: CGFloat, font: UIFont) -> CGFloat {
        (self as NSString).boundingRect(with: CGSize(width: maxWidth, height: maxHeight), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [.font: font], context: nil).size.height
    }
    
    func textSize(maxWidth: CGFloat, maxHeight: CGFloat, font: UIFont) -> CGSize {
        (self as NSString).boundingRect(with: CGSize(width: maxWidth, height: maxHeight), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [.font: font], context: nil).size
    }
    
    func base64Decode() -> String{
        var data = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        var string = NSString(data: data as! Data, encoding: String.Encoding.utf8.rawValue) as! String
        return string
    }
    
    func base64Encode() -> String{
        var data = self.data(using: .utf8)
        var base64String = data?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String!
    }
}
