import 'dart:developer';

import 'package:fixbee_partner/events/file_upload_event.dart';
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
  FileUploadController _controllerAAdhaar,
      _controllerAge,
      _controllerAddress,
      _controllerAdditional;

  @override
  void initState() {
    _bloc = FileUploadBloc(FileModel());
    _controllerAAdhaar = FileUploadController();
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
      appBar: AppBar(
        backgroundColor: PrimaryColors.backgroundColor,
        automaticallyImplyLeading: false,
        title: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(color: PrimaryColors.backgroundColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    IconButton(
                      icon: Icon(Icons.info_outline),
                      onPressed: () {},
                      color: Colors.white,
                    ),
                  ],
                ))
          ],
        ),
      ),
      body: _bloc.widget(onViewModelUpdated: (ctx, viewModel) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                child: FileUploadWidget(
                  controller: _controllerAAdhaar,
                  documentName: " Aadhaar.jpeg",
                  inputString: "Upload your aadhaar card",
                  onImagePicked: (path) {
                    log('OnUPLOAD', name: 'onUp2');
                    onImagePicked(path, "Aadhaar",_controllerAAdhaar.onUpload);
                  },
                  loading: false,
                  text: Text(viewModel.files == null
                      ? "Document"
                      : "Aadhaar Card uploaded"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                child: FileUploadWidget(
                  controller: _controllerAge,
                  documentName: "Age-Proof.jpeg",
                  inputString: "Upload any Age-proof Certificate",
                  onImagePicked: (path) {
                    log('OnUPLOAD', name: 'onUp2');
                    onImagePicked(path, "Age_proof",_controllerAge.onUpload);
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
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                child: FileUploadWidget(
                  controller: _controllerAddress,
                  documentName: "Address_proof.jpeg",
                  inputString: "Upload any address-proof certificate",
                  onImagePicked: (path) {
                    log('OnUPLOAD', name: 'onUp2');
                    onImagePicked(path, "Address",_controllerAddress.onUpload);
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
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                child: FileUploadWidget(
                  controller: _controllerAdditional,
                  documentName: "Additional.jpeg",
                  inputString: "Upload any additional Certifications",
                  onImagePicked: (path) {
                    log('OnUPLOAD', name: 'onUp2');
                    onImagePicked(
                        path, "Additional", _controllerAdditional.onUpload);
                  },
                  //imageURl: viewModel.fileUrl,
                  loading: false,
                  text: Text(viewModel.files == null
                      ? "Document"
                      : "Additional Certifications uploaded"),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  onImagePicked(String path, String fileName, Function onUpload) {
    log('OnUPLOAD', name: 'onUp3');
    _bloc.fire(FileUploadEvent.uploadFile,
        message: {"path": "$path", "file": fileName, "onUpload": onUpload});
  }
}
