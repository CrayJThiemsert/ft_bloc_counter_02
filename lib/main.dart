import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/**
 * Bloc's folders - 1st idea
 * - event
 * - bloc
 * - ui
 * - observer
 * - theme
 * - util
 */

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

enum CounterEvent { increment, decrement }

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0);

  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
//    throw UnimplementedError();
    switch(event) {
      case CounterEvent.decrement:
        yield state - 1;
        break;
      case CounterEvent.increment:
        yield state + 1;
        break;
      default:
        addError(Exception('unsupported event'));
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    return BlocProvider(
//      create: (_) => ThemeCubit(),
//      child: BlocBuilder<ThemeCubit, ThemeData>(
//        builder: (_, theme) {
//          return MaterialApp(
//            theme: theme,
//            home: BlocProvider(
//              create: (_) => CounterBloc(),
//              child: CounterPage(),
//            ),
//          );
//        },
//      ),
//    );
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            theme: theme,
            title: 'Flutter Bloc Counter',
            home: BlocProvider<CounterBloc>(
              create: (context) => CounterBloc(),
              child: CounterPage(),
            ),
          );
        },
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CounterBloc counterBloc = BlocProvider.of<CounterBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Counter'),),
      body: BlocBuilder<CounterBloc, int>(
        builder: (context, count) {
          return Center(
            child: Text(
              '$count',
              style: Theme.of(context).textTheme.headline1,
            ),
          );
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
//                counterBloc.add(CounterEvent.increment);
                context.bloc<CounterBloc>().add(CounterEvent.increment);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.remove),
              onPressed: () {
//                counterBloc.add(CounterEvent.decrement);
                context.bloc<CounterBloc>().add(CounterEvent.decrement);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: const Icon(Icons.brightness_6),
              onPressed: () => context.bloc<ThemeCubit>().toggleTheme(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              child: const Icon(Icons.error),
              onPressed: () => context.bloc<CounterBloc>().add(null),
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleBlocObserver extends BlocObserver {

  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    print(change);
    super.onChange(cubit, change);
  }
}

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_lightTheme);

  static final _lightTheme = ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.light,
  );

  static final _darkTheme = ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
    ),
    brightness: Brightness.dark,
  );

  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}

