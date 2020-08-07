//
//  SlideInTransition.swift
//  DukeRewards
//
//  Created by codeplus on 6/4/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class SlideInTransition: UIViewController, UIViewControllerAnimatedTransitioning {

    var isPresenting = false
    let dimmingView = UIView()
    var closeMenuVC : (() -> Void)?
    
    // var from : UIViewController?

    
    @objc func someAction(_ sender:UITapGestureRecognizer){
          // do other task
        
        // animate function call removes the dimming view
        // this isn't even necessary because closeMenuVC calls dismiss on MenuVC which ends up dismissing dimmingView as well
        /*
        UIView.animate(withDuration: 0.3, animations: { () in // closure for UIView.animate completion function parameter
            self.dimmingView.alpha = 0
            self.from?.view.transform = .identity
        })
 */
        
        self.closeMenuVC?() // this closure is define in Earn, Rankings, and Redeem to close the menuVC once the gesture is recognized. I defined the closure in those locations because they have a reference to the menuVC, which needs to be dismissed. This class has no reference to the open MenuVC so it can't dismiss it unless I passed in a MenuVC
       }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //print("begin transition")
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        
        // allows someAction to remove dimmingView by providing it a reference to fromViewController
        // from = fromViewController

        let containerView = transitionContext.containerView
        
        // add gesture to the dimmingView so it recognizes a tap
        // once tapped, someAction is called
        let gesture =  UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        dimmingView.addGestureRecognizer(gesture)
        


        let percentOfScreen: CGFloat = 0.6 // what percent of screen the sliding menu takes up
        
        let finalWidth = toViewController.view.bounds.width * percentOfScreen
        let finalHeight = toViewController.view.bounds.height

        if isPresenting {
            // Add dimming view
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0.5
            containerView.addSubview(dimmingView)
            //self.dimmingView.addGestureRecognizer(gesture)
            
            dimmingView.frame = containerView.bounds
            // Add menu view controller to container
            containerView.addSubview(toViewController.view)

            // Init frame off the screen
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
        }

        // Move on screen
        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }


        // Move back off screen
        let identity = {
            self.dimmingView.alpha = 0.0
            fromViewController.view.transform = .identity
        }

        // Animation of the transition
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identity()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
        //print("end of transition")
    }

}

