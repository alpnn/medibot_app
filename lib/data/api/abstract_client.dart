abstract class AbstractClient {
  static const clientScheme = "https";
  static const clientHost = "medibot.app";
  static const clientPort = 443;

  Uri buildUri(String path){
    return Uri(
      scheme: clientScheme,
      host: clientHost,
      port: clientPort,
      path: path
    );
  }
}