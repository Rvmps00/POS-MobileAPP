# Phase 5: Receipt Printing (Bluetooth)

> **Status:** `⬜ Not Started`
> **Depends on:** Phase 4 (Inventory & Offline Sync)
> **Estimated Scope:** Bluetooth pairing, ESC/POS receipt formatting, print workflow

---

## Objectives

1. Implement Bluetooth device scanning and printer pairing
2. Build ESC/POS receipt templates for the CODESHOP CM-T58BL
3. Auto-print receipt after successful checkout
4. Add reprint capability from order history
5. Printer status monitoring and error handling

---

## Target Printer Specifications

| Spec | Value |
|:-----|:------|
| **Model** | CODESHOP CM-T58BL |
| **Type** | Portable Bluetooth Thermal Printer |
| **Paper Width** | 58mm (48mm printable) |
| **Protocol** | ESC/POS |
| **Connection** | Bluetooth Classic |
| **Print Speed** | 90mm/s |
| **Resolution** | 203 DPI (8 dots/mm) |
| **Max Characters/Line** | 32 characters (normal) / 16 characters (double-width) |

---

## Step 5.1 — Bluetooth Printer Connection

### Dependencies
```yaml
dependencies:
  esc_pos_utils_plus: ^x.x.x    # ESC/POS command generation
  print_bluetooth_thermal: ^x.x.x  # Bluetooth communication
```

### Android Permissions (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

### Printer Management
- **Scan:** Discover nearby Bluetooth devices
- **Pair:** Connect to selected printer
- **Remember:** Save paired printer MAC address for auto-reconnect
- **Status:** Show connection status (Connected / Disconnected / Searching)
- **Auto-reconnect:** Attempt reconnection on app start and before print

### Settings → Printer Setup Screen
- List of discovered Bluetooth devices
- Currently paired printer info
- Test print button (prints a small test receipt)
- Disconnect button

### Actions
- [ ] Add Bluetooth dependencies to `pubspec.yaml`
- [ ] Configure Android permissions
- [ ] Create `PrinterService` class (scan, connect, disconnect, status)
- [ ] Build `PrinterSetupScreen` in Settings
- [ ] Implement auto-reconnect logic
- [ ] Store paired printer MAC address in local preferences
- [ ] Create printer status indicator widget (for app bar)

---

## Step 5.2 — Receipt Template (ESC/POS)

### Receipt Layout (48mm printable width = 32 chars)
```
================================
       LESEHAN SURYA
    [Address — TBD later]
     [Phone — TBD later]
================================
Date: 11/08/2026   Time: 11:30
Cashier: Surya
Order: LS-20260811-001
Type: Dine-in    Table: 3
--------------------------------
Item                 Qty  Amount
  +/- toppings
--------------------------------
Nasi Goreng           x2  46.000
  + Ayam (+5.000)
  + Extra Telur (+3.000)
  - No Bawang Putih
  📝 Extra pedas
Mie Goreng            x1  15.000
  - No Kecap Manis
  + Kerupuk (FREE)
--------------------------------
Subtotal:          Rp 61.000
Tax (10%):          Rp 6.100
                 ============
TOTAL:             Rp 67.100
                 ============
--------------------------------
Payment: CASH
Received:         Rp 100.000
Change:            Rp 32.900
--------------------------------
     Terima Kasih!
  Selamat Menikmati 🙏
================================
```

### ESC/POS Commands Used
| Command | Hex | Purpose |
|:--------|:----|:--------|
| Initialize | `1B 40` | Reset printer |
| Center align | `1B 61 01` | Center text |
| Left align | `1B 61 00` | Left align |
| Right align | `1B 61 02` | Right align |
| Bold on | `1B 45 01` | Emphasis |
| Bold off | `1B 45 00` | Normal |
| Double height | `1D 21 01` | Large text |
| Normal size | `1D 21 00` | Standard text |
| Cut paper | `1D 56 00` | Full cut (if supported) |
| Feed lines | `1B 64 03` | Feed 3 lines |

### Receipt Builder
Create a `ReceiptBuilder` class that takes an `Order` object and generates ESC/POS byte commands:

```dart
class ReceiptBuilder {
  // Restaurant info (from settings)
  // Order data
  // → Returns List<int> (raw ESC/POS bytes)
  
  List<int> buildReceipt(Order order, RestaurantInfo info);
  List<int> buildTestReceipt();  // For test print
}
```

