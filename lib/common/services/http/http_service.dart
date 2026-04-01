/// Interface abstrata para serviços HTTP
/// Permite trocar implementação (Dio, http, etc) via DI
abstract class HttpService {
  /// Realiza uma requisição GET
  ///
  /// [path] Caminho da requisição (ex: '/users')
  /// [queryParameters] Parâmetros de query string (opcional)
  /// [headers] Headers customizados (opcional)
  ///
  /// Returns [HttpResponse] com os dados da resposta
  Future<HttpResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  /// Realiza uma requisição POST
  ///
  /// [path] Caminho da requisição
  /// [data] Dados do body (opcional)
  /// [queryParameters] Parâmetros de query string (opcional)
  /// [headers] Headers customizados (opcional)
  ///
  /// Returns [HttpResponse] com os dados da resposta
  Future<HttpResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  /// Realiza uma requisição PUT
  ///
  /// [path] Caminho da requisição
  /// [data] Dados do body (opcional)
  /// [queryParameters] Parâmetros de query string (opcional)
  /// [headers] Headers customizados (opcional)
  ///
  /// Returns [HttpResponse] com os dados da resposta
  Future<HttpResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  /// Realiza uma requisição PATCH
  ///
  /// [path] Caminho da requisição
  /// [data] Dados do body (opcional)
  /// [queryParameters] Parâmetros de query string (opcional)
  /// [headers] Headers customizados (opcional)
  ///
  /// Returns [HttpResponse] com os dados da resposta
  Future<HttpResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  /// Realiza uma requisição DELETE
  ///
  /// [path] Caminho da requisição
  /// [queryParameters] Parâmetros de query string (opcional)
  /// [headers] Headers customizados (opcional)
  ///
  /// Returns [HttpResponse] com os dados da resposta
  Future<HttpResponse> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  /// Realiza download de arquivo
  ///
  /// [path] URL completa do arquivo
  /// [savePath] Caminho local onde o arquivo será salvo
  /// [headers] Headers customizados (opcional)
  /// [onReceiveProgress] Callback de progresso (opcional)
  ///
  /// Returns [HttpResponse] indicando sucesso do download
  Future<HttpResponse> download(
    String path,
    String savePath, {
    Map<String, dynamic>? headers,
    void Function(int received, int total)? onReceiveProgress,
  });
}

/// Resposta HTTP agnóstica de implementação
class HttpResponse {
  const HttpResponse({
    required this.data,
    required this.statusCode,
    this.statusMessage,
    this.headers,
  });

  /// Dados da resposta (pode ser Map, List, String, etc)
  final dynamic data;

  /// Código de status HTTP (200, 404, etc)
  final int statusCode;

  /// Mensagem de status (opcional)
  final String? statusMessage;

  /// Headers da resposta (opcional)
  final Map<String, dynamic>? headers;
}
