//
//  OnboardingPageViewController.swift
//  DukeRewards
//
//  Created by Kyra Chan on 7/20/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    lazy var orderedViewControllers:[UIViewController] = {
        return [self.newVC(viewController: "onboardingAttend"), self.newVC(viewController: "onboardingScan"), self.newVC(viewController: "onboardingRewards"), self.newVC(viewController: "navController")]
    }()
    
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        self.delegate = self
        configurePageControl()
        // Do any additional setup after loading the view.
    }
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 120, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor(red: 0.33, green: 0.36, blue: 0.49, alpha: 1.00)
        pageControl.pageIndicatorTintColor = UIColor(red: 0.69, green: 0.74, blue: 0.85, alpha: 1.00)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.33, green: 0.36, blue: 0.49, alpha: 1.00)
        self.view.addSubview(pageControl)
    }
    
    func newVC(viewController: String) -> UIViewController {
        return UIStoryboard(name: LayoutLibraryViewController.currentStoryboard, bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
//            return orderedViewControllers.last
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard orderedViewControllers.count != nextIndex else {
//            return orderedViewControllers.first
            return nil
        }
        
        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
