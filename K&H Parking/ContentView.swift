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
        
        
        
        let calendarStatus: CalendarStatus? = PersistenceController.shared.loadCalendarStatus()
        if calendarStatus == nil {
            
            var cs: CalendarStatus = CalendarStatus(days: [])
            var currDate = startDate
            var i = 0
            
            while currDate < endDate {
                cs.days.append(DayData(day: currDate, id: i))
                currDate = calendar.date(byAdding: .day, value: 1, to: currDate)!
                i += 1
                
            }
            
            PersistenceController.shared.saveCalendarStatus(cs)
            days = PersistenceController.shared.loadCalendarStatus()!.days
        } else {
            days = calendarStatus!.days
        }
        
        
        
    }
}

struct ContentView: View {
    @StateObject var sd = SharedData()
    @State var showingSettings = false
    @State var showingDayTools = false
    @State var showingLoginPage = false
    @State var showingMapTakenPage = false
    @State var showingMapGuidePage = false
    @State var selectedDetent = PresentationDetent.fraction(0.4)
    @State var blurRadius: CGFloat = 0
    
    @State var selectedType: Int = 0
    @State var priority: Bool = false
    @State var hasPriority: Bool = true
    
    
    var body: some View {
        VStack {
            
            ScrollableDaySelectorView(sd: sd, sdt: $showingDayTools, selectedType: $selectedType)
                .sheet(isPresented: $showingDayTools) {
                    NavigationView {
                        
                        List {
                            if selectedType == 1 {
                                Toggle(isOn: $priority) {
                                    Text("Elsőbbségi foglalás")}.disabled(!hasPriority)
                            }
                                Button(action: {
                                    for day in sd.selectedDays.map( { $0.id } ) {
                                        switch selectedType {
                                            case 1:
                                                let isAvailable = Float.random(in: 0...1)
                                                if priority && hasPriority {
                                                    sd.days[day].isPriority = true
                                                    hasPriority = false
                                                    priority = false
                                                }
                                                else if isAvailable > 0.3 {
                                                    sd.days[day].isReserved = true
                                                } else {
                                                    sd.days[day].isQueue = true
                                                }
                                            case -1:
                                                sd.days[day].isSelected = false
                                                sd.days[day].isReserved = false
                                                sd.days[day].isQueue = false
                                                if sd.days[day].isPriority {
                                                    hasPriority = true
                                                }
                                                sd.days[day].isPriority = false
                                            default:
                                                print("Valami nagy baj van")
                                            }
                                        sd.days[day].isSelected = false
                                        }
                                    selectedType = 0
                                    showingDayTools = false
                                    sd.selectedDays.removeAll()
                                }) {
                                    switch selectedType {
                                    case 1:
                                        Text("Foglalás").fontWeight(.bold)
                                    case -1:
                                        Text("Felajánlás bárkinek").fontWeight(.bold)
                                    default:
                                        Text("Hiba bejelentése")
                                    }
                                }
                                if selectedType == -1 {
                                    Button(action: {
                                        
                                        for day in sd.selectedDays.map( { $0.id } ) {
                                            sd.days[day].isSelected = false
                                            sd.days[day].isReserved = false
                                            sd.days[day].isQueue = false
                                            if sd.days[day].isPriority {
                                                hasPriority = true
                                            }
                                            sd.days[day].isPriority = false
                                        }
                                        selectedType = 0
                                        showingDayTools = false
                                        sd.selectedDays.removeAll()
                                    }) {
                                        Label(
                                            title: { Text("Török Péter") },
                                            icon: { Image(systemName: "star") }
                                        )
                                    }

                                    Button(action: {
                                        for day in sd.selectedDays.map( { $0.id } ) {
                                            sd.days[day].isSelected = false
                                            sd.days[day].isReserved = false
                                            sd.days[day].isQueue = false
                                            if sd.days[day].isPriority {
                                                hasPriority = true
                                            }
                                            sd.days[day].isPriority = false
                                        }
                                        selectedType = 0
                                        showingDayTools = false
                                        sd.selectedDays.removeAll()
                                    }) {
                                        Label(
                                            title: { Text("Csutora Nara") },
                                            icon: { Image(systemName: "star") }
                                        )
                                    }

                                    Button(action: {
                                        for day in sd.selectedDays {
                                            sd.days[day.id].isSelected = false
                                            selectedType = 0
                                        };
                                    }) {
                                        Label(
                                            title: { Text("Valaki másnak...") },
                                            icon: { Image(systemName: "magnifyingglass") }
                                        )
                                    }
                                    
                                }
                            
                            
                            

                            
                        }
                        
                        .onAppear {
                            selectedDetent = ( selectedType == -1 ? PresentationDetent.fraction(0.4) : PresentationDetent.fraction(0.3) )
                        }
                    .navigationTitle(selectedType == -1 ?  "Felajánlás..." :  "Foglalás...")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Mégse", action: {
                                showingDayTools = false
                                for day in sd.selectedDays {
                                    sd.days[day.id].isSelected = false
                                    selectedType = 0
                                };
                                sd.selectedDays.removeAll()
                                
                            })
                        }
                    }
                }
                    .presentationDetents(undimmed: [.fraction(0.4)])
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.fraction(0.3), .fraction(0.4)], selection: $selectedDetent)
                    .onAppear {
                        withAnimation() { blurRadius = 8 }
                    }
                    .onDisappear {
                        withAnimation() { blurRadius = 0 }
                    }
                                        
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
                            .shadow(radius: 8)
                            .ignoresSafeArea(edges: .bottom)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                   )
                VStack {
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(Color(.systemGreen))
                            .font(.title)
                            .padding(.leading, 15.0)
                            .padding(.trailing, 5.0)
                        
                            Text("Mai Helyed:")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        Button(action: {
                            showingMapGuidePage = true
                        }) {
                            Text("025")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .frame(width: 90, height: 50)
                                .background(Color(UIColor.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.trailing, 15.0)
                        }

                    }
                    .sheet(isPresented: $showingMapGuidePage) {
                        NavigationView{
                            MapGuideView()
                                .navigationTitle("")
                                .toolbar {
                                    ToolbarItem(placement: .confirmationAction) {
                                        Button("Kész", action: {showingMapGuidePage = false})
                                    }
                                }
                        }
                        .presentationDetents([.fraction(0.57)])
                    }
                    .padding(.top, 20.0)
                    .padding()
                    
                    HStack {
                        Image(systemName: "checkmark.circle.badge.questionmark")
                            .foregroundColor(Color(.systemYellow))
                            .font(.title)
                            .padding(.leading, 15.0)
                            .padding(.trailing, 5.0)
                        
                        VStack {
                            Text("Holnap várhatóan")
                                .font(.title)
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("lesz helyed")
                                .font(.title)
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal, 30.0)
                        .padding(.vertical)
                    
                    HStack {
                        VStack {
                            Image(systemName: "car")
                                .foregroundColor(Color(.systemGray))
                                .font(.system(size: 50))
                                .padding(.horizontal, 20.0)
                                .padding(.vertical)
                            Text("56 szabad hely")
                            ProgressView(value: 0.7)
                                .progressViewStyle(LinearProgressViewStyle(tint: Color.green))
                                .padding([.bottom, .horizontal])
                        }
                        .fontWeight(.medium)
                        .frame(width: 150, height: 150)
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                        
                        VStack {
                            Image(systemName: "bolt.car")
                                .foregroundColor(Color(.systemGray))
                                .font(.system(size: 50))
                                .padding(.horizontal, 20.0)
                                .padding(.vertical)
                            Text("3 szabad töltő")
                            ProgressView(value: 0.3)
                                .progressViewStyle(LinearProgressViewStyle(tint: Color.red))
                                .padding([.bottom, .horizontal])
                        }
                        .fontWeight(.medium)
                        .frame(width: 150, height: 150)
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                    }
                    .padding(.horizontal, 15.0)
                    
                    Divider()
                        .padding(.horizontal, 30.0)
                        .padding(.vertical)
                    
                    Button("Beálltak a helyemre", action: {
                        /*TODO show new view with input field that then returns with an updated spot*/
                        showingMapTakenPage = true
                    })
                    .sheet(isPresented: $showingMapTakenPage) {
                        NavigationView{
                            MapTakenView()
                                .navigationTitle("")
                                .toolbar {
                                    ToolbarItem(placement: .confirmationAction) {
                                        Button("Kész", action: {showingMapTakenPage = false})
                                    }
                                }
                            
                        }
                    }
                    
                    
                    
                    Spacer()
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                .blur(radius: blurRadius)
                
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
            }
            .navigationTitle("Belépés")
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden)
            .interactiveDismissDisabled(true)
            .onDisappear() {
                NotificationManager.shared.requestAuthorization()
            }
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
        .onAppear(){
            UIApplication.shared.applicationIconBadgeNumber=0
        }
        
    }
}


