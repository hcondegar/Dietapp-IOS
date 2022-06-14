//
//  SwiftUIView.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 1/6/22.
//

import SwiftUI

struct SwiftUIView: View {
    let interval: DateInterval

    @EnvironmentObject var store: Store<CalendarState, CalendarAction>
    @State private var selectedDate: Date?

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            CalendarView(interval: interval, onHeaderAppear: fetch) { date in
                Button(action: { self.selectedDate = date }) {
                    DateView(date: date) {
                        // Some content here
                    }
                }
            }
        }
        .navigationBarTitle("calendar", displayMode: .inline)
        .navigate(using: $selectedDate, destination: makeDestination)
    }

    @ViewBuilder
    private func makeDestination(for date: Date) -> some View {
        // create and configure destination view here
    }
}
