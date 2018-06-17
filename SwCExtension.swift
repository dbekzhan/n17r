//
//  SwCExtension.swift
//  demo
//
//  Created by Dimash Bekzhan on 11/17/17.
//  Copyright © 2017 Dimash Bekzhan. All rights reserved.
//

import UIKit

extension SwipingController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // adjust coordinator along view transitioning
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewLayout.invalidateLayout()
            // solve bug with 1st page's wrong centering via contentOffSet
            if self.pageControl.currentPage == 0 {
                self.collectionView?.contentOffset = .zero
            } else {
                let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            
        }, completion: nil)
    }
}
