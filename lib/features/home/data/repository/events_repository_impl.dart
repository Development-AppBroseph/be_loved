import 'package:be_loved/core/error/exceptions.dart';
import 'package:be_loved/core/services/network/network_info.dart';
import 'package:be_loved/features/home/data/datasource/events/events_remote_datasource.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/domain/repositories/events_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';


class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  EventsRepositoryImpl(
      this.remoteDataSource, this.networkInfo);




  @override
  Future<Either<Failure, List<EventEntity>>> getEvents() async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getEvents();
        return Right(items);
      } catch (e) {
        print(e);
        if(e is ServerException){
          return Left(ServerFailure(e.message.toString()));
        }
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }



  @override
  Future<Either<Failure, EventEntity>> addEvent(params) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.addEvent(params.eventEntity);
        return Right(items);
      } catch (e) {
        print(e);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
