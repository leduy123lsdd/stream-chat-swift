//
// Copyright © 2020 Stream.io Inc. All rights reserved.
//

import Foundation

/// A type representing a chat message attachment. `ChatMessageAttachment` is an immutable snapshot of a
/// chat message attachment entity at the given time.
///
/// - Note: `ChatMessageAttachment` is a typealias of `_ChatMessageAttachment` with default extra data.
/// If you're using custom extra data, create your own typealias of `_ChatMessageAttachment`.
///
/// Learn more about using custom extra data in our [cheat sheet](https://github.com/GetStream/stream-chat-swift/wiki/StreamChat-SDK-Cheat-Sheet#working-with-extra-data).
///
public typealias ChatMessageAttachment = _ChatMessageAttachment<DefaultExtraData>

extension _ChatMessageAttachment {
    /// A type designed to combine all the information required to create `_ChatMessageAttachment`.
    public struct Seed: Hashable {
        /// A local url the data for uploading will be taken from.
        /// When an attachment in uploaded and a message is sent the `localURL` of resulting
        /// `_ChatMessageAttachment` will be equal to this value.
        public let localURL: URL
        /// When the attachment is created the filename will be available under `_ChatMessageAttachment.title` field.
        /// A `localURL.lastPathComponent` might be a good option.
        public let fileName: String
        /// An attachment type (see `AttachmentType`).
        public let type: AttachmentType
        /// An extra data for the attachment.
        public let extraData: ExtraData.Attachment

        public init(
            localURL: URL,
            fileName: String,
            type: AttachmentType,
            extraData: ExtraData.Attachment
        ) {
            self.localURL = localURL
            self.fileName = fileName
            self.type = type
            self.extraData = extraData
        }
    }
}

/// A type representing a chat message attachment. `_ChatMessageAttachment` is an immutable snapshot of a
/// chat message attachment entity at the given time.
///
/// - Note: `_ChatMessageAttachment` type is not meant to be used directly. If you're using default extra data,
/// use`ChatMessageAttachment` typealias instead. If you're using custom extra data,
/// create your own typealias of `_ChatMessageAttachment`.
///
/// Learn more about using custom extra data in our [cheat sheet](https://github.com/GetStream/stream-chat-swift/wiki/StreamChat-SDK-Cheat-Sheet#working-with-extra-data).
///
@dynamicMemberLookup
public struct _ChatMessageAttachment<ExtraData: ExtraDataTypes>: Hashable {
    /// A title for the attachment.
    public let title: String
    /// An author generated by backend after enriching URL. (e.g `YouTube`)
    public let author: String?
    /// A description text.
    public let text: String?
    /// A type (see `AttachmentType`).
    public let type: AttachmentType
    /// Actions from a command (see `Action`, `Command`).
    public let actions: [AttachmentAction]
    /// A URL. Depends on type of the attachment (e.g. some asset URL, enriched URL, title URL)
    public let url: URL?
    /// An image URL.
    public let imageURL: URL?
    /// An image preview URL.
    public let imagePreviewURL: URL?
    /// A file description (see `AttachmentFile`).
    public let file: AttachmentFile?
    /// An extra data for the attachment.
    public let extraData: ExtraData.Attachment
    
    public init(
        title: String,
        author: String?,
        text: String?,
        type: AttachmentType,
        actions: [AttachmentAction],
        url: URL?,
        imageURL: URL?,
        imagePreviewURL: URL?,
        file: AttachmentFile?,
        extraData: ExtraData.Attachment
    ) {
        self.title = title
        self.author = author
        self.text = text
        self.type = type
        self.actions = actions
        self.url = url
        self.imageURL = imageURL
        self.imagePreviewURL = imagePreviewURL
        self.file = file
        self.extraData = extraData
    }
        
    var hash: String {
        [title, author, text, type.rawValue, url?.absoluteString, imageURL?.absoluteString]
            .compactMap { $0 }
            .reduce("", +)
    }
}

/// An attachment action, e.g. send, shuffle.
public struct AttachmentAction: Codable, Hashable {
    /// A name.
    public let name: String
    /// A value of an action.
    public let value: String
    /// A style, e.g. primary button.
    public let style: ActionStyle
    /// A type, e.g. button.
    public let type: ActionType
    /// A text.
    public let text: String
    
    /// Init an attachment action.
    /// - Parameters:
    ///   - name: a name.
    ///   - value: a value.
    ///   - style: a style.
    ///   - type: a type.
    ///   - text: a text.
    public init(
        name: String,
        value: String,
        style: ActionStyle,
        type: ActionType,
        text: String
    ) {
        self.name = name
        self.value = value
        self.style = style
        self.type = type
        self.text = text
    }
    
    /// An attachment action type, e.g. button.
    public enum ActionType: String, Codable {
        case button
    }

    /// An attachment action style, e.g. primary button.
    public enum ActionStyle: String, Codable {
        case `default`
        case primary
    }
}

