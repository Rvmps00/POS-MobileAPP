# POS Mobile App — Development Overview

> **Project:** Lesehan Surya — Restaurant POS Mobile App
> **Tech Stack:** Flutter · Supabase · Riverpod · Drift (SQLite) · ESC/POS Bluetooth Printing
> **Target:** Android (Phone + Tablet, tablet-first layout)
> **Languages:** Indonesian 🇮🇩 + English 🇬🇧

---

## Alpha Version Scope

The alpha focuses on **core POS functionality** — 5 phases to get the app working end-to-end at the restaurant.

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Implement   │────▶│ Cross-Check │────▶│   Report    │
│  Phase N     │     │  & Verify   │     │  to User    │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                               │
                                    ┌──────────▼──────────┐
                                    │  ⏸️ PAUSE — Await  │
                                    │  User Approval to   │
                                    │  Continue Phase N+1 │
                                    └─────────────────────┘
```

> [!IMPORTANT]
> **No phase begins until the previous phase is cross-checked, verified, and explicitly approved by the user.**

---

## Phase Index — Alpha Version

| # | Phase | File | Status |
|:--|:------|:-----|:-------|
| 1 | UI/UX Design & Project Setup | [phase_01_ui_ux_design.md](file:///c:/Surya/POS-MobileAPP/development/phase_01_ui_ux_design.md) | `⬜ Not Started` |
| 2 | Product Catalog & Menu Management | [phase_02_product_catalog.md](file:///c:/Surya/POS-MobileAPP/development/phase_02_product_catalog.md) | `⬜ Not Started` |
| 3 | Cart & Checkout System | [phase_03_cart_checkout.md](file:///c:/Surya/POS-MobileAPP/development/phase_03_cart_checkout.md) | `⬜ Not Started` |
| 4 | Inventory Management & Offline Sync | [phase_04_inventory_offline.md](file:///c:/Surya/POS-MobileAPP/development/phase_04_inventory_offline.md) | `⬜ Not Started` |
| 5 | Receipt Printing (Bluetooth) | [phase_05_receipt_printing.md](file:///c:/Surya/POS-MobileAPP/development/phase_05_receipt_printing.md) | `⬜ Not Started` |

### Deferred to Beta / Future Versions
| # | Phase | File | Status |
|:--|:------|:-----|:-------|
| 6 | Dashboard & Order History | [phase_06_dashboard_orders.md](file:///c:/Surya/POS-MobileAPP/development/phase_06_dashboard_orders.md) | `🔒 Beta` |
| 7 | Authentication & Roles | [phase_07_auth_roles.md](file:///c:/Surya/POS-MobileAPP/development/phase_07_auth_roles.md) | `🔒 Beta` |
| 8 | Payment Gateway (QRIS/Cash/Transfer) | [phase_08_payment_gateway.md](file:///c:/Surya/POS-MobileAPP/development/phase_08_payment_gateway.md) | `🔒 Beta` |

---

## Restaurant Profile — Lesehan Surya

| Detail | Value |
|:-------|:------|
| **Name** | Lesehan Surya |
| **Service Type** | Dine-in + Takeaway |
| **Menu Size** | ~4 core items (Nasi Goreng, Mie Goreng, etc.) |
| **Customization** | Add/remove toppings per item (some free, some charged) |
| **Address** | *(to be provided later)* |
| **Phone** | *(to be provided later)* |

---

## Tech Stack

| Layer | Technology | Rationale |
|:---|:---|:---|
| **Framework** | Flutter 3.x | Cross-platform, tablet-first + phone responsive |
| **State Mgmt** | Riverpod | Compile-time safety, async streams, minimal boilerplate |
| **Backend** | Supabase | Postgres, Auth (email/password + Google), Realtime, Storage |
| **Auth** | Supabase Auth | Email/password + Google Sign-In |
| **Local DB** | Drift (SQLite) | Offline-first — local source of truth, background sync |
| **BT Printing** | `esc_pos_utils_plus` + `print_bluetooth_thermal` | ESC/POS for CODESHOP CM-T58BL (58mm) |
| **i18n** | `flutter_localizations` + `intl` | Indonesian + English |
| **UI Design** | Stitch MCP | AI-powered screen prototyping with design system |
| **Architecture** | Clean Architecture + Repository Pattern | Layered, testable, offline-resilient |

---

## Design Direction

### Alpha (Current)
- **Clean, minimal black/white design** — functional first
- Light mode + Dark mode with toggle
- Plus Jakarta Sans (headline) + Inter (body)
- Roundness: ROUND_TWELVE (soft, premium)

### Beta (Future — Nasi Goreng Color Palette)
Saved as design reference for when we evolve the brand:

![Lesehan Surya Nasi Goreng Color Palette](C:\Users\TugasAkhir\.gemini\antigravity-ide\brain\d857ca52-ba8e-41a5-980b-aa9ae4c9c3b8\color_palette_reference_1786424872242.png)

| Color | Hex | Inspired By |
|:------|:----|:------------|
| Golden Yellow | `#F5A623` | Turmeric rice |
| Rich Brown | `#8B5E3C` | Wok-charred flavors |
| Deep Red | `#C0392B` | Chili sambal |
| Fresh Green | `#27AE60` | Vegetables & scallions |
| Egg Orange | `#F39C12` | Fried egg yolk |
| Warm Cream | `#FFF8E7` | Light background |

---

## Menu Structure — Lesehan Surya

The menu uses a **base product + customizable toppings** model:

```
Product: Nasi Goreng (Fried Rice) — Rp 15.000
├── Default Ingredients: rice, egg, garlic, shallots, kecap manis
├── ADD Toppings:
│   ├── Extra Egg ── Rp 3.000
│   ├── Chicken ──── Rp 5.000
│   ├── Sausage ──── Rp 4.000
│   └── Kerupuk ──── FREE
└── REMOVE Ingredients:
    ├── No Egg
    ├── No Garlic
    └── No Kecap Manis
```

### Data Model
- **Products:** ~4 items with base price
- **Default Ingredients:** Pre-selected items that come with the product
- **Add-on Toppings:** Optional extras (free or charged)
- **Removable Ingredients:** Default items customer can opt-out of

---

## Core Architectural Decisions

### 🔌 Offline-First Strategy
The app treats the **local Drift (SQLite) database as the single source of truth**. All operations work offline. Background sync pushes/pulls to Supabase when connected.

```
┌──────────────────┐          ┌──────────────────┐
│   Flutter App    │          │    Supabase       │
│  ┌────────────┐  │  sync    │  ┌────────────┐  │
│  │ Drift/SQL  │◀─┼─────────▶│  │  Postgres  │  │
│  │  (Local)   │  │          │  │  (Remote)  │  │
│  └────────────┘  │          │  └────────────┘  │
└──────────────────┘          └──────────────────┘
```

### 📂 Folder Structure (Alpha — Simplified)
```
lib/
├── core/           # Constants, themes, utils, router, l10n
├── features/
│   ├── auth/       # Email/password + Google login
│   ├── catalog/    # Product listing, categories, toppings
│   ├── cart/       # Cart state, topping modifiers
│   ├── checkout/   # Order finalization (cash only for alpha)
│   ├── inventory/  # Stock management
│   ├── orders/     # Basic order history (minimal)
│   └── settings/   # Printer setup, restaurant info, language
├── shared/         # Shared widgets, models, services
└── main.dart
```
