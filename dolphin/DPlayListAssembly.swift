//
//  DPlayListAssembly.swift
//  dolphin
//
//  Created by Mihail Terekhov on 30.06.2021.
//

import UIKit

class DPlayListAssembly {
    
    public func createModule(rootModule: DRootModuleInjection) -> UIViewController & DPlayListModuleInjection {
        let viewController = DPlayListVC()
        
        viewController.splitTimeService = DTimeSplitterService()
        viewController.playListService = DPlayListService(injectFileSrvice: DFilesService())
        viewController.rootModule = rootModule
        viewController.router = DPlayListRouter()
                
        return viewController
    }
    
}
