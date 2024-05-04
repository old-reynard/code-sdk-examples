import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

/// We'll need this to open the Code app
extension on String {
  String toBase64() => base64UrlEncode(utf8.encode(this));
}

/// what is necessary to register a payment intent
typedef PaymentIntent = ({String destination, double amount, String currency});

/// Once an intent has been registered, we'll add this to the deep link to code
typedef TransactionInfo = ({String id, PaymentIntent intent, String clientSecret});

/// Our pretend backend that returns the payment intent secret
class CodeDummyService {
  Future<TransactionInfo> makeIntent(PaymentIntent intent) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return (
      id: 'CHEqwbtFN6jwkt2pYAN47zK9yxkBMUMozekAWJvDcWPW',
      clientSecret: 'RjL7b6V9wXinjX6',
      intent: intent,
    );
  }
}

class TipScreen extends StatefulWidget {
  const TipScreen({super.key});

  @override
  State<TipScreen> createState() => _TipScreenState();
}

class _TipScreenState extends State<TipScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loader = ValueNotifier(false);
  final _controller = TextEditingController();
  final _service = CodeDummyService();

  @override
  void dispose() {
    _loader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Demo'),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _loader,
        builder: (context, loading, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              Text(
                'Enter tip amount:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                    validator: (value) {
                      return switch (value) {
                        String v when v.isEmpty => 'Enter tip amount',
                        String v when double.tryParse(v) == null => 'Enter a number',
                        String v when double.tryParse(v)! >= 5 => 'Max amount is 5 USD',
                        String v when double.tryParse(v)! < .1 => 'Min amount is 0.1 USD',
                        null => 'Enter tip amount',
                        _ => null,
                      };
                    },
                  ),
                ),
              ),
              const SizedBox(height: 64),
              if (loading)
                const CircularProgressIndicator()
              else
                TextButton(
                  onPressed: _onSubmit,
                  child: const Text(
                    'Tip',
                    style: TextStyle(fontSize: 24),
                  ),
                )
            ],
          );
        },
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _loader.value = true;
      var amount = double.parse(_controller.text);
      var intent = (
        // mandatory for Code Sequencer
        amount: amount,
        // hardcoded currency
        currency: 'usd',
        // our receiver
        destination: 'E8otxw1CVX9bfyddKu3ZB3BVLa4VVF9J7CTPdnUwT9jR',
      );
      var info = await _service.makeIntent(intent);

      var payload = {
        "currency": intent.currency,
        "appearance": "dark",
        "destination": intent.destination,
        "amount": intent.amount,
        "mode": "payment",
        "locale": "en",
        "confirmParams": {
          // IMPORTANT: here we'll deep link the callback from Code back to our app
          // there is no full setup for deep links for this app, since it's out of scope of this demo
          // but refer to https://docs.flutter.dev/ui/navigation/deep-linking for more
          //
          // /tip/callback in the path represents our router's setup,
          // where /tip is the address of our tip screen and
          // /callback is a nested route in it.
          // more on routing: https://pub.dev/packages/go_router/
          //
          // furthermore, we pass the transaction id to that screen
          // so that we can register the result there
          "success": {"url": "https://devweb.hvr.world/code/${info.id}/success"},
          "cancel": {"url": "https://devweb.hvr.world/code/${info.id}/cancel"}
        },
        "clientSecret": info.clientSecret,
      };

      var param = jsonEncode(payload).toBase64();

      await launchUrl(
        Uri.parse(
          'codewallet://sdk.getcode.com/v1/elements/payment-request-modal-mobile/#/<random-value-here>/p=$param',
        ),
      );
      _loader.value = false;
    }
  }
}

class CallbackScreen extends StatelessWidget {
  const CallbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/// The route configuration.
final GoRouter _router = GoRouter(
  initialLocation: '/tip',
  routes: <RouteBase>[
    GoRoute(
      path: '/tip',
      builder: (BuildContext context, GoRouterState state) {
        return const TipScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'callback',
          builder: (BuildContext context, GoRouterState state) {
            // this is the deep link route where we'll ask Code to drop us off
            // after the transaction is done
            // by exploring the path of the URL that we'll be providing ourselves,
            // we can understand the results of the transaction
            // NOTE: the Code app does not seem to process query params,
            // so all the info that we want to be returned to us from Code has to be in the path
            final _ = state.uri.pathSegments;

            // since there's no deep link setup for this demo,
            // we won't actually be able to reach this screen
            return const CallbackScreen();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Code Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
