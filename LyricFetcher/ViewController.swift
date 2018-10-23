//
//  ViewController.swift
//  LyricFetcher
//
//  Created by Jake Dillon on 10/23/18.
//  Copyright © 2018 Jake Dillon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var artistTextView: UITextField!
    
    @IBOutlet weak var songTextView: UITextField!
    
    @IBOutlet weak var lyricTextView: UITextView!
    
   // The Basee URL for the lyrics API, aka the point where we connect to it
    let lyricsAPIBaseURL = "https://api.lyrics.ovh/v1/"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    // touch screen to make keyboard go away
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    @IBAction func submitButton(_ sender: Any) {
    guard let artistName = artistTextView.text,
     let songTitle = songTextView.text else {
            return
        }
        
        let artistNameURLComponent = artistName.replacingOccurrences(of: " ", with: "+")
       
        let songTitleURLComponent = songTitle.replacingOccurrences(of: " ", with: "+")
        
        let requestURL = lyricsAPIBaseURL + artistNameURLComponent + "/" + songTitleURLComponent
        print(requestURL)
        
        
        let request = Alamofire.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
        
        
        request.responseJSON { response in
            switch response.result {
            case .success(let value):
              // Incase of success the request has succeeded
                
                print(value)
                
                let json = JSON(value)
                self.lyricTextView.text = json["lyrics"].stringValue
                
                print("success")
            case .failure(let error):
             // In case of failure, the request has failed and we've gotten an error back
                print("Error")
            print(error.localizedDescription)
            }
        }
        artistTextView.text = ""
        songTextView.text = ""
    }
}

