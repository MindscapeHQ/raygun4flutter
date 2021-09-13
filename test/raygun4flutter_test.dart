import 'package:flutter_test/flutter_test.dart';
import 'package:raygun4flutter/raygun4flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  test('init', () {
    Raygun.init(apiKey: 'KEY');
  }, skip: true);

  test('init with version', () {
    Raygun.init(apiKey: 'KEY', version: 'x.y.z');
  }, skip: true);

  test('sendException without StackTrace', () {
    Raygun.sendException(error: Exception('MESSAGE'));
  }, skip: true);

  test('sendException with StackTrace', () {
    Raygun.sendException(
      error: Exception('MESSAGE'),
      stackTrace: StackTrace.current,
    );
  }, skip: true);

  test('sendException with tags', () {
    Raygun.sendException(
        error: Exception('MESSAGE'),
        stackTrace: StackTrace.current,
        tags: ['tag1', 'tag2']);
  }, skip: true);

  test('Breadcrumb', () {
    Raygun.recordBreadcrumb('BREADCRUMB');
  }, skip: true);

  test('UserId with ID', () {
    Raygun.setUserId('ID');
  }, skip: true);

  test('UserId to null', () {
    Raygun.setUserId(null);
    // todo
  }, skip: true);

  test('Set user with RaygunUserInfo', () {
    final raygunUserInfo = RaygunUserInfo(
      identifier: 'ID',
      firstName: 'FIRST',
      fullName: 'FULL',
      email: 'EMAIL',
    );
    Raygun.setUser(raygunUserInfo);
    // todo
  }, skip: true);

  test('Send custom breadcrumb', () {
    final object = RaygunBreadcrumbMessage(message: 'MESSAGE');
    Raygun.recordBreadcrumbObject(object);
    final object2 = RaygunBreadcrumbMessage(
      message: 'MESSAGE',
      category: 'CATEGORY',
      level: RaygunBreadcrumbLevel.error,
      customData: {'test': 'value'},
      className: 'CLASS',
      methodName: 'METHOD',
      lineNumber: 'LINE',
    );
    Raygun.recordBreadcrumbObject(object2);
    // todo
  }, skip: true);
}
