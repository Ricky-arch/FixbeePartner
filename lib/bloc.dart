import 'dart:async';
import 'package:fixbee_partner/ui/custom_widget/bloc_widget.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'blocs/flavours.dart';
import 'events/event.dart';
import 'models/view_model.dart';

abstract class Bloc<E extends Event, M extends ViewModel> {
  StreamController<M> _modelStreamController;
  StreamController<E> _eventStreamController;
  Function(E event, M viewModel) _onHandled;
  Function(E event, M viewModel, String errorMessage) _onError;
  Map<String, dynamic> _message;

  Stream<M> viewModelStream;
  M latestViewModel;

  Future<M> mapEventToViewModel(E event, Map<String, dynamic> message);

  Bloc(M genesisViewModel) {
    latestViewModel = genesisViewModel;
    _modelStreamController = StreamController();
    _eventStreamController = StreamController();
    viewModelStream = _modelStreamController.stream;
    _eventStreamController.stream.listen(_eventHandler);
  }

  _secondaryStreamListener(FetchResult fetchResult) {
    Map map = fetchResult.data as Map;
    print('subscription : $map');
    latestViewModel = (this as SecondaryStreamable).mapSubResultToModel(map);
    pushViewModel(latestViewModel);
  }


  BlocWidget<E, M> widget(
      {@required
          Widget Function(BuildContext context, M viewModel)
              onViewModelUpdated}) {
    return BlocWidget<E, M>(
      bloc: this,
      onViewModelUpdated: onViewModelUpdated,
    );
  }

  void _eventHandler(E event) async {
    try {
      latestViewModel = await mapEventToViewModel(event, _message);

      if (this is Trackable<E, M>) {
        latestViewModel =
            (this as Trackable<E, M>).setTrackingFlag(event, false, _message);
      }
      pushViewModel(latestViewModel);
      if (_onHandled != null) _onHandled(event, latestViewModel);
    } on Exception catch (e) {
      if (this is Trackable<E, M>) {
        latestViewModel =
            (this as Trackable<E, M>).setTrackingFlag(event, false, _message);
      }
      pushViewModel(latestViewModel);

      if (_onError != null)
        _onError(
          event,
          latestViewModel,
          e.toString(),
        );
    }
  }

  void pushViewModel(M viewModel) {
    if(!_modelStreamController.isClosed)
    _modelStreamController.sink.add(viewModel);
  }

//  void unSubscribe() async {
//    await _secondarySubscription.cancel();
//  }

  void fire(
    E event, {
    Map<String, dynamic> message,
    bool retainOldViewModel,
    Function(E event, M viewModel) onFired,
    Function(E event, M viewModel) onHandled,
    Function(E event, M viewModel, String errorMessage) onError,
  }) {
    if (this is Trackable<E, M>) {
      latestViewModel =
          (this as Trackable<E, M>).setTrackingFlag(event, true, message);
      pushViewModel(latestViewModel);
    }
    if (onFired != null) onFired(event, latestViewModel);
    _message = message;
    _onHandled = onHandled;
    _onError = onError;
    if(!_eventStreamController.isClosed)
    _eventStreamController.sink.add(event);
  }

  void extinguish() {

    if (this is SecondaryStreamable) {
      (this as SecondaryStreamable).onExtinguish();
    }
    _modelStreamController?.close();
    _eventStreamController?.close();
  }
}

class ConflictResolver<M extends ViewModel> {
  Future<M> Function() primarySource;
  Future<M> Function(String errorMessage) fallback;
  ConflictResolver({@required this.primarySource, this.fallback});
  Future<M> supply() async {
    try {
      return await primarySource();
    } on Exception catch (e) {
      if (fallback != null)
        return await fallback(e.toString());
      else
        throw Exception('Could not supply data');
    }
  }
}
