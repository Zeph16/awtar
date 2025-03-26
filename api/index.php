<?php
require __DIR__ . "/helpers.php";
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: *');
header('Access-Control-Allow-Headers: *');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
  http_response_code(200);
  exit();
}

spl_autoload_register(function ($class_name) {
  require __DIR__ . "/src/$class_name.php";
});
set_error_handler("handleError");
set_exception_handler("handleException");

if (isset($_GET['sse'])) {
    require 'sse.php';
    exit();
}

header("Content-type: application/json; charset=utf-8");
http_response_code(200);

$route = new Route($_SERVER["REQUEST_URI"]);

switch ($route->baseRoute) {
  case "blogs":
    $controller = new BlogController($route);
    break;
  case "authors":
    $controller = new AuthorController($route);
    break;
  default:
    handleInvalidRoute();
    exit();
}

$response = $controller->handleRequest();
echo json_encode($response);
    
?>
