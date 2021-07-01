//
//  DPlayerAssembly.swift
//  dolphin
//
//  Created by Mihail Terekhov on 30.06.2021.
//

import UIKit

class DPlayerAssembly {

    public func createModule(screenWidth: CGFloat) -> UIViewController {
        let viewController = DPlayerVC()
        
        viewController.sizeService = DPlayerSizeService(injectScreenWidth: screenWidth)
        
        return viewController
    }

}
