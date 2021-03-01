//
//  Copyright © 2021 Stream.io Inc. All rights reserved.
//

import UIKit
import StreamChatUI

final class SlackChatChannelListItemView: ChatChannelListItemView {
    private lazy var _timestampLabel = UILabel()
    
    override func setUpAppearance() {
        super.setUpAppearance()
        
        avatarView.layer.cornerRadius = 4
    }
    
    override func setUpLayout() {
        super.setUpLayout()
        
        NSLayoutConstraint.activate([
            avatarView.heightAnchor.constraint(equalToConstant: 35),
            avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor),
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
        ])
    }
    
    override func updateContent() {
        super.updateContent()

    }
}
