import 'package:flutter/material.dart';
import 'package:learnflutter/ui/common/page_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      desktopChild: _DesktopHomePage(),
      mobileChild: _MobileHomePage(),
    );
  }
}

class _DesktopHomePage extends StatelessWidget {
  const _DesktopHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'images/logo.png',
          width: 800,
          fit: BoxFit.fitWidth,
        ),
        const Positioned(
            bottom: 15.0,
            child: Text(
              '欢迎使用IPLT系统，XX',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            )
        )
      ],
    );
  }
}

class _MobileHomePage extends StatelessWidget {
  const _MobileHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'images/logo.png',
      ),
    );
  }
}

