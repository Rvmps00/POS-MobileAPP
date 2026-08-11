# Phase 1: UI/UX Design & Project Setup

> **Status:** `⬜ Not Started`
> **Depends on:** None (first phase)
> **Scope:** Design system, screen prototypes, Flutter project scaffolding, localization setup

---

## Objectives

1. Create a Stitch project with a clean, minimal POS design system
2. Generate prototype screens for the alpha app views
3. Scaffold the Flutter project with Clean Architecture folder structure
4. Install core dependencies and configure theming (light/dark toggle)
5. Set up routing with `go_router`
6. Set up localization (Indonesian + English)
7. Configure Supabase Auth (email/password + Google Sign-In)

---

## Step 1.1 — Stitch Design System

Create a design system in Stitch for the alpha version — clean and minimal.

### Alpha Design Tokens

| Token | Value | Rationale |
|:------|:------|:----------|
| **Primary Color** | `#1A1A1A` (near-black) | Clean, minimal, neutral for alpha |
| **Color Mode** | LIGHT (default) + DARK (toggle) | User preference |
| **Color Variant** | Neutral | Clean, professional |
| **Headline Font** | Plus Jakarta Sans | Modern, highly readable |
| **Body Font** | Inter | Industry standard UI font |
| **Label Font** | Inter | Consistent with body |
| **Roundness** | ROUND_TWELVE | Soft, premium feel |

### Actions
- [ ] Create Stitch project: "Lesehan-Surya-POS"
- [ ] Create design system with tokens above
- [ ] Apply design system to project

---

## Step 1.2 — Screen Prototypes (Stitch)

Generate the key screens for the alpha version:

| # | Screen | Description | Priority |
|:--|:-------|:------------|:---------|
| 1 | **Main POS Screen (Tablet)** | Split layout — category tabs (top) + product grid (left ~60%) + cart panel (right ~40%). 4 menu items with topping indicators. For "Lesehan Surya" restaurant | MUST |
| 2 | **Main POS Screen (Phone)** | Full-screen product grid with floating cart badge. Tap to open cart as bottom sheet or separate screen | MUST |
| 3 | **Topping Customizer** | Modal/bottom sheet for a product: shows default ingredients with toggle to remove, add-on toppings with prices, quantity selector. Add/remove topping model | MUST |
| 4 | **Cart / Checkout** | Order summary, dine-in/takeaway toggle, table number (dine-in), cash amount input, change calculation, confirm button | MUST |
| 5 | **Login Screen** | Clean login with email/password fields, Google Sign-In button, "Lesehan Surya" branding | MUST |
| 6 | **Inventory Management** | Simple list of 4 products with stock levels, edit stock, low-stock indicators | NICE |
| 7 | **Settings** | Printer connection, restaurant info, language toggle (ID/EN), dark/light mode toggle | NICE |

### Actions
- [ ] Generate Main POS Screen (tablet layout)
- [ ] Generate Main POS Screen (phone layout)
- [ ] Generate Topping Customizer modal
- [ ] Generate Cart / Checkout screen
- [ ] Generate Login screen
- [ ] Generate Inventory Management screen
- [ ] Generate Settings screen

---

## Step 1.3 — Flutter Project Scaffolding

### Project Initialization
```bash
flutter create --org com.surya --project-name pos_mobile_app --platforms android .
```

### Folder Structure
```
lib/
├── core/
│   ├── constants/        # App-wide constants
│   ├── theme/            # ThemeData (light + dark), color schemes, text styles
│   ├── router/           # GoRouter configuration
│   ├── l10n/             # Localization (arb files)
│   ├── utils/            # Helper functions, formatters (Rupiah, etc.)
│   └── errors/           # Custom exception classes
├── features/
│   ├── auth/
│   │   ├── data/         # AuthRepository, Supabase auth data source
│   │   ├── domain/       # Auth entities, use cases
│   │   └── presentation/ # Login screen, widgets
│   ├── catalog/
│   │   ├── data/         # Product/category repositories, data sources
│   │   ├── domain/       # Product, Category, Topping entities
│   │   └── presentation/ # Product grid, topping customizer
│   ├── cart/
│   │   ├── data/
│   │   ├── domain/       # CartItem, CartState with toppings
│   │   └── presentation/ # Cart panel/screen, checkout
│   ├── checkout/
│   │   ├── data/         # Order repository
│   │   ├── domain/       # Order entity
│   │   └── presentation/ # Checkout screen, cash payment
│   ├── inventory/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── orders/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/ # Basic order list (minimal for alpha)
│   └── settings/
│       ├── data/
│       ├── domain/
│       └── presentation/ # Printer, language, theme, restaurant info
├── shared/
│   ├── widgets/          # Reusable UI components
│   ├── models/           # Shared data models
│   └── services/         # Connectivity, sync engine
└── main.dart
```

### Actions
- [ ] Run `flutter create` with proper config
- [ ] Create full folder structure
- [ ] Install all dependencies (see below)
- [ ] Configure `pubspec.yaml`

---

## Step 1.4 — Theme System (Light + Dark)

### Light Theme
- Background: `#FFFFFF`
- Surface: `#F5F5F5`
- On-Background: `#1A1A1A`
- Primary: `#1A1A1A`
- Accent: `#424242`

### Dark Theme
- Background: `#121212`
- Surface: `#1E1E1E`
- On-Background: `#FFFFFF`
- Primary: `#FFFFFF`
- Accent: `#B0B0B0`

