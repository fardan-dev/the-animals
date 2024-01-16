//
//  SnapCarousel.swift
//  
//
//  Created by Muhamad Fardan Wardhana on 22/08/23.
//

import SwiftUI

struct SnapCarousel<Content: View, T: Identifiable>: View {
  var content: (T) -> Content
  var list: [T]
  
  var spacing: CGFloat
  var trailingSpace: CGFloat
  @Binding var index: Int
  
  init(spacing: CGFloat = 16, trailingSpace: CGFloat = 32, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T) -> Content) {
    self.spacing = spacing
    self.trailingSpace = trailingSpace
    self._index = index
    self.list = items
    self.content = content
  }
  
  @GestureState var offset: CGFloat = 0
  @State var currentIndex: Int = 0
  @State var isDragUpdating = false
  
  var body: some View {
    GeometryReader { proxy in
      let width = proxy.size.width - (trailingSpace - spacing)
      let adjustMentWidth = (trailingSpace / 2) - spacing
      
      HStack(spacing: spacing) {
        ForEach(list) { item in
          content(item)
            .frame(width: proxy.size.width - trailingSpace)
        }
      }
      .padding(.horizontal, spacing)
      .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustMentWidth : 0) + offset)
      .gesture(
        DragGesture()
          .updating($offset, body: { value, out, _ in
            out = value.translation.width
          })
          .onEnded({ value in
            let offsetX = value.translation.width
            let progress = -offsetX / width
            let roundIndex = progress.rounded()
            currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
            currentIndex = index
            isDragUpdating = false
          })
          .onChanged({ value in
            isDragUpdating = true
            let offsetX = value.translation.width
            let progress = -offsetX / width
            let roundIndex = progress.rounded()
            index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
          })
      )
      .onChange(of: index) { index in
        if currentIndex != index && isDragUpdating == false {
          currentIndex = index
        }
      }
      .animation(Animation.easeInOut, value: currentIndex != index)
    }
    .animation(.easeInOut, value: offset == 0)
  }
}
