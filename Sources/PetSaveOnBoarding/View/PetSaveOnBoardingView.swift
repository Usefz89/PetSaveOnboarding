/// Copyright (c) 2023 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct PetSaveOnBoardingView: View {
  @State var currentPageIndex: Int = 0
  private var items: [OnBoardingModel] = []
  
  
  public init(items: [OnBoardingModel]) {
    self.items = items
  }
  private var onNext: (_ currentIndex: Int) -> Void = { _ in}
  private var onSkip: () -> Void = {}
  private var nextButtonTitle: String {
    return items[currentPageIndex].nextButtonTitle
  }
  private var skipButtonTitle: String {
    return items[currentPageIndex].skipButtonTitle
  }
  
    var body: some View {
      if items.isEmpty {
        Text("There is no items to share")
        
      }else {
        VStack {
          TabView(selection: $currentPageIndex) {
            ForEach(items.indices) { index in
              OnBoardingView(onboarding: items[index])
            }
          }
          .padding(.bottom, 10)
          .tabViewStyle(.page)
          .indexViewStyle(.page(backgroundDisplayMode: .always))
          .onAppear { setupPageControlApprearance() }
          
          Button(action: next) {
            Text(nextButtonTitle)
              .frame(maxWidth: .infinity, maxHeight: 44)
          }
          .animation(nil, value: currentPageIndex)
          .buttonStyle(OnboardingButtonStyle(color: .rwBlack))
          
          Button(action: onSkip) {
            Text(skipButtonTitle)
              .frame(maxWidth: .infinity, maxHeight: 44)
          }
          .animation(nil, value: currentPageIndex)
          .buttonStyle(OnboardingButtonStyle(color: .rwGreen))
          .padding(.bottom, 20)
        }
        .background(OnBoardingBackgroundView())
      }
    }
  
  private func onNext(action: @escaping (_ currentIndex: Int) -> Void) -> Self {
    var onboardingView = self
    onboardingView.onNext = action
    return onboardingView
  }
  
   func onSkip(action: @escaping () -> Void) -> Self {
    var onboardingView = self
    onboardingView.onSkip = action
    return onboardingView
  }
  
  private func setupPageControlApprearance() {
    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.rwGreen)
  }
  
  private func next() {
    withAnimation {
      if currentPageIndex + 1 < items.count {
        currentPageIndex += 1
        
      } else {
        currentPageIndex = 0
      }
      onNext(currentPageIndex)
    }
  }
}

struct OnboardingButtonStyle: ButtonStyle {
  let color: Color
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .background(color)
      .clipShape(Capsule())
      .buttonStyle(.plain)
      .padding(.horizontal, 20)
      .foregroundColor(.white)
    
  }
  
  
}



struct PetSaveOnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        PetSaveOnBoardingView(items: mockOnBoarding)
    }
}

private extension PreviewProvider {
  static var mockOnBoarding: [OnBoardingModel] {
    [
      OnBoardingModel(title: "Welcome to PetSave", description: "PetSave is the best appplication for finding your future pe athat will live with you", image: .dogBone),
      OnBoardingModel(title: "Start by finding the type", description: "Find the type you are loodking for and choose the subcategory to proceed", image: .catPurr),
      OnBoardingModel(title: "When finish pay the fukcing amount", description: "Sory for being angray but sometimes people don't pay", image: .bird)
      
    ]
  }
}
