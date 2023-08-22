//
//  BaseVC.swift
//
//
//  Created by 范东 on 2023/2/8.
//

import UIKit
import RxSwift
import SnapKit
import Toast

open class BaseVC: UIViewController {
    
    public var defaultOrientation: UIInterfaceOrientation = .portrait
        
    public var disposeBag = DisposeBag()
    
    public func upConfig() {
        orientations = .portrait
    }
    
    deinit {
        debugPrint("\(type(of: self)) 被释放")
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        upConfig()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        upConfig()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    //MARK: - 处理 ViewModel 默认事件
    private var _loadingDisposable: Disposable?
    open func loadVMAction(_ vm: BaseVM, completion: ((VMActionType) -> Bool)? = nil) {
        vm.actionPS.subscribe(onNext: { [weak self] type in
            if let completion = completion, completion(type) { return }
            guard let `self` = self else { return }
            switch type {
            case let .activity(isEnabled, hasLoading):
                self.view.isUserInteractionEnabled = isEnabled
                self._loadingDisposable?.dispose()
                if isEnabled {
                    self.view.hideToastActivity()
                } else if hasLoading {
                    self._loadingDisposable = Observable.just(()).delay(RxTimeInterval.milliseconds(Int(ceil(ToastManager.shared.style.fadeDuration*1000))+2), scheduler: MainScheduler.asyncInstance)
                        .subscribe(onNext: { [weak self] in
                            guard let `self` = self, !self.view.isUserInteractionEnabled else { return }
                            self.view.makeToastActivity(ToastPosition.center)
                        })
                }
            case let .show(msg, _):
                self.view.makeCenterToast(msg: msg)
            case let .present(vc, animated, completion):
                self.present(vc, animated: animated, completion: completion)
            case let .dismiss(animated, completion):
                if let nvc = self.navigationController {
                    nvc.dismiss(animated: animated, completion: completion)
                } else {
                    self.dismiss(animated: animated, completion: completion)
                }
            case let .push(vc, animated):
                self.navigationController?.pushViewController(vc, animated: animated)
            case let .popViewController(animated):
                self.navigationController?.popViewController(animated: animated)
            case let .popToViewController(viewController, animated):
                self.navigationController?.popToViewController(viewController, animated: animated)
            case let .popToRootViewController(animated):
                self.navigationController?.popToRootViewController(animated: animated)
            }
        }).disposed(by: disposeBag)
    }
    
    public lazy var emptyView: UIView = {
        let emptyView = UIView(frame: .zero)
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "default_empty_list")
        imageView.tag = 101
        let label = UILabel(frame: .zero)
        label.text = "暂无内容"
        label.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        emptyView.addSubview(imageView)
        emptyView.addSubview(label)
        imageView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(14)
            make.bottom.equalToSuperview()
            make.right.left.equalToSuperview()
        }
        return emptyView
    }()
    
    open override var preferredStatusBarStyle: UIStatusBarStyle{
        .default
    }
    
    //MARK:-转屏
    public lazy var orientations: UIInterfaceOrientationMask = UIInterfaceOrientationMask.portrait
    public override var shouldAutorotate: Bool { get { return true } }
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask { get { return orientations } }
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get {
            switch orientations {
            case .portrait:
                return .portrait
            case .portraitUpsideDown:
                return .portraitUpsideDown
            case .landscapeLeft:
                defaultOrientation = .landscapeLeft
                return .landscapeLeft
            case .landscapeRight:
                defaultOrientation = .landscapeRight
                return .landscapeRight
            case .landscape:
                switch UIDevice.current.orientation {
                case .landscapeRight:
                    defaultOrientation = .landscapeLeft
                    return .landscapeLeft
                case .landscapeLeft:
                    defaultOrientation = .landscapeRight
                    return .landscapeRight
                default:
                    return defaultOrientation
                }
            default:
                let ori = UIApplication.shared.statusBarOrientation
                if ori == .landscapeLeft || ori == .landscapeRight {
                    defaultOrientation = ori
                }
                return ori
            }
        }
    }
}
