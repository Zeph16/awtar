import { useEffect } from 'react';
import api from '../api';
import { useAuthorContext } from '../contexts/AuthorContext';

function AuthorSSEListener() {
  const { dispatch } = useAuthorContext();

  useEffect(() => {
    const eventSource = new EventSource('http://localhost:8000/index.php?sse=1'); 

    eventSource.addEventListener('authorCreated', handleAuthorCreated);
    eventSource.addEventListener('authorUpdated', handleAuthorUpdated);
    eventSource.addEventListener('authorDeleted', handleAuthorDeleted);

    return () => {
      eventSource.close();
    };
  }, []);

  const handleAuthorCreated = async (event: MessageEvent) => {
    console.log('Author created:', event.data);
    const authorId = Number(event.data);
    try {
      const response = await api.get(`/authors/${authorId}`); 
      const author = response.data;
      dispatch({ type: 'ADD_AUTHOR', payload: author });
    } catch (error) {
      console.error('Error fetching author details:', error);
    }
  };

  const handleAuthorUpdated = async (event: MessageEvent) => {
    console.log('Author edited:', event.data);
    const authorId = Number(event.data);
    try {
      const response = await api.get(`/authors/${authorId}`); 
      const author = response.data;
      dispatch({ type: 'UPDATE_AUTHOR', payload: author });
    } catch (error) {
      console.error('Error fetching author details:', error);
    }
  };

  const handleAuthorDeleted = (event: MessageEvent) => {
    console.log('Author deleted:', event.data);
    const authorId = Number(event.data);
    dispatch({ type: 'DELETE_AUTHOR', payload: authorId });
  };

  return null;
};

export default AuthorSSEListener;
