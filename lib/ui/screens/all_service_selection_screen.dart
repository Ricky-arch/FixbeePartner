import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixbee_partner/blocs/all_service_bloc.dart';
import 'package:fixbee_partner/data_store.dart';
import 'package:fixbee_partner/events/all_services_event.dart';
import 'package:fixbee_partner/models/all_Service.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
import 'package:fixbee_partner/utils/colors.dart';
import 'package:fixbee_partner/utils/excerpt.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';
import 'child_service.dart';
import 'home.dart';
import 'navigation_screen.dart';

class AllServiceSelection extends StatefulWidget {
  // if mySelectedOrderId is null redirect to Navigation else redirect to parent route
  final List<String> mySelectOrderId;

  const AllServiceSelection({Key key, this.mySelectOrderId}) : super(key: key);

  @override
  _AllServiceSelectionState createState() => _AllServiceSelectionState();
}

class _AllServiceSelectionState extends State<AllServiceSelection> {
  AllServiceBloc _bloc;
  bool addedNewService = false;
  Excerpt excerpt;

  @override
  void initState() {
    _bloc = AllServiceBloc(AllService(),
        mySelectedServiceList: widget.mySelectOrderId);
    _bloc.fire(AllServicesEvent.fetchTreeService);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
          return viewModel.fetching
              ? Center(
                  child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor),
                  backgroundColor: Theme.of(context).canvasColor,
                ))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: (widget.mySelectOrderId != null)
                                  ? 'Grab new skills?\n\n'
                                  : "Hey, bee!\n\n",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                            TextSpan(
                              text: (widget.mySelectOrderId != null)
                                  ? 'Add to your bucket...'
                                  : "Let us know what are you skilled at...",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    viewModel.saving
                        ? LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).accentColor),
                            backgroundColor: Theme.of(context).canvasColor,
                          )
                        : SizedBox(),
                    Expanded(
                      child: Stack(
                        children: [
                          ListView.builder(
                            itemCount: viewModel.allAvailableServices.length,
                            itemBuilder: (BuildContext context, int index) {
                              var excerpt =
                                  viewModel.allAvailableServices[index].excerpt;
                              return GestureDetector(
                                onTap: () {
                                  viewModel.parentServices = [];
                                  _bloc.fire(
                                      AllServicesEvent.fetchParentService,
                                      message: {
                                        'ID': viewModel
                                            .allAvailableServices[index].id
                                      }, onHandled: (e, m) {
                                    var value =
                                        _showParentServicesSheet(context);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: FixbeeColors
                                                      .kImageBackGroundColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              padding: EdgeInsets.all(8),
                                              child: (viewModel
                                                          .allAvailableServices[
                                                              index]
                                                          .imageLink ==
                                                      null)
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: AssetImage(
                                                              "assets/logo/new_launcher_icon.png",
                                                            )),
                                                      ),
                                                    )
                                                  : CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: viewModel
                                                          .allAvailableServices[
                                                              index]
                                                          .imageLink,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          image: DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                      httpHeaders: {
                                                        'authorization':
                                                            DataStore.token
                                                      },
                                                    ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                        viewModel
                                                            .allAvailableServices[
                                                                index]
                                                            .serviceName
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  _footer(excerpt)
                                                ],
                                              ),
                                            ),
                                            (viewModel.fetchingParent) &&
                                                    (viewModel
                                                            .selectedServiceID ==
                                                        viewModel
                                                            .allAvailableServices[
                                                                index]
                                                            .id)
                                                ? CustomCircularProgressIndicator()
                                                : Icon(
                                                    Icons.arrow_drop_up_sharp,
                                                    size: 30,
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          (viewModel.allAvailableServices.length != 0)
                              ? Positioned(
                                  bottom: 16,
                                  right: 16,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      RaisedButton(
                                        onPressed: () {
                                          _showSelectedServicesSheet(context);
                                        },
                                        color: Theme.of(context).primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Text(
                                          "Check",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .canvasColor),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      FloatingActionButton(
                                        mini: true,
                                        elevation: 0,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Icon(
                                          Icons.add,
                                          color: Theme.of(context).canvasColor,
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          _showConfirmDialog();
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    )
                  ],
                );
        }),
      ),
    );
  }

  Widget _footer(Excerpt excerpt) {
    if (excerpt.bulletPoints != null && excerpt.bulletPoints.isNotEmpty)
      return Column(
        children: excerpt.bulletPoints.map((e) {
          return excerptField(e);
        }).toList(),
      );
    else if (excerpt.text != null && excerpt.text.isNotEmpty)
      return excerptField(excerpt.text);
    else if (excerpt.rawString != null && excerpt.rawString.isNotEmpty)
      return excerptField(excerpt.rawString);
    else
      return SizedBox();
  }

  String selectedParentId = '';

  void _showParentServicesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.75,
            builder: (_, controller) {
              return Column(
                children: [
                  Icon(
                    Icons.arrow_drop_up,
                    color: Theme.of(context).hintColor,
                  ),
                  Expanded(
                    child: (_bloc.latestViewModel.parentServices.length == 0)
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "No service available!  ",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(
                                  Icons.sentiment_dissatisfied_rounded,
                                  color: Theme.of(context).errorColor,
                                  size: 30,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: controller,
                            itemCount:
                                _bloc.latestViewModel.parentServices.length,
                            itemBuilder: (BuildContext context, int index) {
                              var excerpt = _bloc.latestViewModel
                                  .parentServices[index].excerpt;
                              bool checkBoxValue = _bloc.latestViewModel
                                  .parentServices[index].selected;
                              return GestureDetector(
                                onTap: (!_bloc.latestViewModel
                                        .parentServices[index].priceable)
                                    ? () {
                                        setState(() {
                                          selectedParentId = _bloc
                                              .latestViewModel
                                              .parentServices[index]
                                              .id;
                                        });
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (ctx) {
                                          return ChildService(
                                            title: _bloc
                                                .latestViewModel
                                                .parentServices[index]
                                                .serviceName,
                                            imageUrl: _bloc
                                                .latestViewModel
                                                .parentServices[index]
                                                .imageLink,
                                            childServices: _bloc
                                                .fetchChildService(
                                                    {'ID': selectedParentId}),
                                          );
                                        }));
                                      }
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: FixbeeColors
                                                    .kImageBackGroundColor),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 8),
                                              child: (_bloc
                                                          .latestViewModel
                                                          .parentServices[index]
                                                          .imageLink ==
                                                      null)
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: AssetImage(
                                                              "assets/logo/new_launcher_icon.png",
                                                            )),
                                                      ),
                                                    )
                                                  : CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: _bloc
                                                          .latestViewModel
                                                          .parentServices[index]
                                                          .imageLink,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          image: DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                      httpHeaders: {
                                                        'authorization':
                                                            DataStore.token
                                                      },
                                                    ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                      _bloc
                                                          .latestViewModel
                                                          .parentServices[index]
                                                          .serviceName
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                _footer(excerpt)
                                              ],
                                            ),
                                          ),
                                          (_bloc
                                                  .latestViewModel
                                                  .parentServices[index]
                                                  .priceable)
                                              ? Checkbox(
                                                  checkColor: Theme.of(context)
                                                      .accentColor,
                                                  activeColor: Theme.of(context)
                                                      .cardColor,
                                                  onChanged: (value) {
                                                    _bloc
                                                        .latestViewModel
                                                        .parentServices[index]
                                                        .selected = value;
                                                    setState(() {
                                                      if (value)
                                                        _bloc.latestViewModel
                                                            .selectedServices
                                                            .add(_bloc
                                                                .latestViewModel
                                                                .parentServices[index]);
                                                      else if (!value)
                                                        _bloc.latestViewModel
                                                            .selectedServices
                                                            .remove(_bloc
                                                                .latestViewModel
                                                                .parentServices[index]);
                                                      checkBoxValue = value;
                                                    });
                                                  },
                                                  value: checkBoxValue,
                                                )
                                              : Icon(
                                                  Icons.arrow_drop_up_sharp,
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        });
      },
    );
  }

  void _showSelectedServicesSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).canvasColor,
      isDismissible: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: .3,
            minChildSize: 0.2,
            maxChildSize: (_bloc.latestViewModel.selectedServices.length == 0)
                ? 0.3
                : 0.5,
            builder: (_, controller) {
              return (_bloc.latestViewModel.selectedServices.length != 0)
                  ? Column(
                      children: [
                        Icon(
                          Icons.arrow_drop_up,
                          color: Colors.grey[600],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 8.0),
                          child: Center(
                            child: Text(
                              "YOUR BUCKET OF SKILLS",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              controller: controller,
                              itemCount:
                                  _bloc.latestViewModel.selectedServices.length,
                              itemBuilder: (ctx, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 15,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              _bloc
                                                  .latestViewModel
                                                  .selectedServices[index]
                                                  .serviceName,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    )
                  : Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "No items selected!  ",
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.sentiment_dissatisfied_rounded,
                            color: Theme.of(context).errorColor,
                            size: 30,
                          ),
                        ],
                      ),
                    );
            },
          );
        });
      },
    );
  }

  _showConfirmDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Theme.of(context).canvasColor,
            elevation: 2,
            insetPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Wrap(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(
                          (_bloc.latestViewModel.selectedServices.length == 0)
                              ? "No items selected!"
                              : "Are you Sure?",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      (_bloc.latestViewModel.selectedServices.length == 0)
                          ? SizedBox()
                          : Row(
                              children: [
                                Spacer(),
                                RaisedButton(
                                  color: Theme.of(context).canvasColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                  child: Container(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  width: 3,
                                ),
                                RaisedButton(
                                  color: Theme.of(context).canvasColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Confirm",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  onPressed: () {
                                    _bloc.fire(
                                        AllServicesEvent.saveSelectedServices,
                                        onHandled: (e, m) {
                                      if (widget.mySelectOrderId == null)
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            NavigationScreen()),
                                                (Route<dynamic> route) =>
                                                    false);
                                      else {
                                        Navigator.pop(context);
                                        Navigator.pop(context, true);
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                )
                              ],
                            ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget excerptField(String excerpt) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: Theme.of(context).hintColor,
          size: 5,
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              excerpt ?? "",
              style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }
}
