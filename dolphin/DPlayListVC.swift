//
//  DPlayListVC.swift
//  dolphin
//
//  Created by Mihail Terekhov on 30.06.2021.
//

import UIKit

protocol DPlayListModuleInjection {
   
    func viewController() -> UIViewController
    
    func view() -> UIView

}

class DPlayListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DPlayListModuleInjection, DFilesBrowserDelegate {
    
    //  injections
    public var router: DPlayListRouterProtocol = DPlayListRouter()
    public var splitTimeService: DTimeSplitterServiceProtocol = DTimeSplitterService()
    public var playListService: DPlayListServiceProtocol = DPlayListService()
    public var rootModule: DRootModuleInjection?

    private let BottomButtonsHeight: CGFloat = 60
    private var tableView = UITableView(frame: .zero, style: .grouped)
    private var playList = DPlayList()
    private var selectedTrackIndex: Int = 0

    override func loadView() {
        super.loadView()
        
        createLayout()
    }
    
    // MARK: - DFilesBrowserDelegate -
    
    func selectedFiles(filesList: [URL]) {
        var selectFirstTrack = false
        if playList.tracksList.count == 0 {
            selectFirstTrack = true
        }
        playList = playListService.newPlayListWithFiles(playList: playList,
                                                        newFilesURLsList: filesList)
        reloadPlayList()
        router.closeFileBrowser(viewController: self)
        if let firstTrack = playList.tracksList.first,
           selectFirstTrack,
           let rootModule = rootModule {
            rootModule.trackSelectedFromPlayList(newTrack: firstTrack.track)
            selectedTrackIndex = 0
        }
    }
    
    func closeBrowser() {
        router.closeFileBrowser(viewController: self)
    }
    
    // MARK: - DPlayListModuleInjection -

    func viewController() -> UIViewController {
        return self
    }
    
    func view() -> UIView {
        return view
    }

    // MARK: - Handlers -
 
    @objc
    private func saveButtonTapped() {
        playListService.savePlayList(playList: playList)
    }

    @objc
    private func shuffleButtonTapped() {
        print("shuffle button tapped")
    }

    @objc
    private func repeatTracksButtonTapped() {
        print("repeats tracks button tapped")
    }

    @objc
    private func addTrackButtonTapped() {
        router.openFileBrowser(viewController: self, browserDelegate: self)
    }
    
    @objc
    private func clearPlayListButtonTapped() {
        playList = DPlayList()
        reloadPlayList()
    }
    
    // MARK: - Routine -

    private func createLayout() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        let bottomButtonsContainerView = UIView(frame: .zero)
        bottomButtonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomButtonsContainerView.backgroundColor = .cyan
        view.addSubview(bottomButtonsContainerView)
        
