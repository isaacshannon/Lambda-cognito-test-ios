//
//  ViewController.swift
//  lambda-testeroo
//
//  Created by Isaac Shannon on 2018-10-20.
//  Copyright © 2018 Isaac Shannon. All rights reserved.
//

import UIKit
import AWSCore
import AWSCognito
import AWSLambda

class ViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var lambdaLabel: UILabel!
    @IBOutlet weak var lambdaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initialize AWS Cognito
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast2,
                                                                identityPoolId:"us-east-2:xxxx123456")
        let serviceConfiguration = AWSServiceConfiguration(region:.USEast2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
        
        // Retrieve your Amazon Cognito ID
        credentialsProvider.getIdentityId().continueOnSuccessWith(block: { (task:AWSTask<NSString>) -> AWSTask<AnyObject>? in
            
            // the task result will contain the identity id
            let cognitoId = task.result
            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.statusLabel.text = cognitoId! as String
            }
            
            
            return nil
            
        })
    }
    
 
    @IBAction func lambdaTouch(_ sender: Any) {
        let lambdaInvoker = AWSLambdaInvoker.default()
        let jsonObject: [String: Any] = ["name" : "testerOfMightAndHonor",
                                         "lastName" : "hurroLastName" ]
        
        lambdaInvoker.invokeFunction("helloWorld", jsonObject: jsonObject)
            .continueWith(block: {(task:AWSTask<AnyObject>) -> Any? in
                if( task.error != nil) {
                    print("Error: \(task.error!)")
                    return nil
                }
                
                if let lambdaResult = task.result as? String {
                    DispatchQueue.main.async {
                        self.lambdaLabel.text = lambdaResult
                    }
                }
                return nil
            })
    }
    
}