### Actions
- [ ] Create `ReceiptBuilder` class
- [ ] Implement header section (restaurant name, address)
- [ ] Implement order info section (date, cashier, order number)
- [ ] Implement items section (with variants and notes)
- [ ] Implement totals section (subtotal, tax, discount, total)
- [ ] Implement payment section (method, received, change)
- [ ] Implement footer section (thank you message)
- [ ] Create test receipt template
- [ ] Handle Indonesian Rupiah formatting (no decimals, dot separator)

---

## Step 5.3 — Print Workflow

### Auto-Print on Checkout
1. Order completes → receipt auto-prints
2. If printer disconnected → show print failed dialog with "Retry" option
3. Queue print job if printer temporarily busy

### Reprint from Order History
1. Order History → tap order → "Reprint Receipt" button
2. Rebuild receipt from stored order data
3. Same print flow as above

### Print Preview (Optional)
- Show a visual preview of the receipt before printing
- Useful for verifying receipt content

### Error Handling
| Error | User-Facing Action |
|:------|:-------------------|
| Printer not connected | "Printer disconnected. Connect in Settings?" |
| Printer out of paper | "Printer may be out of paper. Check printer." |
| Print timeout | "Print failed. Retry?" |
| Bluetooth turned off | "Please enable Bluetooth to print." |

### Actions
- [ ] Integrate print into checkout success flow
- [ ] Add "Reprint" button to order detail screen
- [ ] Implement print error handling with user-friendly messages
- [ ] Add retry logic for failed prints
- [ ] Queue prints when printer is temporarily busy

---

## Step 5.4 — Restaurant Info Configuration

### Settings → Restaurant Info
- Restaurant name
- Address
- Phone number
- Tax registration number (NPWP) — optional on receipt
- Footer message (customizable)

Store in local preferences + sync to Supabase.

### Actions
- [ ] Build restaurant info form in Settings
- [ ] Store info in local preferences
- [ ] Pass restaurant info to `ReceiptBuilder`

---

## Deliverables Checklist

- [ ] Bluetooth device scanning works
- [ ] Printer pairing and connection works
- [ ] Auto-reconnect to saved printer on app start
- [ ] Printer status indicator in app bar
- [ ] Test print from Settings works
- [ ] Receipt template formats correctly on 58mm paper
- [ ] Auto-print after successful checkout
- [ ] Reprint from order history works
- [ ] Error handling for disconnected/busy printer
- [ ] Restaurant info configurable in Settings
- [ ] Indonesian Rupiah formatting correct (Rp X.XXX)

---

## 🚦 Phase Gate — Cross-Check & Verification

### Automated Checks
```bash
flutter analyze
flutter test test/features/settings/printer/
flutter test test/shared/services/receipt/
flutter build apk --debug
```

### Hardware Testing (CODESHOP CM-T58BL)
| Test | Steps | Expected | Status |
|:-----|:------|:---------|:-------|
| Scan & pair | Open Settings → scan → select printer | Printer appears, pairs successfully | ⬜ |
| Test print | Tap "Test Print" | Test receipt prints correctly | ⬜ |
| Auto-print | Complete a checkout | Receipt auto-prints | ⬜ |
| Reprint | Order History → open order → Reprint | Same receipt reprints | ⬜ |
| Disconnect recovery | Turn off printer → try print → turn on → retry | Error shown, retry succeeds | ⬜ |
| Text alignment | Verify receipt layout | All columns aligned, no overflow | ⬜ |
| Special chars | Indonesian text (Rp, é, ñ) | Characters print correctly | ⬜ |

### Manual Verification
| Check | Status |
|:------|:-------|
| Receipt matches template layout exactly | ⬜ |
| Rupiah formatting correct (dots, no decimals) | ⬜ |
| Order details on receipt match app data | ⬜ |
| Restaurant info from Settings appears on receipt | ⬜ |
| Printer status indicator reflects actual state | ⬜ |

### Report
1. Summary of printing implementation
2. Photos of actual printed receipts from CM-T58BL
3. Video of print workflow (checkout → auto-print)
4. Test results for all hardware scenarios
5. Issues found (if any)
6. Request for approval to proceed to Phase 6

> [!CAUTION]
> ### ⏸️ PAUSE POINT
> After cross-check passes:
> 1. **Git commit & push** all Phase 5 work to GitHub
>    ```bash
>    git add .
>    git commit -m "Phase 5: Bluetooth Receipt Printing (CM-T58BL) - Lesehan Surya POS"
>    git push origin main
>    ```
> 2. Development stops until you review and approve proceeding to **Phase 6: Dashboard & Order History** (beta).
>
> 🎉 **Alpha version complete after this phase!**
