//
//  DRootAssembly.swift
//  dolphin
//
//  Created by Mihail Terekhov on 30.06.2021.
//

import UIKit

class DRootAssembly {

    public func createModule(screenWidth: CGFloat) -> UIViewController {
        let viewController = DRootVC()
        
        viewController.playerModule = DPlayerAssembly().createModule(screenWidth: screenWidth)
        viewController.playListModule = DPlayListAssembly().createModule()
        
        return viewController
    }

}
