import 'package:fixbee_partner/bloc.dart';
import 'package:fixbee_partner/events/event.dart';
import 'package:fixbee_partner/models/view_model.dart';
import 'package:flutter/material.dart';

class BlocWidget<E extends Event, M extends ViewModel> extends StatelessWidget {
  final Bloc<E, M> bloc;
  final Widget Function(BuildContext context, M viewModel) onViewModelUpdated;

  BlocWidget({
    @required this.bloc,
    @required this.onViewModelUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<M>(
      stream: bloc.viewModelStream,
      initialData: bloc.latestViewModel,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return onViewModelUpdated(context, snapshot.data);
      },
    );
  }
}
