import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPage extends StatefulWidget {


  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {


  late final WebViewController controller;

 @override
 
 void initState() {
  
    
    controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(NavigationDelegate(
     onProgress: (int progress) {},
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://inri-company.netlify.app/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse('https://inri-company.netlify.app/'));
    
    super.initState();
   
 }


 

  @override
  Widget build(BuildContext context) {    
   
    
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Terminos y Condiciones", style: TextStyle(
          color: Colors.white,
          fontSize: 22
        ),),
        backgroundColor: Colors.indigo,
        leading: IconButton(
          onPressed: ()=> Navigator.pushReplacementNamed(context, 'login'),
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30)
         ),
        
        ),
     
      body: Stack(
        
        children:[
            
            
            WebViewWidget(controller: controller),
           
            
           
            Align(
              alignment: Alignment.bottomCenter,
              child: navBar(context)
              ) 
        ] 
      ),

      
    );
  }
}

Widget navBar(context){
  return Container(
    height: 65,
    margin: const EdgeInsets.only(
      right: 34,
      left: 34,
      bottom: 24
    ),
    decoration: BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(20),
          blurRadius: 20,
          spreadRadius: 10
        )
      ]
    ),
   child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children:  [
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, 'register'),          
          
          child: Text("ACEPTAR", style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w500),),

        )
       
    ],
   ),
  );
}