//
//  DPlayListRouter.swift
//  dolphin
//
//  Created by Mihail Terekhov on 02.07.2021.
//

import UIKit

protocol DPlayListRouterProtocol {

    func openFileBrowser(viewController: UIViewController, browserDelegate: DFilesBrowserDelegate?)
    func closeFileBrowser(viewController: UIViewController)

}

class DPlayListRouter: DPlayListRouterProtocol {

    func openFileBrowser(viewController: UIViewController, browserDelegate: DFilesBrowserDelegate?) {
        let fileBrowserVC = DFilesBrowserAssembly().createModule(browserDelegate: browserDelegate)
        fileBrowserVC.modalPresentationStyle = .fullScreen
        viewController.present(fileBrowserVC, animated: true, completion: nil)
    }
    
    func closeFileBrowser(viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

}
