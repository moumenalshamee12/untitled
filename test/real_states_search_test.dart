import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/features/proreaty/domain/entities/prorety_entity.dart';
import 'package:untitled/features/real_states/domin/entites/real_state_entitey.dart';
import 'package:untitled/features/real_states/presentoin/pages/real_states_body.dart';

void main() {
  testWidgets('search filters real states by name first letter', (
    tester,
  ) async {
    final states = [
      const RealStateEntity(
        id: 1,
        commercialName: 'Al Noor Real Estate',
        address: 'Address 1',
        licenseNumber: '123',
        profileDescription: 'desc',
        phoneNumber: '0500000000',
        isActive: true,
        properties: <PropertyEntity>[],
      ),
      const RealStateEntity(
        id: 2,
        commercialName: 'Blue Sky Realty',
        address: 'Address 2',
        licenseNumber: '456',
        profileDescription: 'desc',
        phoneNumber: '0500000001',
        isActive: true,
        properties: <PropertyEntity>[],
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: RealStatesBody(
          realStates: states,
          onRetry: () {},
          onRefresh: () async {},
        ),
      ),
    );

    final searchField = find.byType(TextField);
    await tester.enterText(searchField, 'a');
    await tester.pump();

    expect(find.text('Al Noor Real Estate'), findsOneWidget);
    expect(find.text('Blue Sky Realty'), findsNothing);
  });
}