/// An attachment type.
/// There are some predefined types on backend but any type can be introduced and sent to backend.
public enum AttachmentType: RawRepresentable, Codable, Hashable, ExpressibleByStringLiteral {
    /// Backend specified types.
    case image
    case imgur
    case giphy
    case video
    case audio
    
    /// Custom types.
    case youtube
    case product
    case file
    case link
    case custom(String?)
    
    public var rawValue: String? {
        switch self {
        case let .custom(raw):
            return raw
        case .image:
            return "image"
        case .imgur:
            return "imgur"
        case .giphy:
            return "giphy"
        case .video:
            return "video"
        case .audio:
            return "audio"
        case .youtube:
            return "youtube"
        case .product:
            return "product"
        case .file:
            return "file"
        case .link:
            return "link"
        }
    }
        
    public init(rawValue: String?) {
        switch rawValue {
        case "image":
            self = .image
        case "imgur":
            self = .imgur
        case "giphy":
            self = .giphy
        case "video":
            self = .video
        case "audio":
            self = .audio
        case "youtube":
            self = .youtube
        case "product":
            self = .product
        case "file":
            self = .file
        case "link":
            self = .link
        default:
            self = .custom(rawValue)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        self = AttachmentType(rawValue: rawValue)
    }
    
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

/// An attachment file description.
public struct AttachmentFile: Codable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case mimeType = "mime_type"
        case size = "file_size"
    }
    
    /// An attachment file type (see `AttachmentFileType`).
    public let type: AttachmentFileType
    /// A size of the file.
    public let size: Int64
    /// A mime type.
    public let mimeType: String?
    /// A file size formatter.
    public static let sizeFormatter = ByteCountFormatter()
    
    /// A formatted file size.
    public var sizeString: String { AttachmentFile.sizeFormatter.string(fromByteCount: size) }
    
    /// Init an attachment file.
    /// - Parameters:
    ///   - type: a file type.
    ///   - size: a file size.
    ///   - mimeType: a mime type.
    public init(type: AttachmentFileType, size: Int64, mimeType: String?) {
        self.type = type
        self.size = size
        self.mimeType = mimeType
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mimeType = try? container.decodeIfPresent(String.self, forKey: .mimeType)
        
        if let mimeType = mimeType {
            type = AttachmentFileType(mimeType: mimeType)
        } else {
            type = .generic
        }
        
        if let size = try? container.decodeIfPresent(Int64.self, forKey: .size) {
            self.size = size
        } else if let floatSize = try? container.decodeIfPresent(Float64.self, forKey: .size) {
            size = Int64(floatSize.rounded())
        } else {
            size = 0
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(size, forKey: .size)
        try container.encodeIfPresent(mimeType, forKey: .mimeType)
    }
}

/// An attachment file type.
public enum AttachmentFileType: String, Codable, Equatable {
    /// A file attachment type.
    case generic, csv, doc, pdf, ppt, tar, xls, zip, mp3, mp4, mov, jpeg, png, gif
    
    private static let mimeTypes: [String: AttachmentFileType] = [
        "application/octet-stream": .generic,
        "text/csv": .csv,
        "application/msword": .doc,
        "application/pdf": .pdf,
        "application/vnd.ms-powerpoint": .ppt,
        "application/x-tar": .tar,
        "application/vnd.ms-excel": .xls,
        "application/zip": .zip,
        "audio/mp3": .mp3,
        "video/mp4": .mp4,
        "video/quicktime": .mov,
        "image/jpeg": .jpeg,
        "image/jpg": .jpeg,
        "image/png": .png,
        "image/gif": .gif
    ]
    
    /// Init an attachment file type by mime type.
    ///
    /// - Parameter mimeType: a mime type.
    public init(mimeType: String) {
        self = AttachmentFileType.mimeTypes[mimeType, default: .generic]
    }
    
    /// Init an attachment file type by a file extension.
    ///
    /// - Parameter ext: a file extension.
    public init(ext: String) {
        if ext == "jpg" {
            self = .jpeg
            return
        }
        
        self = AttachmentFileType(rawValue: ext) ?? .generic
    }
    
    /// Returns a mime type for the file type.
    public var mimeType: String {
        if self == .jpeg {
            return "image/jpeg"
        }
        
        return AttachmentFileType.mimeTypes.first(where: { $1 == self })?.key ?? "application/octet-stream"
    }
}

/// You need to make your custom type conforming to this protocol if you want to use it for extending
/// `ChatMessageAttachment` entity with your custom additional data.
///
/// Learn more about using custom extra data in our [cheat sheet](https://github.com/GetStream/stream-chat-swift/wiki/StreamChat-SDK-Cheat-Sheet#working-with-extra-data).
///
public protocol AttachmentExtraData: ExtraData {}

public extension _ChatMessageAttachment {
    subscript<T>(dynamicMember keyPath: KeyPath<ExtraData.Attachment, T>) -> T {
        extraData[keyPath: keyPath]
    }
}
