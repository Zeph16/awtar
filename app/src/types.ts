export interface Blog {
  id: number;
  author_id: number;
  title: string;
  content: string;
  created_at: Date;
  updated_at: Date;
  image: string;
  featured: boolean;
  tag: string;
  likes: number[];
}

export interface Author {
  id: number;
  username: string;
  password?: string;
  email?: string;
  name: string;
  bio?: string;
  image?: string;
  followers: number[];
  following: number[];
  joined_at: Date;
}

export interface Tag {
  id: number;
  name: string;
}

export interface Comment {
  id: number;
  blog_id: number;
  author_id: number;
  content: string;
  created_at: Date;
  updated_at: Date;
  likes: number[];
}

export interface Notification {
  id: number;
  recipient_id: number;
  sender_id: number;
  action: string;
  action_id: number;
  created_at: Date;
  is_read: boolean;
}

