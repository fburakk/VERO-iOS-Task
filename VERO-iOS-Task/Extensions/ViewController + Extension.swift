//
//  LoadingViewModel.swift
//  VERO-iOS-Task
//
//  Created by Burak Köse on 20.02.2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    //MARK: - Activitiy Indicator functions
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
    //MARK: - Alert functions
    
    func makeAlert(title:String,message:String,buttonText:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonText, style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
