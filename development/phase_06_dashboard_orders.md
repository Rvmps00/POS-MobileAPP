# Phase 6: Dashboard & Order History

> **Status:** `⬜ Not Started`
> **Depends on:** Phase 5 (Receipt Printing)
> **Estimated Scope:** Sales dashboard, order history, charts, reporting

---

## Objectives

1. Build a sales dashboard with key metrics and charts
2. Create searchable/filterable order history
3. Add order detail view with reprint capability
4. Implement report export (CSV/PDF)
5. Date range filtering for all analytics

---

## Step 6.1 — Order History

### Order History Screen
- Chronological list of all orders (newest first)
- Each item shows: order number, date/time, total, payment method, status
- Color-coded status badges (Completed ✅, Cancelled ❌, Pending ⏳)
- Pull-to-refresh

### Search & Filter
- Search by: order number, customer name
- Filter by:
  - Date range (today, this week, this month, custom)
  - Payment method (Cash, QRIS, Transfer)
  - Order type (Dine-in, Takeaway)
  - Status (Completed, Cancelled, Pending)
- Sort by: date (newest/oldest), total (high/low)

### Order Detail View
- Full order information (items, quantities, prices, notes)
- Payment details
- Cashier name
- Timestamps (created, completed)
- Action buttons:
  - **Reprint Receipt** (connects to Phase 5)
  - **Cancel Order** (manager only, with reason)
  - **Refund** (future enhancement)

### Actions
- [ ] Build `OrderHistoryScreen` with list view
- [ ] Build `OrderDetailScreen`
- [ ] Implement search functionality
- [ ] Implement date range picker and filters
- [ ] Connect "Reprint Receipt" to PrinterService
- [ ] Implement order cancellation with reason input
- [ ] Add pagination for large order lists

---

## Step 6.2 — Sales Dashboard

### Dashboard Screen
A quick-glance overview of business performance.

### Key Metrics Cards (Top Row)
| Metric | Description |
|:-------|:------------|
| **Today's Revenue** | Sum of all completed order totals today |
| **Order Count** | Number of completed orders today |
| **Average Order Value** | Today's revenue ÷ order count |
| **Items Sold** | Total quantity of items sold today |

### Charts & Visualizations

#### Top Selling Items (Bar/Horizontal Bar Chart)
- Top 10 products by quantity sold
- Period: Today / This Week / This Month
- Shows product name + quantity

#### Sales by Category (Pie/Donut Chart)
- Revenue breakdown by product category
- Shows percentage and amount

#### Revenue Trend (Line Chart)
- Daily revenue over the past 7 / 30 days
- Shows trend line with data points

#### Hourly Sales (Bar Chart)
- Order count by hour of day
- Helps identify peak hours

### Chart Library
```yaml
dependencies:
  fl_chart: ^0.x.x  # Beautiful, performant Flutter charts
```

### Dashboard Data Queries
All dashboard data should be queried from the local Drift DB for speed, with periodic sync from Supabase.

### Actions
- [ ] Build `DashboardScreen` layout
- [ ] Create metric cards (revenue, orders, avg value, items)
- [ ] Implement top-selling items chart
- [ ] Implement sales by category chart
- [ ] Implement revenue trend line chart
- [ ] Implement hourly sales bar chart
- [ ] Add period selector (Today / Week / Month)
- [ ] Create dashboard Riverpod providers
- [ ] Optimize queries for performance

---

## Step 6.3 — Report Export

### Export Options
- **CSV Export:** Order list with all details, downloadable
- **PDF Report:** Formatted daily/weekly/monthly summary
- Save to device storage or share via Android share sheet

### Dependencies
```yaml
dependencies:
  csv: ^6.x.x          # CSV generation
  pdf: ^3.x.x          # PDF generation
  printing: ^5.x.x     # Print/share PDF
  share_plus: ^9.x.x   # Share files
  path_provider: ^2.x.x
```

### Actions
- [ ] Implement CSV export for order history
- [ ] Implement PDF report generation (daily summary)
- [ ] Add export buttons to dashboard and order history
- [ ] Share/save exported files

---

## Deliverables Checklist

- [ ] Order history list with search and filters
- [ ] Order detail view with complete information
- [ ] Reprint receipt from order detail works
- [ ] Order cancellation (with reason) works
- [ ] Dashboard shows key metrics correctly
- [ ] Top-selling items chart renders
- [ ] Sales by category chart renders
- [ ] Revenue trend chart renders
- [ ] Period selector (today/week/month) updates all charts
- [ ] CSV export generates correct file
- [ ] PDF report generates and is shareable
- [ ] All data loads from local DB (fast, offline-capable)

---

## 🚦 Phase Gate — Cross-Check & Verification

### Automated Checks
```bash
flutter analyze
flutter test test/features/orders/
flutter test test/features/dashboard/
flutter build apk --debug
```

### Manual Verification
| Check | Status |
|:------|:-------|
| Order history shows all past orders | ⬜ |
| Search by order number works | ⬜ |
| Date range filter returns correct orders | ⬜ |
| Payment method filter works | ⬜ |
| Order detail shows all items and prices | ⬜ |
| Reprint receipt from detail works | ⬜ |
| Dashboard metrics match actual data | ⬜ |
| Top-selling chart shows correct products | ⬜ |
| Revenue trend matches daily totals | ⬜ |
| CSV export opens correctly in spreadsheet | ⬜ |
| PDF report is formatted and readable | ⬜ |
| Dashboard loads quickly (<1 second) | ⬜ |

### Report
1. Summary of dashboard & order history implementation
2. Screenshots of dashboard with charts
3. Screenshots of order history and detail views
4. Sample exported CSV and PDF files
5. Performance metrics for dashboard loading
6. Issues found (if any)
7. Request for approval to proceed to Phase 7

> [!CAUTION]
> ### ⏸️ PAUSE POINT
> After cross-check passes:
> 1. **Git commit & push** all Phase 6 work to GitHub
>    ```bash
>    git add .
>    git commit -m "Phase 6: Dashboard & Order History - Lesehan Surya POS"
>    git push origin main
>    ```
> 2. Development stops until you review and approve proceeding to **Phase 7: Authentication & Role Management**.
