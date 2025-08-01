# eCommerce Mobile App

This project implements an eCommerce mobile application using **Clean Architecture** and **TDD** practices.

## Project Structure

```
->lib/
    -core/ # Shared utilities and error handling
    -features/
        -product/ # eCommerce product module
            -domain/ # Entities, repositories, and use cases
            -data/ # Models, datasources, and repository implementations
            -presentation/ # UI and state management
->test/ # Unit and widget tests
```


## Data Flow

1. **Presentation Layer** → UI calls a **Use Case**.
2. **Domain Layer** → Use Case interacts with **Repository (abstract)**.
3. **Data Layer** → Repository implementation calls a **Data Source** (API/local).
4. **Entities & Models** → Data Source maps JSON to **ProductModel** which extends **Product** (Entity).

## Testing

- Unit tests are located under `test/` and cover models, use cases, and repository behaviors.
- Run tests using:
```
flutter test
```

## Architecture

* This project follows Uncle Bob's Clean Architecture:

    - Domain: Business rules, entities, and use cases.

    - Data: Repository implementations, API/local data sources.

    - Presentation: Flutter UI and state management (BLoC).

