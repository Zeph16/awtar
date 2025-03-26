DELIMITER //

CREATE TRIGGER blog_created
AFTER INSERT ON blogs
FOR EACH ROW
BEGIN
  -- Add entry to the events table
  INSERT INTO events (type, data) VALUES ('blogCreated', NEW.id);

  -- Add notification to concerned authors
  INSERT INTO notifications (recipient_id, sender_id, action, action_id)
  SELECT followers.follower_id, NEW.author_id, 'blogCreated', NEW.id
  FROM followers
  WHERE followers.following_id = NEW.author_id;
END//

--------------------------------------------------------------

CREATE TRIGGER blog_edited
AFTER UPDATE ON blogs
FOR EACH ROW
BEGIN
  -- Add entry to the events table
  INSERT INTO events (type, data) VALUES ('blogEdited', OLD.id);

  -- Add notification to concerned authors
  INSERT INTO notifications (recipient_id, sender_id, action, action_id)
  SELECT followers.follower_id, OLD.author_id, 'blogEdited', OLD.id
  FROM followers
  WHERE followers.following_id = OLD.author_id;
END//

--------------------------------------------------------------

CREATE TRIGGER blog_deleted
AFTER DELETE ON blogs
FOR EACH ROW
BEGIN
  -- Add entry to the events table
  INSERT INTO events (type, data) VALUES ('blogDeleted', OLD.id);

  DELETE FROM notifications
    WHERE sender_id = OLD.author_id
      AND action_id = OLD.id
      AND action in ('blogCreated', 'blogEdited');
END//

--------------------------------------------------------------

CREATE TRIGGER author_created
AFTER INSERT ON authors
FOR EACH ROW
BEGIN
  INSERT INTO events (type, data)
  VALUES ('authorCreated', NEW.id);
END//


CREATE TRIGGER author_updated
AFTER UPDATE ON authors
FOR EACH ROW
BEGIN
  INSERT INTO events (type, data)
  VALUES ('authorUpdated', NEW.id);
END//


CREATE TRIGGER author_deleted
AFTER DELETE ON authors
FOR EACH ROW
BEGIN INSERT INTO events (type, data)
  VALUES ('authorDeleted', OLD.id);
END//

DELIMITER ;

--------------------------------------------------------------

CREATE TRIGGER like_created
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
  DECLARE blog_author_id INT;
  DECLARE comment_author_id INT;

  -- Retrieve the blog author ID
  SELECT author_id INTO blog_author_id
  FROM blogs
  WHERE id = NEW.blog_id;

  -- Retrieve the comment author ID
  SELECT author_id INTO comment_author_id
  FROM comments
  WHERE id = NEW.comment_id;


  -- Check if the like is associated with a blog
  IF NEW.blog_id IS NOT NULL THEN
    INSERT INTO events (type, data) VALUES ('blogLiked', NEW.blog_id);
    -- Add notification to the blog author
    INSERT INTO notifications (recipient_id, sender_id, action, action_id)
    VALUES (blog_author_id, NEW.author_id, 'blogLiked', NEW.blog_id);

    -- Add notification to the followers of the blog author (excluding the blog author)
    INSERT INTO notifications (recipient_id, sender_id, action, action_id)
    SELECT followers.follower_id, NEW.author_id, 'authorLiked', NEW.blog_id
    FROM followers
    WHERE followers.following_id = NEW.author_id
      AND followers.follower_id != blog_author_id;
  ELSE
    INSERT INTO events (type, data) VALUES ('commentLiked', NEW.comment_id);
    -- Add notification to the comment author
    INSERT INTO notifications (recipient_id, sender_id, action, action_id)
    VALUES (comment_author_id, NEW.author_id, 'commentLiked', NEW.comment_id);
  END IF;
END//

--------------------------------------------------------------

CREATE TRIGGER like_deleted
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
  DECLARE blog_author_id INT;
  DECLARE comment_author_id INT;

  -- Retrieve the blog author ID
  SELECT author_id INTO blog_author_id
  FROM blogs
  WHERE id = OLD.blog_id;

  -- Retrieve the comment author ID
  SELECT author_id INTO comment_author_id
  FROM comments
  WHERE id = OLD.comment_id;


  -- Check if the like is associated with a blog
  IF OLD.blog_id IS NOT NULL THEN
    INSERT INTO events (type, data) VALUES ('blogUnliked', OLD.blog_id);

    -- Remove the blogLiked notification for the blog author
    DELETE FROM notifications
    WHERE recipient_id = blog_author_id
      AND sender_id = OLD.author_id
      AND action = 'blogLiked'
      AND action_id = OLD.blog_id;

    -- Remove the authorLiked notifications for the followers (excluding the blog author)
    DELETE FROM notifications
    WHERE recipient_id IN (
        SELECT followers.follower_id
        FROM followers
        WHERE followers.following_id = OLD.author_id
          AND followers.follower_id != blog_author_id
      )
      AND sender_id = OLD.author_id
      AND action = 'authorLiked'
      AND action_id = OLD.blog_id;
  ELSE
    INSERT INTO events (type, data) VALUES ('commentUnliked', OLD.comment_id);
    -- Remove the commentLiked notification for the comment author
    DELETE FROM notifications
    WHERE recipient_id = comment_author_id
      AND sender_id = OLD.author_id
      AND action = 'commentLiked'
      AND action_id = OLD.comment_id;
  END IF;
