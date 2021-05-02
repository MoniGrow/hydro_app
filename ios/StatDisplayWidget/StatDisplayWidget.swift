//
//  StatDisplayWidget.swift
//  StatDisplayWidget
//
//  Created by jerry on 4/27/21.
//

import os
import WidgetKit
import SwiftUI
import Intents
import Firebase

struct Provider: IntentTimelineProvider {
    var currentUserUid: String
    var currentDataType: String
    
    func placeholder(in context: Context) -> DataEntry {
        DataEntry(date: Date(), dataType: currentDataType, data: "", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (DataEntry) -> ()) {
        if currentUserUid != "" {
            var currentData: String = "null"
            let db = Firestore.firestore()
            let dataCollection = db.collection("ESP32data").document(currentUserUid).collection("sensorData")
            dataCollection.order(by: "timestamp", descending: true).limit(to: 1).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    os_log("Error getting documents: \(String(describing: err))")
                } else {
                    if querySnapshot!.count > 0 {
                        let document = querySnapshot!.documents.first
                        currentData = String(describing: document!.data()[currentDataType])
                    }
                }
                let entry = DataEntry(date: Date(), dataType: currentDataType, data: currentData, configuration: configuration)
                completion(entry)
            }
        } else {
            let entry = DataEntry(date: Date(), dataType: "null", data: "no user", configuration: configuration)
            print("No user signed in on device")
            os_log("No user signed in on device")
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        if currentUserUid != "" {
            var currentData: String = "null"
            let db = Firestore.firestore()
            let dataCollection = db.collection("ESP32data").document(currentUserUid).collection("sensorData")
            dataCollection.order(by: "timestamp", descending: true).limit(to: 1).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    os_log("Error getting documents: \(String(describing: err))")
                } else {
                    if querySnapshot!.count > 0 {
                        let document = querySnapshot!.documents.first
                        currentData = String(describing: document!.data()[currentDataType])
                    }
                }
                let entry = DataEntry(date: Date(), dataType: currentDataType, data: currentData, configuration: configuration)
                let timeline = Timeline(
                            entries:[entry],
                            policy: .after(nextUpdateDate)
                        )
                completion(timeline)
            }
        } else {
            let entry = DataEntry(date: Date(), dataType: "null", data: "no user", configuration: configuration)
            let timeline = Timeline(
                        entries:[entry],
                        policy: .after(nextUpdateDate)
                    )
            print("No user signed in on device")
            os_log("No user signed in on device")
            completion(timeline)
        }
    }
}

struct DataEntry: TimelineEntry {
    var date: Date
    
    let dataType: String
    let data: String
    let configuration: ConfigurationIntent
}

struct StatDisplayWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("\(entry.dataType): \(entry.data)")
    }
}

@main
struct StatDisplayWidget: Widget {
    let kind: String = "StatDisplayWidget"
    let uid = UserDefaults.standard.string(forKey: "uid") == nil ? "" : UserDefaults.standard.string(forKey: "uid")

    init() {
        FirebaseApp.configure()
        print("is this thing on? printing? init StatDisplayWidget")
    }
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(currentUserUid: uid!, currentDataType: "temperature")) { entry in
            StatDisplayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct StatDisplayWidget_Previews: PreviewProvider {
    static var previews: some View {
        StatDisplayWidgetEntryView(entry: DataEntry(date: Date(), dataType: "temperature", data: "1", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
