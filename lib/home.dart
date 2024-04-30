import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WebViewController controller;
  bool isLoading = false; // Flag to track loading state
  bool connectionError = false; // Flag to track connection error

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          return false; // Do not exit the app
        }
        return true; // Exit the app
      },
      child: Scaffold(
        body: Stack(
          children: [
            WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: "https://magicalkenya.com/",
              onPageStarted: (url) {
                setState(() {
                  isLoading = false;
                  connectionError = false;
                });
              },
              onPageFinished: (url) {
                setState(() {
                  isLoading = false;
                });
              },
              onWebViewCreated: (controller) {
                this.controller = controller;
              },
              navigationDelegate: (NavigationRequest request) {
                // Allow loading only if the requested URL is from the same domain
                if (request.url.startsWith("https://magicalkenya.com/")) {
                  return NavigationDecision.navigate;
                } else {
                  // Open external links in the default browser
                  // You can customize this behavior as needed
                  // Launch the URL in the default browser
                  // launch(request.url);
                  return NavigationDecision.prevent;
                }
              },
            ),

            // Show error page when connection error occurs
            Visibility(
              visible: connectionError,
              child: Center(
                child: Text(
                  "Connection error! Check your internet connection and try again.",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),

            // Show loading indicator while content is loading
            Visibility(
              visible: isLoading,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            setState(() {
              isLoading = false;
            });
            controller.reload();
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
