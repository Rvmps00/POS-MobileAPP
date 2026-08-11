# Phase 3: Cart & Checkout System

> **Status:** `⬜ Not Started`
> **Depends on:** Phase 2 (Product Catalog)
> **Scope:** Cart with toppings, checkout flow, cash payment, order persistence

---

## Objectives

1. Implement cart state management with Riverpod (including topping customizations)
2. Build cart UI (tablet sidebar + phone full-screen)
3. Create checkout flow with cash payment and change calculation
4. Persist orders to Supabase + Drift (offline-capable)
5. Add dine-in / takeaway toggle with table number selection

---

## Step 3.1 — Cart State Management

### Cart Data Model
```dart
CartItem {
  product: Product
  quantity: int
  removedIngredients: List<DefaultIngredient>  // items customer removed
  addedToppings: List<AddonTopping>            // extras added (with prices)
  notes: String?                               // "extra spicy", etc.
  lineTotal: int                               // calculated price
}

CartState {
  items: List<CartItem>
  orderType: OrderType      // DINE_IN | TAKEAWAY
  tableNumber: int?         // only for dine-in
  subtotal: int             // sum of all lineTotals
  taxRate: double           // PB1 10%
  taxAmount: int
  grandTotal: int
}
```

### Price Calculation
```
lineTotal = (base_price + sum(added_topping_prices)) × quantity
subtotal = sum(all lineTotals)
taxAmount = subtotal × taxRate (10%)
grandTotal = subtotal + taxAmount
```

> [!NOTE]
> Removing default ingredients does NOT reduce the price — it's the same base price minus the ingredient. Only add-on toppings affect the price.

### Actions
- [ ] Create `CartItem` and `CartState` models
- [ ] Create `CartNotifier` (Riverpod)
- [ ] Implement add item (with toppings/removals)
- [ ] Implement update quantity
- [ ] Implement remove item
- [ ] Implement clear cart
- [ ] Implement price calculation
- [ ] Write unit tests for cart calculations

---

## Step 3.2 — Cart UI

### Cart Panel — Tablet Layout (Right Sidebar ~40%)
- Current cart items list
- Each item shows: name, toppings added, ingredients removed, quantity, line total
- Quantity controls (+/-)
- Swipe to delete
- Dine-in / Takeaway toggle
- Table number selector (dine-in only)
- Price summary (subtotal, tax, total)
- "Checkout" button (disabled when cart empty)

### Cart Screen — Phone Layout
- Full-screen cart (navigated from main screen)
- Same functionality as tablet sidebar
- Floating cart badge on main screen (item count + total)

### Cart Item Display Example
```
┌────────────────────────────────┐
│ Nasi Goreng              x2   │
│   + Ayam (+Rp 5.000)          │
│   + Extra Telur (+Rp 3.000)   │
│   - No Bawang Putih           │
│   📝 Extra pedas              │
│                    Rp 46.000  │
│              [ - ] 2 [ + ]    │
└────────────────────────────────┘
```

### Actions
- [ ] Build `CartPanel` widget (tablet sidebar)
- [ ] Build `CartScreen` (phone full-screen)
- [ ] Build `CartItemTile` with topping details
- [ ] Build order type toggle (Dine-in / Takeaway)
- [ ] Build table number selector
- [ ] Build price summary section
- [ ] Add floating cart badge to main screen (phone)

---

## Step 3.3 — Checkout Flow

### Order Database Tables (Supabase)

#### `orders`
| Column | Type | Constraints |
|:-------|:-----|:------------|
| `id` | UUID | PK |
| `order_number` | TEXT | NOT NULL, unique (e.g., "LS-20260811-001") |
| `order_type` | TEXT | "DINE_IN" or "TAKEAWAY" |
| `table_number` | INT | Nullable |
| `subtotal` | BIGINT | NOT NULL |
| `tax_amount` | BIGINT | NOT NULL |
| `grand_total` | BIGINT | NOT NULL |
| `payment_method` | TEXT | "CASH" (alpha only) |
| `payment_status` | TEXT | "PAID" (cash is instant) |
| `cash_received` | BIGINT | Nullable |
| `cash_change` | BIGINT | Nullable |
| `status` | TEXT | "COMPLETED" |
| `cashier_id` | UUID | FK → `auth.users.id` |
| `notes` | TEXT | Nullable |
| `created_at` | TIMESTAMPTZ | Default `now()` |

#### `order_items`
| Column | Type | Constraints |
|:-------|:-----|:------------|
| `id` | UUID | PK |
| `order_id` | UUID | FK → `orders.id`, ON DELETE CASCADE |
| `product_id` | UUID | FK → `products.id` |
| `product_name` | TEXT | NOT NULL (snapshot) |
| `quantity` | INT | NOT NULL |
| `base_price` | BIGINT | NOT NULL (snapshot) |
| `topping_total` | BIGINT | Default 0 |
| `line_total` | BIGINT | NOT NULL |
| `removed_ingredients` | JSONB | Array of ingredient names removed |
| `added_toppings` | JSONB | Array of {name, price} objects |
| `notes` | TEXT | Nullable |

