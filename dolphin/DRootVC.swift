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
        guard let playerModule = playerModule else {
            return
        }
        
        playerModule.playTrack(newTrack: newTrack)
    }
    
    //  MARK: - Routine -
    
    private func createLabel(title: String) -> UILabel {
        let newLabel = UILabel(frame: .zero)
        
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.text = title
        newLabel.textAlignment = .center
        newLabel.backgroundColor = .systemGray
        
        return newLabel
    }
    
    private func createLayout() {
        view.backgroundColor = .white
        
        let dolphinLabel = createLabel(title: "Dolpin")
        view.addSubview(dolphinLabel)
        NSLayoutConstraint.activate([
            dolphinLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dolphinLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dolphinLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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

            let playListLabel = createLabel(title: "PlayList")
            view.addSubview(playListLabel)

            NSLayoutConstraint.activate([
                playListView.topAnchor.constraint(equalTo: playListLabel.bottomAnchor),
                playListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                playListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                playListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                playListLabel.topAnchor.constraint(equalTo: playerView.bottomAnchor),
                playListLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                playListLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }
    
}
