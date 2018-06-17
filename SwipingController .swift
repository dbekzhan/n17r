//
//  SwipingController .swift
//  demo
//
//  Created by Dimash Bekzhan on 11/14/17.
//  Copyright © 2017 Dimash Bekzhan. All rights reserved.
//

import UIKit

// delegate protocol - enable additional adjustment of sizes and intervals
class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let pages = [
        Page(text: "STAR", img: "star"),
        Page(text: "DRAGO", img: "drago"),
        Page(text: "COOL LOGO", img: "coolLogo"),
        ]
    
    private let buttonPrev: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Prev", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    @objc private func handlePrev() {
        // set constraints to prevIndex - until the first page - counting starts at 0
        let prevIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: prevIndex, section: 0)
        pageControl.currentPage = prevIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private let buttonNext: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.orange, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleNext() {
        // set constraints to nextIndex - until the last page - counting starts at 0
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    public private(set) lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = .red
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    fileprivate func setUpControllers() {
        let stackViewBottomControl: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [buttonPrev, pageControl
                , buttonNext])
            stackView.distribution = .fillEqually
            // Specify orientation of subviews in stackview. Horizontal by default
            stackView.axis = .horizontal
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        self.view.addSubview(stackViewBottomControl)
        // set stackView layout - alternative approach
        // follow safeAreaLayoutGuide for IOS 11
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                stackViewBottomControl.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                stackViewBottomControl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                stackViewBottomControl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                stackViewBottomControl.heightAnchor.constraint(equalToConstant: 60)
                ])
        } else {
            // Fallback on earlier versions
            NSLayoutConstraint.activate([
                stackViewBottomControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                stackViewBottomControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                stackViewBottomControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                stackViewBottomControl.heightAnchor.constraint(equalToConstant: 60)
                ])
        }
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // get right boundary for scrolling views
        let x = targetContentOffset.pointee.x
        print(x / view.frame.width)
        pageControl.currentPage = Int(x / view.frame.width)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpControllers()
        collectionView?.backgroundColor = .white
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView?.isPagingEnabled = true
    }
}
