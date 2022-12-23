import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController {
  ///variavel que guarda a latitude atual do dispositivo
  RxDouble latitude = (0.0).obs;

  ///variavel que guarda a longitude atual do dispositivo
  RxDouble longitude = (0.0).obs;

  ///variavel que guardará um erro caso ocorra
  RxString erro = ''.obs;

  ///vamos pegar a posição atual do dispositivo
  Future<Position> _posicaoAtual() async {
    //permissão para acessar a localização

    LocationPermission permission;

    //verifica se o serviço de localização está ativado
    bool localizacaoAtivada = await Geolocator.isLocationServiceEnabled();

    //caso não esteja ativado, pediremos para o usuário ativar
    if (!localizacaoAtivada) {
      return Future.error('Por favor, habilite a localização');
    }

    //checar se o nosso app já possui permissão para acessar a localização
    permission = await Geolocator.checkPermission();

    //caso o nosso app não tenha permissão
    if (permission == LocationPermission.denied) {
      //mostra a tela pedindo permissão
      permission = await Geolocator.requestPermission();
      //caso o usuario negue a permissão
      if (permission == LocationPermission.denied) {
        return Future.error('Por favor, autorize nosso app manualmente');
      }
    }

    //caso o usuario clicou no nunca
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Por favor, autorize nosso app manualmente');
    }
    //se temos permissão
    return await Geolocator.getCurrentPosition();
  }

  ///Guarda a posição atual
  Position? position;

  ///pega a posição atual e atualiza as variaveis observadas
  getPosition() async {
    try {
      position = await _posicaoAtual();
      latitude.value = position!.latitude;
      longitude.value = position!.longitude;
    } catch (e) {
      //caso ocorra um erro atualiza a variavel
      erro.value = e.toString();
    }
  }
}
