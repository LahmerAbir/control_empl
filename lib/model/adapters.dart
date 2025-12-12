import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_data/flutter_data.dart';
import '../utils/utils.dart';

mixin ApplicationAdapter<T extends DataModel<T>> on RemoteAdapter<T> {
  @override
  String get baseUrl =>
      'https://cleanmanagements.vercel.app/api';

  @override
  FutureOr<Map<String, String>> get defaultHeaders => Utils.headers();

  @override
  bool isOfflineError(Object? error) {
    final err = error.toString();

    return super.isOfflineError(error) || err.startsWith('Failed host lookup');
  }


}
mixin UserAdapter<T extends DataModel<T>> on RemoteAdapter<T> {

  @protected
  DataRequestMethod methodForSave(id, params) =>
      id != null ? DataRequestMethod.PUT : DataRequestMethod.POST;

  @override
  String urlForSave(id, Map<String, dynamic> params) =>  id != null  ? 'user' : '/auth/register';

}
mixin OrdreAdapter<T extends DataModel<T>> on RemoteAdapter<T> {

  @protected
  String urlForFindAll(params)=> 'orders';


}