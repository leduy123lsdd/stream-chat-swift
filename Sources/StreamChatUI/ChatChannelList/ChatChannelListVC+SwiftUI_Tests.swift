//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import StreamChatTestTools
@testable import StreamChatUI
import XCTest

@available(iOS 13.0, *)
class ChatChannelListVCComponent_Tests: XCTestCase {
    var component: ChatChannelListComponent!
    var mockedChannelListController: ChatChannelListController_Mock<NoExtraData>!
    var vc: ChatChannelListVC!

    override func setUp() {
        super.setUp()
        mockedChannelListController = ChatChannelListController_Mock.mock()
        component = ChatChannelListComponent(controller: mockedChannelListController)

        let testVC = ChatChannelListVC()
        vc = testVC

        vc.controller = mockedChannelListController
    }

    func test_channels_arePopulated() {
        let channel1 = ChatChannel.mock(
            cid: .unique,
            name: "Channel 1",
            imageURL: TestImages.yoda.url
        )

        let channel2 = ChatChannel.mock(
            cid: .unique,
            name: "Channel 2",
            imageURL: TestImages.vader.url
        )

        mockedChannelListController.simulate(channels: [channel1, channel2], changes: [])

        XCTAssertEqual(component.controller.channels, vc.controller.channels)
    }
}
