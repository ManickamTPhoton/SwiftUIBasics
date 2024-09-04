// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Combine

class TextFieldObserver : ObservableObject {
    @Published var debouncedText = ""
    @Published var searchText = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] t in
                self?.debouncedText = t
            } )
            .store(in: &subscriptions)
    }
}

@available(macOS 11.0, *)
public struct SearchViewforSUB: View {
    @StateObject var textObserver = TextFieldObserver()
    
    public init() {}
    
    public var body: some View {
    
        VStack {
            Text("You entered: \(textObserver.debouncedText)")
                .padding()
            TextField("Enter Something", text: $textObserver.searchText)
                .frame(height: 30)
                .padding(.leading, 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.blue, lineWidth: 1)
                )
                .padding(.horizontal, 20)
        }
    }
}

