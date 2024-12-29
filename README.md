# hal_app

A new Flutter project for managing subscriptions, notifications, and user profiles.

## Project Structure

The project is organized into the following main directories:

- `lib/`: Contains the main Dart code for the application.
  - `feature/`: Contains the different features of the application.
    - `auth/`: Handles authentication and subscription start.
      - `login/`: Manages the login functionality.
        - [`viewmodel/cubit/login_cubit.dart`](lib/feature/auth/login/viewmodel/cubit/login_cubit.dart): Login cubit for state management.
      - `start_free_subscription/`: Manages the start free subscription functionality.
        - [`start_free_subscription.dart`](lib/feature/auth/start_free_subscription/start_free_subscription.dart): Start free subscription page.
    - `helper/`: Contains helper classes and extensions.
      - `subscription_helper/`: Manages subscription-related helpers.
        - [`subscription_helper.dart`](lib/feature/helper/subscription_helper/subscription_helper.dart): Subscription helper functions.
    - `home/`: Manages the home view and subviews for notifications, profiles, and more.
      - `view/`: Contains the main home view.
        - [`home_view.dart`](lib/feature/home/view/home_view.dart): Main home view.
      - `sub/`: Contains subviews for the home view.
        - `add_profile/`: Manages the add profile functionality.
          - [`view/add_profile_page.dart`](lib/feature/home/sub/add_profile/view/add_profile_page.dart): Add profile page.
        - `bildirim_page/`: Manages notifications.
          - `main_bildirim_page/`: Contains the main notification page.
            - [`view/main_bildirim_page.dart`](lib/feature/home/sub/bildirim_page/main_bildirim_page/view/main_bildirim_page.dart): Main notification page.
          - `resent_notifications/`: Manages recent notifications.
            - [`view/resent_notifications_page.dart`](lib/feature/home/sub/resent_notifications/view/resent_notifications_page.dart): Recent notifications page.
    - `manage_tc/`: Manages TC (Taxpayer Identification Number) related functionalities.
      - [`view/manage_tc_page.dart`](lib/feature/manage_tc/view/manage_tc_page.dart): Manage TC page.
    - `settings/`: Contains settings-related views and viewmodels.
      - `sub/`: Contains subviews for settings.
        - `update_user_informations/`: Manages user information updates.
          - [`view/update_user_informations_page.dart`](lib/feature/settings/sub/update_user_informations/view/update_user_informations_page.dart): Update user information page.
        - `user_profile_page/`: Manages user profile.
          - [`view/user_profile.dart`](lib/feature/settings/sub/user_profile_page/view/user_profile.dart): User profile page.
    - `subscriptions/`: Manages subscription-related views and viewmodels.
      - [`view/subscriptions_page.dart`](lib/feature/subscriptions/view/subscriptions_page.dart): Subscriptions page.
      - `viewmodel/cubit/`: Contains cubits for state management.
        - [`subscriptions_cubit.dart`](lib/feature/subscriptions/viewmodel/cubit/subscriptions_cubit.dart): Subscriptions cubit for state management.
  - `project/`: Contains project-wide utilities, models, and services.
    - `cache/`: Manages caching for different models.
      - [`app_cache_manager.dart`](lib/project/cache/app_cache_manager.dart): App cache manager.
      - [`user_cache_manager.dart`](lib/project/cache/user_cache_manager.dart): User cache manager.
    - `model/`: Contains data models used throughout the project.
      - [`subscription/subscription_model.dart`](lib/project/model/subscription/subscription_model.dart): Subscription model.
      - [`user/my_user_model.dart`](lib/project/model/user/my_user_model.dart): User model.
    - `service/`: Contains services for interacting with Firebase, MySoft, and other APIs.
      - `firebase/`: Manages Firebase services.
        - `firestore/`: Manages Firestore services.
          - [`firestore_service.dart`](lib/project/service/firebase/firestore/firestore_service.dart): Firestore service.
      - `time/`: Manages time-related services.
        - [`time_service.dart`](lib/project/service/time/time_service.dart): Time service.
  - `core/`: Contains core utilities, enums, and extensions.
    - `enum/`: Contains enums used throughout the project.
      - [`preferences_keys_enum.dart`](lib/core/enum/preferences_keys_enum.dart): Preferences keys enum.
    - `extention/`: Contains extensions used throughout the project.
      - [`user_extension.dart`](lib/core/extention/user_extension.dart): User extension.

## Features

### Authentication

- Login and start free subscription: [`lib/feature/auth/login/viewmodel/cubit/login_cubit.dart`](lib/feature/auth/login/viewmodel/cubit/login_cubit.dart)
- Start free subscription page: [`lib/feature/auth/start_free_subscription/start_free_subscription.dart`](lib/feature/auth/start_free_subscription/start_free_subscription.dart)

### Home

- Main home view: [`lib/feature/home/view/home_view.dart`](lib/feature/home/view/home_view.dart)
- Add profile: [`lib/feature/home/sub/add_profile/view/add_profile_page.dart`](lib/feature/home/sub/add_profile/view/add_profile_page.dart)
- Notifications: [`lib/feature/home/sub/bildirim_page/main_bildirim_page/view/main_bildirim_page.dart`](lib/feature/home/sub/bildirim_page/main_bildirim_page/view/main_bildirim_page.dart)
- Recent notifications: [`lib/feature/home/sub/resent_notifications/view/resent_notifications_page.dart`](lib/feature/home/sub/resent_notifications/view/resent_notifications_page.dart)

### Settings

- Manage TC: [`lib/feature/manage_tc/view/manage_tc_page.dart`](lib/feature/manage_tc/view/manage_tc_page.dart)
- Update user information: [`lib/feature/settings/sub/update_user_informations/view/update_user_informations_page.dart`](lib/feature/settings/sub/update_user_informations/view/update_user_informations_page.dart)
- User profile: [`lib/feature/settings/sub/user_profile_page/view/user_profile.dart`](lib/feature/settings/sub/user_profile_page/view/user_profile.dart)

### Subscriptions

- Subscription helper: [`lib/feature/helper/subscription_helper/subscription_helper.dart`](lib/feature/helper/subscription_helper/subscription_helper.dart)
- Subscriptions page: [`lib/feature/subscriptions/view/subscriptions_page.dart`](lib/feature/subscriptions/view/subscriptions_page.dart)
- Subscriptions cubit: [`lib/feature/subscriptions/viewmodel/cubit/subscriptions_cubit.dart`](lib/feature/subscriptions/viewmodel/cubit/subscriptions_cubit.dart)

## Getting Started

To get started with this project, ensure you have Flutter installed and run the following commands:

```sh
flutter pub get
flutter run