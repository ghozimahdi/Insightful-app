# Clean Provider Architecture Example

This project serves as a training example for new developers, demonstrating clean architecture principles in a Flutter application using the Provider pattern for state management.

## Project Structure

```
lib/
├── animations/     # Custom animations and transitions
├── components/     # Reusable UI components
├── models/         # Data models and entities
├── providers/      # State management using Provider
├── screens/        # UI screens and pages
├── util/          # Utility functions and helpers
└── gen/           # Generated files (colors, fonts, etc.)
```

## Architecture

This project follows Clean Architecture principles:

1. **Presentation Layer** (UI)
   - Screens and components
   - Provider state management
   - UI-specific logic

2. **Domain Layer** (Business Logic)
   - Models
   - Use cases
   - Repository interfaces

3. **Data Layer**
   - Repository implementations
   - Data sources
   - External services

## Key Features

- Firebase integration (Auth, Firestore, Analytics)
- Location services
- File handling and media management
- Clean state management with Provider
- Modern UI components
- Error handling and crash reporting
- Local data persistence

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Set up environment variables:
   - Copy `config.env.example` to `config.env`
   - Fill in required API keys and configurations

4. Run the app:
   ```bash
   flutter run
   ```

## Development Guidelines

1. **Code Style**
   - Follow Flutter's official style guide
   - Use meaningful variable and function names
   - Write clear documentation for complex logic

2. **State Management**
   - Use Provider for state management
   - Keep providers focused and single-responsibility
   - Avoid provider nesting when possible

3. **Testing**
   - Write unit tests for business logic
   - Include widget tests for UI components
   - Maintain good test coverage

4. **Performance**
   - Optimize image and asset loading
   - Use const constructors where possible
   - Implement proper error handling

## Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.