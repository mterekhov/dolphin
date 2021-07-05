//
//  ViewController.swift
//  dolphin
//
//  Created by Mihail Terekhov on 30.06.2021.
//

import UIKit
import AVKit

protocol DPlayerModuleInjection {

    func playTrack(newTrack: DTrack)
    
    func viewController() -> UIViewController
    
    func view() -> UIView

}

class DPlayerVC: UIViewController, DPlayerModuleInjection {
 
    private let PlaybackButtonsSize: CGFloat = 40
    
    private let trackTitleLabel = UILabel(frame: .zero)
    private let stereoLabel = UILabel(frame: .zero)
    private let monoLabel = UILabel(frame: .zero)
    private let bitrateLabel = UILabel(frame: .zero)
    private let frequencyLabel = UILabel(frame: .zero)
    private let timeLabel = UILabel(frame: .zero)

    //  injections
    public var sizeService: DPlayerSizeServiceProtocol = DPlayerSizeService()
    public var splitTimeService: DTimeSplitterServiceProtocol = DTimeSplitterService()
    public var track = DTrack()
    
    override func loadView() {
        super.loadView()
        
        createLayout()
    }
    
    public func openTrack(newTrack: DTrack) {
        track = newTrack
        
        trackTitleLabel.text = "\(track.title) - \(track.author) (\(splitTimeService.timeString(lengthInSeconds: track.length)))"
        timeLabel.text = splitTimeService.timeString(lengthInSeconds: 0)
        frequencyLabel.text = "\(track.frequency) kHz"
        bitrateLabel.text = "\(track.bitrate) kbps"
    }
    
    //  MARK: - Layout -

    private func createLayout() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGreen
        
        let timingContainerView = createTimingContainer()
        view.addSubview(timingContainerView)
        
        let playbackContainerView = createPlaybackContainer()
        view.addSubview(playbackContainerView)

        let trackInfoContainerView = createTrackInfoContainer()
        view.addSubview(trackInfoContainerView)

        let miscContainerView = createMiscContainer()
        view.addSubview(miscContainerView)
        
        let timingHeight = sizeService.timingHeight()
        let timingWidth = sizeService.timingWidth()
        let trackInfoHeight = sizeService.trackInfoHeight()
        
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
    
