import 'package:fixbee_partner/models/bee_model.dart';
import 'package:fixbee_partner/queryclass/query_string_builder.dart';

class Queries {
//  static String fetchAllServices = '''
//      {
//        Services(Cannonical:true)
//        {
//          Name
//          Image
//          Links{
//            Name
//          }
//        }
//      }
//  ''';
//
  static String setActiveStatus(bool activeStatus) => '''

mutation{updateBee(_id: "5e246b19201a46362368c0e0", input: {ActiveStatus:$activeStatus}){ActiveStatus }}

''';
  static String getId(Bee beeModel) {
    QueryStringBuilder get_id =
        new QueryStringBuilder(mutation: false, functionName: 'Bee');
    String query = (get_id
          ..put('Phone', '8259992160')
          ..getBack('_id'))
        .build();
    return query;
  }

  static String getActiveStatus() {
    QueryStringBuilder get_active_status =
        new QueryStringBuilder(mutation: false, functionName: 'Bee');
    String query = (get_active_status
          ..put('_id', '5e246b19201a46362368c0e0')
          ..getBack('ActiveStatus'))
        .build();
    return query;
  }



  static String addBee(Bee beeModel) {
    Map name = Map();
    Map input = Map();
    QueryStringBuilder add_bee =
        new QueryStringBuilder(mutation: true, functionName: 'addBee');
    String query = (add_bee
          ..put('Firstname', (beeModel.firstName), map: name)
          ..put('Middlename', (beeModel.middleName) ?? '', map: name)
          ..put('Lastname', (beeModel.lastName) ?? '', map: name)
          ..put('Name', name, map: input)
          ..put('Phone', beeModel.phoneNumber, map: input)
          ..put('Email', beeModel.emailAddress, map: input)
          ..put('input', input)
          ..getBack('_id')
          ..getBack('Name', fields: ['Firstname', 'Middlename', 'Lastname']))
        .build();

//    String query = '''
//
//    mutation{
//  addBee(input:{
//    Name: {Firstname:"${beeModel.firstName}", Middlename:"${beeModel.middleName??""}", Lastname:"${beeModel.lastName??""}"}
//    Phone:"${beeModel.phoneNumber}"
//    Email: "${beeModel.emailAddress}"
//  })
//  {
//    _id
//  }
//}
//
//
//
//    ''';

    return query;
  }
}
