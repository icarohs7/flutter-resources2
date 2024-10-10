import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pipe', () {
    f1(int n) => n * 2;
    f2(int n) => n * 3;
    expect(f1.pipe(f2).invoke(10), 60);

    f3(String s) => '$s is already';
    f4(String s) => '$s dead';
    expect(f3.pipe(f4).invoke('The detective'), 'The detective is already dead');

    f5(String s) => '$s counts the first';
    f6(String s) => '$s, counts the second';
    f7(String s) => '$s, and finally counts the third';
    expect(
      f5.pipe(f6).pipe(f7)('He'),
      'He counts the first, counts the second, and finally counts the third',
    );
  });
}
