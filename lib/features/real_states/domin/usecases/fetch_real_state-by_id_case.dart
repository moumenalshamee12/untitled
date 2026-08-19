import 'package:dartz/dartz.dart';
import 'package:untitled/core/errors/failure_errors.dart';
import 'package:untitled/features/real_states/domin/entites/real_state_entitey.dart';
import 'package:untitled/features/real_states/domin/repo/real_state_repo.dart';

class FetchRealStateByIdCase {
  final RealStateRepo realStateRepo;

  FetchRealStateByIdCase({required this.realStateRepo});

  Future<Either<ServerFailure, RealStateEntitey>> call(int id) async {
    return await realStateRepo.fetchrealstatebyid(id);
  }
}
