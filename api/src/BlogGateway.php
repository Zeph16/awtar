<?php

class BlogGateway {
  private $connection;
  public function __construct() {
    $this->connection = createConnection();
  }
  public function getAll(): array {
    $statement = $this->connection->query("SELECT blogs.*, tags.name AS tag FROM blogs JOIN tags ON blogs.tag_id = tags.id");
    $blogs = $statement->fetchAll(PDO::FETCH_ASSOC);
    $blogsWithLikes = [];
    foreach ($blogs as $blog) {
      $blog["likes"] = $this->getLikes($blog["id"]);
      $blogsWithLikes[] = $blog;
    }
    return $blogsWithLikes;
  }
  public function getById(int $id): array | false {
    $statement = $this->connection->prepare("SELECT blogs.*, tags.name AS tag 
                                            FROM blogs JOIN tags ON blogs.tag_id = tags.id WHERE blogs.id = :id");
    $statement->bindParam(":id", $id, PDO::PARAM_INT);
    $statement->execute();
    $blog = $statement->fetch(PDO::FETCH_ASSOC);
    $blog["likes"] = $this->getLikes($blog["id"]);
    return $blog;
  }
  public function getByAuthor(int $author_id): array {
    $statement = $this->connection->prepare("SELECT * FROM blogs WHERE author_id = :author_id");
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    $blogs = $statement->fetchAll(PDO::FETCH_ASSOC);
    return $blogs;
  }
  public function getComments(int $blog_id): array {
    $statement = $this->connection->prepare("SELECT * FROM comments WHERE blog_id = :blog_id");
    $statement->bindParam(":blog_id", $blog_id, PDO::PARAM_INT);
    $statement->execute();
    $comments = $statement->fetchAll(PDO::FETCH_ASSOC);
    $commentsWithLikes = [];
    foreach ($comments as $comment) {
      $comment["likes"] = $this->getCommentLikes($comment["id"]);
      $commentsWithLikes[] = $comment;
    }
    return $commentsWithLikes;
  }
  public function getCommentById(int $id): array | false {
    $statement = $this->connection->prepare("SELECT * FROM comments WHERE id = :id");
    $statement->bindParam(":id", $id, PDO::PARAM_INT);
    $statement->execute();
    $comment = $statement->fetch(PDO::FETCH_ASSOC);
    if (!$comment) {
      return false;
    }
    $comment["likes"] = $this->getCommentLikes($comment["id"]);
    return $comment;
  }
  public function getLikes(int $blog_id): array {
    $statement = $this->connection->prepare("SELECT author_id FROM likes WHERE blog_id = :blog_id");
    $statement->bindParam(":blog_id", $blog_id, PDO::PARAM_INT);
    $statement->execute();
    $likes = $statement->fetchAll(PDO::FETCH_COLUMN);
    return $likes;
  }
  public function getCommentLikes(int $comment_id): array {
    $statement = $this->connection->prepare("SELECT author_id FROM likes WHERE comment_id = :comment_id");
    $statement->bindParam(":comment_id", $comment_id, PDO::PARAM_INT);
    $statement->execute();
    $likes = $statement->fetchAll(PDO::FETCH_COLUMN);
    return $likes;
  } 
  public function getAllTags(): array {
    $statement = $this->connection->query("SELECT name FROM tags");
    $tags = $statement->fetchAll(PDO::FETCH_COLUMN);
    return $tags;
  }
  public function getTagBlogs(int $tag_id): array {
    $statement = $this->connection->prepare("SELECT * FROM blogs WHERE tag_id = :tag_id");
    $statement->bindParam(":tag_id", $tag_id, PDO::PARAM_INT);
    $statement->execute();
    $tags = $statement->fetchAll(PDO::FETCH_ASSOC);
    return $tags;
  }






  public function insert(Blog $blog): int {
    $statement = $this->connection->prepare("SELECT id FROM tags WHERE name = :name");
    $statement->bindParam(":name", $blog->tag, PDO::PARAM_STR);
    $statement->execute();
    $tag_id = $statement->fetch(PDO::FETCH_ASSOC);
    $statement = $this->connection->prepare("INSERT INTO blogs (title, content, author_id, tag_id, image) VALUES (:title, :content, :author_id, :tag_id, :image)");
    $statement->bindParam(":title", $blog->title, PDO::PARAM_STR);
    $statement->bindParam(":content", $blog->content, PDO::PARAM_STR);
    $statement->bindParam(":author_id", $blog->author_id, PDO::PARAM_INT);
    $statement->bindParam(":image", $blog->image, PDO::PARAM_STR);
    $statement->bindParam(":tag_id", $tag_id, PDO::PARAM_INT);
    $statement->execute();
    $id = $this->connection->lastInsertId();
    return $id;
  }
  public function update(Blog $current, Blog $new): int {
    $statement = $this->connection->prepare("SELECT id FROM tags WHERE name = :name");
    $statement->bindParam(":name", $new->tag, PDO::PARAM_STR);
    $statement->execute();
    $tag_id = $statement->fetch(PDO::FETCH_ASSOC);
    $statement = $this->connection->prepare("UPDATE blogs SET title = :title, content = :content, author_id = :author_id, image = :image, featured = :featured, tag_id = :tag_id, updated_at = current_timestamp WHERE id = :id");
    $statement->bindValue(":title", $new->title ?? $current->title, PDO::PARAM_STR);
    $statement->bindValue(":content", $new->content ?? $current->content, PDO::PARAM_STR);
    $statement->bindValue(":author_id", $new->author_id ?? $current->author_id, PDO::PARAM_INT);
    $statement->bindValue(":featured", $new->featured ?? $current->featured, PDO::PARAM_BOOL);
    $statement->bindValue(":image", $new->image ?? $current->image, PDO::PARAM_STR);
    $statement->bindParam(":tag_id", $tag_id, PDO::PARAM_INT);
    $statement->bindParam(":id", $current->id, PDO::PARAM_INT);
    $statement->execute();
    return $statement->rowCount();
  }
  public function delete(int $id): int {
    $statement = $this->connection->prepare("DELETE FROM blogs WHERE id = :id");
    $statement->bindParam(":id", $id, PDO::PARAM_INT);
    $statement->execute();
    return $statement->rowCount();
  }
  public function insertLike(int $blog_id, int $author_id): int {
    $statement = $this->connection->prepare("INSERT INTO likes (blog_id, author_id) VALUES (:blog_id, :author_id)");
    $statement->bindParam(":blog_id", $blog_id, PDO::PARAM_INT);
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    $id = $this->connection->lastInsertId();
    return $id;
  }
  public function deleteLike(int $blog_id, int $author_id): int {
    $statement = $this->connection->prepare("DELETE FROM likes WHERE blog_id = :blog_id AND author_id = :author_id");
    $statement->bindParam(":blog_id", $blog_id, PDO::PARAM_INT);
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    return $statement->rowCount();
  }
  public function insertCommentLike(int $comment_id, int $author_id): int {
    $statement = $this->connection->prepare("INSERT INTO likes (comment_id, author_id) VALUES (:comment_id, :author_id)");
    $statement->bindParam(":comment_id", $comment_id, PDO::PARAM_INT);
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    $id = $this->connection->lastInsertId();
    return $id;
  }
  public function deleteCommentLike(int $comment_id, int $author_id): int {
    $statement = $this->connection->prepare("DELETE FROM likes WHERE comment_id = :comment_id AND author_id = :author_id");
    $statement->bindParam(":comment_id", $comment_id, PDO::PARAM_INT);
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->execute();
    return $statement->rowCount();
  }
  public function insertComment(int $blog_id, int $author_id, string $content): int {
    $statement = $this->connection->prepare("INSERT INTO comments (blog_id, author_id, content) VALUES (:blog_id, :author_id, :content)");
    $statement->bindParam(":blog_id", $blog_id, PDO::PARAM_INT);
    $statement->bindParam(":author_id", $author_id, PDO::PARAM_INT);
    $statement->bindParam(":content", $content, PDO::PARAM_STR);
    $statement->execute();
    $id = $this->connection->lastInsertId();
    return $id;
  }
  public function deleteComment(int $id): int {
    $statement = $this->connection->prepare("DELETE FROM comments WHERE id = :id");
    $statement->bindParam(":id", $id, PDO::PARAM_INT);
    $statement->execute();
    return $statement->rowCount();
  }
  public function updateComment(int $id, string $content): int {
    $statement = $this->connection->prepare("UPDATE comments SET content = :content, updated_at = current_timestamp WHERE id = :id");
    $statement->bindParam(":content", $content, PDO::PARAM_STR);
    $statement->bindParam(":id", $id, PDO::PARAM_INT);
    $statement->execute();
    return $statement->rowCount();
  }
}
?>
