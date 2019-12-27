//
//  StarredViewController.swift
//  Calligraphy Dictionary
//
//  Created by Victor Poon on 5/11/2019.
//  Copyright © 2019 SoftFeta. All rights reserved.
//

import UIKit
import SwiftIcons
import GoogleMobileAds

class StarredViewController: UIViewController, UITableViewDataSource, GADBannerViewDelegate {
    
    /// Tells the delegate an ad request loaded an ad.
       func adViewDidReceiveAd(_ bannerView: GADBannerView) {
           print("adViewDidReceiveAd")
       }
       
       /// Tells the delegate an ad request failed.
       func adView(_ bannerView: GADBannerView,
                   didFailToReceiveAdWithError error: GADRequestError) {
           print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
       }
       
       /// Tells the delegate that a full-screen view will be presented in response
       /// to the user clicking on an ad.
       func adViewWillPresentScreen(_ bannerView: GADBannerView) {
           print("adViewWillPresentScreen")
       }
       
       /// Tells the delegate that the full-screen view will be dismissed.
       func adViewWillDismissScreen(_ bannerView: GADBannerView) {
           print("adViewWillDismissScreen")
       }
       
       /// Tells the delegate that the full-screen view has been dismissed.
       func adViewDidDismissScreen(_ bannerView: GADBannerView) {
           print("adViewDidDismissScreen")
       }
       
       /// Tells the delegate that a user click will open another app (such as
       /// the App Store), backgrounding the current app.
       func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
           print("adViewWillLeaveApplication")
       }
    
    var mSaved:[[String:String]] = [[:]]
    
    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mTableView: UITableView!

    @IBOutlet weak var mClearAllBtn: UIButton!
    
    @IBOutlet weak var mAdView: GADBannerView!
    
    @IBAction func mClearAll() {
        DBManager.shared.clearHistory()
        mSaved.removeAll()
        mTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("uiui \(mSaved.count)")
        return mSaved.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("iuiu")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellStarred", for: indexPath) as! BlockListTableViewCell
        let url = URL(string: String(format:"data:application/octet-stream;base64,%@", mSaved[indexPath.row]["image"]!))
        do {
            let data =  try Data(contentsOf: url!)
            cell.mImg.image = UIImage(data: data,scale:1.0)
        } catch {
            print("Unknown error")
        }
        var string = NSMutableAttributedString(string: String(mSaved[indexPath.row]["key"]!.prefix(1)), attributes: [NSAttributedString.Key.font : UIFont(name: "AdobeKaitiStd-Regular", size: 24)!])
        // TODO: Append type here
        string.append(NSMutableAttributedString(string: "\n\(NSLocalizedString("date_of_addition",comment: "")) \(String(mSaved[indexPath.row]["createDate"]!.prefix(10)))", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]))
        if mSaved[indexPath.row]["caption"]! != "" {
//            let nsps = NSMutableParagraphStyle()
//             nsps.lineBreakMode = .byTruncatingTail
            string.append(NSMutableAttributedString(string: "\n\(mSaved[indexPath.row]["caption"]!)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
        }
        
        cell.mCaption.attributedText = string        // Remember to String(prefix)
        cell.mDelete.tag = indexPath.row
        cell.mDelete.addTarget(self, action: #selector(removeRow), for: .touchDown)
        cell.mShare.tag = indexPath.row
        cell.mShare.addTarget(self, action: #selector(share), for: .touchDown)
        return cell
    }
    
    @objc private func removeRow(_ sender:UIButton) {
        DBManager.shared.unstarChar(mSaved[sender.tag]["image"]!)
        mSaved.remove(at: sender.tag)
        mTableView.reloadData()
    }
    
    @objc private func share(_ sender:UIButton) {
        let url = URL(string: String(format:"data:application/octet-stream;base64,%@", mSaved[sender.tag]["image"]!))
        do {
            let data =  try Data(contentsOf: url!)
            let activity = UIActivityViewController(
                activityItems: [UIImage(data: data,scale:1.0)!],
                applicationActivities: nil
            )
            activity.title = "This should be it"
activity.popoverPresentationController?.sourceView = sender

            present(activity, animated: true, completion: nil)
        } catch {
            print("Unknown error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = GADRequest()
        
        mAdView.adUnitID = "ca-app-pub-9627209153774793/3710138358" //ca-app-pub-9627209153774793/2302339919"
        mAdView.rootViewController = self
        mAdView.delegate = self
        //        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["f040a2fc154731455d1ae667f42eb08c"]
        //        request.testDevices = ["f040a2fc154731455d1ae667f42eb08c"]
        mAdView.adSize = GADAdSize(size: CGSize(width: 320, height: 50), flags: 0)
        mAdView.load(request)
        
        mTitle.text = NSLocalizedString("my_favourites", comment: "")
                mClearAllBtn.setIcon(prefixText: "", prefixTextColor: .white, icon: .fontAwesomeSolid(.trashAlt), iconColor: .white, postfixText: NSLocalizedString("clear_all", comment: ""), postfixTextColor: .white, backgroundColor: UIColor(named: "danger")!, forState: .normal, textSize: nil, iconSize: nil)
        mSaved = DBManager.shared.getStarred("zh_Hant")
        mTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "paper\(UserDefaults.standard.integer(forKey: "PREF_BACKGROUND"))")!)
        mSaved = DBManager.shared.getStarred("zh_Hant")
        mTableView.reloadData()
    }
}
