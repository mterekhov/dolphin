//
//  DPlayListVC.swift
//  dolphin
//
//  Created by Mihail Terekhov on 30.06.2021.
//

import UIKit

class DPlayListVC: UIViewController {

    override func loadView() {
        super.loadView()
        
        createLayout()
    }
    
    private func createLayout() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cyan
    }
    
}
