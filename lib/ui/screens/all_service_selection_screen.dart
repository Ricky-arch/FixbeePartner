import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixbee_partner/blocs/all_service_bloc.dart';
import 'package:fixbee_partner/events/all_services_event.dart';
import 'package:fixbee_partner/models/all_Service.dart';
import 'package:flutter/material.dart';
import '../../Constants.dart';
import 'child_service.dart';
import 'home.dart';
import 'navigation_screen.dart';

class AllServiceSelection extends StatefulWidget {
  @override
  _AllServiceSelectionState createState() => _AllServiceSelectionState();
}

class _AllServiceSelectionState extends State<AllServiceSelection> {
  AllServiceBloc _bloc;
  @override
  void initState() {
    _bloc = AllServiceBloc(AllService());
    _bloc.fire(AllServicesEvent.fetchTreeService);
    // _bloc.openHive();
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
        backgroundColor: PrimaryColors.backgroundcolorlight,
        appBar: AppBar(
          backgroundColor: PrimaryColors.backgroundColor,
          automaticallyImplyLeading: false,
          title: Stack(
            children: <Widget>[
              Container(
                  decoration:
                      BoxDecoration(color: PrimaryColors.backgroundColor),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'ADD TO YOUR SKILL LIST',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          mini: true,
          elevation: 0,
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            _showSelectedServiceListDialog();
          },
        ),
        body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
          return viewModel.fetching
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  ],
                )
              : ListView(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: viewModel.allAvailableServices.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            viewModel.parentServices = [];
                            _bloc.fire(AllServicesEvent.fetchParentService,
                                message: {
                                  'ID': viewModel.allAvailableServices[index].id
                                }, onHandled: (e, m) {
                              var value = _showParentServiceDialogBox();
                              // print(value);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Colors.tealAccent)),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 12),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 75,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: (viewModel
                                                    .allAvailableServices[index]
                                                    .imageLink ==
                                                null)
                                            ? Image.asset(
                                                "assets/logo/new_launcher_icon.png")
                                            : CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: viewModel
                                                    .allAvailableServices[index]
                                                    .imageLink,
                                              ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Text(
                                            viewModel
                                                .allAvailableServices[index]
                                                .serviceName
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: PrimaryColors
                                                    .backgroundColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Spacer(),
                                      (viewModel.fetchingParent) &&
                                              (viewModel.selectedServiceID ==
                                                  viewModel
                                                      .allAvailableServices[
                                                          index]
                                                      .id)
                                          ? CircularProgressIndicator()
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
                    )
                  ],
                );
        }),
      ),
    );
  }

  String selectedParentId = '';

  _showParentServiceDialogBox() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Wrap(
                children: [
                  Container(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              _bloc.latestViewModel.parentServices.length,
                          itemBuilder: (BuildContext context, int index) {
                            bool checkBoxValue = _bloc
                                .latestViewModel.parentServices[index].selected;
                            return GestureDetector(
                              onTap: (!_bloc.latestViewModel
                                      .parentServices[index].priceable)
                                  ? () {
                                      setState(() {
                                        selectedParentId = _bloc.latestViewModel
                                            .parentServices[index].id;
                                      });
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (ctx) {
                                        return ChildService(
                                          title: _bloc
                                              .latestViewModel
                                              .parentServices[index]
                                              .serviceName,
                                          imageUrl: _bloc.latestViewModel
                                              .parentServices[index].imageLink,
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
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(color: Colors.white)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 75,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 8),
                                            child: (_bloc
                                                        .latestViewModel
                                                        .parentServices[index]
                                                        .imageLink ==
                                                    null)
                                                ? Image.asset(
                                                    "assets/logo/new_launcher_icon.png")
                                                : CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: _bloc
                                                        .latestViewModel
                                                        .parentServices[index]
                                                        .imageLink),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Container(
                                            // width: MediaQuery.of(context)
                                            //         .size
                                            //         .width /
                                            //     2,
                                            child: Text(
                                              _bloc
                                                  .latestViewModel
                                                  .parentServices[index]
                                                  .serviceName,
                                              style: TextStyle(
                                                  color: PrimaryColors
                                                      .backgroundColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        // SizedBox(width:50),
                                        (_bloc
                                                .latestViewModel
                                                .parentServices[index]
                                                .priceable)
                                            ? Checkbox(
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
                                                                  .parentServices[
                                                              index]);
                                                    else if (!value)
                                                      _bloc.latestViewModel
                                                          .selectedServices
                                                          .remove(_bloc
                                                                  .latestViewModel
                                                                  .parentServices[
                                                              index]);
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
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          );
        });
  }

  _showSelectedServiceListDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: PrimaryColors.backgroundColor,
            elevation: 2,
            insetPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Wrap(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        child: Text(
                          "Your bucket of skills".toUpperCase(),
                          style: TextStyle(
                              color: PrimaryColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      (_bloc.latestViewModel.selectedServices.length == 0)
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Text(
                                "No items selected!",
                                style:
                                    TextStyle(color: PrimaryColors.yellowColor),
                              ),
                            )
                          : Container(
                              child: ListView.builder(
                                itemCount: _bloc
                                    .latestViewModel.selectedServices.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: 15,
                                          color: PrimaryColors.yellowColor,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          child: Text(
                                            _bloc
                                                .latestViewModel
                                                .selectedServices[index]
                                                .serviceName,
                                            style: TextStyle(
                                                color:
                                                    PrimaryColors.yellowColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
                                  color: PrimaryColors.yellowColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Confirm"),
                                  ),
                                  onPressed: () {
                                    _bloc.fire(
                                        AllServicesEvent.saveSelectedServices,
                                        onHandled: (e, m) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => NavigationScreen()),
                                          (Route<dynamic> route) => false);
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
}
