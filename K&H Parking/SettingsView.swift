//
//  SettingsView.swift
//  K&H Parking
//
//  Created by Nara Csutora on 2023. 02. 23..
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section(header: Text("Fiók")){
                NavigationLink(destination: SettingsAccountView()) {
                    Label("Fiók kezelése", systemImage: "person")
                }
            }
            Section(header: Text("Általános")) {
                NavigationLink(destination: SettingsUsersGuideView()) {
                    Label("Felhasználói útmutató", systemImage: "book")
            }
                NavigationLink(destination: SettingsNotificationView()) {
                    Label("Értesítések", systemImage: "bell")
                }
                NavigationLink(destination: SettingsLanguageView()) {
                    Label("Nyelv", systemImage: "globe")
                }
            }
            Section(header: Text("Egyéb")){
                NavigationLink(destination: SettingsTermsAndCond()) {
                    Label("Felhasználási feltételek", systemImage: "doc.text")
                }
                NavigationLink(destination: SettingsContactUs()) {
                    Label("Elérhetőség", systemImage: "envelope")
                }
                NavigationLink(destination: SettingsImpressum()) {
                    Label("Impresszum", systemImage: "info.circle")
                }
            }
        }
    }
}


//ACCOUNT

struct SettingsAccountView: View{
    
    var body: some View{
        Text("ad")
            .navigationTitle("Fiók kezelése")
    }
}

//NOTIFICATION

struct SettingsNotificationView: View {
    
    let isToggleOnKey = "isToggleOn"
    @State var isNotificationToggleOn = false
    
    init(){
        _isNotificationToggleOn = State(initialValue: UserDefaults.standard.bool(forKey: isToggleOnKey))
    }
    
    @State var notificationTime = Date()
    @State private var hasTestRun = false
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        List {
            Text("Amennyiben szükségesnek találja a rendszer, értesítés útján kér visszajelzést arról, hogy Önnek szüksége lesz-e holnapi parkolóhelyére. Ezeket itt szabhatja személyre.")
            NotificationTimePicker(selectedTime: $notificationTime)
            Toggle(isOn: $isNotificationToggleOn){
                Text("Engedélyezve")
            }
            .onChange(of: isNotificationToggleOn) { newValue in
                UserDefaults.standard.set(newValue, forKey: isToggleOnKey)
                if newValue && !hasTestRun {
                    NotificationManager.shared.requestAuthorization()
                    hasTestRun = true
                }
            }
            
        }
        .navigationTitle("Értesítések")
        .onAppear {
            if let loadedNotificationTime = PersistenceController.shared.loadNotificationTime() {
                notificationTime = loadedNotificationTime
            }
        }
    }
}

struct NotificationTimePicker: View {
    @Binding var selectedTime: Date
    
    var body: some View {
        DatePicker("Értesítések ideje", selection: $selectedTime, displayedComponents: .hourAndMinute)
            .datePickerStyle(.compact)
            .onChange(of: selectedTime) { newValue in
                            PersistenceController.shared.saveNotificationTime(notificationTime: newValue)
            }
            .onChange(of: selectedTime) { newValue in
                if(UserDefaults.standard.bool(forKey: "isToggleOn")) {
                    NotificationManager.scheduleNotification(at: newValue)
                }
            }

    }
}

//USERS GUIDE

struct SettingsUsersGuideView: View {
    var body: some View {
        ScrollView{
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce at neque lorem. Sed tincidunt finibus lacus, ac laoreet est lobortis sed. Nullam eleifend posuere magna, eget euismod magna tincidunt nec. Nullam semper bibendum justo, vel vehicula nisl tincidunt in. Proin vitae felis elit. Sed bibendum gravida urna, id congue libero aliquam id. Curabitur bibendum eget urna vel congue. Nunc aliquam tempor arcu ac pellentesque. Sed sit amet convallis nisi. Proin vel sapien orci. Maecenas porttitor, ipsum eget feugiat efficitur, nibh arcu convallis odio, in ultrices eros tortor a nunc. Nunc euismod sagittis augue, ac malesuada arcu auctor eget. Fusce vestibulum nisi libero, in placerat magna maximus at.")
            .padding()
        }
        .navigationTitle("Útmutató")
    }
}

//LANGUAGE

struct SettingsLanguageView: View {
    @State private var selectedLanguage = 1
    
    let languages = ["English", "Magyar"]
    
    var body: some View {
        VStack {
            Picker(selection: $selectedLanguage, label: Text("Nyelv kiválasztása")) {
                ForEach(0..<2) { index in
                    Text(languages[index])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            Spacer()
        }
        .padding()
        .navigationTitle("Nyelv")
    }
}



//TERMS AND CONDITIONS

struct SettingsTermsAndCond: View{
    var body: some View{
        ScrollView{
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce at neque lorem. Sed tincidunt finibus lacus, ac laoreet est lobortis sed. Nullam eleifend posuere magna, eget euismod magna tincidunt nec. Nullam semper bibendum justo, vel vehicula nisl tincidunt in. Proin vitae felis elit. Sed bibendum gravida urna, id congue libero aliquam id. Curabitur bibendum eget urna vel congue. Nunc aliquam tempor arcu ac pellentesque. Sed sit amet convallis nisi. Proin vel sapien orci. Maecenas porttitor, ipsum eget feugiat efficitur, nibh arcu convallis odio, in ultrices eros tortor a nunc. Nunc euismod sagittis augue, ac malesuada arcu auctor eget. Fusce vestibulum nisi libero, in placerat magna maximus at.")
                .padding()
        }
        .navigationTitle("Feltételek")
    }
}

//CONTACT US

struct SettingsContactUs: View {
    var body: some View {
        VStack {
            Text("Ha bármilyen kérdése van, itt tud elérni minket:")
                .multilineTextAlignment(.center)
                .padding(.top)
            Text("support@khparking.com")
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.top, 5)
            Spacer()
                }
            .padding()
            .navigationTitle("Elérhetőség")
    }
}

//IMPRESSIUM

struct SettingsImpressum: View{
    var body: some View{
        VStack {
            Text("made with ❤️")
                .fontWeight(.bold)
            Text("by:")
                .italic()
            Text("")
            Text("Laci")
            Text("Csuti")
            Text("Péter")
        }
    }
}
