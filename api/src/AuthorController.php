<?php

class AuthorController {
  private Route $route;
  private AuthorGateway $gateway;

  public function __construct(Route $route) {
    $this->route = $route;
    $this->gateway = new AuthorGateway();
  }

  /** @return array<string, mixed> */
  public function handleRequest(): array {
    $method = $this->route->method;
    $secondaryRoute = $this->route->secondaryRoute;
    $baseId = $this->route->id;
    $secondaryId = $this->route->secondaryId;


    switch ($method) {
      case "GET":
        if ($baseId === 0 && $secondaryRoute !== null) {
          handleInvalidRoute();
          exit();
        }
        switch ($secondaryRoute) {
          case null:
            if ($baseId === 0) {
              $authors = $this->gateway->getAll();
              return $authors;
            }
            $author = $this->gateway->getById($baseId);
            if ($author === false) {
              http_response_code(404);
              return ["message"=>"author $baseId not found"];
            }
            if (checkAuthorized() !== $baseId) {
              unset($author["email"]);
              unset($author["password"]);
            }
            return $author;
          case "followers":
            return $this->gateway->getFollowers($baseId);
          case "following":
            return $this->gateway->getFollowing($baseId);
          case "notifications":
            $id = checkAuthorized();
            if ($id === 0 || $id !== $baseId) {
              handleUnauthorized();
              exit();
            }
            return $this->gateway->getNotifications($id);
          case "bookmark":
            return $this->gateway->getBookmarks($baseId);
          default:
            handleInvalidRoute();
            exit();
        }

            

      case "POST":
        $id = checkAuthorized();
        if ($id === 0) {
          handleUnauthorized();
          exit();
        }
        switch($secondaryRoute) {
          case "follow":
            $this->gateway->insertFollow($id, $baseId);
            return ["message"=>"Successfully followed author $baseId"];
          case "bookmark":
            $this->gateway->insertBookmark($secondaryId, $id);
            return ["message"=>"Successfully bookmarked blog $secondaryId"];
          default:
            handleInvalidRoute();
            exit();
        }



      case "PUT":
        $id = checkAuthorized();
        if ($id === 0) {
          handleUnauthorized();
          exit();
        }
        switch($secondaryRoute) {
          case null:
            $authorData = (array) json_decode(file_get_contents("php://input"));
            $author = new Author($authorData);
            $this->gateway->update($author, $id);
            return ["message"=>"Successfully updated author $id"];
          case "notifications":
            if ($secondaryId !== null) {
              $this->gateway->readNotification($id, $secondaryId);
              return ["message"=>"Successfully read notification $secondaryId"];
            }
            $this->gateway->readNotifications($id);
            return ["message"=>"Successfully read notifications"];

          default:
            handleInvalidRoute();
            exit();
        }



      case "DELETE":
        $id = checkAuthorized();
        if ($id === 0) {
          handleUnauthorized();
          exit();
        }
        switch($secondaryRoute) {
          case null:
            $blogGateway = new BlogGateway();
            $blogs = $blogGateway->getByAuthor($id);
            foreach ($blogs as $blog) {
              $blogGateway->delete($blog["id"]);
            }
            $this->gateway->delete($id);
            return ["message"=>"Successfully deleted author $id"];
          case "follow":
            $this->gateway->deleteFollow($id, $baseId);
            return ["message"=>"Successfully unfollowed author $baseId"];
          case "bookmark":
            $this->gateway->deleteBookmark($secondaryId, $id);
            return ["message"=>"Successfully unbookmarked blog $secondaryId"];
          case "notifications":
            if ($secondaryId !== null) {
              $this->gateway->deleteNotification($id, $secondaryId);
              return ["message"=>"Successfully deleted notification $secondaryId"];
            }
            $this->gateway->deleteNotifications($id);
            return ["message"=>"Successfully deleted notifications"];
  
          default:
            handleInvalidRoute();
            exit();
        }

      default:
        handleInvalidRoute();
        exit();
    }
  }
}

?>
