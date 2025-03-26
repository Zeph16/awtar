import { useEffect, useState } from "react";
import { useAuthorContext } from "../contexts/AuthorContext";
import { useNotificationContext } from "../contexts/NotificationContext"
import { useBlogContext } from "../contexts/BlogContext";
import { Notification, Comment } from "../types";
import { deleteAllNotifications, deleteNotification, getCommentById, readAllNotifications, readNotification } from "../api";
import { useNavigate } from "react-router-dom";
import Loading from "../components/Loading";
import '../styles/NotificationsPage.css';

function NotificationsPage() {
  const navigate = useNavigate();
  const { state: { notifications, loading: notificationsLoading }, dispatch } = useNotificationContext();
  const { state: { authors, loading: authorsLoading }} = useAuthorContext();
  const { state: { blogs, loading: blogsLoading }} = useBlogContext();
  const [comments, setComments] = useState<Comment[]>([])
  const [commentsLoading, setCommentsLoading] = useState(true);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!notificationsLoading && !authorsLoading && !blogsLoading) {
      setLoading(false);
    } else {
      setLoading(true);
    }
  }, [notificationsLoading, authorsLoading, blogsLoading, commentsLoading])

  useEffect(() => {
    if (!notificationsLoading) {
      setCommentsLoading(true);
      getComments().then(() => setCommentsLoading(false));

    }
  }, [notifications])



  const getComments = async () => {
    const actions = ["newComment", "commentLiked", "followedAuthorComment"];
    const commentIds = notifications.filter(notification => actions.includes(notification.action))
                        .map(notification => notification.action_id);
    const comments = await Promise.all(commentIds.map(id => getCommentById(id)));
    setComments(comments);
  }
  const markAsRead = (id: number) => {
    readNotification(id).then((res: boolean) => {
      if (res) {
        dispatch({ type: 'MARK_NOTIFICATION_AS_READ', payload: id });
      } else {
        console.error("Error marking notification as read");
      }
    })
  }
  const deleteNotif = (id: number) => {
    deleteNotification(id).then((res: boolean) => {
      if (res) {
        dispatch({ type: 'REMOVE_NOTIFICATION', payload: id });
        console.log("Notification deleted");
      } else {
        console.error("Error deleting notification");
      }
    })
  }
  const markAllAsRead = () => {
    readAllNotifications().then((res: boolean) => {
      if (res) {
        dispatch({ type: 'SET_NOTIFICATIONS', payload: notifications.map(notification => ({ ...notification, is_read: true })) });
      } else {
        console.error("Error marking all notifications as read");
      }
    })
  }
  const deleteAll = () => {
    deleteAllNotifications().then((res: boolean) => {
      if (res) {
        dispatch({ type: 'SET_NOTIFICATIONS', payload: [] });
      } else {
        console.error("Error deleting all notifications");
      }
    })
  }

  const getMessage = (notification: Notification) => {
    if (loading) return '';
    let message = '';
    const sender = authors?.find(author => author.id === notification.sender_id);
    if (!sender) {
      return message;
    }
    const concernedBlog = blogs?.find(blog => blog.id === notification.action_id);
    const concernedComment = comments?.find(comment => comment.id === notification.action_id);

    switch (notification.action) {
      case 'blogCreated':
        message = `<span><span>${sender.name}</span></span> has created a new blog titled </span><span>${concernedBlog?.title}</span>"`;
        break;
      case 'blogEdited':
        message = `<span>${sender.name}</span> has edited a blog titled <span>${concernedBlog?.title}</span>"`;
        break;
      case 'blogLiked':
        message = `<span>${sender.name}</span> has liked your blog titled <span>${concernedBlog?.title}</span>"`;
        break;
      case 'authorLiked':
        message = `<span>${sender.name}</span> has liked a blog titled <span>${concernedBlog?.title}</span>"`;
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
        const blog_id = comments.find(comment => comment.id === notification.action_id)?.blog_id;
        return () => navigate(`/app/blogs/${blog_id}`);
      case 'follow':
        return () => navigate(`/app/authors/${notification.sender_id}`);
      default:
      return action;
    }
  }
  const getIcon = (notification: Notification) => {
    switch (notification.action) {
      case 'blogCreated':
      case 'blogEdited':
      return "fas fa-pen";
      case 'blogLiked':
      case 'authorLiked':
      case 'commentLiked':
      return "fas fa-heart";
      case 'newComment':
      case 'followedAuthorComment':
      return "fas fa-comment";
      case 'follow':
      return "fas fa-user-plus";
      default:
      return "fas fa-bell";
    }
  }
  



  if (loading) {
    <div className="notifications-page">
      <h1 className="section-title">Notifications</h1>
      <Loading full={true} />
    </div>
  } else {

  return (
    <div className="notifications-page">
      <h1 className="section-title">Notifications</h1>
      <section className="unread">
        <div className="title">
          <h1 className="read">Unread notifications</h1>
          { notifications.filter(notification => !notification.is_read).length > 1 &&
          <div className="buttons">
            <button onClick={markAllAsRead}><i className="fas fa-check"></i> Read All</button>
            <button onClick={deleteAll}><i className="fas fa-trash"></i> Delete All</button>
          </div>
          }
        </div>
        <div className="notifications">
          {notifications.filter (notification => !notification.is_read).length === 0 ? <div className="empty-message"><p>No unread notifications</p></div> :
              notifications.filter(notification => !notification.is_read).map(notification => (
            <div key={notification.id} className="notification unread">
              <i className={getIcon(notification)}></i>
              <div>
                <p dangerouslySetInnerHTML={ { __html: getMessage(notification) }}></p>
                <div className="buttons">
                  <button onClick={() => markAsRead(notification.id)}><i className="fas fa-check"></i> Mark as read</button>
                  <button onClick={() => { markAsRead(notification.id); getAction(notification)();}}><i className="fas fa-eye"></i> View</button>
                  <button onClick={() => deleteNotif(notification.id)}><i className="fas fa-trash"></i> Delete</button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </section>
      <section className="read">
        <div className="title">
          <h1 className="read">Your previous notifications</h1>
          { notifications.filter(notification => notification.is_read).length > 1 &&
          <div className="buttons">
            <button onClick={deleteAll}><i className="fas fa-trash"></i> Delete All</button>
          </div>
          }
        </div>
        <div className="notifications">
          { notifications.filter(notification => notification.is_read).length === 0 ? <div className="empty-message"><p>No notifications</p></div> :
            notifications.filter(notification => notification.is_read).map(notification => (
            <div key={notification.id} className="notification read">
              <i className={getIcon(notification)}></i>
              <div>
                <p dangerouslySetInnerHTML={ { __html: getMessage(notification) }}></p>
                <div className="buttons">
                  <button onClick={() => getAction(notification)()}><i className="fas fa-eye"></i> View</button>
                  <button onClick={() => deleteNotif(notification.id)}><i className="fas fa-trash"></i> Delete</button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </section>
    </div>
  )

  }
}

export default NotificationsPage
