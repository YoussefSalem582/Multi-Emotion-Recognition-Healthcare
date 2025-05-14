import '../core/core.dart';

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
            const Center(child: AppLogo(size: 200)),

            const SizedBox(height: 48),

            const Text(
              'Different Sizes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Different sizes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const AppLogo(size: 64, showText: false),
                const AppLogo(size: 96, showText: false),
                const AppLogo(size: 128, showText: false),
              ],
            ),

            const SizedBox(height: 48),

            const Text(
              'On Different Backgrounds',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Different backgrounds
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconWithBackground(Colors.white),
                _buildIconWithBackground(Colors.grey.shade200),
                _buildIconWithBackground(Colors.black),
              ],
            ),

            const SizedBox(height: 48),

            ElevatedButton.icon(
              onPressed: () {
                // Show a dialog with information about the app icon
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('About the App Icon'),
                        content: const SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'The EmoSense AI app icon represents the core functionality of emotion detection in customer service interactions.',
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Design Elements:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '• Purple-blue gradient background representing calmness and trust',
                              ),
                              Text(
                                '• Speech bubble with headset symbolizing customer service',
                              ),
                              Text(
                                '• Three emoji faces showing different emotional states (sad, neutral, happy)',
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                );
              },
              icon: const Icon(Icons.info_outline),
              label: const Text('About the App Icon'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconWithBackground(Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const AppLogo(size: 80, showText: false),
    );
  }
}
