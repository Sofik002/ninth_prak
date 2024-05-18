import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
    primaryColor: Colors.amber,
  ),
  home: const MyApp(),
));

class UserInheritedWidget extends InheritedWidget {
  final Widget child;
  final String email;
  final String avatarAsset;
  final Function updateAvatar;

  const UserInheritedWidget({
    Key? key,
    required this.child,
    required this.email,
    required this.avatarAsset,
    required this.updateAvatar,
  }) : super(key: key, child: child);

  static UserInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserInheritedWidget>();
  }

  @override
  bool updateShouldNotify(UserInheritedWidget oldWidget) {
    return avatarAsset != oldWidget.avatarAsset || email != oldWidget.email;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String avatarAsset = 'assets/kot.jpg';
  String email = 'lublupoest@mail.ru';

  void updateAvatar(String newAvatar) {
    setState(() {
      avatarAsset = newAvatar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserInheritedWidget(
      email: email,
      avatarAsset: avatarAsset,
      updateAvatar: updateAvatar,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("9 практическая работа"),
          centerTitle: true,
          backgroundColor: Colors.pinkAccent,
        ),
        body: SafeArea(
          child: UserProfilePage(),
        ),
      ),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userInherited = UserInheritedWidget.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body:  SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children:[
                Padding(padding: EdgeInsets.only(top: 40),),
                Text('София', style: TextStyle(
                    fontSize: 24,
                    color: Colors.black
                ),),
                Padding(padding: EdgeInsets.only(top: 20),),
                GestureDetector(
                  onTap: () {
                    // Тут можно вызывать функцию для изменения аватара
                    userInherited.updateAvatar('assets/new_avatar.jpg');
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage(userInherited.avatarAsset),
                    radius: 100,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20),),
                Row(
                  children: [
                    Icon(Icons.mail_outline,size: 24),
                    Padding(padding: EdgeInsets.only(left: 10),),
                    Text(userInherited.email, style: const TextStyle(fontSize: 24))
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 10),),
                ElevatedButton(child: const Text("Перейти в профиль"),onPressed: (){Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> const Account()));},),
              ],
            )
          ],
        ),
      ),
    );
  }
}


final getIt = GetIt.instance.registerSingleton(Students());

class Students {
  String message = "УПС, при загрузке страницы возникла ошибка";
}

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    String message1 = getIt.message;// Получите сообщение из GetIt

    return Scaffold(
      appBar: AppBar(
        title: const Text('Аккаунт'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 40)),
                Text(message1, style: TextStyle(fontSize: 24, color: Colors.pinkAccent)), // Используйте полученное сообщение
                Padding(padding: EdgeInsets.only(top: 20)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Вернутся на главный экран'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
