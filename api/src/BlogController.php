<?php

class BlogController {
  private Route $route;
  private BlogGateway $gateway;

  public function __construct(Route $route) {
    $this->route = $route;
    $this->gateway = new BlogGateway();
  }

  /**
   * Handles the request and returns the response
   * @return array The response
   */
  public function handleRequest(): array {
    $method = $this->route->method;
    $secondaryRoute = $this->route->secondaryRoute;
    $baseId = $this->route->id;
    $secondaryId = $this->route->secondaryId;

    switch ($method) {
      case "GET":
        switch ($secondaryRoute) {
          case null:
            if ($baseId === 0) {
              return $this->gateway->getAll();
            }
            $blog = $this->gateway->getById($baseId);
            if ($blog === false) {
              http_response_code(404);
              return ["message"=>"Blog $baseId not found"];
            }
            return $blog;
          case "tags":
            if ($secondaryId === 0) {
              return $this->gateway->getAllTags();
            }
            $blog = $this->gateway->getById($baseId);
            return $this->gateway->getTagBlogs($blog["tag_id"]);
          case "likes":
            if ($secondaryId === 0) {
              return $this->gateway->getLikes($baseId);
            }
            return $this->gateway->getCommentLikes($secondaryId);
          case "comments":
            if ($secondaryId === 0) {
              return $this->gateway->getComments($baseId);
            }
            return $this->gateway->getCommentById($secondaryId);
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
          case null:
            $blogData = (array) json_decode(file_get_contents("php://input"));
            $blogData["author_id"] = $id;
            $blog = new Blog($blogData);
            $blogId = $this->gateway->insert($blog);
            $newBlog = $this->gateway->getById($blogId);
            http_response_code(201);
            return ["data"=>$newBlog];
          case "likes":
            if ($secondaryId === 0) {
              $blogLikes = $this->gateway->getLikes($baseId);
              foreach ($blogLikes as $like) {
                if ($like === $id) {
                  handleUnauthorized();
                  exit();
                }
              }
              $this->gateway->insertLike($baseId, $id);
              http_response_code(201);
              return ["message"=>"Succesfully liked blog"];
            }
            $this->gateway->insertCommentLike($secondaryId, $id);
            http_response_code(201);
            return ["message"=>"Successfully liked comment"];
          case "comments":
            $commentData = (array) json_decode(file_get_contents("php://input"));
            $this->gateway->insertComment($baseId, $id, $commentData["content"]);
            http_response_code(201);
            return ["message"=>"Successfully commented"];
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
            $cur = new Blog($this->gateway->getById($baseId));
            if ($cur->author_id !== $id) {
              handleUnauthorized();
              exit();
            }
            $blogData = (array) json_decode(file_get_contents("php://input"));
            $blogData["author_id"] = $id;
            $new = new Blog($blogData);
            $this->gateway->update($cur, $new);
            return ["message"=>"Successfully updated blog"];
          case "comments":
            $cur = $this->gateway->getCommentById($secondaryId);
            if ($cur["author_id"] !== $id) {
              handleUnauthorized();
              exit();
            }
            $commentData = (array) json_decode(file_get_contents("php://input"));
            $this->gateway->updateComment($secondaryId, $commentData["content"]);
            return ["message"=>"Successfully updated comment"];
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
            $blog = $this->gateway->getById($baseId);
            if ($blog === false) {
              http_response_code(404);
              return ["message"=>"Blog $baseId not found"];
            }
            if ($blog["author_id"] !== $id) {
              handleUnauthorized();
              exit();
            }
            $this->gateway->delete($baseId);
            return ["message"=>"Successfully deleted blog"];
          case "likes":
            if ($secondaryId === 0) {
              $this->gateway->deleteLike($baseId, $id);
              return ["message"=>"Successfully unliked blog"];
            }
            $this->gateway->deleteCommentLike($secondaryId, $id);
            return ["message"=>"Successfully unliked comment"];
          case "comments":
            if ($secondaryId === 0) {
              handleInvalidRoute();
              exit();
            }
            $comment = $this->gateway->getCommentById($secondaryId);
            if ($comment === false) {
              http_response_code(404);
              return ["message"=>"Comment $secondaryId not found"];
            }
            if ($comment["author_id"] !== $id) {
              handleUnauthorized();
              exit();
            }
            $this->gateway->deleteComment($secondaryId);
            return ["message"=>"Successfully deleted comment"];
          default:
            handleInvalidRoute();
            exit();
        }

      default:
        return handleInvalidRoute();
    }
  }
}

?>
