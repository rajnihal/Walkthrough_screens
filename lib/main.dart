import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WalkthroughScreen(),
    );
  }
}

class WalkthroughScreen extends StatefulWidget {
  const WalkthroughScreen({super.key});

  @override
  _WalkthroughScreenState createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> with SingleTickerProviderStateMixin {
  int currentPageIndex = 0;
  ValueNotifier<double> _opacity = ValueNotifier(1.0);
  bool _isAnimating = false;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      backgroundColor: const Color(0xFF95C5D3),
      image: const AssetImage("assets/img_1.jpg"),
      title: "ONE TAP \nBOOKING",
      description: "Introducing One Tap ticket booking \nfor the first time in India",
    ),
    OnboardingPage(
      backgroundColor: const Color(0xFFD3B197),
      image: const AssetImage("assets/img_2.jpg"),
      title: "Seamless Travel \nExperience",
      description: "Seamless travel experience with \nFirst and Last mile connectivity.",
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onSwipe(bool isNext) async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    _opacity.value = 0.0;

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      if (isNext) {
        currentPageIndex = (currentPageIndex + 1) % pages.length;
      } else {
        currentPageIndex = (currentPageIndex - 1 + pages.length) % pages.length;
      }
    });

    _opacity.value = 1.0;

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx < -10) {
            _onSwipe(true);
          } else if (details.delta.dx > 10) {
            _onSwipe(false);
          }
        },
        child: ValueListenableBuilder<double>(
          valueListenable: _opacity,
          builder: (context, opacity, child) {
            return Container(
              color: pages[currentPageIndex].backgroundColor,
              child: AnimatedOpacity(
                duration: const Duration(seconds: 2),
                opacity: opacity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Image(image: pages[currentPageIndex].image),
                    const SizedBox(height: 20),
                    Text(
                      pages[currentPageIndex].title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      pages[currentPageIndex].description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < pages.length; i++)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                currentPageIndex = i;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentPageIndex == i ? Colors.white : Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (currentPageIndex == pages.length - 1) ...[
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const NextPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                          backgroundColor: Colors.black, // Set button background color to black
                        ),
                        child: const Text(
                          "Let's Get Started",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _opacity.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final Color backgroundColor;
  final AssetImage image;
  final String title;
  final String description;

  OnboardingPage({
    required this.backgroundColor,
    required this.image,
    required this.title,
    required this.description,
  });
}

class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Page'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Next Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
