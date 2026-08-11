# Phase 2: Product Catalog & Menu Management

> **Status:** `⬜ Not Started`
> **Depends on:** Phase 1 (UI/UX Design & Project Setup)
> **Scope:** Database schema, catalog UI, topping system, CRUD operations

---

## Objectives

1. Design database tables for products, categories, and **toppings** (add/remove model)
2. Implement product CRUD operations
3. Build the catalog browsing UI (category tabs + product grid)
4. Build the **Topping Customizer** (add toppings with prices, remove default ingredients)
5. Set up local Drift mirror for offline access
6. Seed Lesehan Surya's actual menu data

---

## Step 2.1 — Supabase Schema Setup

### Database Tables

#### `categories`
| Column | Type | Constraints |
|:-------|:-----|:------------|
| `id` | UUID | PK, default `gen_random_uuid()` |
| `name` | TEXT | NOT NULL |
| `name_en` | TEXT | Nullable (English translation) |
| `icon` | TEXT | Nullable (emoji or icon name) |
| `sort_order` | INT | Default 0 |
| `is_active` | BOOLEAN | Default TRUE |
| `created_at` | TIMESTAMPTZ | Default `now()` |
| `updated_at` | TIMESTAMPTZ | Default `now()` |

#### `products`
| Column | Type | Constraints |
|:-------|:-----|:------------|
| `id` | UUID | PK, default `gen_random_uuid()` |
| `name` | TEXT | NOT NULL |
| `name_en` | TEXT | Nullable (English translation) |
| `description` | TEXT | Nullable |
| `base_price` | BIGINT | NOT NULL (in Rupiah) |
| `category_id` | UUID | FK → `categories.id` |
| `image_url` | TEXT | Nullable |
| `is_available` | BOOLEAN | Default TRUE |
| `stock_qty` | INT | Default 0 |
| `created_at` | TIMESTAMPTZ | Default `now()` |
| `updated_at` | TIMESTAMPTZ | Default `now()` |

#### `default_ingredients` (items that come with the product by default — can be removed)
| Column | Type | Constraints |
|:-------|:-----|:------------|
| `id` | UUID | PK |
| `product_id` | UUID | FK → `products.id`, ON DELETE CASCADE |
| `name` | TEXT | NOT NULL (e.g., "Telur", "Bawang Putih") |
| `name_en` | TEXT | Nullable (e.g., "Egg", "Garlic") |
| `is_removable` | BOOLEAN | Default TRUE |
| `sort_order` | INT | Default 0 |

#### `addon_toppings` (extras that can be added — free or charged)
| Column | Type | Constraints |
|:-------|:-----|:------------|
| `id` | UUID | PK |
| `product_id` | UUID | FK → `products.id`, ON DELETE CASCADE |
| `name` | TEXT | NOT NULL (e.g., "Extra Telur", "Ayam") |
| `name_en` | TEXT | Nullable (e.g., "Extra Egg", "Chicken") |
| `price` | BIGINT | NOT NULL (0 = free, >0 = charged) |
| `is_available` | BOOLEAN | Default TRUE |
| `sort_order` | INT | Default 0 |

### Seed Data — Lesehan Surya Menu

> [!NOTE]
> This is a starting template. Actual items/prices to be confirmed with the user.

#### Categories
| Name | Name (EN) | Icon |
|:-----|:----------|:-----|
| Nasi | Rice | 🍚 |
| Mie | Noodles | 🍜 |
| Minuman | Drinks | 🥤 |
| Lainnya | Others | 🍽️ |

#### Products (Example)
| Name | Name (EN) | Base Price | Category |
|:-----|:----------|:-----------|:---------|
| Nasi Goreng | Fried Rice | Rp 15.000 | Nasi |
| Nasi Goreng Spesial | Special Fried Rice | Rp 20.000 | Nasi |
| Mie Goreng | Fried Noodles | Rp 15.000 | Mie |
| Mie Goreng Spesial | Special Fried Noodles | Rp 20.000 | Mie |

#### Default Ingredients (Nasi Goreng example)
| Ingredient | Removable |
|:-----------|:----------|
| Nasi (Rice) | ❌ |
| Telur (Egg) | ✅ |
| Bawang Putih (Garlic) | ✅ |
| Bawang Merah (Shallots) | ✅ |
| Kecap Manis (Sweet Soy) | ✅ |

#### Add-on Toppings (Nasi Goreng example)
| Topping | Price |
|:--------|:------|
| Extra Telur (Extra Egg) | Rp 3.000 |
| Ayam (Chicken) | Rp 5.000 |
| Sosis (Sausage) | Rp 4.000 |
| Kerupuk (Crackers) | FREE |
| Sambal Extra (Extra Chili) | FREE |

### Actions
- [ ] Create `categories` table with RLS
- [ ] Create `products` table with RLS
- [ ] Create `default_ingredients` table with RLS
- [ ] Create `addon_toppings` table with RLS
- [ ] Seed menu data (confirm actual items/prices with user)

---

## Step 2.2 — Drift Local Database Mirror

Create Drift table definitions that mirror the Supabase schema.

### Actions
- [ ] Define Drift tables: categories, products, default_ingredients, addon_toppings
- [ ] Create Drift database class
- [ ] Implement `CatalogLocalDataSource` with CRUD operations
- [ ] Run `build_runner` to generate Drift code

---

## Step 2.3 — Repository Layer

```
CatalogRepository
├── CatalogRemoteDataSource (Supabase)
├── CatalogLocalDataSource (Drift)
└── Sync Logic (remote ↔ local)
```

