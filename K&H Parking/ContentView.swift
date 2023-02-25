//
//  ContentView.swift
//  K&H Parking
//
//  Created by Nara Csutora on 2023. 02. 22..
//

import SwiftUI
import CoreData
import SwiftUIKit

class SharedData: ObservableObject {
    @Published var selectedDays: [DayData] = []
    @Published var days: [DayData] = []
    @Published var calendar = Calendar.current
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    
    init() {
        startDate = calendar.startOfWeek(for: Date()) // Start of this week
        endDate = startDate.addingTimeInterval(21 * 24 * 60 * 60) // Two weeks from the start of this week
        
        var currDate = startDate
        var i = 0
        
        while currDate < endDate {
            days.append(DayData(day: currDate, id: i))
            currDate = calendar.date(byAdding: .day, value: 1, to: currDate)!
            i += 1
            
        }
        
    }
}

struct ContentView: View {
    @StateObject var sd = SharedData()
    @State var showingSettings = false
    @State var showingDayTools = false
    @State var showingLoginPage = false
    @State var selectedDetent = PresentationDetent.fraction(0.2)
    
    var body: some View {
        VStack {
            
            ScrollableDaySelectorView(sd: sd, sdt: $showingDayTools)
                .sheet(isPresented: $showingDayTools, onDismiss: { selectedDetent = PresentationDetent.fraction(0.2) }) {
                    NavigationView {
                        List {
                            Text("Működik")
                            // TODO add options for reserving and cancelling and all that
                        }
                            .navigationTitle("Napok kezelése")
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Mégse", action: {
                                        showingDayTools = false;
                                        selectedDetent = PresentationDetent.fraction(0.2);
                                        for day in sd.selectedDays {
                                            sd.days[day.id].isSelected = false
                                        };
                                        sd.selectedDays.removeAll()
                                        
                                    })
                                }
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Kiválasztás", action: { selectedDetent = PresentationDetent.fraction(0.72) })
                                }
                            }
                    }
                    .presentationDetents(undimmed: [.fraction(0.2)])
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled(true)
                    .presentationDetents([.fraction(0.2), .fraction(0.72)], selection: $selectedDetent)
                                        
                }
                .padding(.bottom)
                .background(Color(UIColor.secondarySystemBackground))
            ZStack {
                VStack {
                    Spacer()
                }
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 30)
                        //.stroke(.blue, lineWidth: 5)
                            .fill(Color(UIColor.systemBackground))
                            .shadow(radius: 4)
                            .ignoresSafeArea(edges: .bottom)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                   )
                VStack {
                    Text("smthn")
                    Spacer()
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                
                
            }
            
            Spacer()
            
        }
        .padding(.top)
        .ignoresSafeArea(edges: .bottom)
        .onAppear(perform: {
            if let session = PersistenceController.shared.loadSession() {
                print("already logged in: " + session.name)
            } else {
                showingLoginPage = true
            }
        })
        .sheet(isPresented: $showingLoginPage) {
            NavigationView {
                LoginView(slp: $showingLoginPage)
                
                    //TODO
            }
            .navigationTitle("Belépés")
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden)
            .interactiveDismissDisabled(true)
            
        }
        .onDisappear() {
            NotificationManager.shared.requestAuthorization()
        }
        

            
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text(showingDayTools ? String(sd.selectedDays.count) + " nap kiválasztva" : "Áttekintés")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSettings.toggle()
                } label: {
                    Image(systemName: "gear")
                }
                .sheet(isPresented: $showingSettings) {
                    NavigationView{
                        SettingsView()
                            .navigationTitle("Beállítások")
                            .toolbar {
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Kész", action: {showingSettings = false})
                                }
                            }
                    }
                    
                    
                }
                
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
        
    }
}

struct ScrollableDaySelectorView: View {
    @ObservedObject var sd: SharedData
    var sdt: Binding<Bool>
    let week = ["Hé", "Ke", "Sze", "Cs", "Pé", "Szo", "Va"]
    init(sd: SharedData, sdt: Binding<Bool>) {
        self.sd = sd
        self.sdt = sdt
    }
    
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(week, id: \.self) { day in
                    Text(day)
                        .frame(width: 50)
                        .fontWeight(.light)
                        .foregroundColor(Color.secondary)
                }
            }
            
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(sd.days) { day in
                    DayItem(id: day.id, sd: sd, sdt: sdt)
                }
            }
        }
        .padding(.horizontal)
        
            
    }
    
    
}

struct DayItem: View, Identifiable {
    @ObservedObject var sd: SharedData
    var sdt: Binding<Bool>
    var id: Int
    init(id: Int, sd: SharedData, sdt: Binding<Bool>) {
        self.sd = sd
        self.id = id
        self.sdt = sdt
    }
    
    var body: some View {
        Button(action: { toggleSelected() }) {
            Text("\(sd.calendar.component(.day, from: sd.days[id].day))")
                .frame(width: 35, height: 35)
                .background(sd.days[id].isSelected ? Color.accentColor : Color.clear)
                .clipShape(Circle())
                .fontWeight(sd.calendar.isDate(sd.days[id].day, inSameDayAs: Date()) ? .heavy : .regular)
                .foregroundColor(sd.days[id].isSelected ? Color.primary : sd.calendar.isDate(sd.days[id].day, inSameDayAs: Date()) ? Color.accentColor : id % 7 >= 5 ? Color.secondary : Color.primary)
        }
        .padding(.horizontal, 10.0)
    }
    
    func toggleSelected() {
        sd.days[id].isSelected.toggle()
        if (sd.days[id].isSelected) {
            sd.selectedDays.append(sd.days[id])
        } else {
            sd.selectedDays.removeAll{ $0.id == id }
        }
        if sd.selectedDays.isEmpty {
            sdt.wrappedValue = false
        } else {
            sdt.wrappedValue = true
        }
    }
    
    
}


extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        var components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        components.weekday = firstWeekday
        return self.date(from: components)!
    }

}

extension Date {
    func dayNameOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "ccc"
        return formatter.string(from: self)
    }
}