### Checkout Screen UI
```
┌────────────────────────────────┐
│      ✅ Checkout               │
│                                │
│  Nasi Goreng x2       46.000  │
│  Mie Goreng x1        15.000  │
│  ─────────────────────────── │
│  Subtotal:         Rp 61.000  │
│  Tax (10%):         Rp 6.100  │
│  ═══════════════════════════  │
│  TOTAL:            Rp 67.100  │
│                                │
│  ─── Payment: CASH ───        │
│  Amount received:              │
│  ┌──────────────────────────┐  │
│  │  Rp 100.000              │  │
│  └──────────────────────────┘  │
│                                │
│  [50K] [100K] [200K] [Exact]  │
│                                │
│  Change:           Rp 32.900  │
│                                │
│  ┌──────────────────────────┐  │
│  │    CONFIRM ORDER          │  │
│  └──────────────────────────┘  │
└────────────────────────────────┘
```

### Order Number Format
- Prefix: `LS` (Lesehan Surya)
- Format: `LS-YYYYMMDD-NNN`
- Example: `LS-20260811-001`
- Auto-increment per day, reset daily

### Actions
- [ ] Create `orders` and `order_items` Supabase tables with RLS
- [ ] Create Drift mirror tables for offline orders
- [ ] Build `CheckoutScreen` UI
- [ ] Implement quick-fill cash buttons (50K, 100K, 200K, Exact)
- [ ] Implement change calculation
- [ ] Implement order number generation (LS-YYYYMMDD-NNN)
- [ ] Save order to Drift + queue sync to Supabase
- [ ] Build order success screen
- [ ] Auto-decrement product stock on order completion
- [ ] Clear cart after successful order

---

## Step 3.4 — Table Management (Dine-In)

- Configurable table count (default: 10, adjustable in Settings)
- Table number grid selector (numbered buttons)
- Only appears when "Dine-in" is selected

### Actions
- [ ] Build `TableSelector` widget (number grid)
- [ ] Store table count in settings
- [ ] Associate table number with order

---

## Deliverables Checklist

- [ ] Cart state management with topping tracking
- [ ] Cart UI works on tablet (sidebar) and phone (full-screen)
- [ ] Cart items show toppings added/removed correctly
- [ ] Quantity controls work
- [ ] Price calculation correct (base + toppings × qty + tax)
- [ ] Dine-in / Takeaway toggle works
- [ ] Table selector appears for dine-in only
- [ ] Checkout shows order summary with correct totals
- [ ] Cash quick-fill buttons work
- [ ] Change calculation correct
- [ ] Order saved to Drift + synced to Supabase
- [ ] Order number format correct (LS-YYYYMMDD-NNN)
- [ ] Stock decremented on order completion
- [ ] Cart clears after checkout
- [ ] All labels bilingual (ID/EN)
- [ ] Works offline (order saved locally)

---

## 🚦 Phase Gate — Cross-Check & Verification

### Automated Checks
```bash
flutter analyze
flutter test test/features/cart/
flutter test test/features/checkout/
flutter build apk --debug
```

### Manual Verification
| Check | Status |
|:------|:-------|
| Add item with toppings from customizer to cart | ⬜ |
| Cart shows removed ingredients and added toppings | ⬜ |
| Quantity +/- updates price correctly | ⬜ |
| Remove item from cart works | ⬜ |
| Dine-in/Takeaway toggle works | ⬜ |
| Table selector for dine-in only | ⬜ |
| Subtotal + tax = grand total (correct) | ⬜ |
| Cash quick-fill buttons work (50K, 100K, 200K) | ⬜ |
| Change calculation correct | ⬜ |
| Order saved with correct data | ⬜ |
| Order number format: LS-20260811-001 | ⬜ |
| Stock decremented after order | ⬜ |
| Offline order saved + synced when online | ⬜ |

### Report
1. Summary of cart & checkout implementation
2. Screenshots (tablet cart + phone cart + checkout)
3. Test results for price calculations
4. Issues found (if any)
5. Request for approval to proceed to Phase 4

> [!CAUTION]
> ### ⏸️ PAUSE POINT
> After cross-check passes:
> 1. **Git commit & push** all Phase 3 work to GitHub
>    ```bash
>    git add .
>    git commit -m "Phase 3: Cart & Checkout System (Cash) - Lesehan Surya POS"
>    git push origin main
>    ```
> 2. Development stops until you review and approve proceeding to **Phase 4: Inventory Management & Offline Sync**.
