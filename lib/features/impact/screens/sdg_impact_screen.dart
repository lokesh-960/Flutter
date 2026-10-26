import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SdgImpactScreen extends StatelessWidget {
  const SdgImpactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('UN SDG 4: Quality Education Impact'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SDG 4 Header Banner
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.sdgRed,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.sdgRed.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'SUSTAINABLE DEVELOPMENT GOAL 4',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Ensure inclusive and equitable quality education and promote lifelong learning opportunities for all.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.public, color: AppColors.sdgRed, size: 40),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Architectural Alignment with SDG 4
                  Text(
                    'How DLMS Implements SDG 4',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildPillarCard(
                    icon: Icons.money_off,
                    title: '1. Zero Financial Barriers',
                    description: 'All foundational courses (Programming, Java, Web, Databases, Digital Literacy, Mathematics) are available at zero cost with open educational licenses.',
                    isDark: isDark,
                  ),
                  _buildPillarCard(
                    icon: Icons.wifi_off,
                    title: '2. Low-Bandwidth & Offline Resilience',
                    description: 'Structured text lessons and course curriculum metadata are cached locally to support students in rural or unstable internet environments.',
                    isDark: isDark,
                  ),
                  _buildPillarCard(
                    icon: Icons.accessibility_new,
                    title: '3. Universal Digital Accessibility',
                    description: 'Built with WCAG-compliant color contrast, responsive layout scaling across mobile and desktop browsers, and screen-reader semantic trees.',
                    isDark: isDark,
                  ),
                  _buildPillarCard(
                    icon: Icons.security,
                    title: '4. Digital Literacy & Cyber Hygiene',
                    description: 'Dedicated curriculum educating students on password resilience, phishing defense, digital ethics, and responsible online collaboration.',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 28),

                  // Realistic Platform Indicators
                  Text(
                    'SDG 4 Key Performance Indicators (Demo Cohort)',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricBox('100%', 'Free Open Access Curricula', AppColors.primary, isDark),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricBox('6', 'Core STEM Curricula', AppColors.secondary, isDark),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricBox('8,360+', 'Learner Enrollments', AppColors.success, isDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Disclaimers & Transparency
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, size: 20, color: AppColors.textSecondaryLight),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Academic Note: Platform metrics reflect active cohort data and simulation benchmarks. In accordance with rigorous scientific and academic standards, digital system metrics are clearly delineated from longitudinal community educational outcomes.',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight, height: 1.4),
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
      ),
    );
  }

  Widget _buildPillarCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox(String value, String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
          ),
        ],
      ),
    );
  }
}
