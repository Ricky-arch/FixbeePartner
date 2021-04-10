import 'dart:async';

import 'package:flutter/material.dart';

class PaginatedListViewController<T> {
  final Future<List<T>> Function(int skip) pageFetchFuture;
  final int limit; //page size
  int _skip = 0;
  StreamController<List<T>> _streamController;
  ScrollController _scrollController;
  bool _dontAddToStream = false;
  bool _noMorePages = false;

  void Function(T listItem) removeListItem;
  void Function() refreshList;

  PaginatedListViewController(this.pageFetchFuture, this.limit)
      : _scrollController = ScrollController(),
        _streamController = StreamController<List<T>>() {
    _scrollController.addListener(_onScroll);
    _tryFetchPageAndAddToStream();
  }

  Stream<List<T>> get pageStream => _streamController.stream;

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _tryFetchPageAndAddToStream();
    }
  }

  void _tryFetchPageAndAddToStream() async {
    if (!_noMorePages && !_dontAddToStream) {
      _dontAddToStream = true;
      try {
        List<T> newPage = await pageFetchFuture(_skip);
        _noMorePages = newPage.isEmpty;
        _streamController.add(newPage);
        _skip += limit;
      } catch (e) {
        if (_streamController != null && !_streamController.isClosed)
          _streamController.addError(e.toString());
      } finally {
        _dontAddToStream = false;
      }
    }
  }

  void dispose() {
    removeListItem = null;
    refreshList = null;
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _streamController.close();
    _streamController = _scrollController = null;
  }

  void _reset() {
    _skip = 0;
  }
}

class PaginatedListView<T> extends StatefulWidget {
  final PaginatedListViewController<T> controller;
  final Widget Function(BuildContext context, int index, T listItemModel)
      listItemBuilder;
  final Widget loaderWidget;
  final Widget endOfPagesMarkerWidget;
  final Widget placeHolderWidget;
  final Widget nextPageErrorWidget;
  final Widget separator;
  final Widget emptyListWidget;
  final Widget firstPageErrorWidget;

  const PaginatedListView({
    Key key,
    @required this.controller,
    @required this.listItemBuilder,
    @required this.loaderWidget,
    this.endOfPagesMarkerWidget,
    this.placeHolderWidget,
    @required this.nextPageErrorWidget,
    this.separator,
    @required this.emptyListWidget,
    @required this.firstPageErrorWidget,
  }) : super(key: key);
  @override
  _PaginatedListViewState<T> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  List<T> _cache = [];
  bool _firstPageNotYetLoaded = true;
  bool _errorLoadingNextPage = false;
  bool _errorLoadingFirstPage;

  void _setErrorLoadingFirstPage(bool errorLoadingFirstPage) {
    if (_errorLoadingFirstPage == null)
      _errorLoadingFirstPage = errorLoadingFirstPage;
  }

  @override
  void initState() {
    widget.controller.removeListItem =
        (T item) => setState(() => _cache.remove(item));
    widget.controller.refreshList = () => setState(() {
          _cache.clear();
          widget.controller._reset();
          widget.controller._tryFetchPageAndAddToStream();
        });
    widget.controller.pageStream
        .listen(_onNewPageLoaded, onError: _onErrorLoadingNewPage);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return _firstPageNotYetLoaded
        ? (_errorLoadingFirstPage ?? false)
            ? widget.firstPageErrorWidget
            : Center(
                child: widget.placeHolderWidget ?? CircularProgressIndicator())
        : _cache.isEmpty
            ? widget.emptyListWidget
            : ListView.separated(
                controller: widget.controller._scrollController,
                itemCount: _cache.length + 1,
                itemBuilder: _listItemBuilder,
                separatorBuilder: (ctx, pos) => widget.separator ?? SizedBox(),
              );
  }

  Widget _listItemBuilder(BuildContext ctx, int index) {
    if (index == _cache.length) {
      if (widget.controller._noMorePages) {
        return widget.endOfPagesMarkerWidget ?? SizedBox();
      } else if (_errorLoadingNextPage) {
        return GestureDetector(
          child: widget.nextPageErrorWidget,
          onTap: _onTapErrorMarker,
        );
      } else if (_cache.length < widget.controller.limit) {
        return SizedBox();
      } else {
        return widget.loaderWidget;
      }
    } else {
      return widget.listItemBuilder(ctx, index, _cache[index]);
    }
  }

  void _onNewPageLoaded(List<T> newPage) => setState(() {
        _setErrorLoadingFirstPage(false);
        if (_firstPageNotYetLoaded) _firstPageNotYetLoaded = false;
        _cache.addAll(newPage);
      });

  void _onErrorLoadingNewPage(e) => setState(() {
        _setErrorLoadingFirstPage(true);
        return _errorLoadingNextPage = true;
      });

  void _onTapErrorMarker() {
    setState(() {
      return _errorLoadingNextPage = false;
    });
    widget.controller._tryFetchPageAndAddToStream();
  }
}
