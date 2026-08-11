# Phase 7: Authentication & Role Management

> **Status:** `⬜ Not Started`
> **Depends on:** Phase 6 (Dashboard & Order History)
> **Estimated Scope:** Login system, PIN-based access, role-based permissions

---

## Objectives

1. Implement Supabase Auth (email/password login)
2. Add PIN-based quick login for cashier shift mode
3. Create role-based access control (Cashier, Manager, Owner)
4. Enforce permissions at both UI and API level
5. User management for restaurant staff

---

## Step 7.1 — Supabase Auth Integration

### Auth Flow
1. **First-time setup:** Owner registers with email/password
2. **Daily use:** PIN-based quick login for cashiers
3. **Session management:** Keep user logged in, auto-refresh tokens

### Supabase Configuration
- Enable email/password authentication
- Disable email confirmation (for internal use, not customer-facing)
- Configure session duration (24 hours recommended for POS)

### User Profiles Table
#### `profiles` (extends Supabase `auth.users`)
| Column | Type | Constraints |
|:-------|:-----|:------------|
| `id` | UUID | PK, FK → `auth.users.id` |
| `full_name` | TEXT | NOT NULL |
| `role` | TEXT | "CASHIER", "MANAGER", "OWNER" |
| `pin` | TEXT | 4-6 digit PIN (hashed) |
| `is_active` | BOOLEAN | Default TRUE |
| `avatar_url` | TEXT | Nullable |
| `created_at` | TIMESTAMPTZ | Default `now()` |

### Actions
- [ ] Configure Supabase Auth (email/password)
- [ ] Create `profiles` table with RLS
- [ ] Create database trigger: auto-create profile on user signup
- [ ] Implement `AuthRepository` in Flutter
- [ ] Build `LoginScreen` (email/password)
- [ ] Implement session persistence and auto-refresh
- [ ] Handle auth state changes (logged in/out)
- [ ] Redirect to login when session expires

---

## Step 7.2 — PIN-Based Quick Login

### Use Case
During a shift, cashiers need to quickly switch users or lock/unlock the POS without entering full credentials. A 4-6 digit PIN provides fast, secure access.

### Flow
1. Owner/Manager creates staff accounts with PINs
2. At shift start, cashier enters PIN on lock screen
3. PIN validated against hashed value in `profiles`
4. Session starts for that cashier
5. Lock screen returns after configurable idle timeout

### Lock Screen
- Numeric keypad (0-9) with PIN dots
- Current user avatar/name display
- "Switch User" option
- "Full Login" option (email/password fallback)

### Actions
- [ ] Build `PinEntryScreen` with numeric keypad
- [ ] Implement PIN hashing and verification
- [ ] Build `LockScreen` with idle timeout
- [ ] Configure idle timeout in Settings (default: 5 minutes)
- [ ] Implement user switching via PIN
- [ ] Store current cashier in app state (for receipts/orders)

---

## Step 7.3 — Role-Based Access Control (RBAC)

### Role Permissions Matrix

| Feature | Cashier | Manager | Owner |
|:--------|:--------|:--------|:------|
| POS / Create Orders | ✅ | ✅ | ✅ |
| View Cart / Checkout | ✅ | ✅ | ✅ |
| Print Receipts | ✅ | ✅ | ✅ |
| View Order History | ✅ (own) | ✅ (all) | ✅ (all) |
| Cancel Orders | ❌ | ✅ | ✅ |
| View Dashboard | ❌ | ✅ | ✅ |
| Manage Inventory | ❌ | ✅ | ✅ |
| Manage Products | ❌ | ✅ | ✅ |
| Apply Discounts | ❌ | ✅ | ✅ |
| Manage Users | ❌ | ❌ | ✅ |
| App Settings | ❌ | ❌ | ✅ |
| View Reports / Export | ❌ | ✅ | ✅ |

### Implementation

#### UI Level
- Navigation items hidden/shown based on role
- Action buttons disabled for unauthorized roles
- Redirect to "Access Denied" if navigating to restricted route

