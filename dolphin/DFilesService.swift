//
//  DFilesService.swift
//  dolphin
//
//  Created by Mihail Terekhov on 02.07.2021.
//

import UIKit

protocol DFilesServiceProtocol {
    
    func documentsFolderURL() -> URL
    
    func folderFiles(folderURL: URL, filter: String?) -> [URL]
    
    func isFolder(urlToCheck: URL) -> Bool

}

class DFilesService: DFilesServiceProtocol {
    
    public var fileManager = FileManager.default
    
    func isFolder(urlToCheck: URL) -> Bool {
        var isDir = false
        
        do {
            isDir = (try urlToCheck.resourceValues(forKeys: [.isDirectoryKey])).isDirectory ?? false
        }
        catch {
            return false
        }
        
        return isDir
    }
    
    func folderFiles(folderURL: URL, filter: String?) -> [URL] {
        var fileUrlsList = [URL]()
        do {
            fileUrlsList = try fileManager.contentsOfDirectory(at: folderURL,
                                                               includingPropertiesForKeys: nil,
                                                               options: .skipsHiddenFiles)
        }
        catch {
            print(error)
            return [URL]()
        }
        
        fileUrlsList = fileUrlsList.filter { fileURL in
            if let filter = filter {
                return fileURL.pathExtension == filter
            }
            
            return true
        }
        
        fileUrlsList.sort { urlOne, urlTwo in
            return urlOne.lastPathComponent < urlTwo.lastPathComponent
        }
        
        return fileUrlsList
    }
    
    func documentsFolderURL() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsFolderURL: URL = paths.first  else {
            return URL(fileURLWithPath: "")
        }
        
        return documentsFolderURL
    }
    
}
