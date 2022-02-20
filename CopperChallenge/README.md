#  Copper iOS Assessment Test - David Pasztor

## Architecture choices
- I chose MVVM as my architecture, since in my opinion this is the architecture best suited to app development at the moment, with the ideal number of entities for each screen
    - MVVM is also Apple's choice for SwiftUI apps
    - In a more complex app with several screens, I'd also use Coordinators (MVVM-C)
    - The use of Coordinators helps decouple screens from each other, making it possible to present a screen from anywhere, without needing hardcoded navigation flows, while also helping to achieve the single responsibility principle by removing navigation responsibility from the view
- Some extra entities are added when needed to better achieve single responsibility principle and separation of concerns and don't put too much responsibility on the view models. These are the following:
    - Network: entity responsible for the low-level networking, network error handling, response decoding.
    - Data providers: this abstraction layer lives between the networking layer and the view models. Data providers are specialised towards specific features, so in a larger app, there would be several data providers. For instance if the app would communicate with different backend services/APIs, each service/API would have its own data provider.
        - There's also a data provider responsible for interacting with CoreData
- I chose SwiftUI as my UI framework, since it is the present and future of UI framework targeting Apple platforms, moreover it makes multiplatform development much easier, since there's a unified UI framework for all platforms and some reusable components can even be shared between platforms if needed

## Testing
- `View`s are not tested due to time constraints, however, in a production app, I'd suggest snapshot testing views and UI testing the user interaction/navigation
- ViewModels, data providers and the networking layer are mostly unit tested, however, due to time constraints, there isn't 100% unit test coverage, for production code, I'd aim to achieve even better coverage than in this coding challenge

## Further improvements
- Modularise the code, split the UI and business logic into separate modules
    - This would even better ensure that there are no UI imports in the business module
    - Would further ensure separation of concerns
- Add a launch screen
- Improve error handling
    - Improve error messages displayed to the user
- Improve error handling
    - Improve error handling in `LocationManager`, display a specific error when the user didn't grant location priviliges and tell the user when the default location is used
    - Improve error messages displayed to the user
- Increase unit test coverage

## Missing requirements
- How to display buy/sell transactions
  - Designs always showed BTC -> ETH
  - Both for buy and sell trades
  - We only get back 1 currency for each trade
  - Hence I assumed we always want to display currency -> ETH for sell/buy transactions
- Ordering
  - Designs show all trades having the exact same timestamp
  - I chose to display transactions sorted by their date, in an ascending order
- Light/dark mode
  - The designs only showed 1 theme, so I assumed the same theming was required for both light and dark mode
