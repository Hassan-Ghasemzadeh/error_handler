import 'package:example/core/constants/app_strings.dart';
import 'package:example/features/coffee_demo/domain/entities/coffee_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resultex/resultex.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/coffee_bloc/coffee_bloc.dart';

/// A mockup widget representing a mobile phone device shell that renders reactive coffee data using [ResultBuilder].
class MobileMockup extends StatefulWidget {
  const MobileMockup({super.key});

  @override
  State<MobileMockup> createState() => _MobileMockupState();
}

class _MobileMockupState extends State<MobileMockup> {
  late final ResultNotifier<List<CoffeeEntity>> _coffeeNotifier;

  @override
  void initState() {
    super.initState();
    _coffeeNotifier = ResultNotifier<List<CoffeeEntity>>();
  }

  @override
  void dispose() {
    _coffeeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 650,
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppTheme.borderDark, width: 8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Scaffold(
          backgroundColor: AppTheme.backgroundDark,
          appBar: AppBar(
            backgroundColor: AppTheme.surfaceCard,
            elevation: 0,
            leading: const Icon(CupertinoIcons.bars, color: Colors.white),
            title: const Text(
              AppStrings.mobileTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            centerTitle: true,
          ),
          body: BlocListener<CoffeeBloc, CoffeeState>(
            listener: (context, state) {
              if (state.status == CoffeeStatus.initial) {
                _coffeeNotifier.reset();
              } else if (state.status == CoffeeStatus.loading) {
                _coffeeNotifier.emitLoading();
              } else if (state.status == CoffeeStatus.success) {
                _coffeeNotifier.emitSuccess(state.coffees);
              } else if (state.status == CoffeeStatus.failure) {
                _coffeeNotifier.emitFailure(
                  Failure(message: state.errorMessage ?? 'Unknown error'),
                );
              }
            },
            child: ResultBuilder<List<CoffeeEntity>>(
              notifier: _coffeeNotifier,
              onInitial: (context) => const Center(
                child: Text(
                  AppStrings.initialStateMessage,
                  style: TextStyle(color: AppTheme.textMuted),
                ),
              ),
              onLoading: (context) => const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.accentBlue,
                ),
              ),
              onFailure: (context, failure) => Center(
                child: Text(
                  'Error: ${failure.message}',
                  style: const TextStyle(color: AppTheme.errorRed),
                  textAlign: TextAlign.center,
                ),
              ),
              onSuccess: (context, coffees) => CoffeeListView(coffees: coffees),
            ),
          ),
        ),
      ),
    );
  }
}

/// Scrollable list view displaying fetched coffee items inside the mobile mockup.
class CoffeeListView extends StatelessWidget {
  final List<CoffeeEntity> coffees;

  const CoffeeListView({
    super.key,
    required this.coffees,
  });

  @override
  Widget build(BuildContext context) {
    if (coffees.isEmpty) {
      return const Center(
        child: Text(
          AppStrings.noDataMessage,
          style: TextStyle(color: AppTheme.textMuted),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: coffees.length,
      itemBuilder: (context, index) {
        return CoffeeCard(coffee: coffees[index]);
      },
    );
  }
}

/// Card item presenting details for a single coffee entity.
class CoffeeCard extends StatelessWidget {
  final CoffeeEntity coffee;

  const CoffeeCard({
    super.key,
    required this.coffee,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.surfaceCard,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            coffee.image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(
              CupertinoIcons.photo,
              color: AppTheme.textMuted,
            ),
          ),
        ),
        title: Text(
          coffee.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          coffee.ingredients.join(', '),
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
