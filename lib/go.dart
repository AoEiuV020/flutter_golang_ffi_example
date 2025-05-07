
import 'dart:js';
import 'package:js/js.dart';

@JS()
@staticInterop
class JSWindow {}

extension JSWindowExtension on JSWindow {
  external String Function(String input) get evalCommand;
  external int sum(int a, int b);
}

@JS()
class Go {
  external Go();
  external dynamic run(instance);
  external JsObject importObject();
}