# Phase 8: Payment Gateway (QRIS, Cash, Transfer)

> **Status:** `⬜ Not Started`
> **Depends on:** Phase 7 (Authentication & Roles)
> **Estimated Scope:** Cash handling, QRIS integration, bank transfer, payment reconciliation

---

## Objectives

1. Enhance cash payment with proper handling
2. Integrate QRIS payment via Midtrans or Xendit
3. Add bank transfer (Virtual Account) payment option
4. Implement webhook handling for payment confirmation
5. Build payment reconciliation dashboard

---

## Prerequisites

> [!WARNING]
> ### Business Registration Required
> To accept QRIS payments, your restaurant must be registered as a merchant with a Payment Service Provider (PSP). Required documents:
> - **KTP** (Owner's ID)
> - **NPWP** (Tax ID)
> - **NIB / SIUP** (Business License)
> - **Bank Account** (for settlement)
>
> This registration process typically takes 3-7 business days.

---

## Step 8.1 — Cash Payment (Enhancement)

Cash payment was already implemented in Phase 3. This step enhances it:

### Features
- Amount tendered input with quick-fill buttons (Rp 50K, 100K, 200K)
- Automatic change calculation
- "Exact amount" button (sets tendered = total)
- Cash payment confirmation dialog
- Record cash transaction in payment log

### Actions
- [ ] Add quick-fill amount buttons
- [ ] Add "Exact Amount" convenience button
- [ ] Improve cash confirmation dialog UI
- [ ] Log cash payment details to `payment_transactions` table

---

## Step 8.2 — QRIS Payment Integration

### Payment Gateway Selection
Choose one (to be confirmed by user):

| Gateway | Pros | Cons |
|:--------|:-----|:-----|
| **Midtrans** | Strong ecosystem (Gojek), comprehensive docs, sandbox | Setup can be complex |
| **Xendit** | Developer-friendly API, fast integration, good support | Slightly higher MDR for some methods |

### QRIS Flow (Merchant Presented Mode — MPM)
```
┌──────────┐     ┌──────────────┐     ┌──────────────┐
│ Checkout  │────▶│  App calls   │────▶│  Gateway     │
│ Screen    │     │  Gateway API │     │  returns QR  │
└──────────┘     └──────────────┘     └──────┬───────┘
                                             │
                                    ┌────────▼────────┐
                                    │  Display QR on  │
                                    │  POS screen     │
                                    └────────┬────────┘
                                             │
                                    ┌────────▼────────┐
                                    │  Customer scans │
                                    │  with e-wallet  │
                                    └────────┬────────┘
                                             │
                                    ┌────────▼────────┐
                                    │  Gateway sends  │
                                    │  webhook/notify │
                                    └────────┬────────┘
                                             │
                                    ┌────────▼────────┐
                                    │  Order marked   │
                                    │  as PAID ✅     │
                                    └─────────────────┘
```

### Implementation Steps

#### Backend (Supabase Edge Function)
- **Create payment:** Edge Function that calls Midtrans/Xendit API to generate QRIS code
- **Webhook handler:** Edge Function that receives payment notification from gateway
- **Verify payment:** Validate webhook signature for security

#### Frontend (Flutter)
- QRIS payment option on checkout screen
- Display dynamic QR code to customer
- Polling / Realtime subscription for payment status
- Countdown timer (QRIS typically expires in 15-30 minutes)
- Success animation on payment confirmation
- Fallback: manual payment confirmation button (for edge cases)

### Supabase Edge Functions
```
supabase/functions/
├── create-payment/     # Generate QRIS/VA from gateway
├── payment-webhook/    # Receive gateway notifications
└── check-payment/      # Verify payment status
```

### Payment Transactions Table
#### `payment_transactions`
| Column | Type | Constraints |
|:-------|:-----|:------------|
| `id` | UUID | PK |
| `order_id` | UUID | FK → `orders.id` |
| `payment_method` | TEXT | "CASH", "QRIS", "TRANSFER" |
| `gateway_ref` | TEXT | Nullable (gateway transaction ID) |
| `amount` | BIGINT | NOT NULL |
| `status` | TEXT | "PENDING", "PAID", "EXPIRED", "FAILED" |
| `qr_code_url` | TEXT | Nullable (QRIS image URL) |
| `va_number` | TEXT | Nullable (Virtual Account number) |
| `paid_at` | TIMESTAMPTZ | Nullable |
| `expires_at` | TIMESTAMPTZ | Nullable |
| `raw_response` | JSONB | Nullable (full gateway response) |
| `created_at` | TIMESTAMPTZ | Default `now()` |

### Actions
- [ ] Choose and register with payment gateway (Midtrans/Xendit)
- [ ] Create Supabase Edge Function: `create-payment`
- [ ] Create Supabase Edge Function: `payment-webhook`
- [ ] Create `payment_transactions` table
- [ ] Build QRIS checkout UI (QR display, timer, status polling)
- [ ] Implement payment status Realtime subscription
- [ ] Handle payment success → mark order as PAID
- [ ] Handle payment expiry → allow retry or cancel
- [ ] Test in sandbox environment

---

## Step 8.3 — Bank Transfer (Virtual Account)

### Flow
1. Customer selects "Bank Transfer" at checkout
2. App generates a Virtual Account (VA) number via gateway
3. Display VA number + bank name + amount to customer
4. Customer transfers from their bank app
5. Gateway confirms payment → order marked as PAID

### Supported Banks (via Midtrans/Xendit)
- BCA, BNI, BRI, Mandiri, Permata, CIMB

### Implementation
- Reuse same Edge Functions as QRIS (gateway handles method routing)
- Display VA number with copy-to-clipboard button
- Show bank logo and transfer instructions
- Same polling/Realtime for payment confirmation

### Actions
- [ ] Add bank transfer option to checkout
- [ ] Build VA display screen (number, bank, amount, instructions)
- [ ] Add copy-to-clipboard for VA number
- [ ] Handle VA payment confirmation via webhook
- [ ] Handle VA expiry

---

## Step 8.4 — Payment Reconciliation

### Payment Summary (in Dashboard)
- Total payments by method (Cash / QRIS / Transfer)
- Settlement status tracking
- Failed/expired payment count
- Daily reconciliation report

### Actions
- [ ] Add payment method breakdown to dashboard
- [ ] Show settlement status per transaction
- [ ] Flag discrepancies (if any)
- [ ] Include payment data in CSV/PDF exports

---

## Deliverables Checklist

- [ ] Cash payment enhanced with quick-fill buttons
- [ ] QRIS payment generates dynamic QR code
- [ ] QR code displays on screen for customer scanning
- [ ] Payment confirmation received via webhook/Realtime
- [ ] Order auto-updates to PAID on successful QRIS payment
- [ ] Bank transfer generates Virtual Account number
- [ ] VA number copyable to clipboard
- [ ] Transfer confirmation works via webhook
- [ ] Payment expiry handled gracefully (retry/cancel)
- [ ] All payments logged in `payment_transactions`
- [ ] Payment breakdown visible in dashboard
- [ ] Sandbox testing passed for all payment methods
- [ ] Receipt shows correct payment method

---

## 🚦 Phase Gate — Cross-Check & Verification

### Automated Checks
```bash
flutter analyze
flutter test test/features/checkout/payment/
flutter build apk --debug
# Edge Function tests
supabase functions serve --debug
```

### Payment Testing (Sandbox)
| Test | Method | Steps | Expected | Status |
|:-----|:-------|:------|:---------|:-------|
| QRIS success | QRIS | Checkout → QR → simulate scan | Order marked PAID | ⬜ |
| QRIS expired | QRIS | Checkout → QR → wait for expiry | Shows expired, retry option | ⬜ |
| Cash exact | Cash | Enter exact amount | No change, order PAID | ⬜ |
| Cash change | Cash | Enter more than total | Correct change displayed | ⬜ |
| VA success | Transfer | Checkout → VA → simulate transfer | Order marked PAID | ⬜ |
| VA expired | Transfer | Checkout → VA → wait for expiry | Shows expired, retry option | ⬜ |
| Webhook security | All | Send fake webhook | Rejected (invalid signature) | ⬜ |

### Manual Verification
| Check | Status |
|:------|:-------|
| All 3 payment methods selectable on checkout | ⬜ |
| QRIS QR code renders correctly | ⬜ |
| Payment status updates in realtime | ⬜ |
| VA number displays with correct bank info | ⬜ |
| Receipt shows correct payment method | ⬜ |
| Dashboard shows payment method breakdown | ⬜ |
| Edge Functions deploy and run on Supabase | ⬜ |
| Webhook endpoint secured with signature verification | ⬜ |

### Report
1. Summary of payment gateway integration
2. Screenshots of QRIS, Cash, and Transfer checkout flows
3. Sandbox test results for all scenarios
4. Edge Function deployment status
5. Security verification (webhook signatures)
6. Issues found (if any)

> [!CAUTION]
> ### ⏸️ FINAL PHASE COMPLETE
> After cross-check passes:
> 1. **Git commit & push** all Phase 8 work to GitHub
>    ```bash
>    git add .
>    git commit -m "Phase 8: Payment Gateway (QRIS/Cash/Transfer) - Lesehan Surya POS"
>    git push origin main
>    ```
> 2. Final steps after all phases:
>    - Full end-to-end testing
>    - Performance optimization
>    - Production deployment preparation
>    - User acceptance testing (UAT) at the restaurant
>    - Go live! 🚀
