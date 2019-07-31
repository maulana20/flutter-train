import 'dart:convert';

import 'package:flutter/material.dart';

import 'screen/train_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Flutter Train',
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			home: TrainScreen(),
		);
	}
}
