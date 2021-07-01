//
//  DPlayerSizeService.swift
//  dolphin
//
//  Created by Mihail Terekhov on 01.07.2021.
//

import UIKit

protocol DPlayerSizeServiceProtocol {

    func playerWidth() -> CGFloat
    func playerHeight() -> CGFloat
    func timingHeight() -> CGFloat
    func timingWidth() -> CGFloat
    func trackInfoHeight() -> CGFloat
    func miscWidth() -> CGFloat

}

class DPlayerSizeService: DPlayerSizeServiceProtocol {

    private var screenWidth: CGFloat = 0

    convenience init(injectScreenWidth: CGFloat) {
        self.init()
        
        screenWidth = injectScreenWidth
    }
    
    func timingHeight() -> CGFloat {
        ceil(playerHeight() * 1 / 2)
    }
    
    func timingWidth() -> CGFloat {
        ceil(playerWidth() * 1 / 3)
    }
    
    func trackInfoHeight() -> CGFloat {
        ceil(timingHeight() * 2 / 3)
    }
    
    func playerWidth() -> CGFloat {
        return screenWidth
    }
    
    func playerHeight() -> CGFloat {
        return ceil(screenWidth * 2 / 5)
    }
    
    func miscWidth() -> CGFloat {
        return playerWidth() - timingWidth()
    }

}
