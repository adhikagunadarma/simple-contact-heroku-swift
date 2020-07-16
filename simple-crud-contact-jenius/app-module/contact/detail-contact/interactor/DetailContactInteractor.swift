//
//  ContactInteractor.swift
//  simple-crud-contact-jenius
//
//  Created by Josephine Fransisca on 09/07/20.
//  Copyright © 2020 Adhika gunadarma. All rights reserved.
//

import Foundation

import SwiftyJSON
import Alamofire

class DetailContactInteractor : PresenterToInteractorDetailProtocol {
    var presenter : InteractorToPresenterDetailProtocol?
    private let baseURL = "https://simple-contact-crud.herokuapp.com"
    
    
    func getContact(_ id : String){
        Alamofire.request(self.baseURL + "/contact/\(id)", method: .get).responseJSON { (response) in
            
            if (response.response?.statusCode == 200){
                // fetch and convert the response into JSON
                let resultJSON : JSON = JSON(response.result.value!)
                let contact = DetailContact()
                contact.firstName = resultJSON["data"]["firstName"].stringValue
                contact.lastName = resultJSON["data"]["lastName"].stringValue
                contact.id = resultJSON["data"]["id"].stringValue
                contact.age = resultJSON["data"]["age"].stringValue
                contact.photo = resultJSON["data"]["photo"].stringValue
                self.presenter?.contactFetchSuccess(contact)
                
            }else{
                self.presenter?.contactFetchFailed()
            }
        }
    }
    
    
    func addContact(_ contact : DetailContact){
        Alamofire.request(self.baseURL + "/contact",
                          method: .post,
                          parameters: self.toJSON(contact).dictionaryObject,
                          encoding: JSONEncoding.default).responseJSON { (response) in
                            
                            // since the response only contain property message whether succes or fail ,so there will be no logic condition for it
                            
                            if (response.response?.statusCode == 200){
                                let resultJSON : JSON = JSON(response.result.value!)
                                self.presenter?.addContactSuccess(resultJSON["message"].stringValue)
                            }else{
                                self.presenter?.addContactFailed()
                            }
        }
    }
    
    func editContact(_ id : String, _ contact : DetailContact){
        Alamofire.request(self.baseURL + "/contact/\(id)",
            method: .put,
            parameters: self.toJSON(contact).dictionaryObject,
            encoding: JSONEncoding.default).responseJSON { (response) in
                
                // since the response only contain property message whether succes or fail ,so there will be no logic condition for it
                
                if (response.response?.statusCode == 200){
                    let resultJSON : JSON = JSON(response.result.value!)
                    self.presenter?.editContactSuccess(resultJSON["message"].stringValue)
                }else{
                    self.presenter?.editContactFailed()
                }
        }
    }
    
    func deleteContact(_ id : String){
           
           Alamofire.request(self.baseURL + "/contact/\(id)",
               method: .delete).responseJSON { (response) in
                
                // since the response only contain property message whether succes or fail ,so there will be no logic condition for it
                
                if (response.response?.statusCode == 200){
                    let resultJSON : JSON = JSON(response.result.value!)
                    self.presenter?.deleteContactSuccess(resultJSON["message"].stringValue)
                }else{
                    self.presenter?.deleteContactFailed()
                }
        }
    }
    
    private func toJSON(_ contact : DetailContact) -> JSON {
        // function to convert model into json because Alamofire only support json type of params
        return [
            "firstName": contact.firstName as Any,
            "lastName": contact.lastName as Any,
            "age": contact.age as Any,
            //            "photo": contact.photo as Any
            
        ]
    }
    
    
}