//
//  BaseTableView.swift
//  
//
//  Created by 0x1107 on 2023/3/6.
//

import UIKit

open class BaseTableView: UITableView {

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    open func setupUI() {
        backgroundColor = .systemBackground
        contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
    }
}
