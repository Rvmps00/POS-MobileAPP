import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../data/providers/auth_provider.dart';
import '../../../../core/constants/legal_documents.dart';

class LegalConsentScreen extends ConsumerStatefulWidget {
  const LegalConsentScreen({super.key});

  @override
  ConsumerState<LegalConsentScreen> createState() => _LegalConsentScreenState();
}

class _LegalConsentScreenState extends ConsumerState<LegalConsentScreen> {
  bool _hasAgreed = false;
  bool _isSaving = false;
  int _currentTabIndex = 0;

  Future<void> _acceptEula() async {
    setState(() => _isSaving = true);
    try {
      await ref.read(legalConsentProvider.notifier).accept();
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving consent: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(Icons.gavel, size: 48, color: colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome to POS Mobile',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please review our legal policies before using the app.',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Tabs for Privacy Policy and TOS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('Terms of Service'),
                      selected: _currentTabIndex == 0,
                      onSelected: (val) => setState(() => _currentTabIndex = 0),
                    ),
                    const SizedBox(width: 16),
                    ChoiceChip(
                      label: const Text('Privacy Policy'),
                      selected: _currentTabIndex == 1,
                      onSelected: (val) => setState(() => _currentTabIndex = 1),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Document Content
                Expanded(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Markdown(
                      data: _currentTabIndex == 0 ? termsOfServiceMarkdown : privacyPolicyMarkdown,
                      selectable: true,
                    ),
                  ),
                ),
                
                // Consent Checkbox and Button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _hasAgreed,
                            onChanged: (val) => setState(() => _hasAgreed = val ?? false),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _hasAgreed = !_hasAgreed),
                              child: Text(
                                'I have read and agree to the Terms of Service and Privacy Policy.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: _hasAgreed && !_isSaving ? _acceptEula : null,
                          child: _isSaving
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('Continue to App', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
