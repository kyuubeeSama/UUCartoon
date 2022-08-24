//
// Created by kyuubee on 2020/7/15.
// Copyright (c) 2020 qykj. All rights reserved.
//

import Foundation

class FileTool:NSObject {
    // 获取document地址
    func getDocumentPath()->String{
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        return documentPath
    }
    // 创建文件
    func createFile(document:String,fileData:Data) -> Bool {
        let path = getDocumentPath().appending(document)
        let fileManager = FileManager.default
        let isDirExist = fileManager.fileExists(atPath: path)
        if !isDirExist {
            let bCreateDir = fileManager.createFile(atPath: path, contents: fileData, attributes: nil)
            if bCreateDir {
                return true
            }else{
                return false
            }
        }else{
            return true
        }
    }
    // 删除文件并返回成功与否
    func deleteFileWithPath(path:String) -> Bool {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
            return true
        }catch{
            return false
        }
    }

    /// (recommended) 获取指定文件夹下符合扩展名要求的所有文件名
    /// - parameter path: 文件夹路径
    /// - parameter filterTypes: 扩展名过滤类型(注：大小写敏感)
    /// - returns: 所有文件名数组
    func findFiles(path: String, filterTypes: [String]) -> [String] {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: path)
//            let files = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)
            if filterTypes.count == 0 {
                return files
            }
            else {
                let filteredfiles = NSArray(array: files).pathsMatchingExtensions(filterTypes)
                return filteredfiles
            }
        }
        catch {
            return []
        }
    }
}