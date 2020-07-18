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

  @override
  void initState() {
    _bloc = FileUploadBloc(FileModel());
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
        //backgroundColor: Data.backgroundColor,
        title: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(color: PrimaryColors.backgroundColor),
                child: Row(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Add documents for verification',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
                                  fontSize: 18)),
                        ],
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: Colors.yellow,
                      ),
                      onPressed: () {},
                    )
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
                  onImagePicked: onImagePicked,
                  imageURl: viewModel.fileUrl,
                  loading: false,
                  text: Text(viewModel.fileName==null?"Document":viewModel.fileName),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  onImagePicked(String path) {
    _bloc.fire(FileUploadEvent.uploadFile,
        message: {"path": "$path", "file": "document"});
  }
}
