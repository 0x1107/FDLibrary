//
//  BaseCollectionViewCell.swift
//  
//
//  Created by 范东 on 2023/2/21.
//

import UIKit
import RxSwift

open class BaseCollectionViewCell: UICollectionViewCell {
    public var disposeBag = DisposeBag()
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
