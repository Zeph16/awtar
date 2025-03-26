import { useState } from 'react';
import { useProfileContext } from '../contexts/ProfileContext';
import { postComment } from '../api'

function CommentInput({ blogId } : { blogId: number }) {
  const [comment, setComment] = useState('');
  const { user } = useProfileContext();

  const handleInputChange = (event: any) => {
    setComment(event.target.value);
  };

  const handleSubmit = (event: any) => {
    event.preventDefault();
    if (comment === '') return;
    postComment(comment, blogId).then(success => {
      if (success) console.log('Submitted comment: ', comment);
      else console.log('Failed to submit: ', comment);
    })
    
    setComment('');
  };

  return (
    <form onSubmit={handleSubmit}>
      <img src={user.image} alt="" />
      <input type="text" placeholder='Add a Comment' value={comment} onChange={handleInputChange}/>
      <button type="submit">
        <i className="fa-solid fa-paper-plane"></i>
      </button>
    </form>
  );
}

export default CommentInput
