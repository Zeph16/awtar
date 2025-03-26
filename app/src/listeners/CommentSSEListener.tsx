import { useEffect } from 'react';
import api from '../api';
import { Comment } from '../types';

function CommentSSEListener({ setComments }: { setComments: React.Dispatch<React.SetStateAction<Comment[]>>}) {

  useEffect(() => {
    const eventSource = new EventSource('http://localhost:8000/index.php?sse=1');
    console.log('CommentSSEListener mounted!');

    eventSource.addEventListener('commentCreated', handleCreated);
    eventSource.addEventListener('commentEdited', handleEdited);
    eventSource.addEventListener('commentDeleted', handleDeleted);
    eventSource.addEventListener('commentLiked', handleLikeUnlike);
    eventSource.addEventListener('commentUnliked', handleLikeUnlike);

    return () => {
      eventSource.close();
    };
  }, [setComments]);

  const handleCreated = async (event: MessageEvent) => {
    const id = Number(event.data);
    const response = await api.get(`/blogs/1/comments/${id}`);
    const updatedData = response.data;
    console.log('CommentSSEListener: handleCreated', updatedData);
    setComments((prevComments) => [{...updatedData, likes: []}, ...prevComments]);
  }
  const handleEdited = async (event: MessageEvent) => {
    const id = Number(event.data);
    const response = await api.get(`/blogs/1/comments/${id}`);
    const updatedData = response.data;
    console.log('CommentSSEListener: handleEdited', updatedData);
    setComments((prevComments) => prevComments.map((comment) => comment.id === id ? {...comment, ...updatedData } : comment));
  }
  const handleDeleted = (event: MessageEvent) => {
    const id = Number(event.data);
    console.log('CommentSSEListener: handleDeleted', id);
    setComments((prevComments) => prevComments.filter((comment) => comment.id !== id));
  }
  const handleLikeUnlike = async (event: MessageEvent) => {
    const id = Number(event.data);
    const response = await api.get(`/blogs/1/likes/${id}`);
    const updatedData = response.data;
    console.log('CommentSSEListener: handleLikeUnlike', updatedData);
    setComments((prevComments) => prevComments.map((comment) => comment.id === id ? {...comment, likes: updatedData} : comment));
  }

  return null;
};

export default CommentSSEListener;
