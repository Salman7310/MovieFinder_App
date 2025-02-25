# MovieFinder_App

GitHub repository link:-
https://github.com/Salman7310/MovieFinder_App

An iOS app demonstrating modern SwiftUI development with Combine and Core Data integration.

## Features
- Movie search using OMDb API
- Favorite movie persistence
- Network error handling
- Unit tested components

## 🛠 Technical Approach

### API Integration
- **OMDb API** for movie data
- Combine-based `HTTPClient` with:
  - Request validation
  - Error mapping (`NetworkError` enum)
  - Response decoding
  - Status code checking
- Example request:
  ```swift
  func searchMovies(_ query: String) -> AnyPublisher<[Movie], NetworkError> {
      // API implementation
  }


Prerequisites
Xcode 15+

iOS 17+ Simulator
OMDb API key

Installation
Clone repo:-

  - git clone https://github.com/Salman7310/MovieFinder_App
  - Add API Key:- 
  
  OMDB_API_KEY = 564727fa
  
  - Open MovieApp.xcodeproj
  
Running Tests
In Xcode:
Product > Test (⌘U)

Specific test class:
Right-click test file > "Run"

📱 Screenshots
 
  - Search View:- 
    /var/folders/rq/xw2f1rd90rsf93g92ym7tw4w0000gn/T/simulator_screenshot_AC11E2F5-2EA5-45C4-A72C-0B47895CD558.png
    /var/folders/rq/xw2f1rd90rsf93g92ym7tw4w0000gn/T/simulator_screenshot_958D60E5-81A5-46B2-B1C2-7CFDC06AFF0D.png
    
  - Detail View:-
    /var/folders/rq/xw2f1rd90rsf93g92ym7tw4w0000gn/T/simulator_screenshot_CA8711D7-F454-45C7-81D9-9641C6520125.png
    
  - Favorites:-
    /var/folders/rq/xw2f1rd90rsf93g92ym7tw4w0000gn/T/simulator_screenshot_A2BDD3D6-A96D-475F-B0A3-C18EBEA0E750.png

     
📄 License
MIT License.

https://github.com/Salman7310/MovieFinder_App






