<?php

class EventGateway {
  private $connection;
  public function __construct() {
    $this->connection = createConnection();
  }

  public function getAll(): array {
    $statement = $this->connection->query("SELECT * FROM events");
    $events = $statement->fetchAll(PDO::FETCH_ASSOC);
    return $events;
  }
  public function getById(int $id): array | false {
    $statement = $this->connection->prepare("SELECT * FROM events WHERE id = :id");
    $statement->bindParam(":id", $id, PDO::PARAM_INT);
    $statement->execute();
    $event = $statement->fetch(PDO::FETCH_ASSOC);
    return $event;
  }
  public function getLast(): array | false {
    $statement = $this->connection->query("SELECT * FROM events ORDER BY id DESC LIMIT 1");
    $event = $statement->fetch(PDO::FETCH_ASSOC);
    return $event;
  }

  public function getNext(int $id): array | false {
    $statement = $this->connection->prepare("SELECT * FROM events WHERE id > :id ORDER BY id ASC LIMIT 1");
    $statement->bindParam(":id", $id, PDO::PARAM_INT);
    $statement->execute();
    $event = $statement->fetch(PDO::FETCH_ASSOC);
    return $event;
  }
}

?>
