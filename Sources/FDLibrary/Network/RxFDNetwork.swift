//
//  RxFDNetwork.swift
//
//
//  Created by 韩云智 on 2021/10/3.
//
//  网络请求框架

import Foundation
import RxAlamofire
import RxSwift
import HandyJSON
import Alamofire

/// 基本模型
open class FDBaseModel: HandyJSON {
    required public init() {}
    public func mapping(mapper: HelpingMapper) {}
    
    /// 复制出一个新对象
    var copy: Self {
        guard let dic = toJSON(), let model = RxFDJSONUtil.dictionaryToModel(dic, Self.self) else {
            return Self.init()
        }
        return model
    }
}

/// 扩展Observable：增加模型映射方法
public extension Observable where Element:Any {
    
    /// 将JSON数据转成对象
    func mapModel<T>(type:T.Type) -> Observable<T> where T: HandyJSON {
        return self.map { (element) -> T in
            switch element {
            case let dic as Dictionary<String, Any>: return dic.fdToModel(T.self) ?? T.init()
            case let str as String: return str.fdToModel(T.self) ?? T.init()
            default: return T.init()
            }
        }
    }
}

public extension String {
    
    /// 拼接域名 RxFDNetwork.api
    var xsSpliceApi: String { xsSplice(api: "") }
    
    /// 拼接域名地址 经过 .urlQueryAllowed 转换
    func xsSplice(api: String) -> String {
        let str = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
        if hasPrefix("https://") || hasPrefix("http://") { return str }
        if hasPrefix("/") { return api + str }
        return api + "/" + str
    }
}

open class RxFDNetwork {
    
    /// 统一处理请求参数
    public static var parametersBlock: (([String: Any]?)->[String: Any]?) = { $0 }
    /// 拦截请求返回结果 如果返回 false 中断后面的事件
    public static var filterBlock: ((Any)->Bool) = { _ in true }
    
    /// 请求模型
    public struct FDRequest {
        let method: Alamofire.HTTPMethod
        let url: String
        let parameters: Parameters?
        let encoding: ParameterEncoding
        let headers: Alamofire.HTTPHeaders?
        let interceptor: RequestInterceptor?
        
        /// 创建返回的解码请求模型
        /// - Parameters:
        ///   - method: Alamofire 方法对象
        ///   - url: 采用“URLConvertible”的对象
        ///   - parameters: 包含所有必要选项的字典
        ///   - encoding: 用于处理参数的编码类型 默认 URLEncoding.default
        ///   - headers: 包含所有附加标题的字典
        ///   - interceptor: 返回的“DataRequest”要使用的“RequestInterceptor”值。 默认情况下为`nil`。
        public init(method: Alamofire.HTTPMethod = .post,
             url: String,
             parameters: Parameters?,
             encoding: ParameterEncoding = URLEncoding.default,
             headers: [String : String]? = nil,
             interceptor: RequestInterceptor? = nil) {
            self.method = method
            self.url = url.xsSpliceApi
            self.parameters = parameters
            self.encoding = encoding
            if let headers = headers {
                self.headers = HTTPHeaders(headers)
            } else {
                self.headers = nil
            }
            self.interceptor = interceptor
        }
    }
    
    // MARK: - Request
    
    /// Json 格式的数据请求
    public static func fdJSON<T: HandyJSON>(_ request: FDRequest) -> Observable<T> {
        fdRequest(json(request.method, request.url, parameters: request.parameters as? Parameters, encoding: request.encoding, headers: request.headers, interceptor: request.interceptor), request)
            .mapModel(type: T.self)
            .filter({ filterBlock($0) })
            .observe(on: MainScheduler.instance)
    }
    /// String 格式的数据请求
    public static func fdString(_ request: FDRequest) -> Observable<String> {
        fdRequest(string(request.method, request.url, parameters: request.parameters as? Parameters, encoding: request.encoding, headers: request.headers, interceptor: request.interceptor), request)
            .filter({ filterBlock($0) })
            .observe(on: MainScheduler.instance)
    }
    /// Data 格式的数据请求
    public static func fdData(_ request: FDRequest) -> Observable<Data> {
        fdRequest(data(request.method, request.url, parameters: request.parameters as? Parameters, encoding: request.encoding, headers: request.headers, interceptor: request.interceptor), request)
            .filter({ filterBlock($0) })
            .observe(on: MainScheduler.instance)
    }
    
    private static func fdRequest<T>(_ observable: Observable<T>, _ request: FDRequest) -> Observable<T> {
#if DEBUG
        print("--------------------------------")
        print(request.url)
        if let parameters = request.parameters { print(parameters) }
        if let headers = request.headers { print(headers.dictionary)}
        print("--------------------------------")
        return observable.debug().filter { any in
            print("++++++++++++++++++++++++++++++++")
            print(request.url)
            if let parameters = request.parameters { print(parameters) }
            if let headers = request.headers { print(headers.dictionary)}
            print(any)
            print("++++++++++++++++++++++++++++++++")
            return true
        }
#else
        return observable
#endif
    }
    
    // MARK: - Upload
    
    /// 用于构建“MultipartFormData”的块。
    public static func fdUpload(multipartFormData: @escaping (MultipartFormData) -> Void, _ request: FDRequest) -> Observable<UploadRequest> {
        upload(multipartFormData: multipartFormData, to: request.url, method: request.method, headers: request.headers)
    }
    /// 保存本地文件信息的“Data”实例。
    public static func fdUpload(data: Data, _ request: FDRequest) -> Observable<UploadRequest> {
        upload(data, to: request.url, method: request.method, headers: request.headers)
    }
    /// 一个包含本地文件信息的 URL 实例。
    public static func fdUpload(file: URL, _ request: FDRequest) -> Observable<UploadRequest> {
        upload(file, to: request.url, method: request.method, headers: request.headers)
    }
    
    
    // MARK: - Download
    
    /// 创建下载请求。
    /// - Parameters:
    ///   - request: 解码请求模型
    ///   - resumeData: 获取恢复数据的回调
    ///   - destination: 用于确定下载文件目的地的闭包。
    public static func fdDownload(_ request: FDRequest, resumeData: ((FDRequest)->Data?) = { _ in nil }, to destination: @escaping DownloadRequest.Destination) -> Observable<DownloadRequest>? {
        if let resumeData = resumeData(request) {
            return download(resumeData: resumeData, interceptor: request.interceptor, to: destination)
        } else {
            guard let url = URL(string: request.url), let urlRequest = try? URLRequest(url: url, method: request.method, headers: request.headers) else { return nil }
            return download(urlRequest, interceptor: request.interceptor, to: destination)
        }
    }
}
