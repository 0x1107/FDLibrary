//
//  BaseTableViewCell.swift
//  
//
//  Created by 范东 on 2023/2/21.
//

import UIKit
import RxSwift

open class BaseTableViewCell: UITableViewCell {
    
    public var disposeBag = DisposeBag()
        
    open override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
