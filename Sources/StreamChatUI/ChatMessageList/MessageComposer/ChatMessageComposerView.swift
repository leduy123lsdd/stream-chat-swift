//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import UIKit

public typealias ChatMessageComposerView = _ChatMessageComposerView<NoExtraData>

open class _ChatMessageComposerView<ExtraData: ExtraDataTypes>: _View,
    UIConfigProvider {
    // MARK: - Properties
    
    public var attachmentsViewHeight: CGFloat = .zero
    public var stateIconHeight: CGFloat = .zero
    
    // MARK: - Subviews

    /// Container for all components inside this composer.
    public private(set) lazy var stackContainer: UIStackView = {
        let stack = UIStackView().withoutAutoresizingMaskConstraints
        stack.spacing = UIStackView.spacingUseSystem
        return stack
    }()

    /// Container for `stateIcon`, `dismissButton` and `titleLabel` which are header view in composer
    public private(set) lazy var headerView: UIView = UIView().withoutAutoresizingMaskConstraints

    /// Container for `stateIcon`, `dismissButton` and `titleLabel` which are header view in composer
    public private(set) lazy var attachmentContainerStackView: UIStackView = {
        let stack = UIStackView().withoutAutoresizingMaskConstraints
        stack.spacing = UIStackView.spacingUseSystem
        return stack
    }()

    public private(set) lazy var attachmentOptionsStackView: UIStackView = {
        let stack = UIStackView().withoutAutoresizingMaskConstraints
        stack.spacing = UIStackView.spacingUseSystem
        stack.axis = .horizontal
        return stack
    }()

    public private(set) lazy var composerStackView: UIStackView = {
        let stack = UIStackView().withoutAutoresizingMaskConstraints
        stack.spacing = UIStackView.spacingUseSystem
        stack.axis = .horizontal
        return stack
    }()

    public private(set) lazy var quotedMessageView = uiConfig
        .messageComposer
        .quotedMessageView.init()
        .withoutAutoresizingMaskConstraints
    
    public private(set) lazy var imageAttachmentsView = uiConfig
        .messageComposer
        .imageAttachmentsView.init()
        .withoutAutoresizingMaskConstraints
    
    public private(set) lazy var documentAttachmentsView = uiConfig
        .messageComposer
        .documentAttachmentsView.init()
        .withoutAutoresizingMaskConstraints
    
    public private(set) lazy var messageInputView = uiConfig
        .messageComposer
        .messageInputView.init()
        .withoutAutoresizingMaskConstraints
    
    public private(set) lazy var sendButton = uiConfig
        .messageComposer
        .sendButton.init()
        .withoutAutoresizingMaskConstraints
    
    public private(set) lazy var attachmentButton: UIButton = uiConfig
        .messageComposer
        .composerButton.init()
        .withoutAutoresizingMaskConstraints
    
    public private(set) lazy var commandsButton: UIButton = uiConfig
        .messageComposer
        .composerButton.init()
        .withoutAutoresizingMaskConstraints
    
    public private(set) lazy var shrinkInputButton: UIButton = uiConfig
        .messageComposer
        .composerButton.init()
        .withoutAutoresizingMaskConstraints

    /// Icon detecting if we are editing or replying to some message most left icon on header
    public private(set) lazy var stateIcon: UIImageView = {
        let imageView = UIImageView().withoutAutoresizingMaskConstraints
        imageView.contentMode = .center
        imageView.widthAnchor.pin(equalTo: imageView.heightAnchor, multiplier: 1).isActive = true
        return imageView
    }()

    /// Button for dismissing for example editing message
    public private(set) lazy var dismissButton: UIButton = uiConfig
        .messageComposer
        .composerButton.init()
        .withoutAutoresizingMaskConstraints

    /// Title of action for the given message, for example `Edit Message`
    public private(set) lazy var titleLabel: UILabel = UILabel()
        .withoutAutoresizingMaskConstraints
    
    public private(set) lazy var checkmarkControl: _ChatMessageComposerCheckmarkControl<ExtraData> = uiConfig
        .messageComposer
        .checkmarkControl.init()
        .withoutAutoresizingMaskConstraints
    
    // MARK: - Overrides
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        
        setUp()
        setUpLayout()
        (self as! Self).applyDefaultAppearance()
        setUpAppearance()
        updateContent()
    }

    // MARK: - Public
    
    override public func defaultAppearance() {
        super.defaultAppearance()
        stateIconHeight = 40
        
        setContentHuggingPriority(.required, for: .vertical)
        
        backgroundColor = uiConfig.colorPalette.popoverBackground

        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 0.5

        attachmentContainerStackView.clipsToBounds = true
        attachmentContainerStackView.layer.cornerRadius = 25
        attachmentContainerStackView.layer.borderWidth = 1
        attachmentContainerStackView.layer.borderColor = uiConfig.colorPalette.border.cgColor
        
        let clipIcon = uiConfig.images.messageComposerFileAttachment.tinted(with: uiConfig.colorPalette.inactiveTint)
        attachmentButton.setImage(clipIcon, for: .normal)
        
        let boltIcon = uiConfig.images.messageComposerCommand.tinted(with: uiConfig.colorPalette.inactiveTint)
        commandsButton.setImage(boltIcon, for: .normal)
        
        let shrinkArrowIcon = uiConfig.images.messageComposerShrinkInput
        shrinkInputButton.setImage(shrinkArrowIcon, for: .normal)
        
        let dismissIcon = uiConfig.images.close1.tinted(with: uiConfig.colorPalette.inactiveTint)
        dismissButton.setImage(dismissIcon, for: .normal)
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = uiConfig.colorPalette.text
        titleLabel.font = uiConfig.font.bodyBold
        titleLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func setupHeaderView() {
        headerView.pin(anchors: [.top, .leading, .trailing], to: self)

        headerView.addSubview(stateIcon)
        headerView.addSubview(titleLabel)
        headerView.addSubview(dismissButton)

        stateIcon.heightAnchor.pin(equalToConstant: stateIconHeight).isActive = true

        stateIcon.pin(anchors: [.leading, .top, .bottom], to: headerView)

        titleLabel.pin(anchors: [.top, .bottom], to: headerView)
        titleLabel.leadingAnchor.pin(equalTo: stateIcon.trailingAnchor).isActive = true
        titleLabel.trailingAnchor.pin(equalTo: dismissButton.leadingAnchor).isActive = true

        dismissButton.pin(anchors: [.trailing, .top, .bottom], to: headerView)
    }

    override open func setUpLayout() {
        super.setUpLayout()
        addSubview(stackContainer)
        stackContainer.pin(anchors: [.bottom], to: safeAreaLayoutGuide)
        stackContainer.pin(anchors: [.top], to: layoutMarginsGuide)
        stackContainer.pin(anchors: [.leading, .trailing], to: self)

        stackContainer.distribution = .fillProportionally
        stackContainer.alignment = .fill
        stackContainer.axis = .vertical

        preservesSuperviewLayoutMargins = true
        stackContainer.isLayoutMarginsRelativeArrangement = true

        stackContainer.addArrangedSubview(headerView)
        setupHeaderView()

        attachmentContainerStackView.alignment = .fill
        attachmentContainerStackView.axis = .vertical

        quotedMessageView.isHidden = true

        attachmentContainerStackView.addArrangedSubview(quotedMessageView)
        attachmentContainerStackView.addArrangedSubview(imageAttachmentsView)
        attachmentContainerStackView.addArrangedSubview(documentAttachmentsView)
        attachmentContainerStackView.addArrangedSubview(messageInputView)

        attachmentOptionsStackView.isHidden = false
        attachmentOptionsStackView.alignment = .center
        attachmentOptionsStackView.addArrangedSubview(shrinkInputButton)
        attachmentOptionsStackView.addArrangedSubview(attachmentButton)
        attachmentOptionsStackView.addArrangedSubview(commandsButton)

        composerStackView.addArrangedSubview(attachmentOptionsStackView)
        composerStackView.addArrangedSubview(attachmentContainerStackView)
        composerStackView.addArrangedSubview(sendButton)

        sendButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        stackContainer.addArrangedSubview(composerStackView)

        composerStackView.alignment = .center
        composerStackView.distribution = .fill
        
        composerStackView.setContentHuggingPriority(.required, for: .horizontal)

        messageInputView.setContentHuggingPriority(.streamRequire, for: .horizontal)
        messageInputView.setContentCompressionResistancePriority(.streamRequire, for: .horizontal)

        stackContainer.addArrangedSubview(checkmarkControl)

        [shrinkInputButton, attachmentButton, commandsButton, sendButton, dismissButton]
            .forEach { button in
                button.widthAnchor.pin(equalTo: button.heightAnchor).isActive = true
            }

        imageAttachmentsView.isHidden = true
        documentAttachmentsView.isHidden = true
        shrinkInputButton.isHidden = true

        checkmarkControl.isHidden = true
    }
    
    open func setCheckmarkView(hidden: Bool) {
        if checkmarkControl.isHidden != hidden {
            checkmarkControl.isHidden = hidden
        }
    }
}
