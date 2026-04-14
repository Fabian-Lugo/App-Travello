import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travell_app/router/app_routes.dart';
import 'package:travell_app/widgets/slide_item.dart';
import 'package:travell_app/widgets/slide_dot.dart';
import 'package:travell_app/theme/app_colors.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  /// Lista constante con la información de cada pantalla del tutorial
  final List<Map<String, String>> slideList = const [
    {
      'title': 'Explora el mundo fácilmente',
      'subtitle': 'A tu deseo',
      'image': 'assets/slide_image_1.png'
    },
    {
      'title': 'Llegar al lugar desconocido',
      'subtitle': 'A tu destino',
      'image': 'assets/slide_image_2.png'
    },
    {
      'title': 'Establece conexiones con Travello',
      'subtitle': 'A tu viaje soñado',
      'image': 'assets/slide_image_3.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _SliderPageView(
            pageController: _pageController,
            slideList: slideList,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          Positioned(
            bottom: 50,
            left: 30,
            right: 30,
            child: _SliderControls(
              slideLength: slideList.length,
              currentPage: _currentPage,
              onNext: () {
                if (_currentPage < slideList.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  context.go(AppRoutes.login);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget privado que encapsula el PageView con las tarjetas informativas
class _SliderPageView extends StatelessWidget {
  final PageController pageController;
  final List<Map<String, String>> slideList;
  final ValueChanged<int> onPageChanged;

  const _SliderPageView({
    required this.pageController,
    required this.slideList,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      itemCount: slideList.length,
      itemBuilder: (context, i) {
        return SlideItem(
          title: slideList[i]['title'] ?? '',
          subtitle: slideList[i]['subtitle'] ?? '',
          image: slideList[i]['image'] ?? '',
        );
      },
    );
  }
}

/// Widget privado que agrupa los indicadores (puntos) y el botón de siguiente
class _SliderControls extends StatelessWidget {
  final int slideLength;
  final int currentPage;
  final VoidCallback onNext;

  const _SliderControls({
    required this.slideLength,
    required this.currentPage,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: List.generate(
            slideLength,
            (index) => SlideDot(
              isActive: currentPage == index,
            ),
          ),
        ),
        GestureDetector(
          onTap: onNext,
          child: Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.quaternary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}