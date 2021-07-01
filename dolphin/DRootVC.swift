//
//  DRootVC.swift
//  dolphin
//
//  Created by Mihail Terekhov on 30.06.2021.
//

import UIKit

class DRootVC: UIViewController {

    private let sizeAspect: CGFloat = 3 / 7
    
    //  injections
    public var playerModule = UIViewController()
    public var playListModule = UIViewController()

    override func loadView() {
        super.loadView()
        
        createLayout()
    }
    
    private func createLayout() {
        view.backgroundColor = .white
        addChild(playerModule)
        addChild(playListModule)
        
        view.addSubview(playerModule.view)
        view.addSubview(playListModule.view)
        
        let dolphinLabel = UILabel(frame: .zero)
        dolphinLabel.translatesAutoresizingMaskIntoConstraints = false
        dolphinLabel.text = "Dolphin"
        dolphinLabel.textAlignment = .center
        dolphinLabel.backgroundColor = .systemGray
        view.addSubview(dolphinLabel)
        
        NSLayoutConstraint.activate([
            dolphinLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dolphinLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dolphinLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            playerModule.view.topAnchor.constraint(equalTo: dolphinLabel.bottomAnchor),
            playerModule.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerModule.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerModule.view.heightAnchor.constraint(equalToConstant: ceil(view.bounds.width * sizeAspect)),
            
            playListModule.view.topAnchor.constraint(equalTo: playerModule.view.bottomAnchor),
            playListModule.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playListModule.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playListModule.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
}
