import 'dart:developer';

import 'package:fixbee_partner/events/file_upload_event.dart';
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
  FileUploadController _controllerAadhaar,
      _controllerAge,
      _controllerAddress,
      _controllerAdditional;

  @override
  void initState() {
    _bloc = FileUploadBloc(FileModel());
    _bloc.fire(FileUploadEvent.checkUploaded);
    _controllerAadhaar = FileUploadController();
    _controllerAge = FileUploadController();
    _controllerAddress = FileUploadController();
    _controllerAdditional = FileUploadController();
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
      backgroundColor: PrimaryColors.backgroundcolorlight,
      body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 11,
                child: Stack(
                  children: <Widget>[
                    Container(
                        decoration:
                            BoxDecoration(color: PrimaryColors.backgroundColor),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 5,
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'ADD DOCUMENTS FOR VERIFICATION',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 15)),
                                ],
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {},
                            )
                          ],
                        ))
                  ],
                ),
              ),
              (viewModel.onFetchUploadedDocumentsList)
                  ? CircularProgressIndicator()
                  : Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 0, 8, 0),
                            child: Text(
                              (!viewModel.uploadedDocuments
                                      .contains("Aadhaar.jpg"))
                                  ? "Add your AADHAAR CARD*"
                                  : "AADHAAR CARD UPLOADED \u2713",
                              style: TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {},
                              child: FileUploadWidget(
                                controller: _controllerAadhaar,
                                documentName: "Aadhaar.jpeg",
                                inputString: (!viewModel.uploadedDocuments
                                        .contains("Aadhaar.jpg"))
                                    ? "Upload your aadhaar card"
                                    : "Aadhaar.jpeg",
                                onImagePicked: (path) {
                                  log('OnUPLOAD', name: 'onUp2');
                                  onImagePicked(path, "Aadhaar",
                                      _controllerAadhaar.onUpload);
                                },
                                loading: false,
                                text: Text(viewModel.files == null
                                    ? "Document"
                                    : "Aadhaar Card uploaded"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Container(
                              height: 2,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black54,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 8, 8, 0),
                            child: Text(
                              (!viewModel.uploadedDocuments
                                      .contains("Age_proof.jpg"))
                                  ? "Add an AGE_PROOF CERTIFICATE*"
                                  : "AGE PROOF CERTIFICATE UPLOADED \u2713",
                              style: TextStyle(
                                  color: Colors.brown,
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
                                        .contains("Age_proof.jpg"))
                                    ? "Upload any Age-proof Certificate"
                                    : "Age-Proof.jpeg",
                                onImagePicked: (path) {
                                  log('OnUPLOAD', name: 'onUp2');
                                  onImagePicked(path, "Age_proof",
                                      _controllerAge.onUpload);
                                },
                                //imageURl: viewModel.fileUrl,
                                loading: false,
                                text: Text(viewModel.files == null
                                    ? "Document"
                                    : "Age proof certificate uploaded"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Container(
                              height: 2,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black54,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 8, 8, 0),
                            child: Text(
                              (!viewModel.uploadedDocuments
                                      .contains("Address.jpg"))
                                  ? "Add an ADDRESS-PROOF CERTIFICATE*"
                                  : "ADDRESS PROOF CERTIFICATE UPLOADED \u2713",
                              style: TextStyle(
                                  color: Colors.brown,
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
                                        .contains("Address.jpg"))
                                    ? "Upload any address-proof certificate"
                                    : "Address-proof.jpeg",
                                onImagePicked: (path) {
                                  log('OnUPLOAD', name: 'onUp2');
                                  onImagePicked(path, "Address",
                                      _controllerAddress.onUpload);
                                },
                                //imageURl: viewModel.fileUrl,
                                loading: false,
                                text: Text(viewModel.files == null
                                    ? "Document"
                                    : "Address proof certificate uploaded"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Container(
                              height: 2,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black54,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 8, 8, 0),
                            child: Text(
                              (!viewModel.uploadedDocuments
                                      .contains("Additional.jpg"))
                                  ? "Add any ADDITIONAL CERTIFICATE"
                                  : "ADDITIONAL CERTIFICATE UPLOADED \u2713",
                              style: TextStyle(
                                  color: Colors.brown,
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
                                        .contains("Additional.jpg"))
                                    ? "Upload any additional Certifications"
                                    : "Additional.jpeg",
                                onImagePicked: (path) {
                                  log('OnUPLOAD', name: 'onUp2');
                                  onImagePicked(path, "Additional",
                                      _controllerAdditional.onUpload);
                                },
                                //imageURl: viewModel.fileUrl,
                                loading: false,
                                text: Text(viewModel.files == null
                                    ? "Document"
                                    : "Additional Certifications uploaded"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Container(
                              height: 2,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black54,
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

  onImagePicked(String path, String fileName, Function onUpload) {
    log('OnUPLOAD', name: 'onUp3');
    _bloc.fire(FileUploadEvent.uploadFile,
        message: {"path": "$path", "file": fileName, "onUpload": onUpload},
        onHandled: (e, m) {
      if (m.onErrorUpload)
        _showUploadStatusDialogBox(
            "Error uploading file!\nFile must meet the requirements as per Fixbee, tap info for further details...");
      else
        _showUploadStatusDialogBox(fileName + " uploaded successfully!");
    });
  }

  _showUploadStatusDialogBox(message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              message,
              style: TextStyle(color: PrimaryColors.backgroundColor),
            ),
          );
        });
  }
}
