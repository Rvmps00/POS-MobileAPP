<h1 align="center">Lesehan Surya POS 📱✨</h1>

<p align="center">
  A modern, offline-first mobile Point of Sale (POS) application built with Flutter, designed specifically for restaurants and cafes.
</p>

---

## 🚀 Key Features

### 🛒 Dynamic Order Management
- **Smart Cart System:** Easily add products, customize quantities, and switch between *Dine-in* and *Takeaway* orders.
- **Product Variations:** Support for single-choice variations (e.g., Hot/Cold, Spiciness Levels).
- **Advanced Customization:** Manage default removable ingredients (e.g., "No Onions") and paid add-on toppings (e.g., "Extra Boba").
- **Automatic Calculations:** Real-time calculation of subtotals, configurable taxes (10%), grand totals, and cash change.

### 🖨️ Bluetooth Receipt Printing
- **Thermal Printer Integration:** Seamlessly connect to ESC/POS compatible Bluetooth thermal printers (e.g., 58mm).
- **Auto-incrementing Queue Numbers:** Generates daily queue numbers automatically printed on the receipt for easy order tracking.
- **Customizable Receipts:** Configure store name, address, phone number, and footer messages directly from the app settings.

### 📦 Inventory & Menu Management
- **Categories & Products:** Organize your menu efficiently with categories and product variations.
- **Stock Tracking:** Track available stock and low-stock thresholds to prevent overselling.
- **Image Uploads:** Upload and display beautiful product images directly from the app.

### 📡 Offline-First Architecture
- **Drift (SQLite):** Lightning-fast local database ensures the app works flawlessly without an internet connection.
- **Supabase Sync:** Background synchronization engine automatically pushes local changes and pulls remote updates whenever the device comes online.

### 🎨 Modern UI & UX
- **Dynamic Themes:** Beautiful, curated color palette with seamless switching between Light and Dark modes.
- **Bilingual Support:** Instantly toggle between Indonesian (ID) and English (EN) localizations.
- **Responsive Layouts:** Designed to look stunning and perform smoothly on mobile devices.

---

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **State Management:** [Riverpod](https://riverpod.dev/) (Code Generation)
- **Local Database:** [Drift](https://drift.simonbinder.eu/) (SQLite)
- **Backend & Sync:** [Supabase](https://supabase.com/) (PostgreSQL & Auth)
- **Printing:** `print_bluetooth_thermal`, `esc_pos_utils_plus`

---

## 📸 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- A Supabase Project

### Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/Rvmps00/POS-MobileAPP.git
   ```
2. Navigate to the project directory:
   ```bash
   cd POS-MobileAPP
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run code generation (for Riverpod, Drift, etc.):
   ```bash
   dart run build_runner build -d
   ```
5. Run the app:
   ```bash
   flutter run
   ```

---

*Developed with ❤️ for Lesehan Surya.*