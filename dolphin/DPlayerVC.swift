//
//  ViewController.swift
//  dolphin
//
//  Created by Mihail Terekhov on 30.06.2021.
//

import UIKit

class DPlayerVC: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        createLayout()
    }
    
    private func createLayout() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGreen
        
        let timingContainerView = UIView(frame: .zero)
        timingContainerView.translatesAutoresizingMaskIntoConstraints = false
        timingContainerView.backgroundColor = .systemYellow
        view.addSubview(timingContainerView)
        
        let playbackContainerView = UIView(frame: .zero)
        playbackContainerView.translatesAutoresizingMaskIntoConstraints = false
        playbackContainerView.backgroundColor = .systemRed
        view.addSubview(playbackContainerView)

        let trackInfoContainerView = UIView(frame: .zero)
        trackInfoContainerView.translatesAutoresizingMaskIntoConstraints = false
        trackInfoContainerView.backgroundColor = .systemGreen
        view.addSubview(trackInfoContainerView)

        let miscContainerView = UIView(frame: .zero)
        miscContainerView.translatesAutoresizingMaskIntoConstraints = false
        miscContainerView.backgroundColor = .systemBlue
        view.addSubview(miscContainerView)
        
        let moduleWidth: CGFloat = view.bounds.width
        let moduleHeight: CGFloat = ceil(moduleWidth * 2 / 5)
        let timingHeight: CGFloat = ceil(moduleHeight * 1 / 2)
        let timingWidth: CGFloat = ceil(moduleWidth * 1 / 3)
        let trackInfoHeight: CGFloat = ceil(timingHeight * 2 / 3)
        
        NSLayoutConstraint.activate([
                timingContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            timingContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timingContainerView.widthAnchor.constraint(equalToConstant: timingWidth),
            timingContainerView.heightAnchor.constraint(equalToConstant: timingHeight),
            
            playbackContainerView.topAnchor.constraint(equalTo: timingContainerView.bottomAnchor),
            playbackContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playbackContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playbackContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            trackInfoContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            trackInfoContainerView.leadingAnchor.constraint(equalTo: timingContainerView.trailingAnchor),
            trackInfoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackInfoContainerView.heightAnchor.constraint(equalToConstant: trackInfoHeight),

            miscContainerView.leadingAnchor.constraint(equalTo: timingContainerView.trailingAnchor),
            miscContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            miscContainerView.topAnchor.constraint(equalTo: trackInfoContainerView.bottomAnchor),
            miscContainerView.bottomAnchor.constraint(equalTo: playbackContainerView.topAnchor)
        ])
    }

}
