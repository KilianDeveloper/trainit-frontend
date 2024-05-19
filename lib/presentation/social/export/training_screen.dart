import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainit/bloc/social/bloc.dart';
import 'package:trainit/bloc/social/state.dart';
import 'package:trainit/data/model/dto/loading_status.dart';
import 'package:trainit/presentation/shared/export/loading_widget.dart';
import 'package:trainit/presentation/shared/export/page.dart';
import 'package:trainit/presentation/social/training_screen.dart';
import 'package:trainit/presentation/social/widget/training_loading_error.dart';

class ExportImmutableTrainingScreen extends StatelessWidget {
  final Function(Widget Function()) pushPage;
  final Function() popPage;

  const ExportImmutableTrainingScreen({
    super.key,
    required this.pushPage,
    required this.popPage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialBloc, SocialState>(
      builder: (context, state) {
        if (state.training != null) {
          return TrainingScreen(
            account: state.account,
            training: state.training!,
          );
        } else {
          if (state.loadingStatus == LoadingStatus.error) {
            return const ContentPage(
              title: "",
              content: TrainingLoadingError(),
            );
          }
          return const ContentPage(
            title: "",
            content: LoadingWidget(title: "Training"),
          );
        }
      },
    );
  }
}
