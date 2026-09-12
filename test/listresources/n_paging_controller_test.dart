import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tracks paging state and resets it', () {
    final controller = NPagingController();

    expect(controller.currentPage.value, 1);
    expect(controller.hasMorePages.value, isTrue);
    expect(controller.waitingNextPage.value, isFalse);
    expect(controller.advancePage(), 2);

    controller.setWaitingNextPage(true);
    controller.disableMorePages();
    expect(controller.waitingNextPage.value, isTrue);
    expect(controller.hasMorePages.value, isFalse);
    expect(controller.advancePage(), 2);

    controller.toggleMorePages(true);
    expect(controller.advancePage(), 3);

    controller.reset();
    expect(controller.currentPage.value, 1);
    expect(controller.hasMorePages.value, isTrue);
    expect(controller.waitingNextPage.value, isFalse);
  });
}
