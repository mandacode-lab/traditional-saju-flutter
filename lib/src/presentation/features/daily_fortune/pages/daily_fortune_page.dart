import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:traditional_saju/src/domain/saju/entity/daily_fortune.dart';
import 'package:traditional_saju/src/infrastructure/di/service_locator.dart';
import 'package:traditional_saju/src/presentation/common/widgets/form/confirmation_dialog.dart';
import 'package:traditional_saju/src/presentation/common/widgets/fortune_score_circle.dart';
import 'package:traditional_saju/src/presentation/common/widgets/layouts/adaptive_column.dart';
import 'package:traditional_saju/src/presentation/common/widgets/layouts/waiting_screen.dart';
import 'package:traditional_saju/src/presentation/features/daily_fortune/bloc/daily_fortune_bloc.dart';
import 'package:traditional_saju/src/presentation/features/daily_fortune/bloc/daily_fortune_event.dart';
import 'package:traditional_saju/src/presentation/features/daily_fortune/bloc/daily_fortune_state.dart';

class DailyFortunePage extends StatelessWidget {
  const DailyFortunePage({super.key});

  static const routeName = 'daily-fortune';

  @override
  Widget build(BuildContext context) {
    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, Object? result) async {
        if (!didPop) {
          await showDialog<bool>(
            context: context,
            builder: (context) => ConfirmationDialog(
              title: '처음으로 돌아가시겠습니까?',
              content: '결과는 자동으로 저장됩니다.',
              confirmText: '예',
              cancelText: '아니오',
              onConfirm: () {
                Navigator.of(context).pop(true);
                context.go('/');
              },
              onCancel: () {
                Navigator.of(context).pop(false);
              },
            ),
          );
        }
      },
      child: Scaffold(
        body: BlocProvider(
          create: (_) {
            final bloc = getIt<DailyFortuneBloc>();
            // Trigger API call immediately since we only navigate here
            // after form submission
            bloc.add(const DailyFortuneLoadRequested());
            return bloc;
          },
          child: const _ResultPageContent(),
        ),
      ),
    );
  }
}

class _ResultPageContent extends StatelessWidget {
  const _ResultPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyFortuneBloc, DailyFortuneState>(
      builder: (context, state) {
        if (state.status == DailyFortuneStatus.loading ||
            state.status == DailyFortuneStatus.initial) {
          return WaitingScreen(
            duration: const Duration(milliseconds: 3000),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                '운명을 해석중입니다...\n잠시만 기다려주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 0.1
                    ..color = Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'MapoFlowerIsland',
                  height: 2.5,
                ),
              ),
            ),
          );
        }

        if (state.status == DailyFortuneStatus.success &&
            state.dailyFortune != null) {
          return _DailySajuResult(result: state.dailyFortune!);
        }

        return _FailureResultContent(
          error: state.error ?? '운세를 불러오는데 실패했습니다.',
        );
      },
    );
  }
}

class _DailySajuResult extends StatelessWidget {
  const _DailySajuResult({required this.result});

  final DailyFortune result;

  @override
  Widget build(BuildContext context) {
    return AdaptiveColumn(
      portraitPadding: EdgeInsets.zero,
      landscapePadding: EdgeInsets.zero,
      spacing: 40,
      children: [
        _ResultTitle(
          title: '오늘의 운세',
          subtitle: DateFormat(
            'yyyy.MM.dd (E)',
            'ko_KR',
          ).format(DateTime.now()),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, bottom: 60),
          child: Column(
            spacing: 50,
            children: [
              _ResultField(
                title: '🌟 오늘의 총운',
                child: Column(
                  spacing: 20,
                  children: [
                    Center(
                      child: FortuneScoreCircle(number: result.fortuneScore),
                    ),
                    Text(result.totalFortuneMessage),
                  ],
                ),
              ),
              _ResultField(
                title: '📝 오늘의 한마디',
                child: _ShadowContainer(
                  child: Center(
                    child: Text('"${result.todayShortMessage}"'),
                  ),
                ),
              ),
              _ResultField(
                title: '🤝 대인관계운',
                child: Text(result.relationship),
              ),
              _ResultField(
                title: '💎 재물운',
                child: Text(result.wealth),
              ),
              _ResultField(
                title: '❤️  연애운',
                child: Text(result.romantic),
              ),
              _ResultField(
                title: '💊 건강운',
                child: Text(result.health),
              ),
              _ResultField(
                title: '🚨 주의사항',
                child: Text(result.caution),
              ),
              Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: _HomeButton()),
                  Expanded(child: _ShareButton()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultTitle extends StatelessWidget {
  const _ResultTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/daily_top.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 14,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'MapoFlowerIsland',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultField extends StatelessWidget {
  const _ResultField({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
        child,
      ],
    );
  }
}

class _ShadowContainer extends StatelessWidget {
  const _ShadowContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: child,
      ),
    );
  }
}

class _FailureResultContent extends StatelessWidget {
  const _FailureResultContent({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('홈으로'),
          ),
        ],
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.grey[200]),
        foregroundColor: WidgetStateProperty.all(Colors.grey[800]),
      ),
      onPressed: () async {
        await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmationDialog(
            title: '처음으로 돌아가시겠습니까?',
            content: '결과는 자동으로 저장됩니다.',
            confirmText: '예',
            cancelText: '아니오',
            onConfirm: () {
              Navigator.of(context).pop(true);
              context.go('/');
            },
            onCancel: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      },
      child: const Text('처음으로'),
    );
  }
}

class _ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.black),
        foregroundColor: WidgetStateProperty.all(Colors.grey[100]),
      ),
      onPressed: () {
        // TODO: Implement share functionality
      },
      child: const Text('공유하기'),
    );
  }
}
