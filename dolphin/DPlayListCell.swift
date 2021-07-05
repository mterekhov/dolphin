//
//  DPlayListCell.swift
//  dolphin
//
//  Created by Mihail Terekhov on 01.07.2021.
//

import UIKit

let DPlayListCellID = "PlayListCellID"

class DPlayListCell: UITableViewCell {
    
    private var trackInfo = DTrack()
    private let trackIndexLabel = UILabel(frame: .zero)
    private let trackTitleAndAuthorLabel = UILabel(frame: .zero)
    private let trackLengthLabel = UILabel(frame: .zero)
    
    private var trackIndexLabelWidthConstraint = NSLayoutConstraint()
    private var trackLengthLabelWidthConstraint = NSLayoutConstraint()
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(newTrackInfo: DTrack, trackIndex: Int, splitTimeService: DTimeSplitterServiceProtocol) {
        trackInfo = newTrackInfo
        
        trackIndexLabel.text = "\(trackIndex). "
        trackTitleAndAuthorLabel.text = "\(newTrackInfo.title) - \(newTrackInfo.author)"
        trackTitleAndAuthorLabel.numberOfLines = 0
        trackLengthLabel.text = splitTimeService.timeString(lengthInSeconds: newTrackInfo.length)
        
        trackIndexLabelWidthConstraint.constant = trackIndexLabel.intrinsicContentSize.width
        trackLengthLabelWidthConstraint.constant = trackLengthLabel.intrinsicContentSize.width
    }
    
    // MARK: - Routine -

    private func createLayout() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        trackIndexLabel.translatesAutoresizingMaskIntoConstraints = false
        trackIndexLabel.backgroundColor = .clear
        contentView.addSubview(trackIndexLabel)
        
        trackTitleAndAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        trackTitleAndAuthorLabel.backgroundColor = .clear
        contentView.addSubview(trackTitleAndAuthorLabel)
        
        trackLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        trackLengthLabel.backgroundColor = .clear
        contentView.addSubview(trackLengthLabel)
        
        trackIndexLabelWidthConstraint = trackIndexLabel.widthAnchor.constraint(equalToConstant: 0)
        trackLengthLabelWidthConstraint = trackLengthLabel.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            trackIndexLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackIndexLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            trackIndexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackIndexLabelWidthConstraint,
            
            trackTitleAndAuthorLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackTitleAndAuthorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            trackTitleAndAuthorLabel.leadingAnchor.constraint(equalTo: trackIndexLabel.trailingAnchor),
            trackTitleAndAuthorLabel.trailingAnchor.constraint(equalTo: trackLengthLabel.leadingAnchor),

            trackLengthLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackLengthLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            trackLengthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackLengthLabelWidthConstraint
        ])
    }

}
