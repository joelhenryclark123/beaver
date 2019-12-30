//
//  StackTests.swift
//  StackTests
//
//  Created by Joel Clark on 12/28/19.
//  Copyright © 2019 MyCo. All rights reserved.
//

import XCTest

class StackTests: XCTestCase {

    func testToDoStore() {
        let td1 = ToDo(title: "grind", complete: false)
        let td2 = ToDo(title: "yo", complete: false)

        let store = ToDoStore()

        store.newToDo(td1)
        store.newToDo(td2)

        print("hello?????")
        XCTAssert(store.topToDo == td1)

        store.checkTopToDo()

        XCTAssert(store.topToDo == td2)
    }

}
