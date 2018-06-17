//
//  UISegmentedControl+selectedBackground+Extension.swift
//  
//
//  Created by Dimash Bekzhan on 4/14/18.
//

import UIKit

import UIKit

class CustomSegmentedControl: UISegmentedControl {
    
    let selectedBackgroundColor = UIColor(red: 19/255, green: 59/255, blue: 85/255, alpha: 0.5)
    var sortedViews: [UIView]!
    var currentIndex: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        sortedViews = self.subviews.sorted(by:{$0.frame.origin.x < $1.frame.origin.x})
        changeSelectedIndex(to: currentIndex)
        self.tintColor = UIColor.white
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        let unselectedAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                    NSFontAttributeName:  UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)]
        self.setTitleTextAttributes(unselectedAttributes, for: .normal)
        self.setTitleTextAttributes(unselectedAttributes, for: .selected)
    }
    
    func changeSelectedIndex(to newIndex: Int) {
        sortedViews[currentIndex].backgroundColor = UIColor.clear
        currentIndex = newIndex
        self.selectedSegmentIndex = UISegmentedControlNoSegment
        sortedViews[currentIndex].backgroundColor = selectedBackgroundColor
    }
}
