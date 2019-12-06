//
//  String+ApproximateWidth.swift

import UIKit

extension String {
    func approximateWidthFor(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                       options: .usesLineFragmentOrigin,
                                       attributes: [NSAttributedString.Key.font: font],
                                       context: nil)
        
        return ceil(boundingBox.width)
    }
}
