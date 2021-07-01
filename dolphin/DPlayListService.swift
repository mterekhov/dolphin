//
//  DPlayListService.swift
//  dolphin
//
//  Created by Mihail Terekhov on 01.07.2021.
//

import Foundation


protocol DPlayListServiceProtocol {

    func recentPlayList() -> DPlayList?

    func availablePlayLists() -> [DPlayList]
    
    func addTrack(playList: DPlayList, newTrack: DTrack) -> DPlayList
    
    func savePlayList(playList: DPlayList, playListFileName: String)

}

class DPlayListService: DPlayListServiceProtocol {

    let UserDefaultsCurrentPlayListKey = "CurrentPlayListKey"
    let UserDefaultsDefaultPlayListNameKey = "DefaultPlayListNameKey"

    let PlayListFileExtension = "json"
    let TracksFileExtension = "mp3"
    let PlayListJSONMagicWord = "DOLPHIN"

    func recentPlayList() -> DPlayList? {
        return nil
    }
    
    func availablePlayLists() -> [DPlayList] {
        var playLists = [DPlayList]()
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var fileUrls = [URL]()
        if let documentsFolder: URL = paths.first {
            do {
                print("docs folder \(documentsFolder.absoluteString)")
                fileUrls = try FileManager.default.contentsOfDirectory(at: documentsFolder, includingPropertiesForKeys: nil)
                print("files list:\n \(fileUrls)")
            }
            catch {
                print("error \(error)")
            }
        }

        return playLists
    }
    
    func addTrack(playList: DPlayList, newTrack: DTrack) -> DPlayList {
        var newPlayList = playList
        
        newPlayList.tracksList.append(newTrack)
        
        return newPlayList
    }

    func savePlayList(playList: DPlayList, playListFileName: String) {
        
    }

}