    private func createMiscContainer() -> UIView {
        let miscContainerView = UIView(frame: .zero)
        
        miscContainerView.translatesAutoresizingMaskIntoConstraints = false
        miscContainerView.backgroundColor = .systemBlue
        
        let volumeSlider = UISlider(frame: .zero)
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeSlider.maximumValue = 100
        volumeSlider.minimumValue = 0
        volumeSlider.value = 80
        miscContainerView.addSubview(volumeSlider)
        
        let balanceSlider = UISlider(frame: .zero)
        balanceSlider.translatesAutoresizingMaskIntoConstraints = false
        balanceSlider.maximumValue = 2
        balanceSlider.minimumValue = 0
        balanceSlider.value = 1
        miscContainerView.addSubview(balanceSlider)
        
        let eqButton = UIButton(frame: .zero)
        eqButton.translatesAutoresizingMaskIntoConstraints = false
        eqButton.addTarget(self, action: #selector(eqButtonTapped), for: .touchUpInside)
        eqButton.setTitle("eq", for: .normal)
        miscContainerView.addSubview(eqButton)

        let miscWidth = sizeService.miscWidth()
        let buttonsWidth = ceil(miscWidth / 8)
        NSLayoutConstraint.activate([
            volumeSlider.topAnchor.constraint(equalTo: miscContainerView.topAnchor),
            volumeSlider.bottomAnchor.constraint(equalTo: miscContainerView.bottomAnchor),
            volumeSlider.leadingAnchor.constraint(equalTo: miscContainerView.leadingAnchor),
            volumeSlider.widthAnchor.constraint(equalToConstant: ceil(miscWidth / 2)),
            
            balanceSlider.topAnchor.constraint(equalTo: miscContainerView.topAnchor),
            balanceSlider.bottomAnchor.constraint(equalTo: miscContainerView.bottomAnchor),
            balanceSlider.leadingAnchor.constraint(equalTo: volumeSlider.trailingAnchor),
            balanceSlider.trailingAnchor.constraint(equalTo: eqButton.leadingAnchor),

            eqButton.topAnchor.constraint(equalTo: miscContainerView.topAnchor),
            eqButton.bottomAnchor.constraint(equalTo: miscContainerView.bottomAnchor),
            eqButton.trailingAnchor.constraint(equalTo: miscContainerView.trailingAnchor),
            eqButton.widthAnchor.constraint(equalToConstant: buttonsWidth),
        ])
        
        return miscContainerView
    }
    
    private func createTrackInfoContainer() -> UIView {
        let trackInfoContainerView = UIView(frame: .zero)
        
        trackInfoContainerView.translatesAutoresizingMaskIntoConstraints = false
        trackInfoContainerView.backgroundColor = .systemGreen
        
        trackTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        trackTitleLabel.backgroundColor = .clear
        trackInfoContainerView.addSubview(trackTitleLabel)
        
        stereoLabel.text = "stereo"
        stereoLabel.translatesAutoresizingMaskIntoConstraints = false
        stereoLabel.backgroundColor = .clear
        trackInfoContainerView.addSubview(stereoLabel)
        
        monoLabel.text = "mono"
        monoLabel.translatesAutoresizingMaskIntoConstraints = false
        monoLabel.backgroundColor = .clear
        trackInfoContainerView.addSubview(monoLabel)
        
        bitrateLabel.translatesAutoresizingMaskIntoConstraints = false
        bitrateLabel.backgroundColor = .clear
        trackInfoContainerView.addSubview(bitrateLabel)
        
        frequencyLabel.translatesAutoresizingMaskIntoConstraints = false
        frequencyLabel.backgroundColor = .clear
        trackInfoContainerView.addSubview(frequencyLabel)
        
        NSLayoutConstraint.activate([
            trackTitleLabel.topAnchor.constraint(equalTo: trackInfoContainerView.topAnchor),
            trackTitleLabel.leadingAnchor.constraint(equalTo: trackInfoContainerView.leadingAnchor),
            trackTitleLabel.trailingAnchor.constraint(equalTo: trackInfoContainerView.trailingAnchor),
            
            stereoLabel.topAnchor.constraint(equalTo: trackTitleLabel.bottomAnchor),
            stereoLabel.trailingAnchor.constraint(equalTo: trackInfoContainerView.trailingAnchor),
            stereoLabel.bottomAnchor.constraint(equalTo: trackInfoContainerView.bottomAnchor),
            
            monoLabel.topAnchor.constraint(equalTo: trackTitleLabel.bottomAnchor),
            monoLabel.trailingAnchor.constraint(equalTo: stereoLabel.leadingAnchor),
            monoLabel.bottomAnchor.constraint(equalTo: trackInfoContainerView.bottomAnchor),
            
            bitrateLabel.topAnchor.constraint(equalTo: trackTitleLabel.bottomAnchor),
            bitrateLabel.leadingAnchor.constraint(equalTo: trackInfoContainerView.leadingAnchor),
            bitrateLabel.bottomAnchor.constraint(equalTo: trackInfoContainerView.bottomAnchor),
            
            frequencyLabel.topAnchor.constraint(equalTo: trackTitleLabel.bottomAnchor),
            frequencyLabel.leadingAnchor.constraint(equalTo: bitrateLabel.trailingAnchor),
            frequencyLabel.bottomAnchor.constraint(equalTo: trackInfoContainerView.bottomAnchor),
        ])
        
        return trackInfoContainerView
    }
    
    private func createTimingContainer() -> UIView {
        let timingContainerView = UIView(frame: .zero)
        timingContainerView.translatesAutoresizingMaskIntoConstraints = false
        timingContainerView.backgroundColor = .systemYellow
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textAlignment = .center
        timingContainerView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: timingContainerView.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: timingContainerView.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: timingContainerView.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: timingContainerView.bottomAnchor)
        ])

        return timingContainerView
    }

    private func createPlaybackContainer() -> UIView {
        let playbackContainerView = UIView(frame: .zero)
        
        playbackContainerView.translatesAutoresizingMaskIntoConstraints = false
        playbackContainerView.backgroundColor = .systemRed

        let trackTimeSlider = UISlider(frame: .zero)
        trackTimeSlider.translatesAutoresizingMaskIntoConstraints = false
        trackTimeSlider.maximumValue = 5
        trackTimeSlider.minimumValue = 0
        trackTimeSlider.value = 3.4
        playbackContainerView.addSubview(trackTimeSlider)
        
        let playbackButtonsContainer = createPlaybackButtonsContainer()
        playbackContainerView.addSubview(playbackButtonsContainer)

        NSLayoutConstraint.activate([
            trackTimeSlider.topAnchor.constraint(equalTo: playbackContainerView.topAnchor),
            trackTimeSlider.leadingAnchor.constraint(equalTo: playbackContainerView.leadingAnchor),
            trackTimeSlider.trailingAnchor.constraint(equalTo: playbackContainerView.trailingAnchor),
            trackTimeSlider.bottomAnchor.constraint(equalTo: playbackContainerView.centerYAnchor),
            
            playbackButtonsContainer.topAnchor.constraint(equalTo: trackTimeSlider.bottomAnchor),
            playbackButtonsContainer.leadingAnchor.constraint(equalTo: playbackContainerView.leadingAnchor),
            playbackButtonsContainer.trailingAnchor.constraint(equalTo: playbackContainerView.trailingAnchor),
            playbackButtonsContainer.bottomAnchor.constraint(equalTo: playbackContainerView.bottomAnchor),
        ])

        return playbackContainerView
    }
    
    private func createPlaybackButtonsContainer() -> UIView {
        let buttonsContainer = UIView(frame: .zero)
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let playButton = UIButton(frame: .zero)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        buttonsContainer.addSubview(playButton)
        
        let pauseButton = UIButton(frame: .zero)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        buttonsContainer.addSubview(pauseButton)
        
        let stopButton = UIButton(frame: .zero)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.setImage(UIImage(named: "stop"), for: .normal)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        buttonsContainer.addSubview(stopButton)
        
        let nextTrackButton = UIButton(frame: .zero)
        nextTrackButton.translatesAutoresizingMaskIntoConstraints = false
        nextTrackButton.setImage(UIImage(named: "next"), for: .normal)
        nextTrackButton.addTarget(self, action: #selector(nextTrackButtonTapped), for: .touchUpInside)
        buttonsContainer.addSubview(nextTrackButton)
        
        let previousTrackButton = UIButton(frame: .zero)
        previousTrackButton.translatesAutoresizingMaskIntoConstraints = false
        previousTrackButton.setImage(UIImage(named: "previous"), for: .normal)
        previousTrackButton.addTarget(self, action: #selector(previousTrackButtonTapped), for: .touchUpInside)
        buttonsContainer.addSubview(previousTrackButton)
        
        NSLayoutConstraint.activate([
            previousTrackButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            previousTrackButton.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor),
            previousTrackButton.widthAnchor.constraint(equalToConstant: PlaybackButtonsSize),
            previousTrackButton.heightAnchor.constraint(equalToConstant: PlaybackButtonsSize),

            playButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            playButton.leadingAnchor.constraint(equalTo: previousTrackButton.trailingAnchor),
            playButton.widthAnchor.constraint(equalToConstant: PlaybackButtonsSize),
            playButton.heightAnchor.constraint(equalToConstant: PlaybackButtonsSize),

            pauseButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            pauseButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor),
            pauseButton.widthAnchor.constraint(equalToConstant: PlaybackButtonsSize),
            pauseButton.heightAnchor.constraint(equalToConstant: PlaybackButtonsSize),

            stopButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            stopButton.leadingAnchor.constraint(equalTo: pauseButton.trailingAnchor),
            stopButton.widthAnchor.constraint(equalToConstant: PlaybackButtonsSize),
            stopButton.heightAnchor.constraint(equalToConstant: PlaybackButtonsSize),

            nextTrackButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            nextTrackButton.leadingAnchor.constraint(equalTo: stopButton.trailingAnchor),
            nextTrackButton.widthAnchor.constraint(equalToConstant: PlaybackButtonsSize),
            nextTrackButton.heightAnchor.constraint(equalToConstant: PlaybackButtonsSize),
        ])

        return buttonsContainer
    }
    
    //  MARK: - DPlayerModuleInjection -

    func playTrack(newTrack: DTrack) {
        openTrack(newTrack: newTrack)
    }

    func viewController() -> UIViewController {
        return self
    }
    
    func view() -> UIView {
        return view
    }

    //  MARK: - Handlers -

    @objc
    private func eqButtonTapped() {
        print("eq button tapped")
    }

    @objc
    private func playButtonTapped() {
        print("play button tapped")
    }

    @objc
    private func pauseButtonTapped() {
        print("pause button tapped")
    }

    @objc
    private func stopButtonTapped() {
        print("stop button tapped")
    }

    @objc
    private func nextTrackButtonTapped() {
        print("next track button tapped")
    }

    @objc
    private func previousTrackButtonTapped() {
        print("previous track button tapped")
    }

}
