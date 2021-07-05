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

}

class DPlayListService: DPlayListServiceProtocol {
    
    let UserDefaultsCurrentPlayListKey = "CurrentPlayListKey"
    let UserDefaultsDefaultPlayListNameKey = "DefaultPlayListNameKey"
    
    let PlayListFileExtension = "json"
    let TracksFileExtension = "mp3"
    let PlayListJSONMagicWord = "DOLPHIN"
    
    //  injections
    public var fileService: DFilesServiceProtocol = DFilesService()
    
    convenience init(injectFileSrvice: DFilesServiceProtocol) {
        self.init()
        
        fileService = injectFileSrvice
    }
    
    func newPlayListWithFiles(playList: DPlayList, newFilesURLsList: [URL]) -> DPlayList {
        var newPlayList = playList
        
        newFilesURLsList.forEach { newTrackUrl in
            newPlayList.tracksList.append(generateTracks(fileUrl: newTrackUrl))
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
