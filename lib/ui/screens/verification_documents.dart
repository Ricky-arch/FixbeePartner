import 'dart:developer';

import 'package:fixbee_partner/events/file_upload_event.dart';
import 'package:fixbee_partner/ui/custom_widget/custom_circular_progress_indicator.dart';
import 'package:fixbee_partner/ui/custom_widget/document_view_widget.dart';
import 'package:fixbee_partner/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';
import 'package:fixbee_partner/blocs/file_upload_bloc.dart';
import 'package:fixbee_partner/models/fileModel.dart';
import 'package:fixbee_partner/ui/custom_widget/file_upload_widget.dart';

class VerificationDocuments extends StatefulWidget {
  @override
  _VerificationDocumentsState createState() => _VerificationDocumentsState();
}

class _VerificationDocumentsState extends State<VerificationDocuments> {
  FileUploadBloc _bloc;
  FileUploadController _controllerID,
      _controllerAge,
      _controllerAddress,
      _controllerAdditional;

  @override
  void initState() {
    _bloc = FileUploadBloc(FileModel());
    _bloc.fire(FileUploadEvent.checkUploaded);
    _controllerID = FileUploadController();
    _controllerAge = FileUploadController();
    _controllerAddress = FileUploadController();
    _controllerAdditional = FileUploadController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _showRuleList();
    });
    super.initState();
  }

  @override
  void dispose() {
    _bloc.extinguish();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColors.backgroundColor,
      body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
        return SafeArea(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                        decoration:
                            BoxDecoration(color: PrimaryColors.backgroundColor),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 20),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Upload Documents!\n\n",
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    TextSpan(
                                      text: "To be a verified Bee",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).accentColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                color: Theme.of(context).accentColor,
                                size: 20,
                              ),
                              onPressed: () {
                                _showRuleList();
                              },
                            )
                          ],
                        ))
                  ],
                ),
              ),
              (viewModel.onFetchUploadedDocumentsList)
                  ? LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).accentColor),
                      backgroundColor: Theme.of(context).canvasColor,
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 0, 8, 0),
                            child: Text(
                              (!viewModel.uploadedDocuments
                                      .contains(Constants.IDENTITY_PROOF_TAG))
                                  ? "Add an IDENTITY PROOF CERTIFICATE*"
                                  : "IDENTITY PROOF CERTIFICATE UPLOADED \u2713",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {},
                              child: FileUploadWidget(
                                controller: _controllerID,
                                documentName: "Identity-proof.jpeg",
                                inputString: (!viewModel.uploadedDocuments
                                        .contains(Constants.IDENTITY_PROOF_TAG))
                                    ? "Upload any Identity-proof Certificate"
                                    : "Identity-proof.jpeg",
                                onImagePicked: (path) {
                                  onImagePicked(
                                      path,
                                      "Identity_proof",
                                      _controllerID.onUpload,
                                      Constants.IDENTITY_PROOF_TAG);
                                },
                                loading: false,
                                text: Text(viewModel.files == null
                                    ? "Document"
                                    : "Identity proof certificate uploaded"),
                                viewWidget: (viewModel.uploadedDocuments
                                        .contains(Constants.IDENTITY_PROOF_TAG))
                                    ? IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          size: 25,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return DocumentViewerPage(
                                              documentName:
                                                  Constants.IDENTITY_PROOF_TAG,
                                              documentKey: viewModel.keys[
                                                  Constants.IDENTITY_PROOF_TAG],
                                            );
                                          }));
                                        },
                                      )
                                    : SizedBox(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 8, 8, 0),
                            child: Text(
                              (!viewModel.uploadedDocuments
                                      .contains(Constants.AGE_PROOF_TAG))
                                  ? "Add an AGE_PROOF CERTIFICATE*"
                                  : "AGE PROOF CERTIFICATE UPLOADED \u2713",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {},
                              child: FileUploadWidget(
                                controller: _controllerAge,
                                documentName: "Age-Proof.jpeg",
                                inputString: (!viewModel.uploadedDocuments
                                        .contains(Constants.AGE_PROOF_TAG))
                                    ? "Upload any Age-proof Certificate"
                                    : "Age-Proof.jpeg",
                                onImagePicked: (path) {
                                  log('OnUPLOAD', name: 'onUp2');
                                  onImagePicked(
                                      path,
                                      "Age_proof",
                                      _controllerAge.onUpload,
                                      Constants.AGE_PROOF_TAG);
                                },
                                //imageURl: viewModel.fileUrl,
                                loading: false,
                                text: Text(viewModel.files == null
                                    ? "Document"
                                    : "Age proof certificate uploaded"),
                                viewWidget: (viewModel.uploadedDocuments
                                        .contains(Constants.AGE_PROOF_TAG))
                                    ? IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          size: 25,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return DocumentViewerPage(
                                              documentName:
                                                  Constants.AGE_PROOF_TAG,
                                              documentKey: viewModel.keys[
                                                  Constants.AGE_PROOF_TAG],
                                            );
                                          }));
                                        },
                                      )
                                    : SizedBox(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 8, 8, 0),
                            child: Text(
                              (!viewModel.uploadedDocuments
                                      .contains(Constants.ADDRESS_PROOF_TAG))
                                  ? "Add an ADDRESS-PROOF CERTIFICATE*"
                                  : "ADDRESS PROOF CERTIFICATE UPLOADED \u2713",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {},
                              child: FileUploadWidget(
                                controller: _controllerAddress,
                                documentName: "Address-proof.jpeg",
                                inputString: (!viewModel.uploadedDocuments
                                        .contains(Constants.ADDRESS_PROOF_TAG))
                                    ? "Upload any address-proof certificate"
                                    : "Address-proof.jpeg",
                                onImagePicked: (path) {
                                  log('OnUPLOAD', name: 'onUp2');
                                  onImagePicked(
                                      path,
                                      "Address",
                                      _controllerAddress.onUpload,
                                      "${Constants.ADDRESS_PROOF_TAG}");
                                },
                                //imageURl: viewModel.fileUrl,
                                loading: false,
                                text: Text(viewModel.files == null
                                    ? "Document"
                                    : "Address proof certificate uploaded"),
                                viewWidget: (viewModel.uploadedDocuments
                                        .contains(Constants.ADDRESS_PROOF_TAG))
                                    ? IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          size: 25,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return DocumentViewerPage(
                                              documentName:
                                                  Constants.ADDRESS_PROOF_TAG,
                                              documentKey: viewModel.keys[
                                                  Constants.ADDRESS_PROOF_TAG],
                                            );
                                          }));
                                        },
                                      )
                                    : SizedBox(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 8, 8, 0),
                            child: Text(
                              (!viewModel.uploadedDocuments
                                      .contains(Constants.ADDITIONAL_TAG))
                                  ? "Add any ADDITIONAL CERTIFICATE"
                                  : "ADDITIONAL CERTIFICATE UPLOADED \u2713",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {},
                              child: FileUploadWidget(
                                controller: _controllerAdditional,
                                documentName: "Additional.jpeg",
                                inputString: (!viewModel.uploadedDocuments
                                        .contains(Constants.ADDITIONAL_TAG))
                                    ? "Upload any additional Certifications"
                                    : "Additional.jpeg",
                                onImagePicked: (path) {
                                  log('OnUPLOAD', name: 'onUp2');
                                  onImagePicked(
                                      path,
                                      "Additional",
                                      _controllerAdditional.onUpload,
                                      Constants.ADDITIONAL_TAG);
                                },
                                loading: false,
                                text: Text(viewModel.files == null
                                    ? "Document"
                                    : "Additional Certifications uploaded"),
                                viewWidget: (viewModel.uploadedDocuments
                                        .contains(Constants.ADDITIONAL_TAG))
                                    ? IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          size: 25,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return DocumentViewerPage(
                                              documentName:
                                                  Constants.ADDITIONAL_TAG,
                                              documentKey: viewModel.keys[
                                                  Constants.ADDITIONAL_TAG],
                                            );
                                          }));
                                        },
                                      )
                                    : SizedBox(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Container(
                              height: 2,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }

  onImagePicked(String path, String fileName, Function onUpload, String tags) {
    _bloc.fire(FileUploadEvent.uploadFile, message: {
      "path": "$path",
      "file": fileName,
      "onUpload": onUpload,
      'tags': tags
    }, onHandled: (e, m) {
      if (m.onErrorUpload)
        _showUploadStatusDialogBox(
            "Error uploading file!\n\nTry uploading pictures less than 500-KB (jpeg/png recommended)");
      else
        _showUploadStatusDialogBox(fileName + " uploaded successfully!");
    });
  }

  _showUploadStatusDialogBox(message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            title: Text(
              message,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          );
        });
  }

  _showRuleList() {
    int c = 0;
    showModalBottomSheet(
        backgroundColor: FixbeeColors.kImageBackGroundColor,
        isDismissible: false,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12),
                      child: Text("DO KEEP IN MIND THE FOLLOWING!",
                          style: TextStyle(
                              color: Theme.of(context).errorColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    for (var i in Rules.DOCUMENT_RULES)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: (Rules.DOCUMENT_RULES.indexOf(i) + 1)
                                      .toString() +
                                  ".\t",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15)),
                          TextSpan(
                              text: i.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15))
                        ])),
                      ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 12, 12),
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            elevation: 4,
                            color: Theme.of(context).primaryColor,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                    color: Theme.of(context).canvasColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        });
  }
}
