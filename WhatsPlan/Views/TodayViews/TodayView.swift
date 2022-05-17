//
//  TodayView.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/05/17.
//

import SwiftUI
import CoreData

struct TodayView: View {
    
    //MARK: - PROPERTIES
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Plan.time, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Plan>
    //MARK: - FUNCTIONS
    
    //MARK: - INIT
    var body: some View {
        
        VStack{

//            HeaderView(userSelectedTab: .today)
            
            if items.isEmpty{
                VStack{
                    Spacer()
                    Text("오늘 할일을 작성해주세요.")
                        .foregroundColor(.white)
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .foregroundColor(.white)
            }else{
                ScrollView(.vertical, showsIndicators: false){
                    ForEach(items.filter{DateToString($0.time) == DateToString(Date())}) { item in
                        TodayCellView(item: item)
                            .padding(.vertical,10)
                            .padding(.horizontal)
                    }
                    .listRowBackground(Color.black)
                    .listStyle(.plain)
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}


