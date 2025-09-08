# wejha

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
┌─────────────────────────────────────────┐
│           PRESENTATION LAYER            │
│  ┌─────────────┐  ┌─────────────────┐   │
│  │    Pages    │  │     BLoCs       │   │
│  │   (UI/UX)   │  │ (State Mgmt)    │   │
│  └─────────────┘  └─────────────────┘   │// User wants to login
LoginWithEmailPasswordEvent(email: "user@example.com", password: "password123")

// User wants to logout
LogoutEvent()

// System needs to refresh token
RefreshTokenEvent(refreshToken: "refresh_token_here")

// Form field updates (real-time)
UpdateLoginFormEvent(email: "new_email@example.com")

└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│            DOMAIN LAYER                 │
│  ┌─────────────┐  ┌─────────────────┐   │
│  │  Use Cases  │  │   Entities      │   │
│  │ (Bus Logic) │  │   Repository    │   │
│  └─────────────┘  └─────────────────┘   │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│             DATA LAYER                  │
│  ┌─────────────┐  ┌─────────────────┐   │
│  │ Data Sources│  │  Models         │   │
│  │ (API/Local) │  │  Repo Impl      │   │
│  └─────────────┘  └─────────────────┘   │
└─────────────────────────────────────────┘
// User wants to login
LoginWithEmailPasswordEvent(email: "user@example.com", password: "password123")

// User wants to logout
LogoutEvent()

// System needs to refresh token
RefreshTokenEvent(refreshToken: "refresh_token_here")

// Form field updates (real-time)
UpdateLoginFormEvent(email: "new_email@example.com")
// LoginBloc handles the business logic
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  // When user submits login form
  Future<void> _onLoginWithEmailPassword(
    LoginWithEmailPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    // 1. Show loading state
    emit(LoginLoading());

    // 2. Update form model
    _formModel = _formModel.copyWith(
      email: event.email,
      password: event.password,
    );

    // 3. Call use case (business logic)
    final result = await login(
      LoginParams(
        email: _formModel.email,
        password: _formModel.password,
      ),
    );

    // 4. Handle result (success or failure)
    result.fold(
      (failure) => emit(LoginError(failure: failure)),
      (loginResponse) => emit(LoginSuccess(loginResponse: loginResponse)),
    );
  }
}
