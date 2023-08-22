//
//  SRM+UserDefault.swift
//  srm
//
//  Created by 范东 on 2023/2/9.
//

import Foundation

public extension UserDefaults {
    class func setAndSyncValue(_ value: Any?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
