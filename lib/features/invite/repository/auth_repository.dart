import 'dart:async';

import 'package:be_loved/core/data_source/dev_remote_data_source.dart';
import 'package:be_loved/core/domain/object/general_callback_result.dart';
import 'package:be_loved/features/invite/repository/auth_client.dart';

final class AuthRepository extends DevRemoteDataSource {
  late final _client = AuthClient(dio);

  Future<RemoteCbResult<void>> putJoker() => request(() => _client.putJoker());

  Future<RemoteCbResult<void>> getJoker() => request(() => _client.getJoker());
}
