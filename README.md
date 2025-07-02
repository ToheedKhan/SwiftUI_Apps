# SwiftUI_Apps

## Architecture Overview

UserListApp/

├── Models/          # Entities

├── Services/        # Network layer

├── Repositories/    # Abstractions + implementation

├── UseCases/        # Business logic

├── ViewModels/      # Presentation logic

└── Views/           # SwiftUI UI layer

<img src="https://github.com/user-attachments/assets/847f0444-ac09-4ec8-84c3-04c73abaf47a" width="400" height="600"/>

# SOLID Principle Highlights
**S:** **Single Responsibility** — Each class has one purpose.

**O:** **Open/Closed** — Components are extendable but not modifiable.

**L:** **Liskov **— ViewModel depends on protocol, not concrete class.

**I:** **Interface Segregation** — Fine-grained protocols (**UserServiceProtocol**, **UserRepositoryProtocol**).

**D:** **Dependency Inversion** — Dependencies injected via initializer.


# Caching
Offline caching using **FileManager** and **UserDefaults** 
- Cache fetched users as a JSON file in the app's cache directory.
- Load cached users on app launch.
- Keep using network data when available.

# Coverage Summary

Test cases for **UserListViewModel**, including:

- Fetching users
- Refreshing users
- Loading more users (pagination)
- Offline caching using FileManager



| Test Case                    | What it Validates                  |
| ---------------------------- | ---------------------------------- |
| `testFetchUsersSuccess`      | Successfully fetches users         |
| `testFetchUsersFailure`      | Displays error on fetch failure    |
| `testRefreshUsers`           | Refresh replaces user list         |
| `testLoadMoreUsersIfNeeded`  | Pagination appends users           |
| `testSaveAndLoadCachedUsers` | File-based caching works correctly |

## UserService (Networking Layer)
| Layer      | File                     | Test                              |
| ---------- | ------------------------ | --------------------------------- |
| Service    | `UserServiceTests`       | API call success/failure          |

## UserRepositoryTests (Domain Logic Layer)
| Layer      | File                     | Test                              |
| ---------- | ------------------------ | --------------------------------- |
| Repository | `UserRepositoryTests`    | Data from service, error handling  |

## FetchUsersUseCase (UseCase Layer)
| Layer      | File                     | Test                              |
| ---------- | ------------------------ | --------------------------------- |
| Use Case   | `FetchUsersUseCaseTests` | Happy path + error handling       |
