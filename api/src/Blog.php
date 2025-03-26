<?php

class Blog 
{
  public ?int $id;
  public int $author_id;
  public string $title;
  public string $content;
  public ?string $image;
  public ?string $created_at;
  public ?string $updated_at;
  public ?bool $featured;
  public string $tag;

  /**
   * @param array $data
   */
  public function __construct(array $data)
  {
    $this->validateData($data);
    $this->id = isset($data['id']) ? $data['id'] : null;
    $this->author_id = $data['author_id'];
    $this->title = $data['title'];
    $this->content = $data['content'];
    $this->image = isset($data['image']) ? $data['image'] : null;
    $this->created_at = isset($data['created_at']) ? $data['created_at'] : null;
    $this->updated_at = isset($data['updated_at']) ? $data['updated_at'] : null;
    $this->featured = isset($data['featured']) ? $data['featured'] : null;
    $this->tag = $data['tag'];
  }
  /**
   * @param array $data
   */
  public function validateData(array $data): void
  {
    if (!isset($data['author_id']) 
      || !isset($data['title']) 
      || !isset($data['content'])
      || !isset($data['tag'])
      ) {
      throw new Exception("Missing data for Blog creation", 1);
    }
  }

}

?>
