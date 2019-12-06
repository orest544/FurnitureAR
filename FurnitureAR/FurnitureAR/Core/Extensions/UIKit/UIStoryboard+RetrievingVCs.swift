//
//  UIStoryboard+RetrievingVCs.swift

import UIKit

extension UIStoryboard {
    private enum Name {
        static let AR = UIStoryboard(name: "AR", bundle: nil)
    }
    
    enum AR {
        static var initial: ARViewController {
            return Name.AR.instantiateViewController()
        }
    }
}
