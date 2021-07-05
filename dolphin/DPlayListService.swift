//
//  DPlayListService.swift
//  dolphin
//
//  Created by Mihail Terekhov on 01.07.2021.
//

import Foundation
import ID3TagEditor
import AVFoundation


protocol DPlayListServiceProtocol {
    
    func newPlayListWithFiles(playList: DPlayList, newFilesURLsList: [URL]) -> DPlayList
    
    func savePlayList(playList: DPlayList)

    func loadPlayList(playListURL: URL) -> DPlayList

}

class DPlayListService: DPlayListServiceProtocol {
    
    let UserDefaultsCurrentPlayListKey = "CurrentPlayListKey"
    let UserDefaultsDefaultPlayListNameKey = "DefaultPlayListNameKey"
    
    let PlayListFileExtension = "json"
    let PlayListJSONMagicWord = "DOLPHIN"
    
    //  injections
    public var fileService: DFilesServiceProtocol = DFilesService()
    
    convenience init(injectFileSrvice: DFilesServiceProtocol) {
        self.init()
        
        fileService = injectFileSrvice
    }
    
    // MARK: - DPlayListServiceProtocol -
    
    func newPlayListWithFiles(playList: DPlayList, newFilesURLsList: [URL]) -> DPlayList {
        var newPlayList = playList
        
        newFilesURLsList.forEach { newTrackUrl in
            if newTrackUrl.pathExtension == PlayListFileExtension {
                let tmpPlayList = loadPlayList(playListURL: newTrackUrl)
                newPlayList.name = tmpPlayList.name
                newPlayList.repeatPlayback = tmpPlayList.repeatPlayback
                newPlayList.shuffleMode = tmpPlayList.shuffleMode
                newPlayList.tracksList.append(contentsOf: tmpPlayList.tracksList)
            }
            else {
                newPlayList.tracksList.append(generateTracks(fileUrl: newTrackUrl))
            }
        }
        
        return newPlayList
    }
    
    func savePlayList(playList: DPlayList) {
        var repeatString = "false"
        var shuffleModeString = "false"
        if playList.repeatPlayback {
            repeatString = "true"
        }
        if playList.shuffleMode {
            shuffleModeString = "true"
        }
        var jsonString = "{\"magic_word\": \"\(PlayListJSONMagicWord)\", \"repeat\":\(repeatString), \"shuffle\":\(shuffleModeString), \"name\":\"\(playList.name)\", \"files\": [{"
        for i in 0...playList.tracksList.count - 1 {
            if i != 0 {
                jsonString += " {"
            }
            jsonString += "\"file_name\": \"\(fileService.relativeDocumentsPath(fullPathURL: playList.tracksList[i].track.fileURL))\"}"
            if i != playList.tracksList.count - 1 {
                jsonString += ", "
            }
        }
        playList.tracksList.forEach { track in
        }
        jsonString += "]}"
        do {
            let saveURL = fileService.documentsFolderURL().appendingPathComponent(playList.name + ".\(PlayListFileExtension)")
            print("save URL <\(saveURL.path)>")
            try jsonString.data(using: .utf8)?.write(to: saveURL)
        }
        catch {
            
        }
    }

    func loadPlayList(playListURL: URL) -> DPlayList {
        var jsonDict = [String:Any]()
        
        do {
            let jsonData = try Data(contentsOf: playListURL)
            jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] ?? [String:Any]()
        }
        catch {
            print(error)
            return DPlayList()
        }
        
        guard let magicWord = jsonDict["magic_word"] as? String else {
            return DPlayList()
        }
        
        if magicWord != PlayListJSONMagicWord {
            return DPlayList()
        }
        
        var newPlayList = DPlayList()
        if let name = jsonDict["name"] as? String {
            newPlayList.name = name
        }
        if let shuffle = jsonDict["shuffle"] as? Bool {
            newPlayList.shuffleMode = shuffle
        }
        if let repeatPlayback = jsonDict["repeat"] as? Bool {
            newPlayList.repeatPlayback = repeatPlayback
        }
        if let tracksList = jsonDict["files"] as? [[String:String]] {
            tracksList.forEach { tracksDict in
                if let relativeTrackPath = tracksDict["file_name"] {
                newPlayList.tracksList.append(generateTracks(fileUrl: fileService.fullDocumentsPath(relativePathURL: relativeTrackPath)))
                }
            }
        }

        return newPlayList
    }

    // MARK: - Routine -
    
    private func generateTracks(fileUrl: URL) -> DPlayListTrack {
        let newTrack = DPlayListTrack()
        do {
            let tagEditor = ID3TagEditor()
            let audioPlayer = try AVAudioPlayer(contentsOf: fileUrl)
            if let id3Tag = try tagEditor.read(from: fileUrl.path) {
                return DPlayListTrack(track: DTrack(title: (id3Tag.frames[.title] as?  ID3FrameWithStringContent)?.content ?? "",
                                                    author: (id3Tag.frames[.artist] as?  ID3FrameWithStringContent)?.content ?? "",
                                                    length: Int(audioPlayer.duration),
                                                    frequency: Int(audioPlayer.format.sampleRate),
                                                    bitrate: 0,
                                                    fileURL: fileUrl),
                                      selectionBlock: nil,
                                      deselectionBlock: nil)
            }
        }
        catch {
            return newTrack
        }
        
        return newTrack
    }
    
}
