import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ArcadeX());
}

class ArcadeX extends StatelessWidget {
  const ArcadeX({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArcadeX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090A10),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C4DFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ArcadeHome(),
    );
  }
}

class ArcadeHome extends StatefulWidget {
  const ArcadeHome({super.key});

  @override
  State<ArcadeHome> createState() => _ArcadeHomeState();
}

class _ArcadeHomeState extends State<ArcadeHome> {
  Map<String, int> scores = {};

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      scores = {
        'snake': prefs.getInt('score_snake') ?? 0,
        '2048': prefs.getInt('score_2048') ?? 0,
        'ttt': prefs.getInt('score_ttt') ?? 0,
      };
    });
  }

  Future<void> _open(Widget page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
    _loadScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ARCADEX',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'YOUR OFFLINE POCKET ARCADE',
                      style: TextStyle(
                        color: Colors.white.withOpacity(alpha: .55),
                        letterSpacing: 1.5,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 26),
                    _ArcadeBanner(
                      games: 3,
                      best: scores.values.isEmpty
                          ? 0
                          : scores.values.reduce(max),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'GAMES',
                      style: TextStyle(
                        color: Colors.white.withOpacity(alpha: .65),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _GameCard(
                    icon: '🐍',
                    title: 'SNAKE',
                    subtitle: 'Eat. Grow. Survive.',
                    score: scores['snake'] ?? 0,
                    accent: const Color(0xFF00E676),
                    onTap: () => _open(const SnakeGame()),
                  ),
                  const SizedBox(height: 14),
                  _GameCard(
                    icon: '🔢',
                    title: '2048',
                    subtitle: 'Merge tiles. Reach 2048.',
                    score: scores['2048'] ?? 0,
                    accent: const Color(0xFFFFB300),
                    onTap: () => _open(const Game2048()),
                  ),
                  const SizedBox(height: 14),
                  _GameCard(
                    icon: '❌',
                    title: 'TIC-TAC-TOE',
                    subtitle: 'Classic. Offline. No mercy.',
                    score: scores['ttt'] ?? 0,
                    accent: const Color(0xFF40C4FF),
                    onTap: () => _open(const TicTacToe()),
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: Text(
                      '100% OFFLINE • ARCADEX V1.0',
                      style: TextStyle(
                        color: Colors.white.withOpacity(alpha: .3),
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcadeBanner extends StatelessWidget {
  final int games;
  final int best;

  const _ArcadeBanner({required this.games, required this.best});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF21164D), Color(0xFF111827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(alpha: .08)),
      ),
      child: Row(
        children: [
          const Text('🎮', style: TextStyle(fontSize: 42)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$games GAMES READY',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Best score: $best',
                  style: TextStyle(color: Colors.white.withOpacity(alpha: .55)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final int score;
  final Color accent;
  final VoidCallback onTap;

  const _GameCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.score,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF11131C),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(alpha: .07)),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withOpacity(alpha: .10),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(icon, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(alpha: .5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'BEST',
                  style: TextStyle(
                    color: Colors.white.withOpacity(alpha: .35),
                    fontSize: 9,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  '$score',
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
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

// -----------------------------------------------------------------------------
// SNAKE
// -----------------------------------------------------------------------------

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  static const int size = 20;
  final Random random = Random();

  List<Point<int>> snake = [];
  Point<int> food = const Point(10, 10);
  Direction direction = Direction.right;
  Direction queuedDirection = Direction.right;
  Timer? timer;
  int score = 0;
  bool running = false;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    timer?.cancel();
    snake = [
      const Point(10, 10),
      const Point(9, 10),
      const Point(8, 10),
    ];
    direction = Direction.right;
    queuedDirection = Direction.right;
    score = 0;
    running = false;
    gameOver = false;
    _spawnFood();
    setState(() {});
  }

  void _start() {
    if (running) return;
    setState(() {
      running = true;
      gameOver = false;
    });
    timer = Timer.periodic(const Duration(milliseconds: 130), (_) => _tick());
  }

  void _tick() {
    if (!running) return;

    direction = queuedDirection;
    final head = snake.first;
    Point<int> next;

    switch (direction) {
      case Direction.up:
        next = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        next = Point(head.x, head.y + 1);
        break;
      case Direction.left:
        next = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        next = Point(head.x + 1, head.y);
        break;
    }

    if (next.x < 0 ||
        next.x >= size ||
        next.y < 0 ||
        next.y >= size ||
        snake.contains(next)) {
      _endGame();
      return;
    }

    final ate = next == food;
    final updated = [next, ...snake];
    if (!ate) updated.removeLast();

    setState(() {
      snake = updated;
      if (ate) {
        score += 10;
        _spawnFood();
      }
    });
  }

  void _spawnFood() {
    do {
      food = Point(random.nextInt(size), random.nextInt(size));
    } while (snake.contains(food));
  }

  Future<void> _endGame() async {
    timer?.cancel();
    running = false;
    gameOver = true;

    final prefs = await SharedPreferences.getInstance();
    final old = prefs.getInt('score_snake') ?? 0;
    if (score > old) await prefs.setInt('score_snake', score);

    if (mounted) setState(() {});
  }

  void _changeDirection(Direction next) {
    final opposite = {
      Direction.up: Direction.down,
      Direction.down: Direction.up,
      Direction.left: Direction.right,
      Direction.right: Direction.left,
    };
    if (opposite[direction] != next) queuedDirection = next;
    if (!running && !gameOver) _start();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🐍 SNAKE')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SCORE  $score',
                    style: const TextStyle(fontWeight: FontWeight.w900)),
                if (gameOver)
                  TextButton(onPressed: _reset, child: const Text('RESTART')),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: GestureDetector(
                onVerticalDragEnd: (d) {
                  if ((d.primaryVelocity ?? 0) < 0) {
                    _changeDirection(Direction.up);
                  } else {
                    _changeDirection(Direction.down);
                  }
                },
                onHorizontalDragEnd: (d) {
                  if ((d.primaryVelocity ?? 0) < 0) {
                    _changeDirection(Direction.left);
                  } else {
                    _changeDirection(Direction.right);
                  }
                },
                child: CustomPaint(
                  painter: SnakePainter(snake: snake, food: food, size: size),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          if (!running && !gameOver)
            FilledButton.icon(
              onPressed: _start,
              icon: const Icon(Icons.play_arrow),
              label: const Text('START GAME'),
            ),
          if (gameOver)
            Text(
              'GAME OVER — $score POINTS',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          const SizedBox(height: 12),
          Text(
            'SWIPE TO MOVE',
            style: TextStyle(
              color: Colors.white.withOpacity(alpha: .35),
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

enum Direction { up, down, left, right }

class SnakePainter extends CustomPainter {
  final List<Point<int>> snake;
  final Point<int> food;
  final int size;

  SnakePainter({
    required this.snake,
    required this.food,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final cell = canvasSize.width / size;
    final bg = Paint()..color = const Color(0xFF11131C);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & canvasSize,
        const Radius.circular(20),
      ),
      bg,
    );

    final grid = Paint()
      ..color = Colors.white.withOpacity(alpha: .035)
      ..strokeWidth = 1;

    for (var i = 1; i < size; i++) {
      canvas.drawLine(
        Offset(i * cell, 0),
        Offset(i * cell, canvasSize.height),
        grid,
      );
      canvas.drawLine(
        Offset(0, i * cell),
        Offset(canvasSize.width, i * cell),
        grid,
      );
    }

    final foodPaint = Paint()..color = const Color(0xFFFF5252);
    canvas.drawCircle(
      Offset((food.x + .5) * cell, (food.y + .5) * cell),
      cell * .32,
      foodPaint,
    );

    for (var i = 0; i < snake.length; i++) {
      final p = snake[i];
      final rect = Rect.fromLTWH(
        p.x * cell + 2,
        p.y * cell + 2,
        cell - 4,
        cell - 4,
      );
      final paint = Paint()
        ..color = i == 0
            ? const Color(0xFF69F0AE)
            : const Color(0xFF00C853);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(5)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SnakePainter oldDelegate) => true;
}

// -----------------------------------------------------------------------------
// 2048
// -----------------------------------------------------------------------------

class Game2048 extends StatefulWidget {
  const Game2048({super.key});

  @override
  State<Game2048> createState() => _Game2048State();
}

class _Game2048State extends State<Game2048> {
  final Random random = Random();
  List<int> board = List.filled(16, 0);
  int score = 0;
  bool won = false;
  bool over = false;

  @override
  void initState() {
    super.initState();
    _newGame();
  }

  void _newGame() {
    board = List.filled(16, 0);
    score = 0;
    won = false;
    over = false;
    _addTile();
    _addTile();
    setState(() {});
  }

  void _addTile() {
    final empty = <int>[];
    for (var i = 0; i < 16; i++) {
      if (board[i] == 0) empty.add(i);
    }
    if (empty.isEmpty) return;
    board[empty[random.nextInt(empty.length)]] =
        random.nextDouble() < .9 ? 2 : 4;
  }

  List<int> _mergeLine(List<int> line) {
    final values = line.where((v) => v != 0).toList();
    final result = <int>[];
    var i = 0;
    while (i < values.length) {
      if (i + 1 < values.length && values[i] == values[i + 1]) {
        final merged = values[i] * 2;
        result.add(merged);
        score += merged;
        i += 2;
      } else {
        result.add(values[i]);
        i++;
      }
    }
    while (result.length < 4) result.add(0);
    return result;
  }

  void _move(Direction direction) {
    final before = List<int>.from(board);

    if (direction == Direction.left || direction == Direction.right) {
      for (var r = 0; r < 4; r++) {
        var line = List.generate(4, (c) => board[r * 4 + c]);
        if (direction == Direction.right) line = line.reversed.toList();
        line = _mergeLine(line);
        if (direction == Direction.right) line = line.reversed.toList();
        for (var c = 0; c < 4; c++) board[r * 4 + c] = line[c];
      }
    } else {
      for (var c = 0; c < 4; c++) {
        var line = List.generate(4, (r) => board[r * 4 + c]);
        if (direction == Direction.down) line = line.reversed.toList();
        line = _mergeLine(line);
        if (direction == Direction.down) line = line.reversed.toList();
        for (var r = 0; r < 4; r++) board[r * 4 + c] = line[r];
      }
    }

    if (!_same(before, board)) {
      _addTile();
      if (board.contains(2048)) won = true;
      over = !_canMove();
      setState(() {});
      _saveBest();
    }
  }

  bool _same(List<int> a, List<int> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool _canMove() {
    if (board.contains(0)) return true;
    for (var r = 0; r < 4; r++) {
      for (var c = 0; c < 4; c++) {
        final v = board[r * 4 + c];
        if (c < 3 && board[r * 4 + c + 1] == v) return true;
        if (r < 3 && board[(r + 1) * 4 + c] == v) return true;
      }
    }
    return false;
  }

  Future<void> _saveBest() async {
    final prefs = await SharedPreferences.getInstance();
    final old = prefs.getInt('score_2048') ?? 0;
    if (score > old) await prefs.setInt('score_2048', score);
  }

  Color _tileColor(int value) {
    if (value == 0) return const Color(0xFF191B26);
    if (value == 2) return const Color(0xFF3B3F52);
    if (value == 4) return const Color(0xFF4B5067);
    if (value == 8) return const Color(0xFFFF8A65);
    if (value == 16) return const Color(0xFFFF7043);
    if (value == 32) return const Color(0xFFFF5252);
    if (value == 64) return const Color(0xFFE53935);
    if (value == 128) return const Color(0xFFFFCA28);
    if (value == 256) return const Color(0xFFFFB300);
    if (value == 512) return const Color(0xFFFFA000);
    if (value == 1024) return const Color(0xFF7C4DFF);
    return const Color(0xFF651FFF);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔢 2048'),
        actions: [
          IconButton(
            onPressed: _newGame,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: GestureDetector(
        onVerticalDragEnd: (d) {
          if ((d.primaryVelocity ?? 0) < 0) {
            _move(Direction.up);
          } else {
            _move(Direction.down);
          }
        },
        onHorizontalDragEnd: (d) {
          if ((d.primaryVelocity ?? 0) < 0) {
            _move(Direction.left);
          } else {
            _move(Direction.right);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SCORE  $score',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  if (won)
                    const Text(
                      '2048! 🎉',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E1018),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 16,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 7,
                    ),
                    itemBuilder: (_, i) {
                      final value = board[i];
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _tileColor(value),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          value == 0 ? '' : '$value',
                          style: TextStyle(
                            fontSize: value >= 1000 ? 22 : 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                over ? 'GAME OVER' : 'SWIPE TO MOVE',
                style: TextStyle(
                  color: over
                      ? const Color(0xFFFF5252)
                      : Colors.white.withOpacity(alpha: .35),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              if (over)
                FilledButton(
                  onPressed: _newGame,
                  child: const Text('TRY AGAIN'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TIC-TAC-TOE
// -----------------------------------------------------------------------------

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<String> board = List.filled(9, '');
  String current = 'X';
  String status = 'YOUR TURN';
  int xWins = 0;
  int oWins = 0;
  int draws = 0;

  void _reset() {
    setState(() {
      board = List.filled(9, '');
      current = 'X';
      status = 'YOUR TURN';
    });
  }

  void _play(int index) {
    if (board[index].isNotEmpty || status != 'YOUR TURN') return;

    setState(() => board[index] = 'X');

    if (_winner('X')) {
      _finish('X WINS');
      return;
    }
    if (!board.contains('')) {
      _finish('DRAW');
      return;
    }

    setState(() => status = 'CPU THINKING...');
    Future.delayed(const Duration(milliseconds: 350), _cpuMove);
  }

  void _cpuMove() {
    if (!mounted || status != 'CPU THINKING...') return;

    final move = _bestCpuMove();
    setState(() => board[move] = 'O');

    if (_winner('O')) {
      _finish('CPU WINS');
      return;
    }
    if (!board.contains('')) {
      _finish('DRAW');
      return;
    }

    setState(() => status = 'YOUR TURN');
  }

  int _bestCpuMove() {
    final empty = <int>[];
    for (var i = 0; i < 9; i++) {
      if (board[i].isEmpty) empty.add(i);
    }

    // Win if possible.
    for (final i in empty) {
      board[i] = 'O';
      if (_winner('O')) {
        board[i] = '';
        return i;
      }
      board[i] = '';
    }

    // Block the player.
    for (final i in empty) {
      board[i] = 'X';
      if (_winner('X')) {
        board[i] = '';
        return i;
      }
      board[i] = '';
    }

    if (board[4].isEmpty) return 4;

    final corners = [0, 2, 6, 8].where((i) => board[i].isEmpty).toList();
    if (corners.isNotEmpty) {
      return corners[Random().nextInt(corners.length)];
    }

    return empty[Random().nextInt(empty.length)];
  }

  bool _winner(String player) {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    return lines.any((line) => line.every((i) => board[i] == player));
  }

  Future<void> _finish(String result) async {
    setState(() => status = result);

    final prefs = await SharedPreferences.getInstance();

    if (result == 'X WINS') {
      xWins++;
      await prefs.setInt('ttt_x_wins', xWins);
    } else if (result == 'CPU WINS') {
      oWins++;
      await prefs.setInt('ttt_o_wins', oWins);
    } else {
      draws++;
      await prefs.setInt('ttt_draws', draws);
    }

    // ArcadeX score for this game = player wins.
    final old = prefs.getInt('score_ttt') ?? 0;
    if (xWins > old) await prefs.setInt('score_ttt', xWins);
  }

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      xWins = prefs.getInt('ttt_x_wins') ?? 0;
      oWins = prefs.getInt('ttt_o_wins') ?? 0;
      draws = prefs.getInt('ttt_draws') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('❌ TIC-TAC-TOE'),
        actions: [
          IconButton(onPressed: _reset, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Stat(label: 'YOU', value: xWins),
                _Stat(label: 'DRAW', value: draws),
                _Stat(label: 'CPU', value: oWins),
              ],
            ),
            const Spacer(),
            Text(
              status,
              style: TextStyle(
                color: Colors.white.withOpacity(alpha: .55),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 9,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (_, i) {
                  final value = board[i];
                  return InkWell(
                    onTap: () => _play(i),
                    borderRadius: BorderRadius.circular(18),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: const Color(0xFF151823),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.w900,
                            color: value == 'X'
                                ? const Color(0xFF40C4FF)
                                : const Color(0xFFFF5252),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh),
              label: const Text('NEW GAME'),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(alpha: .35),
            fontSize: 10,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
