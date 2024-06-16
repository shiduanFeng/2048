import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_model.dart';

void main() {
  runApp(MyApp()); // 运行应用
}

class MyApp extends StatelessWidget { // 应用的主体
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( // 使用ChangeNotifierProvider来提供GameModel
      create: (context) => GameModel(), // 创建GameModel实例
      child: MaterialApp(
        title: '2048', // 应用的标题
        theme: ThemeData(
          primarySwatch: Colors.blue, // 应用的主题颜色
        ),
        home: GamePage(), // 应用的主页
      ),
    );
  }
}

class GamePage extends StatelessWidget { // 游戏页面
  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameModel>(context); // 获取GameModel实例

    return Scaffold(
      appBar: AppBar(
        title: Text('2048'), // 页面标题
      ),
      body: LayoutBuilder( // 使用LayoutBuilder来获取父控件的大小
        builder: (context, constraints) {
          double gridSize = constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth * 0.8
              : constraints.maxHeight * 0.8; // 计算网格大小

          return Center( // 将内容居中显示
            child: GestureDetector( // 使用手势检测器来处理滑动事件
              onVerticalDragEnd: (details) { // 处理垂直滑动事件
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! < 0) {
                    game.moveUp(); // 向上滑动
                  } else if (details.primaryVelocity! > 0) {
                    game.moveDown(); // 向下滑动
                  }
                }
              },
              onHorizontalDragEnd: (details) { // 处理水平滑动事件
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! < 0) {
                    game.moveLeft(); // 向左滑动
                  } else if (details.primaryVelocity! > 0) {
                    game.moveRight(); // 向右滑动
                  }
                }
              },
              child: AspectRatio( // 保持1:1的宽高比
                aspectRatio: 1,
                child: Container(
                  width: gridSize,
                  height: gridSize,
                  child: GridView.builder( // 使用GridView.builder来创建网格
                    padding: EdgeInsets.all(16), // 设置网格的内边距
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: game.gridSize, // 设置网格的列数
                      crossAxisSpacing: 8, // 设置网格的列间距
                      mainAxisSpacing: 8, // 设置网格的行间距
                    ),
                    itemCount: game.gridSize * game.gridSize, // 设置网格的总数
                    itemBuilder: (context, index) { // 使用builder来创建每个网格
                      int value = game.grid[index ~/ game.gridSize][index % game.gridSize]; // 获取当前网格的值
                      return Container(
                        decoration: BoxDecoration(
                          color: value == 0 ? Colors.grey[300] : Colors.orange[100 * (value % 10)], // 设置网格的颜色
                          borderRadius: BorderRadius.circular(8), // 设置网格的圆角
                        ),
                        child: Center(
                          child: Text(
                            value == 0 ? '' : value.toString(), // 显示网格的值
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}