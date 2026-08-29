# Phase 8: Payment Gateway (QRIS & Cash)

> **Status:** `✅ Completed`
> **Depends on:** Phase 7 (Authentication & Roles)
> **Estimated Scope:** Cash handling, physical QRIS integration, payment reconciliation

---

## Objectives

1. Maintain standard cash payment with quick-fill amount logic.
2. Integrate physical QRIS payment workflow (No dynamic generation needed, merchant already has a physical standee).
3. Ensure accurate recording of payment method ("CASH" or "QRIS") in database.

---

## Step 8.1 — Cash Payment (Retained)

Cash payment was already robustly implemented in Phase 3. 

### Features
- Amount tendered input with quick-fill buttons (+ Rp 50K, 100K, 200K).
- "Exact amount" button (sets tendered = total).
- Number pad for precise manual input.
- Automatic change calculation.

### Status
- [x] Implemented in `checkout_screen.dart`.

---

## Step 8.2 — Physical QRIS Workflow

Since the restaurant already uses a printed bank QRIS standee on the cashier desk, we do not need to generate a dynamic digital QR code or handle webhooks. We only need the POS to properly categorize the payment and adjust the UI flow.

### Workflow
1. Cashier taps **Checkout**.
2. Cashier selects **QRIS** on the payment method toggle.
3. The cash input field and change calculator disappear.
4. UI prompts the cashier to direct the customer to scan the physical QRIS standee.
5. Once the cashier visually verifies the successful payment on their banking app/mutation or the customer's phone, they tap **Confirm QRIS Payment**.
6. The POS logs the payment exactly as the order total, with 0 change, and saves `payment_method` as `'QRIS'`.

### Implementation Details
- **UI (`checkout_screen.dart`)**: Added a `SegmentedButton` to switch between `CASH` and `QRIS`.
- **Logic**: If QRIS is selected, `effectiveCashReceived` equals `grandTotal`, and `effectiveChange` is `0`.
- **Database (`order_repository.dart`)**: Modified `saveOrder` to accept `paymentMethod` and inject it into both the local Drift DB (`OrdersTable`) and the Supabase sync payload (`payment_method` field).

### Status
- [x] UI Toggle built
- [x] Conditional UI rendering for QRIS built
- [x] Repository updated to accept `paymentMethod`
- [x] Order sync updated to push `paymentMethod`

---

## 🚦 Phase Gate — Cross-Check & Verification

### Manual Verification
| Check | Status |
|:------|:-------|
| Cash and QRIS toggle on checkout | ✅ |
| QRIS hides cash input and change | ✅ |
| QRIS sets exact amount automatically | ✅ |
| Database saves `payment_method` correctly | ✅ |
| Receipt displays the correct data | ✅ |

### ⏸️ FINAL PHASE COMPLETE
The simplified Physical QRIS workflow is fully implemented and fulfills the restaurant's operational needs without requiring external API dependencies or fees.
