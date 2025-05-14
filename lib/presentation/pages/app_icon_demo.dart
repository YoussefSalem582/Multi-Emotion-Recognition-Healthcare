import '../../core/core.dart';

class AppIconDemo extends StatelessWidget {
  const AppIconDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EmoSense App Icon')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'App Icon Preview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Large icon with text
            const Center(child: AppLogo(size: 150, showText: true)),
            const SizedBox(height: 48),

            // Different sizes
            const Text(
              'Different Sizes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                AppLogo(size: 40, showText: false),
                AppLogo(size: 60, showText: false),
                AppLogo(size: 80, showText: false),
              ],
            ),
            const SizedBox(height: 48),

            // Light and dark mode
            const Text(
              'Light & Dark Mode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Light mode card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: const [
                        AppLogo(size: 80, showText: true),
                        SizedBox(height: 16),
                        Text(
                          'Light Mode',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Dark mode card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: const [
                        AppLogo(size: 80, showText: true),
                        SizedBox(height: 16),
                        Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Icon details
            const Text(
              'Icon Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Format', 'SVG & PNG'),
                    _buildDetailRow('Dimensions', '1024 x 1024 px'),
                    _buildDetailRow('Primary Color', '#9C5BB5 (Purple)'),
                    _buildDetailRow('Secondary Color', '#2B4B8C (Blue)'),
                    _buildDetailRow('Font', 'Arial Bold'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // App icon description
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'About the Icon',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'The EmoSense AI app icon represents the core functionality of the application: emotion detection in customer service interactions. The icon features a speech bubble with a headset, symbolizing customer service conversations, and three emoji faces showing different emotions (sad, neutral, happy) that the app can detect and analyze.',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
