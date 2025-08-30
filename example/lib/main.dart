import 'package:flutter/material.dart';
import 'package:universal_asset/universal_asset.dart';

void main() {
  runApp(const UniversalAssetDemo());
}

class UniversalAssetDemo extends StatelessWidget {
  const UniversalAssetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universal Asset Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AssetGalleryPage(),
    const NetworkAssetsPage(),
    const ConfigurationPage(),
    const ErrorHandlingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universal Asset Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          NavigationDestination(
            icon: Icon(Icons.cloud),
            label: 'Network',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Config',
          ),
          NavigationDestination(
            icon: Icon(Icons.error),
            label: 'Errors',
          ),
        ],
      ),
    );
  }
}

class AssetGalleryPage extends StatelessWidget {
  const AssetGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Local Assets Gallery',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSection('Standard Images', [
            _buildAssetCard(
              'PNG Image',
              'assets/sample.png',
              'A sample PNG image',
            ),
            _buildAssetCard(
              'JPEG Image',
              'assets/photo.jpg',
              'A sample JPEG photo',
            ),
          ]),
          _buildSection('Vector Graphics', [
            _buildAssetCard(
              'SVG Icon',
              'assets/icon.svg',
              'Scalable vector graphic',
            ),
            _buildAssetCard(
              'SVG Logo',
              'assets/logo.svg',
              'Company logo in SVG format',
            ),
          ]),
          _buildSection('Animations', [
            _buildAssetCard(
              'Lottie Animation',
              'assets/loading.json',
              'Lottie animation file',
            ),
            _buildAssetCard(
              'Rive Animation',
              'assets/character.riv',
              'Interactive Rive animation',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> cards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...cards,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAssetCard(String title, String source, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: UniversalAsset(
                source,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    source,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NetworkAssetsPage extends StatelessWidget {
  const NetworkAssetsPage({super.key});

  final List<String> sampleUrls = const [
    'https://picsum.photos/200/200?random=1',
    'https://picsum.photos/200/200?random=2',
    'https://picsum.photos/200/200?random=3',
    'https://picsum.photos/200/200?random=4',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Network Assets',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Images with Caching',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: sampleUrls.length,
            itemBuilder: (context, index) {
              return Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: UniversalAsset(
                    sampleUrls[index],
                    fit: BoxFit.cover,
                    placeholder: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: const Center(
                      child: Icon(
                        Icons.error,
                        size: 48,
                        color: Colors.red,
                      ),
                    ),
                    networkConfig: const NetworkImageConfig(
                      useCache: true,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Without Caching',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sampleUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 16),
                  child: Card(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: UniversalAsset(
                        sampleUrls[index],
                        fit: BoxFit.cover,
                        networkConfig: const NetworkImageConfig(
                          useCache: false,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  double _lottieSpeed = 1.0;
  bool _lottieRepeat = true;
  Color _svgColor = Colors.blue;
  BoxFit _imageFit = BoxFit.contain;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configuration Examples',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildLottieConfig(),
          const SizedBox(height: 24),
          _buildSvgConfig(),
          const SizedBox(height: 24),
          _buildImageConfig(),
        ],
      ),
    );
  }

  Widget _buildLottieConfig() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lottie Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: UniversalAsset(
                    'assets/loading.json',
                    lottieConfig: LottieConfig(
                      speed: _lottieSpeed,
                      repeat: _lottieRepeat,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('Speed: '),
                          Expanded(
                            child: Slider(
                              value: _lottieSpeed,
                              min: 0.1,
                              max: 3.0,
                              divisions: 29,
                              label: _lottieSpeed.toStringAsFixed(1),
                              onChanged: (value) {
                                setState(() {
                                  _lottieSpeed = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SwitchListTile(
                        title: const Text('Repeat'),
                        value: _lottieRepeat,
                        onChanged: (value) {
                          setState(() {
                            _lottieRepeat = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSvgConfig() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SVG Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: UniversalAsset(
                    'assets/icon.svg',
                    svgConfig: SvgConfig(
                      colorOverride: _svgColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      const Text('Color Override:'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          Colors.blue,
                          Colors.red,
                          Colors.green,
                          Colors.orange,
                          Colors.purple,
                        ].map((color) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _svgColor = color;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(20),
                                border: _svgColor == color
                                    ? Border.all(color: Colors.black, width: 2)
                                    : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageConfig() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Image Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: UniversalAsset(
                    'https://picsum.photos/300/200',
                    fit: _imageFit,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('BoxFit:'),
                      const SizedBox(height: 8),
                      DropdownButton<BoxFit>(
                        value: _imageFit,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: BoxFit.contain,
                            child: Text('Contain'),
                          ),
                          DropdownMenuItem(
                            value: BoxFit.cover,
                            child: Text('Cover'),
                          ),
                          DropdownMenuItem(
                            value: BoxFit.fill,
                            child: Text('Fill'),
                          ),
                          DropdownMenuItem(
                            value: BoxFit.fitWidth,
                            child: Text('Fit Width'),
                          ),
                          DropdownMenuItem(
                            value: BoxFit.fitHeight,
                            child: Text('Fit Height'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _imageFit = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorHandlingPage extends StatelessWidget {
  const ErrorHandlingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Error Handling Examples',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildErrorExample(
            'Missing File',
            'assets/nonexistent.png',
            'Shows error when file doesn\'t exist',
          ),
          _buildErrorExample(
            'Unsupported Format',
            'assets/document.pdf',
            'Shows error for unsupported file types',
          ),
          _buildErrorExample(
            'Missing SVG Package',
            'assets/icon.svg',
            'Shows error when flutter_svg is not installed',
          ),
          _buildErrorExample(
            'Missing Lottie Package',
            'assets/animation.json',
            'Shows error when lottie is not installed',
          ),
          _buildErrorExample(
            'Invalid Network URL',
            'https://invalid-url-that-does-not-exist.com/image.jpg',
            'Shows error for invalid network resources',
          ),
          const SizedBox(height: 24),
          const Text(
            'Custom Error Widget',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                    ),
                    child: UniversalAsset(
                      'assets/missing.png',
                      errorWidget: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning,
                              color: Colors.orange,
                              size: 32,
                            ),
                            Text(
                              'Custom\nError',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Custom Error Widget',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'You can provide your own error widget for better UX',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorExample(String title, String source, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: UniversalAsset(
                source,
                width: 80,
                height: 80,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    source,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
