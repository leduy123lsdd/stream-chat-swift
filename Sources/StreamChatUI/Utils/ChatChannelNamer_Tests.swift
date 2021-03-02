//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import StreamChatTestTools
@testable import StreamChatUI
import XCTest

class ChatChannelNamer_Tests: XCTestCase {

    var defaultMembers: Set<_ChatChannelMember<NoExtraData>>!

    override func setUp() {
        super.setUp()
        
        defaultMembers = [
            .mock(
                id: .unique,
                name: "Darth Vader",
                imageURL: nil,
                isOnline: true
            ),
            .mock(
                id: .unique,
                name: "Darth Maul",
                imageURL: nil,
                isOnline: true
            ),
            .mock(
                id: .unique,
                name: "Kylo Ren",
                imageURL: nil,
                isOnline: true
            )
        ]
    }

    func test_defaultChannelNamer_whenChannelHasName_showsChannelName() {
        // Create channel and currentUserId
        let channel = ChatChannel.mock(
            cid: .unique,
            name: "Darth Channel",
            imageURL: TestImages.vader.url,
            members: defaultMembers
        )

        let currentUserId: String = .unique
        let namer: ChatChannelNamer<NoExtraData> = DefaultChatChannelNamer()
        let nameForChannel = namer(channel, currentUserId)

        XCTAssert(nameForChannel == "Darth Channel")
    }

    func test_defaultChannelNamer_directChannel_whenChannelHasNoName_showsCurrentMembers() {
        // Create channel and currentUserId

        defaultMembers = [
            .mock(
                id: .unique,
                name: "Darth Vader",
                imageURL: nil,
                isOnline: true
            ),
            .mock(
                id: .unique,
                name: "Darth Maul",
                imageURL: nil,
                isOnline: true
            )
        ]

        let channel = ChatChannel.mockDMChannel(
            name: nil,
            members: defaultMembers
        )

        let currentUserId: String = .unique

        let namer: ChatChannelNamer<NoExtraData> = DefaultChatChannelNamer()
        let nameForChannel = namer(channel, currentUserId)

        XCTAssert(nameForChannel == "Darth Maul, Darth Vader")
    }

    func test_defaultChannelNamer_directChannel_whenChannelHasNoName_whenChannelHasNoMembers_showsCurrentUserId() {
        // Create channel and currentUserId
        let channel = ChatChannel.mockDMChannel(
            name: nil
        )

        let currentUserId: String = "current user :)"

        let namer: ChatChannelNamer<NoExtraData> = DefaultChatChannelNamer()
        let nameForChannel = namer(channel, currentUserId)

        XCTAssert(nameForChannel == nil)
    }

    func test_defaultChannelNamer_directChannel_whenChannelHasNoName_whenChannelHasOnlyCurrentMember_showsCurrentMemberName() {
        // Create channel and currentUserId
        let currentUser: _ChatChannelMember<NoExtraData> = .mock(id: "current user :)", name: "Luke Skywalker")

        let channel = ChatChannel.mockDMChannel(
            name: nil,
            members: [currentUser]
        )

        let currentUserId: String = "current user :)"

        let namer: ChatChannelNamer<NoExtraData> = DefaultChatChannelNamer()
        let nameForChannel = namer(channel, currentUserId)

        XCTAssert(nameForChannel == currentUser.name)
    }

    func test_defaultChannelNamer_directChannel_whenChannelHasNoName_andMoreThan2Members_showsMembersAndNMore() {
        // Create channel and currentUserId
        let channel = ChatChannel.mockDMChannel(
            name: nil,
            members: defaultMembers
        )

        let currentUserId: String = .unique

        let namer: ChatChannelNamer<NoExtraData> = DefaultChatChannelNamer()
        let nameForChannel = namer(channel, currentUserId)

        XCTAssert(nameForChannel == "Darth Maul, Darth Vader and 1 more")
    }
    
    func test_defaultChannelNamer_whenChannelHasNoName_AndNotDM_showsChannelCID() {
        // Create channel ID, channel and currentUserId
        let channelID = "cid"

        let channel = ChatChannel.mock(
            cid: ChannelId(type: .gaming, id: channelID),
            name: nil
        )

        let currentUserId: String = .unique

        let namer: ChatChannelNamer<NoExtraData> = DefaultChatChannelNamer()
        let nameForChannel = namer(channel, currentUserId)

        XCTAssert(nameForChannel == channelID)
    }

}
