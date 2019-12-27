//
//  PrefsTableViewController.swift
//  Calligraphy Dictionary
//
//  Created by Victor Poon on 5/11/2019.
//  Copyright © 2019 SoftFeta. All rights reserved.
//

import UIKit
import DropDown
import FlagKit
import GoogleMobileAds

class PrefsTableViewController: UITableViewController, GADBannerViewDelegate {

    private var mLocaleDropDown:DropDown?
    private var mBackgroundDropDown:DropDown?
    
    @IBOutlet weak var mLocaleTitle: UILabel!
    @IBOutlet weak var mLocaleSubtitle: UILabel!
    
    @IBOutlet weak var mBackgroundTitle: UILabel!
    @IBOutlet weak var mBackgroundSubtitle: UILabel!
    
    @IBOutlet weak var mAdView: GADBannerView!
    @IBOutlet weak var mAdView2: GADBannerView!
    private let mPreferences = UserDefaults.standard

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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
        return NSLocalizedString("pref_general",comment:"")
        } else {
        return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mLocaleTitle.text = NSLocalizedString("settings_locale", comment: "")
          mBackgroundTitle.text = NSLocalizedString("settings_background", comment: "")
          
          let request = GADRequest()
          
          mAdView.adUnitID = "ca-app-pub-9627209153774793/4054028954" //ca-app-pub-9627209153774793/2302339919"
          mAdView.rootViewController = self
          mAdView.delegate = self
          //        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["f040a2fc154731455d1ae667f42eb08c"]
          //        request.testDevices = ["f040a2fc154731455d1ae667f42eb08c"]
          mAdView.adSize = GADAdSize(size: CGSize(width: 320, height: 50), flags: 0)
          mAdView.load(request)
          
          let request2 = GADRequest()
          
          mAdView2.adUnitID = "ca-app-pub-9627209153774793/9114783945" //ca-app-pub-9627209153774793/2302339919"
          mAdView2.rootViewController = self
          mAdView2.delegate = self
          //        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["f040a2fc154731455d1ae667f42eb08c"]
          //        request.testDevices = ["f040a2fc154731455d1ae667f42eb08c"]
          mAdView2.adSize = GADAdSize(size: CGSize(width: 300, height: 250), flags: 0)
          mAdView2.load(request2)
                  
          
          let langs:[String:[String]] = ["繁體中文": ["Chinese (Authentic)", "TW", "zh-Hant", "請重新開啟應用程式。", "確定"], "简体中文": ["Chinese (Simplified)", "SG", "zh-Hans", "请重新开启应用程式。", "确定"], "English (UK)": ["English", "GB", "en", "Please relaunch the app.", "OK"], "français": ["French","FR", "fr", "Priez de redémarrer l'appli.", "OK"], "Deutsch": ["German", "DE", "de", "Wieder öffnet die Applikation bitte.", "OK"], "español": ["Spanish","ES", "es", "Reinicie la aplicación por favor.", "Aceptar"]]
        //["繁體中文": ["Chinese (Authentic)", "TW", "zh-Hant", "請重新開啟應用程式。", "確定"], "简体中文": ["Chinese (Simplified)", "CN", "zh-Hans", "请重新开启应用程式。", "确定"], "English (UK)": ["English", "GB", "en", "Please relaunch the app.", "OK"], "català": ["Catalan", "AD", "ca", "Reinicieu l'aplicació per favor.", "D'acord"], "français": ["French","FR", "fr", "Priez de redémarrer l'appli.", "OK"], "Deutsch": ["German", "DE", "de", "Wieder öffnet die Applikation bitte.", "OK"], "español": ["Spanish","ES", "es", "Reinicie la aplicación por favor.", "Aceptar"], "日本語": ["Japanese", "JP", "ja", "アプリを再起動して下さい。", "OK"], "Українська": ["Ukrainian","UA", "uk", "Відкрий додаток знову, будь ласка.", "OK"]]
          
          if let savedLocale = self.mPreferences.string(forKey: "PREF_LOCALE") {
              for x in langs.keys {
                  if langs[x]![2] == savedLocale {
                      self.mLocaleSubtitle.text = x
                  }
              }
          } else {
              let reference = (UserDefaults.standard.array(forKey: "AppleLanguages") as! [String])[0]
              if reference.contains("Hant") {
                  self.mLocaleSubtitle.text = "繁體中文"
              } else if reference.contains("Hans") {
                  self.mLocaleSubtitle.text = "简体中文"
              } else {
                  switch reference {
                  case "fr":
                      self.mLocaleSubtitle.text = "français"
                  case "ca":
                      self.mLocaleSubtitle.text = "català"
                  case "de":
                      self.mLocaleSubtitle.text = "Deutsch"
                  case "es":
                      self.mLocaleSubtitle.text = "español"
                  case "ja":
                      self.mLocaleSubtitle.text = "日本語"
                  case "uk":
                      self.mLocaleSubtitle.text = "Українська"
                  default:
                      self.mLocaleSubtitle.text = "English (UK)"
                  }
              }
          }
          
          mLocaleDropDown = DropDown()
          mLocaleDropDown!.dataSource = Array(langs.keys)
          mLocaleDropDown!.anchorView = mLocaleSubtitle
          
          mLocaleDropDown!.bottomOffset = CGPoint(x: 0, y:(mLocaleDropDown!.anchorView!.plainView.bounds.height))
          mLocaleDropDown!.cellNib = UINib(nibName: "LocaleDropDownTableViewCell", bundle: nil)
          
          mLocaleDropDown!.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
              guard let cell = cell as? LocaleDropDownTableViewCell else { return }
              cell.mSubtitle.text = langs[item]![0]
              let flag = Flag(countryCode: langs[item]![1])!
              cell.mFlag.image = flag.originalImage
          }
          
          mLocaleDropDown!.selectionAction = { [unowned self] (index: Int, item: String) in
              
              self.mLocaleSubtitle.text = item
              
              self.mPreferences.set(langs[item]![2], forKey: "PREF_LOCALE")
              self.mPreferences.synchronize()

              UserDefaults.standard.set([langs[item]![2]], forKey: "AppleLanguages")     //zh-Hant-HK
              UserDefaults.standard.synchronize()
              
              let alert = UIAlertController(title: nil, message: NSLocalizedString(langs[item]![3], comment: ""), preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: langs[item]![4], style: .default, handler: {
                  (action : UIAlertAction!) -> Void in
                  exit(0)
              }))
              self.present(alert, animated: true, completion: nil)
          }
        
        mBackgroundSubtitle.text = NSLocalizedString("settings_paper\(mPreferences.integer(forKey: "PREF_BACKGROUND"))", comment: "")
        
        
        let backgroundArray = [
            NSLocalizedString("settings_paper0", comment: ""),
            NSLocalizedString("settings_paper1", comment: ""), NSLocalizedString("settings_paper2", comment: ""), NSLocalizedString("settings_paper3", comment: ""), NSLocalizedString("settings_paper4", comment: ""), NSLocalizedString("settings_paper5", comment: ""), NSLocalizedString("settings_paper6", comment: ""), NSLocalizedString("settings_paper7", comment: "")]
        mBackgroundDropDown = DropDown()
        mBackgroundDropDown!.dataSource = backgroundArray
        mBackgroundDropDown!.anchorView = mBackgroundSubtitle
        
        mBackgroundDropDown!.bottomOffset = CGPoint(x: 0, y:(mBackgroundDropDown!.anchorView!.plainView.bounds.height))
        mBackgroundDropDown!.cellNib = UINib(nibName: "BackgroundTableViewCell", bundle: nil)
        
        mBackgroundDropDown!.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? BackgroundTableViewCell else { return }
            cell.mBackgroundImg.image = UIImage(named: "paper\(index)")
        }
        
        mBackgroundDropDown!.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.mBackgroundSubtitle.text = item
            
            self.mPreferences.set(index, forKey: "PREF_BACKGROUND")
            self.mPreferences.synchronize()
        }
        
        mLocaleDropDown!.selectedTextColor = .white
        mLocaleDropDown!.textColor = .white

//          let difficulties = [NSLocalizedString("pref_difficulty_hard", comment: ""): NSLocalizedString("pref_difficulty_hard_sub", comment: ""), NSLocalizedString("pref_difficulty_insane", comment: ""): NSLocalizedString("pref_difficulty_insane_sub", comment: ""), NSLocalizedString("pref_difficulty_hysterical", comment: ""): NSLocalizedString("pref_difficulty_hysterical_sub", comment: "")]
//          let difficultiesKeys = [NSLocalizedString("pref_difficulty_hard", comment: ""), NSLocalizedString("pref_difficulty_insane", comment: ""), NSLocalizedString("pref_difficulty_hysterical", comment: "")]
//
//          if let savedDifficulty = self.mPreferences.object(forKey: "PREF_DIFFICULTY") {
//              let keyText = difficultiesKeys[savedDifficulty as! Int]
//              self.mDifficultySubtitle1.text = keyText
//              self.mDifficultySubtitle2.text = difficulties[keyText]
//          }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                mLocaleDropDown!.show()
            case 1:
                mBackgroundDropDown!.show()
            default:
                break
            }
        }
    }


}
