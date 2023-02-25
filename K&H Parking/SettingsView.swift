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
        .onAppear(){
            NotificationManager.scheduleAlternateNotification()
        }
    }
}


//ACCOUNT

struct SettingsAccountView: View{
    let session = PersistenceController.shared.loadSession()
    var body: some View{
        VStack{
            List{
                SettingsAccountInfoRow(title:"Név", value: session?.name ?? "failed to load")
                SettingsAccountInfoRow(title:"Email", value: session?.email ?? "failed to load")
                SettingsAccountInfo2Row(title:"Rendszámaim", value: session?.licensePlates ?? ["failed to load"])
                SettingsAccountInfo2Row(title:"Kedvencek", value: session?.favoriteNames ?? ["failed to load"])
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    // handle logout logic
                }) {
                    Text("Kijelentkezés")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                Spacer()
            }
            .padding(.bottom, 20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitle(Text("Fiók"), displayMode: .inline)
    }
}


struct SettingsAccountInfoRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
struct SettingsAccountInfo2Row: View {
    var title: String
    var value: [String]
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            VStack(alignment: .trailing) {
                ForEach(value, id: \.self) { item in
                    Text(item)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

//NOTIFICATION

struct SettingsNotificationView: View {
    
    @State var isNotificationToggleOn = true
    @State var isNotificationAutomaticToggleOn = true
    @State var notificationTime = Date()
    
    init() {
        var settings = PersistenceController.shared.loadSettings()
        if settings == nil {
            print("settings reset to default")
            PersistenceController.shared.saveSettings(settings: Settings(notifEnabled: isNotificationToggleOn, notifAutomatic: isNotificationAutomaticToggleOn, notifTime: notificationTime))
            settings = PersistenceController.shared.loadSettings()
        }
        isNotificationToggleOn = settings!.notifEnabled
        isNotificationAutomaticToggleOn = settings!.notifAutomatic
        notificationTime = settings!.notifTime
    }
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        List {
            Text("Amennyiben szükségesnek találja a rendszer, értesítés útján kér visszajelzést arról, hogy Önnek szüksége lesz-e holnapi parkolóhelyére. Ezeket itt szabhatja személyre.")
            Toggle(isOn: $isNotificationToggleOn){
                Text("Engedélyezve")
            }
            .onChange(of: isNotificationToggleOn) { newValue in
                PersistenceController.shared.saveSettings(settings: Settings(notifEnabled: isNotificationToggleOn, notifAutomatic: isNotificationAutomaticToggleOn, notifTime: notificationTime))
            }
            if isNotificationToggleOn {
                Toggle(isOn: $isNotificationAutomaticToggleOn){
                    Text("Automatikus időpont")
                }
                if !isNotificationAutomaticToggleOn {
                    NotificationTimePicker(selectedTime: $notificationTime, isNotificationToggleOn: $isNotificationToggleOn, isNotificationAutomaticToggleOn: $isNotificationAutomaticToggleOn)
                }
            }
            
        }
        .onDisappear {
            if isNotificationAutomaticToggleOn {
                notificationTime = Calendar.current.date(bySettingHour: 4, minute: 20, second: 0, of: Date())!
                NotificationManager.scheduleNotification(at: notificationTime)
            }
            PersistenceController.shared.saveSettings(settings: Settings(notifEnabled: isNotificationToggleOn, notifAutomatic: isNotificationAutomaticToggleOn, notifTime: notificationTime))
        }
        .navigationTitle("Értesítések")
        .onAppear {
            var settings = PersistenceController.shared.loadSettings()
            if settings == nil {
                print("settings reset to default")
                PersistenceController.shared.saveSettings(settings: Settings(notifEnabled: isNotificationToggleOn, notifAutomatic: isNotificationAutomaticToggleOn, notifTime: notificationTime))
                settings = PersistenceController.shared.loadSettings()
            }
            isNotificationToggleOn = settings!.notifEnabled
            isNotificationAutomaticToggleOn = settings!.notifAutomatic
            notificationTime = settings!.notifTime
        }
    }
}

struct NotificationTimePicker: View {
    @Binding var selectedTime: Date
    @Binding var isNotificationToggleOn: Bool
    @Binding var isNotificationAutomaticToggleOn: Bool
    
    var body: some View {
        DatePicker("Értesítések ideje", selection: $selectedTime, displayedComponents: .hourAndMinute)
            .datePickerStyle(.compact)
            .onChange(of: selectedTime) { newValue in
                PersistenceController.shared.saveSettings(settings: Settings(notifEnabled: isNotificationToggleOn, notifAutomatic: isNotificationAutomaticToggleOn, notifTime: selectedTime))
            }
            .onChange(of: selectedTime) { newValue in
                if(isNotificationToggleOn) {
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
