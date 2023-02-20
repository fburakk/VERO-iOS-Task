//
//  LoadingViewModel.swift
//  VERO-iOS-Task
//
//  Created by Burak Köse on 20.02.2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
    
    func hideActivityIndicator() {
        if let activityIndicator = self.view.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
}
