//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import SwiftUI

@available(iOS 13.0, *)
/// A `UIViewControllerRepresentable` subclass which wraps `ChatChannelListVC` and shows list of channels.
public typealias ChatChannelListComponent = ChatChannelListVCComponent<NoExtraData>

/// A `UIViewControllerRepresentable` subclass which wraps `ChatChannelListVC` and shows list of channels.
public struct ChatChannelListVCComponent<ExtraData: ExtraDataTypes>: UIViewControllerRepresentable {
    /// The `ChatChannelListController` instance that provides channels data.
    let controller: ChatChannelListController

    public init(controller: ChatChannelListController) {
        self.controller = controller
    }

    public func makeUIViewController(context: Context) -> _ChatChannelListVC<NoExtraData> {
        let vc = _ChatChannelListVC<NoExtraData>()
        vc.controller = controller

        return vc
    }

    public func updateUIViewController(_ chatChannelListVC: _ChatChannelListVC<NoExtraData>, context: Context) {

    }
}
