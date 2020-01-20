//
//  DonationPopupViewController.swift
//  Calligraphy Dictionary
//
//  Created by Victor Poon on 8/1/2020.
//  Copyright © 2020 SoftFeta. All rights reserved.
//

import UIKit
import StoreKit
import BraintreeDropIn
import Braintree

class DonationPopupViewController: UIViewController, SKProductsRequestDelegate {
    
    var request: SKProductsRequest!
    var products: [SKProduct] = []
    var noAdsPurchased = false
    
    //Called when appstore responds and populates the products array
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("products request received")
        self.products = response.products
        self.request = nil
        print("products count: ", products.count)
//        if (response.invalidProductidentifiers.count != 0) {
//            print("*** products request not received ***")
//            print(response.invalidProductidentifiers.description)
//        }
    }
    
    // Braintree START
    func fetchClientToken() {
        // TODO: Switch this URL to your own authenticated API
        let clientTokenURL = NSURL(string: "https://braintree-sample-merchant.herokuapp.com/client_token")!
        let clientTokenRequest = NSMutableURLRequest(url: clientTokenURL as URL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: clientTokenRequest as URLRequest) { (data, response, error) -> Void in
            // TODO: Handle errors
            let clientToken = String(data: data!, encoding: String.Encoding.utf8)
            
            // As an example, you may wish to present Drop-in at this point.
            // Continue to the next section to learn more...
        }.resume()
    }
    
    func showDropIn(_ clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
            }
            controller.dismiss(animated: false, completion: nil)
        }
        self.present(dropIn!, animated: false, completion: nil)
    }
    // Braintree END
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Present BTDropInController to collect the customer's payment information and receive the nonce to send to your server. Saved payment methods will appear if you specified a customer_id when creating your client token.
        
        print(NSLocalizedString("donate", comment: ""))
        showDropIn("sandbox_nd5wmq7c_h3vcbxbmtnr82vvd")
    }
    
}
