//
//  ViewController.swift
//  Calligraphy Dictionary
//
//  Created by Victor Poon on 30/10/2019.
//  Copyright © 2019 SoftFeta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftIcons
import FlagKit
import GoogleMobileAds

// Mapping from XML/HTML character entity reference to character
// From http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
private let characterEntities : [ Substring : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]

class SmallSealViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GADBannerViewDelegate {
    @IBOutlet weak var mAdView: GADBannerView!
    
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("Hi \(mCurrent.count)")
        return mCurrent.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    @objc func starUnstar(_ sender:UIButton) {
        if mCurrent[sender.tag].starred {
            sender.setImage(UIImage(named: "dark_star"), for: .normal)
            mCurrent[sender.tag].starred = false
            DBManager.shared.unstarChar(mCurrent[sender.tag].image)
        } else {
            sender.setImage(UIImage(named: "star"), for: .normal)
            mCurrent[sender.tag].starred = true
            DBManager.shared.starChar(mCurrent[sender.tag].image, 1)
            
        }
    }
    
    @objc func share(_ sender:UIButton) {
        let url = URL(string: String(format:"data:application/octet-stream;base64,%@", mCurrent[sender.tag].image))
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        let url = URL(string: String(format:"data:application/octet-stream;base64,%@", mCurrent[indexPath.section].image))
        do {
            let data =  try Data(contentsOf: url!)
            cell.mCharImg.image = UIImage(data:data,scale:1.0)
            if mCurrent[indexPath.section].starred {
                cell.mStar.setImage(UIImage(named: "star"), for: .normal)
            } else {
                cell.mStar.setImage(UIImage(named: "dark_star"), for: .normal)
            }
            cell.mStar.tag = indexPath.section //*-1 if
            cell.mStar.addTarget(self, action: #selector(starUnstar), for: .touchDown)
            cell.mShare.setIcon(icon: .fontAwesomeSolid(.share), iconSize: nil, color: .gray, backgroundColor: .clear, forState: .normal)
            cell.mShare.tag = indexPath.section //*-1 if
            cell.mShare.addTarget(self, action: #selector(share), for: .touchDown)
        } catch {
            print("Unknown error")
        }
        return cell
    }
    
    //    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    //        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Caption", for: indexPath) as! CaptionCollectionReusableView
    //        header.mCaption.text = "北宋·米芾 (978-1013)《草堂》"
    //        return header
    //    }
    private let mPreferences = UserDefaults.standard
    
    private var mCurrent:[(image:String,caption:String,starred:Bool)] = []
    
    @IBOutlet weak var mReckon: UIButton!
    
    @IBOutlet weak var mSearchBox: UITextField!
    
    @IBOutlet weak var mSearchBtn: UIButton!
    
    @IBOutlet weak var mCangjieLbl: UILabel!
    
    @IBOutlet weak var mCangjie: UILabel!
    
    @IBOutlet weak var mCantoneseYaleLbl: UILabel!
    @IBOutlet weak var mCantoneseYale: UILabel!
    
    
    @IBOutlet weak var mHanyuPinyinLbl: UILabel!
    @IBOutlet weak var mHanyuPinyin: UILabel!
    
    @IBOutlet weak var mEngTrans: UILabel!
    
    @IBOutlet weak var mFrTrans: UILabel!
    
    @IBOutlet weak var mDeTrans: UILabel!
    
    @IBOutlet weak var mEngFlag: UIImageView!
    
    @IBOutlet weak var mFrFlag: UIImageView!
    
    @IBOutlet weak var mDeFlag: UIImageView!
    
    @IBOutlet weak var mCollectionView: UICollectionView!
    
    @IBOutlet weak var mRandomBtn: UIButton!
    
    @IBOutlet weak var mInstructions: UILabel!
    
    @IBOutlet weak var mCaption: UILabel!
    @IBOutlet weak var mBigCharDisplay: UILabel!
    
    @IBAction func mRandom() {
        mSearchBox.text = DBManager.shared.randomSmallSeal()
        mSearchPicts()
    }
    
    @IBAction func mSearchPicts() {
        if mSearchBox.text == "" {
            let alert = UIAlertController(title: nil, message: NSLocalizedString("search_input_req", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let picts = DBManager.shared.getSmallSeal(mSearchBox.text!)
            if picts.count > 0 {
                mInstructions.isHidden = true
                mCangjieLbl.isHidden = false
                mCantoneseYaleLbl.isHidden = false
                mHanyuPinyinLbl.isHidden = false
                mEngFlag.isHidden = false
                mFrFlag.isHidden = false
                mDeFlag.isHidden = false
                let rawValue = CFStringEncodings.big5.rawValue
                let encoding = CFStringEncoding(rawValue)
                let big5Encoding = CFStringConvertEncodingToNSStringEncoding(encoding)
                if let big5Data = mSearchBox.text!.data(using: String.Encoding(rawValue: big5Encoding)) {
                    mBigCharDisplay.text = mSearchBox.text!
                    var codepoint = ""
                    for code in big5Data { codepoint += "%\(String(code, radix: 16))" }
                    
                    //"https://www.unicode.org/cgi-bin/GetUnihanData.pl?codepoint=\()&useutf8=true"
                    
                    
                    //for code in mSearchBox.text!.utf8 { print(code) }
                    print("https://humanum.arts.cuhk.edu.hk/Lexis/lexi-can/search.php?q=\(codepoint)")
                    AF.request("https://humanum.arts.cuhk.edu.hk/Lexis/lexi-can/search.php?q=\(codepoint)")
                        .validate(statusCode: 200..<300)
                        .responseString(encoding: String.Encoding(rawValue: big5Encoding)) { response in
                            switch response.result {
                            case .success(let _):
                                if response.value != nil {
                                    
                                    print("Seems to be okay.")
                                    
                                    let regex = try! NSRegularExpression(pattern: "(?<=譯:\\</td\\>\\<td\\>\\<font size\\=\\-1\\>).*?(?=\\<)")
                                    if let match = regex.firstMatch(in: response.value!, options: [], range: NSMakeRange(0, response.value!.count)) {
                                        self.mEngTrans.text = response.value!.substring(with: Range(match.range, in: response.value!)!)
                                    } else {
                                        self.mEngTrans.text = ""
                                    }
                                    
                                    let regexCJ = try! NSRegularExpression(pattern: "(?<=頡碼:\\<\\/td\\>\\n\\t\\t\\<td class=t2\\>).*?(?=\\<\\/)")
                                    if let matchCJ = regexCJ.firstMatch(in: response.value!, options: [], range: NSMakeRange(0, response.value!.count)) {
                                        self.mCangjie.text = response.value!.substring(with: Range(matchCJ.range, in: response.value!)!)
                                    } else {
                                         self.mCangjie.text = ""
                                    }
                                    
                                    var canto:[String] = []
                                    var canto2:[String] = []
                                    var cantoStr = ""
                                    
                                    let regexTxt = try! NSRegularExpression(pattern: "(?<=sound\\.php\\?s=).*?(?=\")")
                                    let matchTxt = regexTxt.matches(in: response.value!, options: [], range: NSMakeRange(0, response.value!.count))
                                    if matchTxt.count > 0 {
                                        canto = matchTxt.map { (res) -> String in
                                            return response.value!.substring(with: Range(res.range, in: response.value!)!)
                                        }
                                    }
                                    
                                    print("bbu")
                                    print(canto)
                                    
                                    let regexSig = try! NSRegularExpression(pattern: "(?<=\\<td\\>\\<div nowrap\\>).*?(?=\\<\\/td)")
                                    let matchSig = regexSig.matches(in: response.value!, options: [], range: NSMakeRange(0, response.value!.count))
                                    if matchSig.count > 0 {
                                        canto2 = matchSig.map { (res) -> String in
                                            return response.value!.substring(with: Range(res.range, in: response.value!)!)
                                        }
                                    }
                                    
                                    for x in 0..<(canto.count) {
                                        var canto2Str = ""
                                        
                                        if let commaStartIndex = canto2[x].firstIndex(where: { (char) -> Bool in
                                            return !char.isASCII
                                        }) {
                                            if let commaIndex = canto2[x].firstIndex(of: ",") {
                                                canto2Str = canto2[x].substring(with: commaStartIndex..<commaIndex)
                                            } else {
                                                canto2Str = canto2[x].substring(with: commaStartIndex..<canto2[x].endIndex)
                                            }
                                            let regexPattern = "<.*?>"

                                            do {
                                            let regex = try NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)

                                            var matches = regex.matches(in: canto2Str, options: .withoutAnchoringBounds, range: NSMakeRange(0, canto2Str.count))
                                                var canto2Mutable = NSMutableString(string: canto2Str)
                                            regex.replaceMatches(in: canto2Mutable, options: .withoutAnchoringBounds, range: NSMakeRange(0, canto2Str.count), withTemplate: "")
                                                canto2Str = canto2Mutable as String
                                            } catch let error {
                                                                            print(error)
                                                                        }
                                        }
                                        
                                        
                                        cantoStr += "\(canto2Str): \(canto[x])"
                                        if x != canto.count-1 {
                                            cantoStr += ";\n"
                                        }
                                    }
                                    
                                    self.mCantoneseYale.text = cantoStr
                                    //                            do {
                                    //                                let document = try ONOXMLDocument(string: regex.stringByReplacingMatches(in: response.value!, options: [], range: NSMakeRange(0, response.value!.count), withTemplate: ""), encoding: String.Encoding.utf8.rawValue)
                                    //
                                    //
                                    //                                document.enumerateElements(withXPath: "//font") { (element, _, _) in
                                    //                                    print(element.stringValue!)
                                    //                                }
                                    //                                //                                let document = try XMLDocument(string: try! response.result.get())
                                    //                                //                                self.mEngTrans.text = document.xpath("//font").first!.stringValue
                                    //                            } catch let error {
                                    //                                print(error)
                                    //                            }
                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                    }
                    
                    AF.request("https://www.moedict.tw/\(mSearchBox.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)")
                        .validate(statusCode: 200..<300)
                        .responseString { response in
                            switch response.result {
                            case .success(let _):
                                if response.value != nil {
                                    let regex = try! NSRegularExpression(pattern: "(?<=francais\\.1\"\\>).*?(?=\\<)")
                                    let regex1 = try! NSRegularExpression(pattern: "(?<=Deutsch\\.1\"\\>).*?(?=\\<)")
                                    if let match = regex.firstMatch(in: response.value!, options: [], range: NSMakeRange(0, response.value!.count)) {
                                        self.mFrTrans.text = response.value!.substring(with: Range(match.range, in: response.value!)!).stringByDecodingHTMLEntities
                                    } else {
                                        self.mFrTrans.text = ""
                                    }
                                    if let match = regex1.firstMatch(in: response.value!, options: [], range: NSMakeRange(0, response.value!.count)) {
                                        self.mDeTrans.text = response.value!.substring(with: Range(match.range, in: response.value!)!).stringByDecodingHTMLEntities
                                    } else {
                                        self.mDeTrans.text = ""
                                    }
                                }
                                
                                let regexHY = try! NSRegularExpression(pattern: "(?<=\"pinyin\": \").*?(?=\")")
                                let matchHY = regexHY.matches(in: response.value!, options: [], range: NSMakeRange(0, response.value!.count))
                                if matchHY.count > 0 {
                                    self.mHanyuPinyin.text = matchHY.map { (res) -> String in
                                        return response.value!.substring(with: Range(res.range, in: response.value!)!)
                                    }.filter {
                                        (str) -> Bool in
                                        return str.count < 8
                                    }.joined(separator: ", ")
                                } else {
                                     self.mCangjie.text = ""
                                }
                                //                            do {
                                //                                let document = try ONOXMLDocument(data: response.data)
                                //                                document.enumerateElements(withXPath: "//font") { (element, _, _) in
                                //                                    print(element.stringValue!)
                                //                                }
                                //                                //                                let document = try XMLDocument(data: response.data!)
                                //                            } catch let error {
                                //                                print(error)
                            //                            }
                            case .failure(let _):
                                break
                            }
                    }
                } else {
                    mRandom()
                    return
                }
                
                mCaption.text = picts[0].caption
                mCurrent = picts
                for x in picts {
                    DBManager.shared.addHistory(x.image, 1)
                }
                mCollectionView.reloadData()
            } else {
                let alert = UIAlertController(title: nil, message: NSLocalizedString("no_results", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        /*
         kZVariant
         kTraditionalVariant
         kSemanticVariant
         
         kCangjie
         kTotalStrokes
         
         */
        super.viewDidLoad()
        
        let request = GADRequest()
        
        mAdView.adUnitID = "ca-app-pub-9627209153774793/5570014933" //ca-app-pub-9627209153774793/2302339919"
        mAdView.rootViewController = self
        mAdView.delegate = self
        //        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["f040a2fc154731455d1ae667f42eb08c"]
        //        request.testDevices = ["f040a2fc154731455d1ae667f42eb08c"]
        mAdView.adSize = GADAdSize(size: CGSize(width: 320, height: 50), flags: 0)
        mAdView.load(request)
        
        if mPreferences.object(forKey: "PREF_BACKGROUND") == nil{
            mPreferences.set(5, forKey: "PREF_BACKGROUND")
            mPreferences.synchronize()
            view.backgroundColor = UIColor(patternImage: UIImage(named: "paper5")!)
        }
        mCollectionView.register(CaptionCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Caption")
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        
        mCangjieLbl.isHidden = true
        mCangjieLbl.text = NSLocalizedString("cangjie", comment: "")
        mCantoneseYaleLbl.isHidden = true
        mCantoneseYaleLbl.text = NSLocalizedString("cantonese_yale", comment: "")
        mHanyuPinyinLbl.isHidden = true
        mHanyuPinyinLbl.text = NSLocalizedString("mandarin_pinyin", comment: "")

        mSearchBox.placeholder = NSLocalizedString("search_placeholder", comment: "")
        mSearchBtn.setIcon(icon: .icofont(.search), iconSize: nil, color: .white, backgroundColor: .systemBlue, forState: .normal)
        mRandomBtn.setIcon(prefixText: "", prefixTextColor: .white, icon: .fontAwesomeSolid(.questionCircle), iconColor: .white, postfixText: NSLocalizedString("random_character", comment: ""), postfixTextColor: .white, backgroundColor: .systemGreen, forState: .normal, textSize: nil, iconSize: nil)
        mReckon.setIcon(prefixText: "", prefixTextColor: .white, icon: .fontAwesomeSolid(.cameraRetro), iconColor: .white, postfixText: NSLocalizedString("s_conversion", comment: ""), postfixTextColor: .white, backgroundColor: .systemIndigo, forState: .normal, textSize: nil, iconSize: nil)
        //        mEngTrans.lineBreakMode = .byWordWrapping
        //        mEngTrans.numberOfLines = 0
        //        mFrTrans.lineBreakMode = .byWordWrapping
        //        mFrTrans.numberOfLines = 0
        //        mDeTrans.lineBreakMode = .byWordWrapping
        //        mDeTrans.numberOfLines = 0
        mInstructions.text = NSLocalizedString("search_placeholder_large", comment: "")
        mEngFlag.isHidden = true
        mEngFlag.image = Flag(countryCode: "GB")!.image(style: .circle)
        mFrFlag.isHidden = true
        mFrFlag.image = Flag(countryCode: "FR")!.image(style: .circle)
        mDeFlag.isHidden = true
        mDeFlag.image = Flag(countryCode: "DE")!.image(style: .circle)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "paper\(UserDefaults.standard.integer(forKey: "PREF_BACKGROUND"))")!)
    }
}

