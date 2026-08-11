# Phase 4: Inventory Management & Offline Sync

> **Status:** `⬜ Not Started`
> **Depends on:** Phase 3 (Cart & Checkout)
> **Estimated Scope:** Stock tracking, low-stock alerts, offline sync engine

---

## Objectives

1. Build inventory management UI (stock levels, batch updates)
2. Implement low-stock threshold alerts
3. Create the full offline-first sync engine (Drift ↔ Supabase)
4. Add stock history logging
5. Ensure all app features work reliably without internet

---

## Step 4.1 — Inventory Management UI

### Inventory List Screen
- Table/list view of all products with:
  - Product name + category
  - Current stock quantity
  - Low-stock indicator (red badge when below threshold)
  - Availability toggle
- Sort by: name, stock level, category
- Filter by: category, low-stock only, out-of-stock
- Search by product name

### Stock Update Features
- **Single item:** Tap product → edit stock quantity
- **Batch restock:** Select multiple items → enter restock quantities → save all
- **Quick adjust:** +/- buttons for rapid stock changes
- **Set threshold:** Per-product low-stock alert threshold

### Stock History (Audit Log)

#### `stock_history` table (Supabase)
| Column | Type | Constraints |
|:-------|:-----|:------------|
| `id` | UUID | PK |
| `product_id` | UUID | FK → `products.id` |
| `previous_qty` | INT | NOT NULL |
| `new_qty` | INT | NOT NULL |
| `change_type` | TEXT | "SALE", "RESTOCK", "ADJUSTMENT", "WASTE" |
| `change_amount` | INT | NOT NULL (can be negative) |
| `notes` | TEXT | Nullable |
| `user_id` | UUID | FK → `auth.users.id` |
| `created_at` | TIMESTAMPTZ | Default `now()` |

### Actions
- [ ] Build `InventoryListScreen` with sort/filter/search
- [ ] Build `StockEditDialog` for single-item updates
- [ ] Build `BatchRestockScreen` for bulk updates
- [ ] Create `stock_history` Supabase table
- [ ] Log all stock changes to history
- [ ] Build `StockHistoryScreen` for audit trail

---

## Step 4.2 — Low-Stock Alert System

### Alert Logic
- Each product has a configurable `low_stock_threshold` (default: 10)
- When `stock_qty <= low_stock_threshold`, show warning badge
- When `stock_qty == 0`, auto-set `is_available = false`
- Dashboard notification count for low-stock items
- Optional: push notification for critical items

### Actions
- [ ] Add `low_stock_threshold` column to `products` table
- [ ] Implement threshold check in inventory providers
- [ ] Show badge/indicator on inventory list
- [ ] Show alert count on dashboard/nav bar
- [ ] Auto-disable products when stock hits zero

---

## Step 4.3 — Offline-First Sync Engine

This is the **core architectural component** that enables the app to function without internet.

### Architecture
```
┌─────────────────────────────────────────────┐
│                 Flutter App                  │
│                                             │
│  ┌─────────┐    ┌──────────┐    ┌────────┐ │
│  │   UI    │───▶│Repository│───▶│  Drift │ │
│  │ (Views) │    │ (Logic)  │    │(SQLite)│ │
│  └─────────┘    └────┬─────┘    └───┬────┘ │
│                      │              │       │
│                 ┌────▼──────────────▼────┐  │
│                 │     Sync Engine        │  │
│                 │  ┌─────────────────┐   │  │
│                 │  │  Mutation Queue  │   │  │
│                 │  │  (pending ops)   │   │  │
│                 │  └─────────────────┘   │  │
│                 └───────────┬────────────┘  │
│                             │               │
└─────────────────────────────┼───────────────┘
                              │ sync when online
                    ┌─────────▼─────────┐
                    │     Supabase      │
                    │  (Remote Source)   │
                    └───────────────────┘
```

### Sync Strategy

#### Write Path (Mutations)
1. All writes go to **Drift (local) first**
2. Each mutation is recorded in a `sync_queue` table:
   ```
   sync_queue {
     id, table_name, record_id, operation (INSERT/UPDATE/DELETE),
     payload (JSON), created_at, status (PENDING/SYNCED/FAILED)
   }
   ```
