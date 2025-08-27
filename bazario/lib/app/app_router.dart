import 'package:auto_route/auto_route.dart';
import 'package:bazario/app/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();
  @override
  List<AutoRoute> get routes => [
    /// routes go here
    AutoRoute(page: SplashRoute.page,initial: true),
    AutoRoute(page: CompleteProfileRoute.page),
    AutoRoute(page: LocationRouteViewBody.page),
    AutoRoute(page: OnboardingRoute.page),
    AutoRoute(page: SignInRoute.page),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: VerificationRoute.page),
    AutoRoute(page: WelcomeRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: ProductDetailsRoute.page),
    AutoRoute(page: WishlistRoute.page),
    AutoRoute(page: MyCartRoute.page),
    AutoRoute(page: ProfileRoute.page),
    AutoRoute(page: CheckoutRoute.page),
    AutoRoute(page: ShippingAddressRoute.page),
    AutoRoute(page: PaymentMethodsRoute.page),
    AutoRoute(page: AddCardRoute.page),
    AutoRoute(page: PaymentSuccessfulRoute.page),
    AutoRoute(page: CouponRoute.page),
    AutoRoute(page: MyOrdersRoute.page),
    AutoRoute(page: ShippingTypeRoute.page),
    AutoRoute(page: LeaveReviewRoute.page),
    AutoRoute(page: TrackOrderRoute.page),
    AutoRoute(page: AdminHomeRoute.page),
    AutoRoute(page: AddProductRoute.page),
    AutoRoute(page: UsersManagementRoute.page),
    AutoRoute(page: ManageProductsRoute.page),


  ];
}