//
//  FifthViewController.swift
//  Greetings
//
//  Created by Ruslan Gilmullin on 21/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

class FifthViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
        let offset = scrollView.frame.width * CGFloat(pageControl.currentPage)
        
        scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
    
    private var imageViewList = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [1, 2, 3, 4, 5].forEach { (number) in
            let name = "screen_\(number)"
            let image = UIImage(named: name)
            
            if let image = image {
                let imageView = UIImageView(image: image)
                
                imageView.contentMode = .scaleAspectFit
                imageViewList.append(imageView)
                scrollView.addSubview(imageView)
            }
        }
        
        scrollView.delegate = self
        pageControl.numberOfPages = imageViewList.count
        pageControl.currentPage = 0
        
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for (index, imageView) in imageViewList.enumerated() {
            imageView.frame.size = scrollView.frame.size
            imageView.frame.origin.x = scrollView.frame.width * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        
        let contentWidth = scrollView.frame.width * CGFloat(imageViewList.count)
        
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
    }
}

extension FifthViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        pageControl.currentPage = currentPage
    }
}
