<?php

class Author
{
  public ?int $id;
  public string $username;
  public string $password;
  public string $email;
  public string $name;
  public ?string $bio;
  public ?string $image;
  public ?string $joined_at;
  /**
   * @param array $data
   */
  public function __construct(array $data)
  {
    $this->validateData($data);
    $this->id = isset($data['id']) ? $data['id'] : null;
    $this->username = $data['username'];
    $this->name = $data['name'];
    $this->email = $data['email'];
    $this->password = $data['password'];
    $this->bio = isset($data['bio']) ? $data['bio'] : null;
    $this->image = isset($data['image']) ? $data['image'] : null;
    $this->joined_at = isset($data['created_at']) ? $data['created_at'] : null;
  }
  /**
   * @param array $data
   */
  public function validateData(array $data): void
  {
    if (!isset($data['username']) 
      || !isset($data['password'])
      || !isset($data['email']) 
      || !isset($data['name']) 
      ) {
      throw new Exception("Missing data for Author creation", 1);
    }
  }
}


?>
