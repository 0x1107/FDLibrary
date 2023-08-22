//
//  FDJSONUtil.swift
//  
//
//  Created by fd on 2021/10/3.
//
//  模型转换工具(应用泛型)

import Foundation
import HandyJSON

public extension String {
    
    /// JSON转对象
    func fdToModel<T: HandyJSON>(_ modelType: T.Type) -> T? {
        RxFDJSONUtil.jsonToModel(self, modelType)
    }
    
    /// JSON转数组对象
    func fdToModels<T: HandyJSON>(_ modelType: T.Type) -> [T] {
        RxFDJSONUtil.jsonArrayToModel(self, modelType)
    }
}

public extension Dictionary where Key == String {
    
    /// 字典转对象
    func fdToModel<T: HandyJSON>(_ modelType: T.Type) -> T? {
        RxFDJSONUtil.dictionaryToModel(self, modelType)
    }
}

public extension Array where Element == [String : Any] {
    
    /// 数组转对象数组
    func fdToModel<T: HandyJSON>(_ modelType: T.Type) -> [T] {
        RxFDJSONUtil.arrayToModel(self, modelType)
    }
}

open class RxFDJSONUtil {
    /**
     *  JSON转对象
     */
    public static func jsonToModel<T:HandyJSON>(_ jsonStr:String,_ modelType:T.Type) -> T? {
        guard jsonStr.count > 0 else {
            #if DEBUG
            print("jsonoModel:字符串为空")
            #endif
            return nil
        }
        return modelType.deserialize(from: jsonStr)
    }
    
    /**
     *  JSON转数组对象
     */
    public static func jsonArrayToModel<T:HandyJSON>(_ jsonArrayStr:String, _ modelType:T.Type) -> [T] {
        guard jsonArrayStr.count > 0 else {
            #if DEBUG
            print("jsonToModelArray:字符串为空")
            #endif
            return []
        }
        guard let data = jsonArrayStr.data(using: .utf8),
              let peoplesArray = try? JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions()) as? [[String : Any]] else {
            return []
        }
        return peoplesArray.compactMap { dictionaryToModel($0, modelType) }
    }
    
    /**
     *  字典转对象
     */
    public static func dictionaryToModel<T:HandyJSON>(_ dictionStr:[String:Any],_ modelType:T.Type) -> T? {
        guard dictionStr.count > 0 else {
            #if DEBUG
            print("dictionaryToModel:字符串为空")
            #endif
            return nil
        }
        return modelType.deserialize(from: dictionStr)
    }
    /**
     *  数组转对象数组
     */
    public static func arrayToModel<T:HandyJSON>(_ array:[[String:Any]],_ modelType:T.Type) -> [T] {
        guard array.count > 0 else {
            #if DEBUG
            print("dictionaryToModel:字符串为空")
            #endif
            return []
        }
        return array.compactMap { dictionaryToModel($0, T.self) }
    }
    
    /**
     *  对象转JSON
     */
    public static func modelToJson(_ model:HandyJSON?) -> String? {
        guard let model = model else {
            #if DEBUG
            print("modelToJson:model为空")
            #endif
            return nil
        }
        return model.toJSONString()
    }
    
    /**
     *  对象转字典
     */
    public static func modelToDictionary(_ model:HandyJSON?) -> [String:Any]? {
        guard let model = model else {
            #if DEBUG
            print("modelToJson:model为空")
            #endif
            return nil
        }
        return model.toJSON()
    }
}
