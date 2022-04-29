//
//  Task.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/04/29.
//

import Foundation

struct Task:Codable,Hashable,Identifiable{
    let id = UUID().uuidString
    let task:String
    var isDone:Bool
}