END//

--------------------------------------------------------------

CREATE TRIGGER author_followed
AFTER INSERT ON followers
FOR EACH ROW
BEGIN
  -- Add notification to the followed author
  INSERT INTO notifications (recipient_id, sender_id, action)
  VALUES (NEW.following_id, NEW.follower_id, 'follow');
END//

--------------------------------------------------------------

CREATE TRIGGER comment_created
AFTER INSERT ON comments
FOR EACH ROW
BEGIN
  DECLARE blog_author_id INT;

  -- Retrieve the blog author ID
  SELECT author_id INTO blog_author_id
  FROM blogs
  WHERE id = NEW.blog_id;

  INSERT INTO events (type, data) VALUES ('commentCreated', NEW.id);
  -- Add notification to the blog author
  INSERT INTO notifications (recipient_id, sender_id, action, action_id)
  VALUES (blog_author_id, NEW.author_id, 'newComment', NEW.id);

  -- Add notification to the authors the blog author follows (excluding the blog author and the comment author)
  INSERT INTO notifications (recipient_id, sender_id, action, action_id)
  SELECT followers.follower_id, NEW.author_id, 'followedAuthorComment', NEW.id
  FROM followers
  WHERE followers.following_id = NEW.author_id
    AND followers.follower_id != blog_author_id;
END//

--------------------------------------------------------------

CREATE TRIGGER comment_edited
AFTER UPDATE ON comments
FOR EACH ROW
BEGIN
  INSERT INTO events (type, data) VALUES ('commentEdited', NEW.id);
END//

--------------------------------------------------------------

CREATE TRIGGER comment_deleted
AFTER DELETE ON comments
FOR EACH ROW
BEGIN
  DECLARE blog_author_id INT;

  -- Retrieve the blog author ID
  SELECT author_id INTO blog_author_id
  FROM blogs
  WHERE id = OLD.blog_id;

  INSERT INTO events (type, data) VALUES ('commentDeleted', OLD.id);

  -- Remove the newComment notification for the blog author
  DELETE FROM notifications
  WHERE recipient_id = blog_author_id
    AND sender_id = OLD.author_id
    AND action = 'newComment'
    AND action_id = OLD.id;

  -- Remove the followedAuthorComment notifications for the authors the blog author follows (excluding the blog author and the comment author)
  DELETE FROM notifications
  WHERE sender_id = OLD.author_id
    AND action = 'followedAuthorComment'
    AND action_id = OLD.id;
END//


-- Add authorUpdated event for the follower and the following when followers table is modified
CREATE TRIGGER follower_updated
AFTER INSERT ON followers
FOR EACH ROW
BEGIN
  INSERT INTO events (type, data) VALUES ('authorUpdated', NEW.follower_id);
  INSERT INTO events (type, data) VALUES ('authorUpdated', NEW.following_id);
END//

CREATE TRIGGER follower_deleted
AFTER DELETE ON followers
FOR EACH ROW
BEGIN
  INSERT INTO events (type, data) VALUES ('authorUpdated', OLD.follower_id);
  INSERT INTO events (type, data) VALUES ('authorUpdated', OLD.following_id);
END//
--------------------------------------------------------------

CREATE TRIGGER notification_inserted
AFTER INSERT ON notifications
FOR EACH ROW
BEGIN
  INSERT INTO events (type, data) VALUES ('newNotification', NEW.recipient_id);
END//

CREATE TRIGGER notification_deleted
AFTER DELETE ON notifications
FOR EACH ROW
BEGIN
  INSERT INTO events (type, data) VALUES ('removedNotification', OLD.recipient_id);
END//

--------------------------------------------------------------

--------------------------------------------------------------

CREATE TRIGGER before_blog_deleted
BEFORE DELETE ON blogs
FOR EACH ROW
BEGIN
  DELETE FROM bookmarks WHERE blog_id = OLD.id;
  DELETE FROM comments WHERE blog_id = OLD.id;
  DELETE FROM likes WHERE blog_id = OLD.id;
END//

--------------------------------------------------------------

DELIMITER //
CREATE TRIGGER before_author_deleted
BEFORE DELETE ON authors
FOR EACH ROW
BEGIN
  DELETE FROM followers WHERE following_id = OLD.id;
  DELETE FROM followers WHERE follower_id = OLD.id;
  DELETE FROM blogs WHERE author_id = OLD.id;
  DELETE FROM comments WHERE author_id = OLD.id;
  DELETE FROM likes WHERE author_id = OLD.id;
  DELETE FROM notifications WHERE sender_id = OLD.id or recipient_id = OLD.id
END//

--------------------------------------------------------------

CREATE TRIGGER before_comment_deleted
BEFORE DELETE ON comments
FOR EACH ROW
BEGIN
  DELETE FROM likes WHERE comment_id = OLD.id;
END//


DELIMITER //
