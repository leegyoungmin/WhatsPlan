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
        NavigationView{
            ZStack(alignment: .bottom) {
                
                tabView.zIndex(0)
                bottomTabBar.zIndex(0)
                
                VStack{
                    HStack(alignment:.center,spacing:10){
                        Text(currentTab.rawValue)
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading,4)
                            .foregroundColor(.accentColor)
                        
                        Spacer()
                        if currentTab == .today{
                            EditButton()
                                .environment(\.locale, Locale(identifier: "ko_KR"))
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.accentColor)
                                .padding(.horizontal,10)
                                .padding(.vertical,3)
                                .background(
                                    Capsule()
                                        .stroke(Color.accentColor,lineWidth: 2)
                                )
                                .padding(.trailing,10)
                            
                            Button {
                                withAnimation {
                                    isShowAddView = true
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .font(.system(.title, design: .rounded))
                            }

                        }
                    }
                    .padding()
                    .foregroundColor(.accentColor)
                    
                    Spacer()
                }
                
                
                if isShowAddView{
                    Color.black.edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                self.isShowAddView = false
                            }
                        }
                    TaskAddView(isShowing: $isShowAddView)
                }
            }
            .navigationBarHidden(true)
            
        }
    }
}

//MARK: - EXTENSION
extension ContentView{
    var tabView:some View{
        TabView(selection: $currentTab) {
            TodayView()
                .padding(.top,100)
                .tag(BottomTab.today)
            
            Text("과거")
                .navigationTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .font(.largeTitle)
                .tag(BottomTab.past)
        }
        .navigationBarHidden(true)
    }
    
    var bottomTabBar:some View{
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
        .navigationBarHidden(true)
        .frame(width:UIScreen.main.bounds.width*0.9,height:60)
        .clipped()
        .background(Color.gray.opacity(0.4).blur(radius: 1).edgesIgnoringSafeArea(.bottom))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

//MARK: - PREVIEWS
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .foregroundColor(.accentColor)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

    }
}
