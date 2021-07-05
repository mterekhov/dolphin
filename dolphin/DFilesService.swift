//
//  DFilesService.swift
//  dolphin
//
//  Created by Mihail Terekhov on 02.07.2021.
//

import UIKit

protocol DFilesServiceProtocol {
    
    func documentsFolderURL() -> URL
    
    func folderPlayableFiles(folderURL: URL) -> [URL]

    func isFolder(urlToCheck: URL) -> Bool

    func relativeDocumentsPath(fullPathURL: URL) -> String

}

class DFilesService: DFilesServiceProtocol {
    
    //  injections
    public var fileManager = FileManager.default
    
    private let playableFormats = ["mp3"]
    
    convenience init(injectFileManager: FileManager) {
        self.init()
        
        fileManager = injectFileManager
    }
    
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
    
    func folderPlayableFiles(folderURL: URL) -> [URL] {
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
        
        var folders = fileUrlsList.filter { fileURL in
            return isFolder(urlToCheck: fileURL)
        }
        folders.sort { urlOne, urlTwo in
            return urlOne.lastPathComponent < urlTwo.lastPathComponent
        }

        var playableFiles = fileUrlsList.filter { fileURL in
            for format in playableFormats {
                if fileURL.pathExtension.lowercased() != format {
                    return false
                }
            }

            return !isFolder(urlToCheck: fileURL)
        }
        playableFiles.sort { urlOne, urlTwo in
            return urlOne.lastPathComponent < urlTwo.lastPathComponent
        }

        return folders + playableFiles
    }
    
    func documentsFolderURL() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsFolderURL: URL = paths.first  else {
            return URL(fileURLWithPath: "")
        }
        
        return documentsFolderURL
    }
    
    func relativeDocumentsPath(fullPathURL: URL) -> String {
        return relativePath(rootPath: documentsFolderURL(), fullPathURL: fullPathURL)
    }

    func fullDocumentsPath(relativePathURL: String) -> URL {
        return URL(fileURLWithPath: documentsFolderURL().path + "/" + relativePathURL)
    }

    private func relativePath(rootPath: URL, fullPathURL: URL) -> String {
        var fullPathString = fullPathURL.path
        guard let range = fullPathString.range(of: rootPath.path) else {
            return fullPathString
        }
        
        fullPathString.removeSubrange(range)
        fullPathString.removeFirst()
        
        return fullPathString
    }
    

}
