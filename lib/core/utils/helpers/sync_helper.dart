

import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/purpose/purpose_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/tags/tags_bloc.dart';
import 'package:be_loved/features/profile/presentation/bloc/decor/decor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

allSync(BuildContext context){
  context.read<TagsBloc>().add(GetTagsEvent());
  context.read<EventsBloc>().add(GetEventsEvent());
  context.read<PurposeBloc>().add(GetAllPurposeDataEvent());
  context.read<DecorBloc>().add(GetBackgroundEvent());
}