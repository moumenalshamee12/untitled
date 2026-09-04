import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/service_locator.dart';
import 'package:untitled/core/utils/error_snackbar.dart';
import 'package:untitled/features/real_states/domin/entites/real_state_entitey.dart';
import 'package:untitled/features/real_states/domin/usecases/fetch_real_state_case.dart';
import 'package:untitled/features/real_states/presentoin/manger/real_states_cubit/real_states_cubit.dart';
import 'package:untitled/features/real_states/presentoin/manger/real_states_cubit/real_states_states.dart';
import 'package:untitled/features/real_states/presentoin/pages/real_states_body.dart';

class RealStatesPage extends StatelessWidget {
  const RealStatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          RealStatesCubit(getIt<FetchRealStateCase>())..fetchRealStates(),
      child: const RealStatesView(),
    );
  }
}

class RealStatesView extends StatelessWidget {
  const RealStatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RealStatesCubit, RealStatesStates>(
      listener: (context, state) {
        if (state is RealStatesErrorState) {
          showErrorSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        final isLoading = state is RealStatesLoadingState;
        final List<RealStateEntity> realStates = state is RealStatesLoadedState
            ? state.realStates
            : const [];

        final cubit = context.read<RealStatesCubit>();

        return RealStatesBody(
          isLoading: isLoading,
          realStates: realStates,
          onRefresh: cubit.fetchRealStates,
          onRetry: cubit.fetchRealStates,
          showError: state is RealStatesErrorState,
        );
      },
    );
  }
}
