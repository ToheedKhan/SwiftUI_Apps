# SwiftUI_Apps
# SwiftUI_Apps

## Architecture Overview

UserListApp/

├── Models/          # Entities

├── Services/        # Network layer

├── Repositories/    # Abstractions + implementation

├── UseCases/        # Business logic

├── ViewModels/      # Presentation logic

└── Views/           # SwiftUI UI layer



# SOLID Principle Highlights
**S:** **Single Responsibility** — Each class has one purpose.

**O:** **Open/Closed** — Components are extendable but not modifiable.

**L:** **Liskov **— ViewModel depends on protocol, not concrete class.

**I:** **Interface Segregation** — Fine-grained protocols (**UserServiceProtocol**, **UserRepositoryProtocol**).

**D:** **Dependency Inversion** — Dependencies injected via initializer.
