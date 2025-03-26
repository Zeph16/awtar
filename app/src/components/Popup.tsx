import { useNavigate } from "react-router-dom";
import { useAuthorContext } from "../contexts/AuthorContext";
import { useBlogContext } from "../contexts/BlogContext";
import { useEffect, useState } from "react";
import { getCommentById } from "../api";
import { Comment, Notification } from "../types";
import '../styles/Popup.css'

function Popup({ notification, markAsRead }: { notification: Notification, markAsRead: () => void }) {
  const navigate = useNavigate();
  const { state: { authors, loading: authorsLoading }} = useAuthorContext();
  const { state: { blogs, loading: blogsLoading }} = useBlogContext();
  const [comment, setComment] = useState<Comment>({} as Comment);
  const [commentLoading, setCommentLoading] = useState(true);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!authorsLoading && !blogsLoading) {
      setLoading(false);
    } else {
      setLoading(true);
    }
  }, [authorsLoading, blogsLoading, commentLoading])
  useEffect(() => {
    setCommentLoading(true);
    if (notification.action === 'commentLiked' || notification.action === 'newComment' || notification.action === 'followedAuthorComment') {
      getCommentById(notification.action_id).then(comment => {
        setComment(comment);
        setCommentLoading(false);
      })
    } else {
      setCommentLoading(false);
    }
  }, [notification])



  const getMessage = (notification: Notification) => {
    if (loading) return '';
    let message = '';
    const sender = authors?.find(author => author.id === notification.sender_id);
    if (!sender) {
      return message;
    }
    const concernedBlog = blogs?.find(blog => blog.id === notification.action_id);
    const concernedComment = comment;

    switch (notification.action) {
      case 'blogCreated':
        message = `<span>${sender.name}</span> has created a new blog titled "<span>${concernedBlog?.title}</span>"`;
        break;
      case 'blogEdited':
        message = `<span>${sender.name}</span> has edited a blog titled "<span>${concernedBlog?.title}</span>"`;
        break;
      case 'blogLiked':
        message = `<span>${sender.name}</span> has liked your blog titled "<span>${concernedBlog?.title}</span>"`;
        break;
      case 'authorLiked':
        message = `<span>${sender.name}</span> has liked a blog titled "<span>${concernedBlog?.title}</span>"`;
        break;
      case 'commentLiked':
        message = `<span>${sender.name}</span> has liked your comment that says "<span>${concernedComment?.content}</span>"`;
        break;
      case 'follow':
        message = `<span>${sender.name}</span> has followed you"`;
        break;
      case 'newComment':
        message = `<span>${sender.name}</span> commented on your blog saying "<span>${concernedComment?.content}</span>"`;
        break;
      case 'followedAuthorComment':
        message = `<span>${sender.name}</span> commented on a blog saying "<span>${concernedComment?.content}</span>"`;
        break;
      default:
        message = `New notification received.`;
    }

    return message;
  }
  const getAction = (notification: Notification) => {
    const action = () => {};
    switch (notification.action) {
      case 'blogCreated':
      case 'blogEdited':
      case 'blogLiked':
      case 'authorLiked':
      return () => navigate(`/app/blogs/${notification.action_id}`);
      case 'commentLiked':
      case 'newComment':
      case 'followedAuthorComment':
        const blog_id = comment.blog_id;
        return () => navigate(`/app/blogs/${blog_id}`);
      case 'follow':
        return () => navigate(`/app/authors/${notification.sender_id}`);
      default:
      return action;
    }
  }

  if (loading) return null;
  else
  return (
    <div className="popup" onClick={() => { markAsRead(); getAction(notification)(); }}>
      <p dangerouslySetInnerHTML={{ __html: getMessage(notification) }}></p>
    </div>
  )
}

export default Popup
