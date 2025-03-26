<?php

class Route {
  public string $baseRoute;
  public string $method;
  public ?int $id;
  public ?string $secondaryRoute;
  public ?int $secondaryId;

  public function __construct(string $URI) {
    $parts = explode("/", $URI);
    $this->baseRoute = $parts[1] ?? null;
    $this->id = (int) ($parts[2] ?? null);
    if ($this->id === 0 && isset($parts[2]) && $parts[2] !== "") {
      handleInvalidRoute();
      exit();
    }
    $this->method = $_SERVER["REQUEST_METHOD"];
    $this->secondaryRoute = $parts[3] ?? null;
    $this->secondaryId = (int) ($parts[4] ?? null);
  }
}

?>
