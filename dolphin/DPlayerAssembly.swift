//
//  DPlayerAssembly.swift
//  dolphin
//
//  Created by Mihail Terekhov on 30.06.2021.
//

import UIKit

class DPlayerAssembly {

    public func createModule(screenWidth: CGFloat) -> UIViewController & DPlayerModuleInjection {
        let viewController = DPlayerVC()
        
        viewController.sizeService = DPlayerSizeService(injectScreenWidth: screenWidth)
        viewController.splitTimeService = DTimeSplitterService()
        viewController.openTrack(newTrack: DTrack(title: "Opera Singer",
                                                  author: "Cake",
                                                  length: 150,
                                                  frequency: 44,
                                                  bitrate: 256))
        
        return viewController
    }

}
