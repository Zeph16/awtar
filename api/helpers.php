<?php

function createConnection() {
  return new PDO("mysql:host=awtar-mysql;dbname=awtar", "awtar", "awtar");
}

function handleException(Throwable $exception) {
  http_response_code(500);
  
  echo json_encode([
      "code" => $exception->getCode(),
      "message" => $exception->getMessage(),
      "file" => $exception->getFile(),
      "line" => $exception->getLine()
  ]);
}

function handleError (
  int $errno,
  string $errstr,
  string $errfile,
  int $errline
): bool 
{
  throw new ErrorException($errstr, 0, $errno, $errfile, $errline);
}

function handleInvalidRoute() {
  http_response_code(405);
  echo json_encode(["message"=>"Method $_SERVER[REQUEST_METHOD] not allowed for route $_SERVER[REQUEST_URI]"]);
}
function handleUnauthorized() {
  http_response_code(401);
  echo json_encode(["message"=>"Unauthorized"]);
}

function secretKey() {
  return "secretkey";
}

function checkAuthorized() {
  if (!isset($_SERVER['HTTP_X_TOKEN'])) {
    return 0;
  }
  $token = $_SERVER['HTTP_X_TOKEN'];

  $parts = explode('.', $token);
  $payloadId = $parts[0];
  $signature = $parts[1];
  $expectedSignature = hash_hmac('sha256', $payloadId, secretKey());

  if ($signature === $expectedSignature) {
    $id = json_decode($payloadId);
    return $id;
  }
  return 0;
}

function writeSSEMessage($message)
{
    $file = fopen('messages.txt', 'a');
    fwrite($file, $message . PHP_EOL);
    fclose($file);
}

function readSSEMessage()
{
    $messages = file('messages.txt', FILE_IGNORE_NEW_LINES);

    if (count($messages) > 0) {
        $message = $messages[0];
        array_shift($messages);
        file_put_contents('messages.txt', implode(PHP_EOL, $messages));
        return $message;
    }

    return null;
}
?>
