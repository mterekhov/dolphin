//
//  DPlayListService.swift
//  dolphin
//
//  Created by Mihail Terekhov on 01.07.2021.
//

import Foundation


protocol DPlayListServiceProtocol {

    func generateTracks(filesUrlsList: [URL]) -> [DTrack]

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

    func generateTracks(filesUrlsList: [URL]) -> [DTrack] {
        var tracksList = [DTrack]()
        
        filesUrlsList.forEach { trackURL in
            let newTrack = DTrack(title: trackURL.lastPathComponent,
                                  author: "",
                                  length: 0,
                                  frequency: 0,
                                  bitrate: 0,
                                  fileURL: trackURL)
            tracksList.append(newTrack)
        }
        
        return tracksList
    }
    
    func addTrack(playList: DPlayList, newTrack: DTrack) -> DPlayList {
        var newPlayList = playList
        
        newPlayList.tracksList.append(newTrack)
        
        return newPlayList
    }

    func recentPlayList() -> DPlayList? {
        return nil
    }
    
    func availablePlayLists() -> [DPlayList] {
        var playLists = [DPlayList]()
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var fileUrls = [URL]()
        if let documentsFolder: URL = paths.first {
            do {
                print("docs folder \(documentsFolder.path)")
                fileUrls = try FileManager.default.contentsOfDirectory(at: documentsFolder, includingPropertiesForKeys: nil)
                print("files list:\n \(fileUrls)")
            }
            catch {
                print("error \(error)")
            }
        }

        return playLists
    }
    
    func savePlayList(playList: DPlayList, playListFileName: String) {
        
    }

}
