//
//  Copyright © 2021 Stream.io Inc. All rights reserved.
//

import UIKit

enum Colors {
    static let primary = UIColor(hex: 0x3E3139)
    static let background = UIColor.white
}

extension UIColor {
    /**
     Initialize color from hex int (eg. 0xff00ff).
     - parameter hex: Hex int to create color from
     */
    convenience init(hex: UInt32) {
        self.init(
            red: CGFloat(Double((hex & 0xFF0000) >> 16) / 255.0),
            green: CGFloat(Double((hex & 0xFF00) >> 8) / 255.0),
            blue: CGFloat(Double(hex & 0xFF) / 255.0),
            alpha: 1.0
        )
    }
}
