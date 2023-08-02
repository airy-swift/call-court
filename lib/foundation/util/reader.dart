import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef Reader = T Function<T>(AlwaysAliveRefreshable<T> provider);