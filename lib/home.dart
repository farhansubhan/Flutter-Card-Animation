import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      backgroundColor: Colors.green.shade100,
      body: AnimatedCard(
        scrollController: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              for (int i = 0; i < MediaQuery.of(context).size.height * 2 / 100; i++)
                Container(
                  color: Colors.white,
                  height: 100,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;

  const AnimatedCard({
    super.key,
    required this.child,
    required this.scrollController,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> with SingleTickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
    value: 1,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceOut,
    reverseCurve: Curves.ease,
  );

  bool _isInfoBarExpanded = true;

  List<Map<String, dynamic>> listIcon = [
    {
      "nama": "Transfer",
      "icon": "assets/image1.svg"
    },
    {
      "nama": "QR Code",
      "icon": "assets/image2.svg"
    },
    {
      "nama": "Riwayat",
      "icon": "assets/image3.svg"
    }
  ];

  @override
  initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (widget.scrollController.offset == 0 && !_isInfoBarExpanded) {
      _controller.duration = const Duration(milliseconds: 500);
      _controller.forward();
      _isInfoBarExpanded = true;
    } else if (_isInfoBarExpanded && _controller.status == AnimationStatus.completed) {
      _controller.duration = const Duration(milliseconds: 250);
      _controller.reverse();
      _isInfoBarExpanded = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: 0.5 + (_animation.value / 2),
                  child: child,
                ),
              ),
            );
          },
          child: Container(
            height: 150.0,
            color: Colors.green,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Saldo Anda',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Rp 10.000.000',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      3, (index) => Column(
                        children: [
                          SvgPicture.asset(
                            "${listIcon[index]["icon"]}"
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${listIcon[index]["nama"]}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 20,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
        ),
        Expanded(
          child: widget.child,
        ),
      ],
    );
  }
}