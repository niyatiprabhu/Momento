//
//  HomeViewController.swift
//  Momento
//
//  Created by jasmine wang on 3/2/23.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // check if most recent post is the same as today's date
        let calendar = Calendar.current
        let today = calendar.dateComponents([.year, .month, .day], from: Date.now)
        let lastPostIndex = GlobalVariables.myPosts.endIndex - 1
        if today == GlobalVariables.myPosts[lastPostIndex].date {
            // segue to after posting home page
            //performSegue(withIdentifier: "GoToOtherHome", sender: self)
            let vc = storyboard!.instantiateViewController(withIdentifier: "HomeVC")
            let vc2 = storyboard!.instantiateViewController(withIdentifier: "Home2VC")
            //vc.view.removeFromSuperview()
            self.view.addSubview(vc2.view)


        }
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
