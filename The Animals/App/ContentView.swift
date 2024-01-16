//
//  ContentView.swift
//  The Animals
//
//  Created by Muhamad Fardan Wardhana on 11/01/24.
//

import SwiftUI

struct ContentView: View {
  @State var listAnimalsShow: Bool = false
  
  var body: some View {
    VStack(spacing: 32) {
      Image("animals-image")
        .renderingMode(.template)
        .imageScale(.large)
        .foregroundColor(.white)
      
      Text("The Animals")
        .font(Font.system(size: 32, weight: .bold))
        .foregroundColor(.white)
    }
    .onAppear {
      _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { timer in
        listAnimalsShow = true
      })
    }
    .padding()
    .fullScreenCover(isPresented: $listAnimalsShow) {
      ListAnimalsView()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
