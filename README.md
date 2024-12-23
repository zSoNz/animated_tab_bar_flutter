# Animated TabBar

## Description

**AnimatedTabBar** is a customizable widget that allows you to implement an interactive Bottom Bar in your application, playing an animation when the user clicks on any of the Bottom Bar tabs.

## Usage example

https://github.com/user-attachments/assets/d547d6c9-f3a3-41e2-8d78-ba1eccb5c02c

```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

/// This is an example implementation of a class that uses AnimatedTabBar. You can use a different implementation.

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Favorites Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Chat Page', style: TextStyle(fontSize: 24))),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AnimatedTabBar(
        icons: const [
          Icon(Icons.home, size: 30),
          Icon(Icons.favorite, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.person, size: 30),
          Icon(Icons.chat, size: 30),
        ],
        labels: const ['Home', 'Favorites', 'Search', 'Profile', 'Chat'],
        onItemTapped: _onTabSelected,
      ),
    );
  }
}
```

This example demonstrates how to implement the bottom TabBar shown above. The **AnimatedTabBar** widget has the following optional and required parameters:

- `icons` is a required parameter in which an array of **Icon** widgets is passed.
- `labels` is a required parameter in which an array of **String** labels is passed.  
  **IMPORTANT!** The size of the icon and string arrays must match!
- `onItemTapped` is a required parameter, it is a callback that takes as an argument the **int** index number of the selected tab.

Tle following are optional parameters:

- `bottomBarColor` is a color of the TabBar that has **Color** type.
- `selectedColor` is a color for the icon and label of the selected tab. This parameter has **Color** type.
- `unselectedColor` is a color for the icon and label of the unselected tabs. This parameter has **Color** type.
- `duration` is a parameter that determines the duration of the **half-period** of the animation (i.e., the time the "wave" rises or the time the "wave" falls). This parameter has **double** type.  
  The default value is `1.0`. It is recommended to use values greater than `0.0` and less than `2.0`, but you are free to choose a higher value.