### Actions
- [ ] Create `AppTheme` class with `lightTheme` and `darkTheme`
- [ ] Create `ThemeNotifier` (Riverpod) for theme toggle
- [ ] Persist theme preference in local storage
- [ ] Apply theme in `MaterialApp`

---

## Step 1.5 — Localization (Indonesian + English)

### Setup
- Use `flutter_localizations` + `intl`
- Create `l10n.yaml` configuration
- ARB files: `app_id.arb` (Indonesian) + `app_en.arb` (English)

### Initial Strings
```
app_name: "Lesehan Surya POS"
login / logout
product names won't be translated (they're data, not UI)
UI labels: "Cart", "Checkout", "Total", "Add to Cart", etc.
```

### Actions
- [ ] Configure `l10n.yaml`
- [ ] Create `app_en.arb` with all UI strings
- [ ] Create `app_id.arb` with Indonesian translations
- [ ] Create `LanguageNotifier` for language toggle
- [ ] Persist language preference in local storage
- [ ] Add language toggle to Settings

---

## Step 1.6 — Routing (GoRouter)

### Route Map (Alpha)
```
/login              → LoginScreen
/pos                → MainPOSScreen (home, after login)
/pos/product/:id    → ProductDetailScreen
/pos/customize/:id  → ToppingCustomizerModal
/cart               → CartScreen (phone layout)
/checkout           → CheckoutScreen
/inventory          → InventoryScreen
/orders             → OrderHistoryScreen (basic)
/settings           → SettingsScreen
/settings/printer   → PrinterSetupScreen
```

### Actions
- [ ] Configure `GoRouter` with all routes
- [ ] Add auth redirect (unauthenticated → /login)
- [ ] Create placeholder screens for each route
- [ ] Test navigation between all screens

---

## Step 1.7 — Supabase Auth Setup

### Configuration
- Enable email/password authentication in Supabase
- Enable Google OAuth provider
- Disable email confirmation (internal use)

### Flutter Implementation
- `supabase_flutter` initialization in `main.dart`
- `google_sign_in` package for Google OAuth
- Login screen with email/password + Google button
- Auth state listener (redirect on login/logout)

### Actions
- [ ] Configure Supabase Auth providers (email + Google)
- [ ] Add `supabase_flutter` and `google_sign_in` to dependencies
- [ ] Initialize Supabase in `main.dart`
- [ ] Build `LoginScreen` with email/password + Google Sign-In
- [ ] Implement auth state management with Riverpod
- [ ] Test login/logout flow

---

## Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  # State Management
  flutter_riverpod: ^2.x
  riverpod_annotation: ^2.x
  # Backend & Auth
  supabase_flutter: ^2.x
  google_sign_in: ^6.x
  # Local Database (Offline-First)
  drift: ^2.x
  sqlite3_flutter_libs: ^0.x
  # Routing
  go_router: ^14.x
  # UI Utilities
  cached_network_image: ^3.x
  flutter_svg: ^2.x
  google_fonts: ^6.x
  # Localization
  intl: ^0.x
  # Utilities
  uuid: ^4.x
  connectivity_plus: ^6.x
  path_provider: ^2.x
  shared_preferences: ^2.x   # Theme/language persistence

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.x
  riverpod_generator: ^2.x
  drift_dev: ^2.x
  flutter_lints: ^5.x
```

---

## Deliverables Checklist

- [ ] Stitch project created with design system applied
- [ ] 7 screen prototypes generated and reviewed
- [ ] Flutter project scaffolded with Clean Architecture folders
- [ ] All dependencies installed and resolving
- [ ] Light + Dark theme configured with toggle
- [ ] Localization set up (Indonesian + English) with toggle
- [ ] GoRouter configured with all alpha routes
- [ ] Supabase Auth working (email/password + Google)
- [ ] Login screen functional
- [ ] `main.dart` compiles and runs
- [ ] `flutter analyze` passes with zero errors

---

## 🚦 Phase Gate — Cross-Check & Verification

Before proceeding to Phase 2, the following checks **must pass**:

### Automated Checks
```bash
# Project builds without errors
flutter analyze

# Dependencies resolve correctly
flutter pub get

# App launches on emulator/device
flutter run
```

### Manual Verification
| Check | Status |
|:------|:-------|
| Stitch design system looks correct (clean, minimal) | ⬜ |
| All 7 screen prototypes match POS requirements | ⬜ |
| Folder structure follows Clean Architecture | ⬜ |
| Light theme renders correctly | ⬜ |
| Dark theme renders correctly | ⬜ |
| Theme toggle switches properly | ⬜ |
| Language switches between ID/EN | ⬜ |
| GoRouter navigates between placeholder screens | ⬜ |
| Login with email/password works | ⬜ |
| Login with Google works | ⬜ |
| Logout works and redirects to login | ⬜ |
| App compiles and runs on Android emulator/device | ⬜ |

### Report Format
After completing this phase, I will provide:
1. **Summary** of what was built
2. **Stitch screenshots** of generated screens
3. **Build output** from `flutter analyze` and `flutter run`
4. **Issues found** (if any) with proposed fixes
5. **Explicit request** for your approval to proceed to Phase 2

> [!CAUTION]
> ### ⏸️ PAUSE POINT
> After cross-check passes:
> 1. **Git commit & push** all Phase 1 work to GitHub
>    ```bash
>    git add .
>    git commit -m "Phase 1: UI/UX Design & Project Setup - Lesehan Surya POS"
>    git push origin main
>    ```
> 2. Development stops until you review the report and approve proceeding to **Phase 2: Product Catalog & Menu Management**.
