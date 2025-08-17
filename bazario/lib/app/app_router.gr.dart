// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i24;
import 'package:bazario/features/authentication/screens/otp_verification.dart'
    as _i21;
import 'package:bazario/features/authentication/screens/signIn_screen.dart'
    as _i17;
import 'package:bazario/features/authentication/screens/signUp_screen.dart'
    as _i18;
import 'package:bazario/features/checkout&payment/screens/add_cart_screen.dart'
    as _i1;
import 'package:bazario/features/checkout&payment/screens/checkout_screen.dart'
    as _i2;
import 'package:bazario/features/checkout&payment/screens/coupon_screen.dart'
    as _i4;
import 'package:bazario/features/checkout&payment/screens/payment_methods_screen.dart'
    as _i11;
import 'package:bazario/features/checkout&payment/screens/payment_successful_screen.dart'
    as _i12;
import 'package:bazario/features/checkout&payment/screens/shipping_address_screen.dart'
    as _i15;
import 'package:bazario/features/checkout&payment/screens/shipping_type_screen.dart'
    as _i16;
import 'package:bazario/features/home/models/product.dart' as _i26;
import 'package:bazario/features/home/screens/home_screen.dart' as _i5;
import 'package:bazario/features/home/screens/my_cart_screen.dart' as _i8;
import 'package:bazario/features/home/screens/product_details_screen.dart'
    as _i13;
import 'package:bazario/features/home/screens/whishlist_screen.dart' as _i23;
import 'package:bazario/features/location/location_page_view_body.dart' as _i7;
import 'package:bazario/features/onboarding/onboarding.dart' as _i10;
import 'package:bazario/features/order/screens/leave_order_review_screen.dart'
    as _i6;
import 'package:bazario/features/order/screens/my_orders.dart' as _i9;
import 'package:bazario/features/order/screens/track_order_screen.dart' as _i20;
import 'package:bazario/features/Profile&setting/screens/complete_profile.dart'
    as _i3;
import 'package:bazario/features/Profile&setting/screens/profile_screen.dart'
    as _i14;
import 'package:bazario/features/welcome/splash_screen.dart' as _i19;
import 'package:bazario/features/welcome/welcome_screen.dart' as _i22;
import 'package:flutter/material.dart' as _i25;

/// generated route for
/// [_i1.AddCardScreen]
class AddCardRoute extends _i24.PageRouteInfo<void> {
  const AddCardRoute({List<_i24.PageRouteInfo>? children})
      : super(AddCardRoute.name, initialChildren: children);

  static const String name = 'AddCardRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i1.AddCardScreen();
    },
  );
}

/// generated route for
/// [_i2.CheckoutScreen]
class CheckoutRoute extends _i24.PageRouteInfo<void> {
  const CheckoutRoute({List<_i24.PageRouteInfo>? children})
      : super(CheckoutRoute.name, initialChildren: children);

  static const String name = 'CheckoutRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i2.CheckoutScreen();
    },
  );
}

/// generated route for
/// [_i3.CompleteProfileScreen]
class CompleteProfileRoute extends _i24.PageRouteInfo<void> {
  const CompleteProfileRoute({List<_i24.PageRouteInfo>? children})
      : super(CompleteProfileRoute.name, initialChildren: children);

  static const String name = 'CompleteProfileRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i3.CompleteProfileScreen();
    },
  );
}

/// generated route for
/// [_i4.CouponScreen]
class CouponRoute extends _i24.PageRouteInfo<void> {
  const CouponRoute({List<_i24.PageRouteInfo>? children})
      : super(CouponRoute.name, initialChildren: children);

  static const String name = 'CouponRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i4.CouponScreen();
    },
  );
}

/// generated route for
/// [_i5.HomeScreen]
class HomeRoute extends _i24.PageRouteInfo<void> {
  const HomeRoute({List<_i24.PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i5.HomeScreen();
    },
  );
}

/// generated route for
/// [_i6.LeaveReviewScreen]
class LeaveReviewRoute extends _i24.PageRouteInfo<void> {
  const LeaveReviewRoute({List<_i24.PageRouteInfo>? children})
      : super(LeaveReviewRoute.name, initialChildren: children);

  static const String name = 'LeaveReviewRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i6.LeaveReviewScreen();
    },
  );
}

/// generated route for
/// [_i7.LocationPageViewBody]
class LocationRouteViewBody extends _i24.PageRouteInfo<void> {
  const LocationRouteViewBody({List<_i24.PageRouteInfo>? children})
      : super(LocationRouteViewBody.name, initialChildren: children);

  static const String name = 'LocationRouteViewBody';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i7.LocationPageViewBody();
    },
  );
}

/// generated route for
/// [_i8.MyCartScreen]
class MyCartRoute extends _i24.PageRouteInfo<void> {
  const MyCartRoute({List<_i24.PageRouteInfo>? children})
      : super(MyCartRoute.name, initialChildren: children);

  static const String name = 'MyCartRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i8.MyCartScreen();
    },
  );
}

/// generated route for
/// [_i9.MyOrdersScreen]
class MyOrdersRoute extends _i24.PageRouteInfo<void> {
  const MyOrdersRoute({List<_i24.PageRouteInfo>? children})
      : super(MyOrdersRoute.name, initialChildren: children);

