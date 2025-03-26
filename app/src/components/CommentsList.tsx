import { useEffect, useState } from "react";
import api, { deleteComment, likeComment, unlikeComment } from "../api";
import { Comment } from "../types";
import CommentSSEListener from "../listeners/CommentSSEListener";
import { useAuthorContext } from "../contexts/AuthorContext";
import Loading from "./Loading";
import '../styles/CommentsList.css';
import CommentInput from "./CommentInput";
import { useProfileContext } from "../contexts/ProfileContext";
import { getTimeAgo } from '../utils.ts'
import { useNavigate } from "react-router-dom";

function CommentsList({ blogId }: { blogId: number; }) {
    const navigate = useNavigate();
    const { state: { authors } } = useAuthorContext();
    const [comments, setComments] = useState([] as Comment[]);
    const [loading, setLoading] = useState(true);
    const { user } = useProfileContext();

    useEffect(() => {
        setLoading(true);
        fetchComments().then(() => setLoading(false));
    }, [blogId]);

    const handleLike = (comment: Comment) => {
      if (comment.likes.find(like => like === user.id)) {
        unlikeComment(comment.id).then(success => {
          if (success) console.log('Successfully unliked comment: ', comment.content);
          else console.log('Failed to unlike comment: ', comment.content)
        })
      } else {
        likeComment(comment.id).then(success => {
          if (success) console.log('Successfully liked comment: ', comment.content);
          else console.log('Failed to like comment: ', comment.content)
        })
      }
    }

    const fetchComments = async () => {
        try {
            const response = await api.get(`/blogs/${blogId}/comments`);
            const commentData = response.data;
            const updatedData = commentData.map((comment: Comment) => {
              return { ...comment, created_at: new Date(comment.created_at), updated_at: new Date(comment.updated_at) };
            });
            setComments(updatedData);
        } catch (error) {
            console.error('Error fetching comments:', error);
        }
    };

    const renderComment = (comment: Comment) => {
        const author = authors.find(author => author.id === comment.author_id);
        return (
          <li key={comment.id}>
            <div className="left">
              <img src={author?.image} alt="" className="profile-image" onClick={() => navigate(`/app/authors/${author?.id}`)}/>
              {comment.author_id === user.id && (
                <>
                {/* <i className="fa-solid fa-pen"></i> */}
                <i className="fa-solid fa-trash" onClick={() => deleteComment(comment.id)}></i>
                </>
              )}
            </div>
            <div>
              <span className="author-name" onClick={() => navigate(`/app/authors/${author?.id}`)}>{author?.name}
                <span>{getTimeAgo(comment.updated_at)}</span>
              </span>
              <p>{comment.content} 
                {((comment.created_at as any) - (comment.updated_at as any) > 1000) && <span>(edited)</span>}</p>
              <div>
                  <button className="like" onClick={() => handleLike(comment)}>
                { comment.likes.findIndex(like => like === user.id) === -1 ?
                     <i className="far fa-heart"></i> :
                    <i className="fas fa-heart"></i> }
                  </button>
                  {comment.likes.length} 
              </div>
            </div>
          </li>
        )
    };
    return (
      <>
        <CommentSSEListener setComments={setComments} />
        <section className="comments" id="comments">
          <h1 className="title">Comments <span>{!loading && comments.length} comments</span></h1>

          <CommentInput blogId={blogId} />
          {loading ? <Loading full={false} /> :
            <ul>
              {comments.map((comment) => renderComment(comment))}
            </ul>}

        </section>
      </>
    );
}

export default CommentsList
