//
//  DRootAssembly.swift
//  dolphin
//
//  Created by Mihail Terekhov on 30.06.2021.
//

import UIKit

class DRootAssembly {

    public func createModule(screenWidth: CGFloat) -> UIViewController & DRootModuleInjection {
        let viewController = DRootVC()
        
        let playerModule = DPlayerAssembly().createModule(screenWidth: screenWidth)
        viewController.playerModule = playerModule
        
        let playListModule = DPlayListAssembly().createModule(rootModule: viewController)
        viewController.playListModule = playListModule
        
        return viewController
    }

}
