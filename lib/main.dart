import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_maps/controllers/localization_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  //garante que os widgets serão bem inicializados
  WidgetsFlutterBinding.ensureInitialized();

  //inicializando variavel de ambiente
  await FlutterConfig.loadEnvVariables();

  //inicializando o localization controller
  Get.put(LocalizationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//Isso deve ficar em uma pasta chamada views
//vou deixar aqui só para ver o que mudei
class _MyHomePageState extends State<MyHomePage> {
  //chamei o localizationController
  var localizationController = Get.find<LocalizationController>();

  @override
  void initState() {
    super.initState();
    //Pega a posição assim que entra na tela
    localizationController.getPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      //o corpo agora é o proprio map
      body: Center(
        //Obx para atualizar os valores de latitude e longitude quando necessario e chama o GoogleMap que é o mapa
        child: Obx(() => localizationController.erro.value == ''
            ? GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(localizationController.latitude.value,
                        localizationController.longitude.value),
                    zoom: 18),
                //permite que você se mova no mapa
                scrollGesturesEnabled: true,

                //permite que dê um zoom
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,

                //mostra a sua localização
                myLocationEnabled: true,
              )
            //caso tenha algum erro de autorização é mostrado para o usuário
            : Center(
                child: Card(
                  color: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 170,
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.warning_amber),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(localizationController.erro.value),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
      ),
    );
  }
}
