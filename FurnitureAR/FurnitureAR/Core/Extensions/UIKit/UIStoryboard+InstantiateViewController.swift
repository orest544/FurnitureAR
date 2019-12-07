//  UIStoryboard+InstantiateViewController.swift

import UIKit

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>() -> T {
        let identifier = String(describing: T.self)
        return instantiateViewController(withIdentifier: identifier) as! T
    }
    
    func instantiateInitialViewController<T: UIViewController>() -> T {
        return instantiateInitialViewController() as! T
    }
}
