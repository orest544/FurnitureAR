//
//  UIStoryboard+RetrievingVCs.swift

import UIKit

extension UIStoryboard {
    private enum Name {
        static let AR = UIStoryboard(name: "AR", bundle: nil)
        static let Furniture = UIStoryboard(name: "Furniture", bundle: nil)
    }
    
    enum Furniture {
        static var initial: UINavigationController {
            return Name.Furniture.instantiateInitialViewController() as! UINavigationController
        }
    }
    
    enum AR {
        static var initial: ARViewController {
            return Name.AR.instantiateViewController()
        }
    }
}