### Behavior
- **Online:** Fetch from Supabase, cache to Drift
- **Offline:** Serve from Drift
- **Mutations:** Write to Drift first, queue sync to Supabase

### Actions
- [ ] Create `CatalogRemoteDataSource` (Supabase queries)
- [ ] Create `CatalogRepository` with online/offline logic
- [ ] Create Riverpod providers for catalog data
- [ ] Implement connectivity-aware data fetching

---

## Step 2.4 — Catalog UI

### Category Tab Bar
- Horizontal scrollable tabs at top
- 4 categories: Nasi 🍚, Mie 🍜, Minuman 🥤, Lainnya 🍽️
- "All" tab as default
- Labels in current app language (ID/EN)

### Product Grid
- Responsive: 2 columns (phone), 3 columns (tablet)
- Product card: name, base price, availability badge
- Tap → opens Topping Customizer
- Skeleton loading state
- Empty state

### Product Management (Simple)
- Add new product form (name, base price, category)
- Edit existing product
- Manage default ingredients (add/remove)
- Manage add-on toppings (add/remove, set price)
- Toggle availability

### Actions
- [ ] Build `CategoryTabBar` widget
- [ ] Build `ProductCard` widget
- [ ] Build `ProductGrid` with responsive layout
- [ ] Build product add/edit form
- [ ] Build ingredient management UI
- [ ] Build topping management UI
- [ ] Connect UI to Riverpod providers
- [ ] Add loading & empty states

---

## Step 2.5 — Topping Customizer

The core interaction — when a user taps a product, this opens:

### UI Layout (Bottom Sheet or Modal)
```
┌────────────────────────────────┐
│  Nasi Goreng      Rp 15.000   │
│  Fried Rice                    │
│                                │
│  ─── Default Ingredients ───   │
│  ✅ Nasi (Rice)      [locked]  │
│  ✅ Telur (Egg)      [remove]  │
│  ✅ Bawang Putih     [remove]  │
│  ✅ Kecap Manis      [remove]  │
│                                │
│  ─── Add Toppings ───          │
│  ☐ Extra Telur    +Rp 3.000   │
│  ☐ Ayam           +Rp 5.000   │
│  ☐ Sosis          +Rp 4.000   │
│  ☐ Kerupuk        FREE        │
│  ☐ Sambal Extra   FREE        │
│                                │
│  ─── Quantity ───              │
│       [ - ]  1  [ + ]          │
│                                │
│  ─── Notes ───                 │
│  [ Add special instructions ]  │
│                                │
│  Total: Rp 15.000              │
│  ┌──────────────────────────┐  │
│  │     ADD TO CART           │  │
│  └──────────────────────────┘  │
└────────────────────────────────┘
```

### Logic
- Default ingredients: shown with checkmarks, tap to remove (strike-through)
- Add-on toppings: unchecked by default, tap to add
- Total updates live: `base_price - removed_value + added_toppings × qty`
- Notes field for special instructions
- "Add to Cart" saves the customized item

### Actions
- [ ] Build `ToppingCustomizer` widget (bottom sheet)
- [ ] Implement default ingredient toggle (remove/keep)
- [ ] Implement add-on topping selection with prices
- [ ] Implement live price calculation
- [ ] Implement quantity selector
- [ ] Implement notes field
- [ ] "Add to Cart" action (connects to Cart in Phase 3)

---

## Deliverables Checklist

- [ ] Supabase tables created (categories, products, ingredients, toppings)
- [ ] Menu seeded with Lesehan Surya data
- [ ] Drift local tables mirror Supabase schema
- [ ] Repository pattern implemented (online + offline)
- [ ] Category tabs navigate between categories
- [ ] Product grid displays items
- [ ] Topping Customizer opens on product tap
- [ ] Default ingredients toggleable (remove/keep)
- [ ] Add-on toppings selectable with correct prices
- [ ] Live price calculation works
- [ ] Product CRUD works (add, edit, delete)
- [ ] Ingredient/topping management works
- [ ] Labels display in correct language (ID/EN)
- [ ] Offline mode: catalog loads from local DB

---

## 🚦 Phase Gate — Cross-Check & Verification

### Automated Checks
```bash
flutter analyze
flutter test test/features/catalog/
flutter build apk --debug
```

### Manual Verification
| Check | Status |
|:------|:-------|
| 4 categories display with correct icons | ⬜ |
| ~4 products load in grid | ⬜ |
| Topping customizer opens on product tap | ⬜ |
| Default ingredients show with remove toggle | ⬜ |
| Add-on toppings show with correct prices | ⬜ |
| Price updates live when adding/removing | ⬜ |
| Quantity +/- works in customizer | ⬜ |
| Notes field accepts input | ⬜ |
| Product add/edit form works | ⬜ |
| Labels switch between Indonesian/English | ⬜ |
| Offline: catalog loads from local DB | ⬜ |
| Data syncs to Supabase | ⬜ |

### Report
1. Summary of catalog implementation
2. Screenshots of product grid and topping customizer
3. Build & test output
4. Issues found (if any)
5. Request for approval to proceed to Phase 3

> [!CAUTION]
> ### ⏸️ PAUSE POINT
> After cross-check passes:
> 1. **Git commit & push** all Phase 2 work to GitHub
>    ```bash
>    git add .
>    git commit -m "Phase 2: Product Catalog & Topping System - Lesehan Surya POS"
>    git push origin main
>    ```
> 2. Development stops until you review and approve proceeding to **Phase 3: Cart & Checkout System**.
