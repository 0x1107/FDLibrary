//
//  SRM+Double.swift
//  srm
//
//  Created by 范东 on 2023/2/23.
//

import Foundation


public extension Double {
    /// 保留n位小数
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
