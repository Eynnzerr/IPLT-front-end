import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:learnflutter/data/model/signup_model.dart';
import 'package:learnflutter/routes.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double formWidth;
    if (screenWidth > 600) {
      formWidth = 600;
    }
    else {
      formWidth = 350;
    }

    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/hust.jpg'),
                fit: BoxFit.cover
            )
        ),
        child: Center(
          child: SizedBox(
            width: formWidth,
            child: Card(
              child: SignupForm(),
            ),
          ),
        )
    );
  }
}

class SignupForm extends StatelessWidget {
  SignupForm({Key? key}) : super(key: key);

  final SignupModel model = Get.put(SignupModel());

  void _enterHomePage() async {
    bool isLoggedIn = await model.loginByPassword(model.username.value, model.password.value);
    if (isLoggedIn) {
      // Fluttertoast.showToast(
      //   msg: '登录成功',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM
      // );
      Get.snackbar('Login successfully', 'Welcome to IPLT system!');
      Get.offNamed(Routes.home);
    } else {
      // Fluttertoast.showToast(
      //     msg: '登录失败，请检查密码是否正确与网络是否连接',
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM
      // );
      Get.snackbar('Login failed', 'Please check password and network connection.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Form(
      onChanged: () => model.updateProgress(),
      child: Container(
        // padding: const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 4.0
              )
            ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedProgressIndicator(value: model.formProgress.value,),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                  'Project  IPLT',
                  style: Theme.of(context).textTheme.headline4),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Member ID',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    prefixIcon: Icon(Icons.account_circle)
                ),
                onChanged: (String text) => model.updateUsername(text),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Password',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    prefixIcon: Icon(Icons.remove_red_eye)
                ),
                obscureText: true,
                onChanged: (String text) => model.updatePassword(text),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith(
                              (Set<MaterialState> states) {
                            return states.contains(MaterialState.disabled)
                                ? Colors.black54
                                : Colors.white;
                          }),
                      backgroundColor: MaterialStateProperty.resolveWith(
                              (Set<MaterialState> states) {
                            return states.contains(MaterialState.disabled)
                                ? Colors.blue.shade50
                                : Colors.blue;
                          }),
                    ),
                    onPressed: model.formProgress.value == 1 ? _enterHomePage : null,
                    child: const Text('Sign in'),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                    ),
                    onPressed: null,
                    child: const Text('Register'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  const AnimatedProgressIndicator({super.key,
    required this.value,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  // 混入SingleTickerProviderStateMixin以提供帧计时/触发
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);

    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withOpacity(0.4),
      ),
    );
  }
}