//
//  DRootVC.swift
//  dolphin
//
//  Created by Mihail Terekhov on 30.06.2021.
//

import UIKit

protocol DRootModuleInjection {
    
    func trackSelectedFromPlayList(newTrack: DTrack)
    
}

class DRootVC: UIViewController, DRootModuleInjection {
    
    private let sizeAspect: CGFloat = 3 / 7
    
    //  injections
    public var playerModule: DPlayerModuleInjection?
    public var playListModule: DPlayListModuleInjection?
    
    override func loadView() {
        super.loadView()
        
        createLayout()
    }
    
    //  MARK: - PlayerModuleInjection -
    
    func trackSelectedFromPlayList(newTrack: DTrack) {
        print("player is going to playback new track")
    }
    
    //  MARK: - Routine -
    
    private func createLayout() {
        view.backgroundColor = .white
        
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
            
        ])
        
        var playerView = UIView(frame: .zero)
        if let playerModule = playerModule {
            addChild(playerModule.viewController())
            playerView = playerModule.view()
            view.addSubview(playerView)
            NSLayoutConstraint.activate([
                playerView.topAnchor.constraint(equalTo: dolphinLabel.bottomAnchor),
                playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                playerView.heightAnchor.constraint(equalToConstant: ceil(view.bounds.width * sizeAspect)),
            ])
        }
        
        if let playListModule = playListModule {
            addChild(playListModule.viewController())
            let playListView = playListModule.view()
            view.addSubview(playListView)
            NSLayoutConstraint.activate([
                playListView.topAnchor.constraint(equalTo: playerView.bottomAnchor),
                playListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                playListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                playListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
    }
    
}
