# DataLayer

Implementation of a data layer.

To see documetations for source code — build project `.docc` document

## Should contains
- API calls implementations. And all network related classes
- Repositories implementations
- CoreData / Defaults / Keychain storage implementation
- Shared storage (UserDefaults and Keychain) implementation

## Structure
- Extensions
    - CodableCoders+Extensions — shared JSONEncoder/JSONDecoder
## Guides
- Access to Data layer should provide via `DataLayer.swift`
- For convertation from `Response` object to `Entity` — subscribe `Response` data type to a `DomainEntityConvertable` protocol
- For a network stack implementation use [Alamofire](https://github.com/Alamofire/Alamofire)