  static const String name = 'MyOrdersRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i9.MyOrdersScreen();
    },
  );
}

/// generated route for
/// [_i10.OnboardingScreen]
class OnboardingRoute extends _i24.PageRouteInfo<void> {
  const OnboardingRoute({List<_i24.PageRouteInfo>? children})
      : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i10.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i11.PaymentMethodsScreen]
class PaymentMethodsRoute extends _i24.PageRouteInfo<void> {
  const PaymentMethodsRoute({List<_i24.PageRouteInfo>? children})
      : super(PaymentMethodsRoute.name, initialChildren: children);

  static const String name = 'PaymentMethodsRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i11.PaymentMethodsScreen();
    },
  );
}

/// generated route for
/// [_i12.PaymentSuccessfulScreen]
class PaymentSuccessfulRoute extends _i24.PageRouteInfo<void> {
  const PaymentSuccessfulRoute({List<_i24.PageRouteInfo>? children})
      : super(PaymentSuccessfulRoute.name, initialChildren: children);

  static const String name = 'PaymentSuccessfulRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i12.PaymentSuccessfulScreen();
    },
  );
}

/// generated route for
/// [_i13.ProductDetailsScreen]
class ProductDetailsRoute extends _i24.PageRouteInfo<ProductDetailsRouteArgs> {
  ProductDetailsRoute({
    _i25.Key? key,
    required _i26.Product product,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          ProductDetailsRoute.name,
          args: ProductDetailsRouteArgs(key: key, product: product),
          initialChildren: children,
        );

  static const String name = 'ProductDetailsRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDetailsRouteArgs>();
      return _i13.ProductDetailsScreen(key: args.key, product: args.product);
    },
  );
}

class ProductDetailsRouteArgs {
  const ProductDetailsRouteArgs({this.key, required this.product});

  final _i25.Key? key;

  final _i26.Product product;

  @override
  String toString() {
    return 'ProductDetailsRouteArgs{key: $key, product: $product}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductDetailsRouteArgs) return false;
    return key == other.key && product == other.product;
  }

  @override
  int get hashCode => key.hashCode ^ product.hashCode;
}

/// generated route for
/// [_i14.ProfileScreen]
class ProfileRoute extends _i24.PageRouteInfo<void> {
  const ProfileRoute({List<_i24.PageRouteInfo>? children})
      : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i14.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i15.ShippingAddressScreen]
class ShippingAddressRoute extends _i24.PageRouteInfo<void> {
  const ShippingAddressRoute({List<_i24.PageRouteInfo>? children})
      : super(ShippingAddressRoute.name, initialChildren: children);

  static const String name = 'ShippingAddressRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i15.ShippingAddressScreen();
    },
  );
}

/// generated route for
/// [_i16.ShippingTypeScreen]
class ShippingTypeRoute extends _i24.PageRouteInfo<void> {
  const ShippingTypeRoute({List<_i24.PageRouteInfo>? children})
      : super(ShippingTypeRoute.name, initialChildren: children);

  static const String name = 'ShippingTypeRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i16.ShippingTypeScreen();
    },
  );
}

/// generated route for
/// [_i17.SignInScreen]
class SignInRoute extends _i24.PageRouteInfo<void> {
  const SignInRoute({List<_i24.PageRouteInfo>? children})
      : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i17.SignInScreen();
    },
  );
}

/// generated route for
/// [_i18.SignUpScreen]
class SignUpRoute extends _i24.PageRouteInfo<void> {
  const SignUpRoute({List<_i24.PageRouteInfo>? children})
      : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i18.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i19.SplashScreen]
class SplashRoute extends _i24.PageRouteInfo<void> {
  const SplashRoute({List<_i24.PageRouteInfo>? children})
      : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i19.SplashScreen();
    },
  );
}

/// generated route for
/// [_i20.TrackOrderScreen]
class TrackOrderRoute extends _i24.PageRouteInfo<void> {
  const TrackOrderRoute({List<_i24.PageRouteInfo>? children})
      : super(TrackOrderRoute.name, initialChildren: children);

  static const String name = 'TrackOrderRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i20.TrackOrderScreen();
    },
  );
}

/// generated route for
/// [_i21.VerificationScreen]
class VerificationRoute extends _i24.PageRouteInfo<void> {
  const VerificationRoute({List<_i24.PageRouteInfo>? children})
      : super(VerificationRoute.name, initialChildren: children);

  static const String name = 'VerificationRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i21.VerificationScreen();
    },
  );
}

/// generated route for
/// [_i22.WelcomeScreen]
class WelcomeRoute extends _i24.PageRouteInfo<void> {
  const WelcomeRoute({List<_i24.PageRouteInfo>? children})
      : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i22.WelcomeScreen();
    },
  );
}

/// generated route for
/// [_i23.WishlistScreen]
class WishlistRoute extends _i24.PageRouteInfo<void> {
  const WishlistRoute({List<_i24.PageRouteInfo>? children})
      : super(WishlistRoute.name, initialChildren: children);

  static const String name = 'WishlistRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i23.WishlistScreen();
    },
  );
}
