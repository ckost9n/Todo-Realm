//
//  Extension + NavigationBar.swift
//  Todo Realm
//
//  Created by Konstantin on 17.05.2022.
//

import UIKit

extension UINavigationBar {
    
    public func setupNavigationBar(barColor: UIColor, textColor: UIColor) {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = barColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: textColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]
        self.standardAppearance = coloredAppearance
        self.scrollEdgeAppearance = coloredAppearance

        self.tintColor = textColor
        self.prefersLargeTitles = true
    }
}

