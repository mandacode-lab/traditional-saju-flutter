import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:traditional_saju/src/domain/saju/entity/yearly_fortune.dart';
import 'package:traditional_saju/src/infrastructure/di/service_locator.dart';
import 'package:traditional_saju/src/presentation/common/widgets/form/confirmation_dialog.dart';
import 'package:traditional_saju/src/presentation/common/widgets/layouts/adaptive_column.dart';
import 'package:traditional_saju/src/presentation/common/widgets/layouts/waiting_screen.dart';
import 'package:traditional_saju/src/presentation/common/widgets/saju/chart_view.dart';
import 'package:traditional_saju/src/presentation/features/yearly_fortune/bloc/yearly_fortune_bloc.dart';
import 'package:traditional_saju/src/presentation/features/yearly_fortune/bloc/yearly_fortune_event.dart';
import 'package:traditional_saju/src/presentation/features/yearly_fortune/bloc/yearly_fortune_state.dart';

class YearlyFortunePage extends StatelessWidget {
  const YearlyFortunePage({super.key});

  static const routeName = 'yearly-fortune';

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
            final bloc = getIt<YearlyFortuneBloc>();
            // Trigger API call immediately since we only navigate here
            // after form submission
            bloc.add(const YearlyFortuneLoadRequested());
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
    return BlocBuilder<YearlyFortuneBloc, YearlyFortuneState>(
      builder: (context, state) {
        if (state.status == YearlyFortuneStatus.loading ||
            state.status == YearlyFortuneStatus.initial) {
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

        if (state.status == YearlyFortuneStatus.success &&
            state.yearlyFortune != null) {
          return _YearlySajuResult(result: state.yearlyFortune!);
        }

        return _FailureResultContent(
          error: state.error ?? '운세를 불러오는데 실패했습니다.',
        );
      },
    );
  }
}

class _YearlySajuResult extends StatelessWidget {
  const _YearlySajuResult({required this.result});

  final YearlyFortune result;

  @override
  Widget build(BuildContext context) {
    return AdaptiveColumn(
      portraitPadding: EdgeInsets.zero,
      landscapePadding: EdgeInsets.zero,
      spacing: 40,
      children: [
        const _ResultTitle(title: '2025 신년운세'),
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, bottom: 60),
          child: Column(
            spacing: 50,
            children: [
              _ResultField(
                title: '🔍 사주원국표 / 오행분석',
                child: Center(child: ChartView(chart: result.chart)),
              ),
              _ResultField(
                title: '🌟 신년운세 총운',
                child: Text(result.description.general),
              ),
              _ResultField(
                title: '🤝 대인관계운',
                child: Text(result.description.relationship),
              ),
              _ResultField(
                title: '💎 재물운',
                child: Text(result.description.wealth),
              ),
              _ResultField(
                title: '❤️ 연애운',
                child: Text(result.description.romantic),
              ),
              _ResultField(
                title: '💊 건강운',
                child: Text(result.description.health),
              ),
              _ResultField(
                title: '🏢 직장운',
                child: Text(result.description.career),
              ),
              _ResultField(
                title: '🍀 운을 높이는 법',
                child: Text(result.description.waysToImprove),
              ),
              _ResultField(
                title: '🚨 올해의 주의사항',
                child: Text(result.description.caution),
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
  const _ResultTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/yearly_top.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
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
