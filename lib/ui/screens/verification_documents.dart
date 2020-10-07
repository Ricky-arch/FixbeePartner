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
  FileUploadController _controller1;

  @override
  void initState() {
    _bloc = FileUploadBloc(FileModel());
    _controller1 = FileUploadController();
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
                  controller: _controller1,
                  documentName: " Aadhaar.jpeg",
                  inputString: "Upload your aadhaar card",
                  onImagePicked: (path) {
                    onImagePicked1(path, _controller1.onUpload);
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
                  documentName: "Age-Proof.jpeg",
                  inputString: "Upload any Age-proof Certificate",
                  onImagePicked: onImagePicked2,
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
                  documentName: "Address_proof.jpeg",
                  inputString: "Upload any address-proof certificate",
                  onImagePicked: onImagePicked3,
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
                  documentName: "Additional.jpeg",
                  inputString: "Upload any additional Certifications",
                  onImagePicked: onImagePicked4,
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

  onImagePicked1(String path, Function onUpload) {
    _bloc.fire(FileUploadEvent.uploadFile,
        message: {"path": "$path", "file": "aadhaar", "onUpload": onUpload});
  }

  onImagePicked2(String path) {
    _bloc.fire(FileUploadEvent.uploadFile,
        message: {"path": "$path", "file": "age_proof"});
  }

  onImagePicked3(String path) {
    _bloc.fire(FileUploadEvent.uploadFile,
        message: {"path": "$path", "file": "address_proof"});
  }

  onImagePicked4(String path) {
    _bloc.fire(FileUploadEvent.uploadFile,
        message: {"path": "$path", "file": "additional_certificate"});
  }
}
