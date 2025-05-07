import 'go.dart';
import 'dart:html' as html;

JSWindow get jsWindow => html.window as JSWindow;

int sum(int a, int b) => jsWindow.sum(a, b);
