//
//  DPlayListTrack.swift
//  dolphin
//
//  Created by Mihail Terekhov on 05.07.2021.
//

import UIKit

struct DPlayListTrack {
    
    public var track = DTrack()
    public var selectionBlock: VoidCompletionHandler?
    public var deselectionBlock: VoidCompletionHandler?
    
}
