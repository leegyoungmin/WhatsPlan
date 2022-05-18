//
//  ContentView.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/05/17.
//

import SwiftUI
enum BottomTab:String{
    case today = "오늘할일"
    case past = "과거이력"
}
struct ContentView: View {
    //MARK: - PROPERTIES
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Plan.time, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Plan>
    
    //MARK: - VIEW PROPERTIES
    @State var currentTab:BottomTab = .today
    @State var isShowAddView:Bool = false
    
    //MARK: - FUNCTIONS
    
    var body: some View {
        ZStack{
            tabView
                .zIndex(0)
            bottomTabBar
                .zIndex(1)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

//MARK: - EXTENSION
extension ContentView{
    var tabView:some View{
        TabView(selection: $currentTab) {
            TodayView()
                .tag(BottomTab.today)
            
            PastCalendarView()
                .tag(BottomTab.past)
        }
    }
    
    var bottomTabBar:some View{
        VStack {
            Spacer()
            HStack{
                Button {
                    withAnimation {
                        self.currentTab = .today
                    }
                } label: {
                    Image(systemName: "checklist")
                        .font(.title)
                        .foregroundColor(currentTab == .today ? .white:.gray)
                        .padding()
                        .scaleEffect(currentTab == .today ? 1:0.8)
                        .opacity(currentTab == .today ? 1:0.5)
                        .frame(width:UIScreen.main.bounds.width*0.4)
                }

                Button {
                    withAnimation {
                        self.currentTab = .past
                    }
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.title)
                        .foregroundColor(currentTab == .past ? .white:.gray)
                        .padding()
                        .scaleEffect(currentTab == .past ? 1:0.8)
                        .opacity(currentTab == .past ? 1:0.5)
                        .frame(width:UIScreen.main.bounds.width*0.4)
                }
            }
            .frame(width:UIScreen.main.bounds.width*0.9,height:60)
            .clipped()
            .background(Color.gray.opacity(0.4).blur(radius: 1).edgesIgnoringSafeArea(.bottom))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

//MARK: - PREVIEWS
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .navigationBarHidden(true)
            .foregroundColor(.accentColor)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

    }
}
