//
//  DFilesBrowserAssembly.swift
//  dolphin
//
//  Created by Mihail Terekhov on 02.07.2021.
//

import UIKit

class DFilesBrowserAssembly {

    public func createModule(browserDelegate: DFilesBrowserDelegate?) -> UIViewController {
        let viewController = DFilesBrowserVC()
        
        let fileService = DFilesService()
        fileService.fileManager = FileManager.default
        viewController.filesService = fileService
        viewController.delegate = browserDelegate
        
        return viewController
    }
    
}
