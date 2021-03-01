//
//  Copyright © 2021 Stream.io Inc. All rights reserved.
//

import UIKit
import StreamChat
import StreamChatUI

final class SlackChatChannelListViewController: ChatChannelListVC {
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let channelListController = ChatClient
            .shared
            .channelListController(
                query: ChannelListQuery(
                    filter: .containMembers(
                        userIds: [ChatClient.shared.currentUserId!]
                    )
                )
            )
        self.controller = channelListController
    }
    
    override func setUpLayout() {
        let titleView = UIView()
        titleView.backgroundColor = Colors.primary
        titleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = "Direct messages"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -15),
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func setUpAppearance() {
        super.setUpAppearance()
        
        title = "Messages"
        
        userAvatarView.isHidden = true
        navigationItem.searchController = UISearchController()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
        
        createNewChannelButton
            .setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        
        view.directionalLayoutMargins.leading = 24
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    @objc
    private func editButtonTapped() {
    }
}