#### API Level (Supabase RLS)
- Update RLS policies on all tables to check user role
- Example: Only MANAGER/OWNER can DELETE products
- Example: Cashiers can only view their own orders

#### Flutter Implementation
- `RoleGuard` widget wrapper that checks permissions
- `PermissionService` that provides role-based checks
- GoRouter redirect guards for protected routes

### Actions
- [ ] Define permission constants/enum
- [ ] Create `PermissionService` with role checks
- [ ] Build `RoleGuard` widget wrapper
- [ ] Update GoRouter with auth/role redirects
- [ ] Update Supabase RLS policies per role
- [ ] Hide/show nav items based on role
- [ ] Disable restricted actions for unauthorized roles
- [ ] Test all role scenarios

---

## Step 7.4 — User Management (Owner Only)

### Staff Management Screen
- List of all staff members (name, role, status)
- Add new staff member (name, email, PIN, role)
- Edit staff member (change role, reset PIN)
- Deactivate staff member (soft delete)
- Activity log per staff member (optional)

### Actions
- [ ] Build `StaffListScreen`
- [ ] Build `AddStaffScreen` (create user via Supabase Admin)
- [ ] Build `EditStaffScreen`
- [ ] Implement deactivate/activate staff
- [ ] Send invite email to new staff (optional)

---

## Deliverables Checklist

- [ ] Email/password login works
- [ ] PIN-based quick login works
- [ ] Lock screen with idle timeout works
- [ ] User switching via PIN works
- [ ] Cashier role has correct permissions (POS only)
- [ ] Manager role has correct permissions (+ inventory, dashboard)
- [ ] Owner role has full access (+ settings, user management)
- [ ] Unauthorized actions are blocked (UI + API)
- [ ] Staff management CRUD works (Owner only)
- [ ] Supabase RLS enforces role permissions
- [ ] Current cashier name appears on receipts

---

## 🚦 Phase Gate — Cross-Check & Verification

### Automated Checks
```bash
flutter analyze
flutter test test/features/auth/
flutter build apk --debug
```

### Role Testing Matrix
| Action | As Cashier | As Manager | As Owner | Status |
|:-------|:-----------|:-----------|:---------|:-------|
| Create order | ✅ Works | ✅ Works | ✅ Works | ⬜ |
| View all orders | ❌ Own only | ✅ Works | ✅ Works | ⬜ |
| Cancel order | ❌ Blocked | ✅ Works | ✅ Works | ⬜ |
| View dashboard | ❌ Hidden | ✅ Works | ✅ Works | ⬜ |
| Edit inventory | ❌ Hidden | ✅ Works | ✅ Works | ⬜ |
| Manage staff | ❌ Hidden | ❌ Hidden | ✅ Works | ⬜ |
| Change settings | ❌ Hidden | ❌ Hidden | ✅ Works | ⬜ |

### Manual Verification
| Check | Status |
|:------|:-------|
| Login with email/password works | ⬜ |
| PIN entry screen displays correctly | ⬜ |
| PIN login authenticates correct user | ⬜ |
| Wrong PIN shows error | ⬜ |
| Lock screen appears after idle timeout | ⬜ |
| Switch user via lock screen works | ⬜ |
| Navigation items correct per role | ⬜ |
| RLS blocks unauthorized Supabase queries | ⬜ |
| Cashier name on receipt matches logged-in user | ⬜ |
| Add new staff member works | ⬜ |
| Deactivate staff prevents their login | ⬜ |

### Report
1. Summary of auth & RBAC implementation
2. Screenshots of login, PIN, lock screen
3. Role testing matrix results
4. RLS policy test results
5. Issues found (if any)
6. Request for approval to proceed to Phase 8

> [!CAUTION]
> ### ⏸️ PAUSE POINT
> After cross-check passes:
> 1. **Git commit & push** all Phase 7 work to GitHub
>    ```bash
>    git add .
>    git commit -m "Phase 7: Authentication & Role Management - Lesehan Surya POS"
>    git push origin main
>    ```
> 2. Development stops until you review and approve proceeding to **Phase 8: Payment Gateway (QRIS, Cash, Transfer)**.
