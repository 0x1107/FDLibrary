//
//  RxMJRefresh.swift
//
//
//  Created by 韩云智 on 2021/10/4.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

open class Target: NSObject, Disposable {
    private var retainSelf: Target?
    override init() {
        super.init()
        self.retainSelf = self
    }
    public func dispose() {
        self.retainSelf = nil
    }
}

open class MJRefreshTarget<Component: MJRefreshComponent>: Target {
    weak var component: Component?
    let refreshingBlock: MJRefreshComponentAction
    
    init(_ component: Component , refreshingBlock: @escaping MJRefreshComponentAction) {
        self.refreshingBlock = refreshingBlock
        self.component = component
        super.init()
        component.setRefreshingTarget(self, refreshingAction: #selector(onRefeshing))
    }
    
    @objc func onRefeshing() {
        refreshingBlock()
    }
    
    public override func dispose() {
        super.dispose()
        self.component?.refreshingBlock = nil
    }
}

public extension Reactive where Base: MJRefreshComponent {
    var refresh: ControlProperty<MJRefreshState> {
        let source: Observable<MJRefreshState> = Observable.create { [weak component = self.base] observer  in
            MainScheduler.ensureExecutingOnScheduler()
            guard let component = component else {
                observer.on(.completed)
                return Disposables.create()
            }
            
            observer.on(.next(component.state))
            
            let observer = MJRefreshTarget(component) {
                observer.on(.next(component.state))
            }
            return observer
        }.take(until: deallocated)
                
        let bindingObserver = Binder<MJRefreshState>(self.base) { (component, state) in
            component.state = state
        }
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
}
