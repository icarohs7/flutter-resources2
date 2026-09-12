import 'package:reactor_fp_resources/reactor_fp_resources.dart';

/// Tracks page, loading, and continuation state for paged lists.
class NPagingController() {
  /// The page currently being displayed.
  final currentPage = 1.rc;

  /// Whether another page may be requested.
  final hasMorePages = true.rc;

  /// Whether the next page request is in progress.
  final waitingNextPage = false.rc;

  /// Restores the controller to its initial state.
  void reset() {
    currentPage.value = 1;
    hasMorePages.value = true;
    waitingNextPage.value = false;
  }

  /// Advances the page when more pages are available and returns its value.
  int advancePage() {
    if (hasMorePages.value) currentPage.value++;
    return currentPage.value;
  }

  /// Sets whether the next page request is in progress.
  void setWaitingNextPage(bool waitingNextPage) {
    this.waitingNextPage.value = waitingNextPage;
  }

  /// Sets whether another page may be requested.
  void toggleMorePages(bool hasMorePages) {
    this.hasMorePages.value = hasMorePages;
  }

  /// Prevents further page advances until the controller is reset.
  void disableMorePages() {
    hasMorePages.value = false;
  }
}
