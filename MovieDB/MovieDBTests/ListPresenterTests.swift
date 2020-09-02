//
//  ListPresenterTests.swift
//  MovieDBTests
//
//  Created by Gabriel Ferreira on 01/09/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import XCTest
@testable import MovieDB

class ListPresenterTests: XCTestCase {
    var serviceMock : ServiceMock = ServiceMock()
    var presenter : ListPresenter = ListPresenter(service: ServiceMock())
    
    func testDecode() {
        var title : String?
        self.presenter.getData { (listData, status, message) in
            guard let list = listData else { return }
            title = list.first?.title
        }
        
        //testing decode character
        XCTAssertEqual(title, "Rogue", "getting character error")
        
        let key = String(self.presenter.actualPage)
        
        let list = self.presenter.getDataFromCache(key: key)
        title = list?.first?.title
        
        //testing setting and getting character from cache
        XCTAssertEqual(title, "Rogue", "getting character error")
    }
}
