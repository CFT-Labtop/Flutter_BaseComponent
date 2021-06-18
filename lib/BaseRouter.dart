import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
abstract class BaseRouter {
  FluroRouter? fluroRouter;
  void configureRoutes();
  BaseRouter init(BaseRouter baseRouter){
    baseRouter.fluroRouter = new FluroRouter();
    return baseRouter;
  }
  Future<dynamic> goToPage(BuildContext context, Pages page, {TransitionType? type, bool replace = false, bool clear = false, String parameters = "", RouteSettings? routeSettings}) async {
    return await this.fluroRouter!.navigateTo(context, "/" + page.getName() + parameters,transition: type ?? TransitionType.native,replace: replace,clearStack: clear, routeSettings: routeSettings);
  }
}

class Pages{
  final String page;
  const Pages(this.page);
  String getName(){
    return this.page;
  }
}