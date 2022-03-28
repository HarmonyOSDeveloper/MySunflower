// ignore_for_file: prefer_const_constructors

class ServerIpManager {
  ServerIpManager._privateConstructor();

  static final ServerIpManager _instance =
      ServerIpManager._privateConstructor();

  String _ip = '';

  static ServerIpManager get instance => _instance;

  get ip => _ip;
  set ip(newIp) => _ip = newIp;
}