struct ScrollableDaySelectorView: View {
    @ObservedObject var sd: SharedData
    var sdt: Binding<Bool>
    let week = ["Hé", "Ke", "Sze", "Cs", "Pé", "Szo", "Va"]
    var selectedType: Binding<Int>
    
    init(sd: SharedData, sdt: Binding<Bool>, selectedType: Binding<Int>) {
        self.sd = sd
        self.sdt = sdt
        self.selectedType = selectedType
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
                    DayItem(id: day.id, sd: sd, sdt: sdt, selectedType: self.selectedType)
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
    var selectedType: Binding<Int>
    init(id: Int, sd: SharedData, sdt: Binding<Bool>, selectedType: Binding<Int>) {
        self.sd = sd
        self.id = id
        self.sdt = sdt
        self.selectedType = selectedType
    }
    
    var body: some View {
        Button(action: { toggleSelected() }) {
            Text("\(sd.calendar.component(.day, from: sd.days[id].day))")
                .frame(width: 35, height: 35)
                .background(sd.days[id].isSelected ? sd.days[id].isPriority ? Color.cyan : sd.days[id].isReserved ? Color.green : sd.days[id].isQueue ? Color.yellow : Color.gray : Color.clear)
                .clipShape(Circle())
                .fontWeight(sd.calendar.isDate(sd.days[id].day, inSameDayAs: Date()) ? .heavy : .regular)
                .foregroundColor(sd.days[id].isSelected ? Color.primary : sd.days[id].isPriority ? Color.blue : sd.days[id].isReserved ? Color.green : sd.days[id].isQueue ? Color.yellow : id % 7 >= 5 ? Color.secondary : Color.primary)
        }
        .padding(.horizontal, 10.0)
    }
    
    func toggleSelected() {
        let isReserved = sd.days[id].isReserved || sd.days[id].isQueue || sd.days[id].isPriority
        //ne tudjon másikdra nyomni
        if selectedType.wrappedValue != 0 {
            if ((isReserved && selectedType.wrappedValue == 1 ) || (!isReserved && selectedType.wrappedValue == -1)){
                return;
            }
        }
        //selectedType beálltása
        else {
            if (sd.days[id].isReserved || sd.days[id].isQueue || sd.days[id].isPriority) {selectedType.wrappedValue = -1}
            else {selectedType.wrappedValue = 1}
        }
        
        sd.days[id].isSelected.toggle()
        if (sd.days[id].isSelected) {
            sd.selectedDays.append(sd.days[id])
        } else {
            sd.selectedDays.removeAll{ $0.id == id }
            if sd.selectedDays.isEmpty {
                selectedType.wrappedValue = 0
            }
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
