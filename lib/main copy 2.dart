import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameModel(),
      child: MaterialApp(
        title: '2048',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GamePage(),
      ),
    );
  }
}

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('2048'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double gridSize = constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth * 0.8
              : constraints.maxHeight * 0.8;

          return Center(
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! < 0) {
                    game.moveUp();
                  } else if (details.primaryVelocity! > 0) {
                    game.moveDown();
                  }
                }
              },
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! < 0) {
                    game.moveLeft();
                  } else if (details.primaryVelocity! > 0) {
                    game.moveRight();
                  }
                }
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  width: gridSize,
                  height: gridSize,
                  child: GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: game.gridSize,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: game.gridSize * game.gridSize,
                    itemBuilder: (context, index) {
                      int value = game.grid[index ~/ game.gridSize][index % game.gridSize];
                      return Container(
                        decoration: BoxDecoration(
                          color: value == 0 ? Colors.grey[300] : Colors.orange[100 * (value % 10)],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            value == 0 ? '' : value.toString(),
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
