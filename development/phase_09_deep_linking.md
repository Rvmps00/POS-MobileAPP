# Phase 9: Deep Linking & Password Reset Flow

## Overview
Currently, the Supabase authentication emails (like "Confirm Email" and "Reset Password") redirect users to the default Site URL (`localhost:3000`). This works well for web applications but leads to a dead end on a mobile device, breaking the password reset flow.

## Objectives
1. **Configure Deep Linking:** Use a package like `app_links` to allow the Flutter app to intercept specific custom URL schemes (e.g., `com.surya.pos://login-callback`).
2. **Update Supabase Configuration:** Change the Site URL and Redirect URLs in the Supabase Dashboard to match the custom deep link scheme.
3. **Handle Incoming Links:** Update `main.dart` or `app_router.dart` to catch the deep link, parse the session code/token, and automatically route the user to a "Set New Password" screen if they are resetting their password.

## Expected Outcome
When a user clicks "Reset Password" in their email app on their phone, it will seamlessly open the POS app and present them with a screen to securely type their new password.