        let addTrackButton = UIButton(frame: .zero)
        addTrackButton.translatesAutoresizingMaskIntoConstraints = false
        addTrackButton.setImage(UIImage(named: "plus"), for: .normal)
        addTrackButton.addTarget(self, action: #selector(addTrackButtonTapped), for: .touchUpInside)
        bottomButtonsContainerView.addSubview(addTrackButton)
        
        let clearPlayListButton = UIButton(frame: .zero)
        clearPlayListButton.translatesAutoresizingMaskIntoConstraints = false
        clearPlayListButton.setImage(UIImage(named: "clear"), for: .normal)
        clearPlayListButton.addTarget(self, action: #selector(clearPlayListButtonTapped), for: .touchUpInside)
        bottomButtonsContainerView.addSubview(clearPlayListButton)

        let shuffleButton = UIButton(frame: .zero)
        shuffleButton.translatesAutoresizingMaskIntoConstraints = false
        shuffleButton.setImage(UIImage(named: "shuffle"), for: .normal)
        shuffleButton.addTarget(self, action: #selector(shuffleButtonTapped), for: .touchUpInside)
        bottomButtonsContainerView.addSubview(shuffleButton)
        
        let saveButton = UIButton(frame: .zero)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.backgroundColor = .systemGreen
        saveButton.layer.cornerRadius = ceil(BottomButtonsHeight / 2)
        saveButton.setTitle("S", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        bottomButtonsContainerView.addSubview(saveButton)
        
        let repeatTracksButton = UIButton(frame: .zero)
        repeatTracksButton.translatesAutoresizingMaskIntoConstraints = false
        repeatTracksButton.setImage(UIImage(named: "repeat"), for: .normal)
        repeatTracksButton.addTarget(self, action: #selector(repeatTracksButtonTapped), for: .touchUpInside)
        bottomButtonsContainerView.addSubview(repeatTracksButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomButtonsContainerView.topAnchor),
            
            bottomButtonsContainerView.heightAnchor.constraint(equalToConstant: BottomButtonsHeight),
            bottomButtonsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButtonsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomButtonsContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addTrackButton.topAnchor.constraint(equalTo: bottomButtonsContainerView.topAnchor),
            addTrackButton.bottomAnchor.constraint(equalTo: bottomButtonsContainerView.bottomAnchor),
            addTrackButton.leadingAnchor.constraint(equalTo: bottomButtonsContainerView.leadingAnchor),
            addTrackButton.widthAnchor.constraint(equalToConstant: BottomButtonsHeight),
            
            saveButton.topAnchor.constraint(equalTo: bottomButtonsContainerView.topAnchor),
            saveButton.bottomAnchor.constraint(equalTo: bottomButtonsContainerView.bottomAnchor),
            saveButton.leadingAnchor.constraint(equalTo: addTrackButton.trailingAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: BottomButtonsHeight),
            
            clearPlayListButton.topAnchor.constraint(equalTo: bottomButtonsContainerView.topAnchor),
            clearPlayListButton.bottomAnchor.constraint(equalTo: bottomButtonsContainerView.bottomAnchor),
            clearPlayListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            clearPlayListButton.widthAnchor.constraint(equalToConstant: BottomButtonsHeight),
            
            shuffleButton.topAnchor.constraint(equalTo: bottomButtonsContainerView.topAnchor),
            shuffleButton.bottomAnchor.constraint(equalTo: bottomButtonsContainerView.bottomAnchor),
            shuffleButton.trailingAnchor.constraint(equalTo: clearPlayListButton.leadingAnchor),
            shuffleButton.widthAnchor.constraint(equalToConstant: BottomButtonsHeight),

            repeatTracksButton.topAnchor.constraint(equalTo: bottomButtonsContainerView.topAnchor),
            repeatTracksButton.bottomAnchor.constraint(equalTo: bottomButtonsContainerView.bottomAnchor),
            repeatTracksButton.trailingAnchor.constraint(equalTo: shuffleButton.leadingAnchor),
            repeatTracksButton.widthAnchor.constraint(equalToConstant: BottomButtonsHeight)
       ])
    }
    
    private func reloadPlayList() {
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate -
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let rootModule = rootModule else {
            return
        }
        
        rootModule.trackSelectedFromPlayList(newTrack: playList.tracksList[indexPath.row].track)
        if let selectionoBlock = playList.tracksList[indexPath.row].selectionBlock {
            selectionoBlock()
        }
        if let deselectionoBlock = playList.tracksList[selectedTrackIndex].deselectionBlock {
            deselectionoBlock()
        }
        selectedTrackIndex = indexPath.row
    }
    
    // MARK: - UITableViewDataSource -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playList.tracksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = DPlayListCell(style: .default, reuseIdentifier: DPlayListCellID)
        
        newCell.contentView.backgroundColor = .clear
        newCell.configureCell(newTrackInfo: playList.tracksList[indexPath.row].track,
                              trackIndex: indexPath.row + 1,
                              splitTimeService: splitTimeService)
        playList.tracksList[indexPath.row].selectionBlock = {
            newCell.contentView.backgroundColor = .yellow
        }
        playList.tracksList[indexPath.row].deselectionBlock = {
            newCell.contentView.backgroundColor = .clear
        }

        if indexPath.row == selectedTrackIndex {
            newCell.contentView.backgroundColor = .yellow
        }
                
        return newCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 2 * FileCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        playList.tracksList.remove(at: indexPath.row)
        reloadPlayList()
    }
    
}
