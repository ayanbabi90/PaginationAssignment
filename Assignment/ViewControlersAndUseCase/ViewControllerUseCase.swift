//
//  ViewControllerUseCase.swift
//  Assignment
//
//  Created by Ayan Chakraborty on 07/09/20.
//  Copyright © 2020 Assignment Ayan Chakraborty. All rights reserved.
//

import Foundation

protocol ViewControllerDelegate: NSObjectProtocol {
    func updateItems(list: [Item])
    func showError(str: String)
}

class ViewControllerUseCase {
    weak var delegate: ViewControllerDelegate?{
        didSet{
            fetchData()
        }
    }
    
    var offset = 0
    var totalPages = 0
    
    func fetchData(){
        if self.offset <= totalPages {
            RunningActivity.show()
            APIService.share.request(url: BaseURL,
                                     header: RequestHeader(authToken: AuthToken,
                                                           userId: "63",
                                                           apiName: APINames.getItems,
                                                           appVersion: AppVersion),
                                     payLoad: RequestBody(branchId: 1, page: self.offset),
                                     expectedModel: ResponseModel.self) { (resp, err) in
                                        DispatchQueue.main.async {
                                            RunningActivity.dismiss()
                                            if resp != nil {
                                                self.totalPages = resp?.response?.numberOfPages ?? 0
                                                if let items = resp?.response?.items {
                                                    self.offset = self.offset + 1
                                                    self.delegate?.updateItems(list: items)
                                                    
                                                }
                                            }else{
                                                self.delegate?.showError(str: StrAny(err))
                                            }
                                        }
            }
        }
    }
    
    deinit {
        print("End: \(self)")
    }
}
