<?php

class AuthorGateway {
  private $connection;
  public function __construct() {
    $this->connection = createConnection();
  }
  public function getAll(): array {
    $statement = $this->connection->query("SELECT * FROM authors");
    $authors = $statement->fetchAll(PDO::FETCH_ASSOC);
    for ($i = 0; $i < count($authors); $i++) {
      unset($authors[$i]["email"]);
      unset($authors[$i]["password"]);
    }
    // set followers and following
    for ($i = 0; $i < count($authors); $i++) {
      $authors[$i]["followers"] = $this->getFollowers($authors[$i]["id"]);
      $authors[$i]["following"] = $this->getFollowing($authors[$i]["id"]);
    }
    return $authors;
  }
  public function getById(int $id): array | false {
    $statement = $this->connection->prepare("SELECT * FROM authors WHERE id = :id");
    $statement->bindParam(":id", $id, PDO::PARAM_INT);
    $statement->execute();
    $author = $statement->fetch(PDO::FETCH_ASSOC);
    $author["followers"] = $this->getFollowers($id);
    $author["following"] = $this->getFollowing($id);
    return $author;
  }
  public function getByUsername(string $username): array | false {
    $statement = $this->connection->prepare("SELECT * FROM authors WHERE username = :username");
    $statement->bindParam(":username", $username, PDO::PARAM_STR);
    $statement->execute();
    $author = $statement->fetch(PDO::FETCH_ASSOC);
    return $author;
  }
  public function getComments(int $author_id): array {
    $statement = $this->connection->prepare("SELECT * FROM comments WHERE author_id = :author_id");
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    $comments = $statement->fetchAll(PDO::FETCH_ASSOC);
    return $comments;
  }
  public function getLikes(int $author_id): array {
    $statement = $this->connection->prepare("SELECT * FROM likes WHERE author_id = :author_id");
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    $likes = $statement->fetchAll(PDO::FETCH_ASSOC);
    return $likes;
  }
  public function getNotifications(int $author_id): array {
    $statement = $this->connection->prepare("SELECT * FROM notifications WHERE recipient_id = :author_id order by id desc");
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    $notifications = $statement->fetchAll(PDO::FETCH_ASSOC);
    return $notifications;
  }
  public function getFollowers(int $author_id): array {
    $statement = $this->connection->prepare("SELECT follower_id FROM followers WHERE following_id = :author_id");
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    $followers = $statement->fetchAll(PDO::FETCH_COLUMN);
    return $followers;
  }
  public function getFollowing(int $author_id): array {
    $statement = $this->connection->prepare("SELECT following_id FROM followers WHERE follower_id = :author_id");
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    $following = $statement->fetchAll(PDO::FETCH_COLUMN);
    return $following;
  }
  public function getBookmarks(int $author_id): array {
    $statement = $this->connection->prepare("SELECT blog_id FROM bookmarks WHERE author_id = :author_id");
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    $bookmarkIds = $statement->fetchAll(PDO::FETCH_COLUMN);
    return $bookmarkIds;
  }

  



  public function insert(Author $author): int {
    $statement = $this->connection->prepare("INSERT INTO authors (username, password, email, name, bio, image) VALUES (:username, :password, :email, :name, :bio, :image)");
    $statement->bindParam(":username", $author->username, PDO::PARAM_STR);
    $statement->bindParam(":password", $author->password, PDO::PARAM_STR);
    $statement->bindParam(":email", $author->email, PDO::PARAM_STR);
    $statement->bindParam(":name", $author->name, PDO::PARAM_STR);
    $statement->bindParam(":bio", $author->bio ?? "", PDO::PARAM_STR);
    $statement->bindParam(":image", $author->image ?? "", PDO::PARAM_STR);
    $statement->execute();
    $id = $this->connection->lastInsertId();
    return $id;
  }
  public function update(Author $new, int $id): int {
    $statement = $this->connection->prepare("UPDATE authors SET username = :username, password = :password, email = :email, name = :name, bio = :bio, image = :image WHERE id = :id");
    $statement->bindParam(":id", $id, PDO::PARAM_INT);
    $statement->bindParam(":username", $new->username, PDO::PARAM_STR);
    $statement->bindParam(":password", $new->password, PDO::PARAM_STR);
    $statement->bindParam(":email", $new->email, PDO::PARAM_STR);
    $statement->bindParam(":name", $new->name, PDO::PARAM_STR);
    $statement->bindParam(":bio", $new->bio , PDO::PARAM_STR);
    $statement->bindParam(":image", $new->image , PDO::PARAM_STR);
    $statement->execute();
    return $statement->rowCount();
  }
  public function delete(int $id): int {
    $statement = $this->connection->prepare("DELETE FROM authors WHERE id = :id");
    $statement->bindParam(":id", $id, PDO::PARAM_INT);
    $statement->execute();
    return $statement->rowCount();
  }
  public function insertBookmark(int $blog_id, int $author_id): int {
    $statement = $this->connection->prepare("INSERT INTO bookmarks (blog_id, author_id) VALUES (:blog_id, :author_id)");
    $statement->bindParam(":blog_id", $blog_id, PDO::PARAM_INT);
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    $id = $this->connection->lastInsertId();
    return $id;
  }
  public function deleteBookmark(int $blog_id, int $author_id): int {
    $statement = $this->connection->prepare("DELETE FROM bookmarks WHERE blog_id = :blog_id AND author_id = :author_id");
    $statement->bindParam(":blog_id", $blog_id, PDO::PARAM_INT);
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    return $statement->rowCount();
  }
  public function insertFollow(int $follower_id, int $following_id): int {
    $statement = $this->connection->prepare("INSERT INTO followers (follower_id, following_id) VALUES (:follower_id, :following_id)");
    $statement->bindParam(":follower_id", $follower_id, PDO::PARAM_INT);
    $statement->bindParam(":following_id", $following_id, PDO::PARAM_INT);
    $statement->execute();
    $id = $this->connection->lastInsertId();
    return $id;
  }
  public function deleteFollow(int $follower_id, int $following_id): int {
    $statement = $this->connection->prepare("DELETE FROM followers WHERE follower_id = :follower_id AND following_id = :following_id");
    $statement->bindParam(":follower_id", $follower_id, PDO::PARAM_INT);
    $statement->bindParam(":following_id", $following_id, PDO::PARAM_INT);
    $statement->execute();
    return $statement->rowCount();
  }
  public function readNotifications(int $author_id): int {
    $statement = $this->connection->prepare("UPDATE notifications SET is_read = 1 WHERE author_id = :author_id");
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    return $statement->rowCount();
  }
  public function readNotification(int $author_id, int $notification_id): int {
    $statement = $this->connection->prepare("UPDATE notifications SET is_read = 1 WHERE recipient_id = :author_id AND id = :notification_id");
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->bindParam(":notification_id", $notification_id, PDO::PARAM_INT);
    $statement->execute();
    return $statement->rowCount();
  }
  public function deleteNotifications(int $author_id): int {
    $statement = $this->connection->prepare("DELETE FROM notifications WHERE recipient_id = :author_id");
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    return $statement->rowCount();
  }
  public function deleteNotification(int $author_id, int $notification_id): int {
    $statement = $this->connection->prepare("DELETE FROM notifications WHERE id = :notification_id AND recipient_id = :author_id");
    $statement->bindParam(":notification_id", $notification_id, PDO::PARAM_INT);
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    return $statement->rowCount();
  }
}


?>