3. When connectivity is detected, process queue in FIFO order
4. On success: mark as SYNCED
5. On failure: retry with exponential backoff (max 3 retries)
6. On conflict: **last-write-wins** using `updated_at` timestamps

#### Read Path (Fetching)
1. Always serve from **Drift (local)** for instant UI response
2. Background fetch from Supabase when online
3. Merge remote data into local DB (upsert)
4. Use Supabase Realtime for live updates when connected

#### Connectivity Monitoring
- Use `connectivity_plus` package to detect network changes
- Show connectivity indicator in app header (🟢 Online / 🔴 Offline)
- Auto-trigger sync when transitioning from offline → online

### Drift Sync Queue Table
```dart
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tableName => text()();
  TextColumn get recordId => text()();
  TextColumn get operation => text()(); // INSERT, UPDATE, DELETE
  TextColumn get payload => text()();   // JSON string
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get status => text().withDefault(const Constant('PENDING'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}
```

### Actions
- [ ] Create `SyncQueue` Drift table
- [ ] Create `SyncEngine` service class
- [ ] Implement mutation queueing (write to local + add to queue)
- [ ] Implement queue processor (push pending ops to Supabase)
- [ ] Implement pull sync (fetch remote changes, upsert local)
- [ ] Add connectivity monitoring with `connectivity_plus`
- [ ] Add connectivity indicator to app UI
- [ ] Implement exponential backoff retry logic
- [ ] Implement conflict resolution (last-write-wins)
- [ ] Handle Supabase Realtime updates for live sync
- [ ] Write integration tests for sync scenarios

---

## Deliverables Checklist

- [ ] Inventory list screen with stock levels and indicators
- [ ] Single-item stock editing works
- [ ] Batch restock functionality works
- [ ] Low-stock alerts display correctly
- [ ] Out-of-stock products auto-disabled
- [ ] Stock history logs all changes
- [ ] Sync engine queues mutations when offline
- [ ] Sync engine processes queue when online
- [ ] Connectivity indicator shows current status
- [ ] App works fully offline (catalog, cart, checkout, inventory)
- [ ] Data syncs correctly when reconnecting
- [ ] No data loss during offline → online transitions

---

## 🚦 Phase Gate — Cross-Check & Verification

### Automated Checks
```bash
flutter analyze
flutter test test/features/inventory/
flutter test test/shared/services/sync/
flutter build apk --debug
```

### Critical Offline Test Scenarios
| Scenario | Steps | Expected Result | Status |
|:---------|:------|:----------------|:-------|
| Offline order | Turn off Wi-Fi → create order → verify saved locally | Order in Drift, sync queue has pending entry | ⬜ |
| Reconnect sync | Reconnect Wi-Fi → verify order appears in Supabase | Supabase has the order, queue item marked SYNCED | ⬜ |
| Offline restock | Turn off Wi-Fi → update stock → verify local update | Stock updated in Drift | ⬜ |
| Conflict | Edit same product on two devices → reconnect | Last-write-wins, no data corruption | ⬜ |
| Queue retry | Trigger sync failure → verify retry with backoff | Retries up to 3 times with increasing delay | ⬜ |

### Manual Verification
| Check | Status |
|:------|:-------|
| Inventory list shows all products with stock levels | ⬜ |
| Low-stock badges appear for items below threshold | ⬜ |
| Batch restock updates multiple items at once | ⬜ |
| Stock history shows audit trail | ⬜ |
| Connectivity indicator accurate (🟢/🔴) | ⬜ |
| Full checkout flow works in airplane mode | ⬜ |

### Report
1. Summary of inventory + sync implementation
2. Screenshots of inventory UI
3. Offline test scenario results
4. Sync engine performance metrics
5. Issues found (if any)
6. Request for approval to proceed to Phase 5

> [!CAUTION]
> ### ⏸️ PAUSE POINT
> After cross-check passes:
> 1. **Git commit & push** all Phase 4 work to GitHub
>    ```bash
>    git add .
>    git commit -m "Phase 4: Inventory Management & Offline Sync - Lesehan Surya POS"
>    git push origin main
>    ```
> 2. Development stops until you review and approve proceeding to **Phase 5: Receipt Printing (Bluetooth)**.
