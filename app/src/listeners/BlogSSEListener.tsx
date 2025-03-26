import { useEffect } from 'react';
import api from '../api';
import { useBlogContext } from '../contexts/BlogContext';
import { randomBlogImage } from '../utils';

function BlogSSEListener() {
  const { dispatch } = useBlogContext();

  useEffect(() => {
    const eventSource = new EventSource("http://localhost:8000/index.php?sse=1");
    console.log('BlogSSEListener', eventSource);

    eventSource.addEventListener('blogCreated', handleCreated);
    eventSource.addEventListener('blogEdited', handleEdited);
    eventSource.addEventListener('blogDeleted', handleDeleted);
    eventSource.addEventListener('blogLiked', handleLikeUnlike);
    eventSource.addEventListener('blogUnliked', handleLikeUnlike);

    return () => {
      eventSource.close();
    };
  }, [dispatch]);

  const handleCreated = async (event: MessageEvent) => {
    const id = Number(event.data);
    const blogResponse = await api.get(`/blogs/${id}`);
    const image = blogResponse.data.image ? blogResponse.data.image : randomBlogImage();
    const updatedData = { ...blogResponse.data, image, created_at: new Date(blogResponse.data.created_at), updated_at: new Date(blogResponse.data.updated_at)}
    dispatch({ type: 'ADD_BLOG', payload: updatedData });
  }
  const handleEdited = async (event: MessageEvent) => {
    const id = Number(event.data);
    const blogResponse = await api.get(`/blogs/${id}`);
    const image = blogResponse.data.image ? blogResponse.data.image : randomBlogImage();
    const updatedData = { ...blogResponse.data, image, created_at: new Date(blogResponse.data.created_at), updated_at: new Date(blogResponse.data.updated_at)}
    dispatch({ type: 'UPDATE_BLOG', payload: updatedData });
  }
  const handleDeleted = (event: MessageEvent) => {
    const id = Number(event.data);
    dispatch({ type: 'DELETE_BLOG', payload: id });
  };
  const handleLikeUnlike = async (event: MessageEvent) => {
    const id = Number(event.data);
    const blogResponse = await api.get(`/blogs/${id}`);
    const image = blogResponse.data.image ? blogResponse.data.image : randomBlogImage();
    const updatedData = {...blogResponse.data, image, created_at: new Date(blogResponse.data.created_at), updated_at: new Date(blogResponse.data.updated_at)};
    dispatch({ type: 'UPDATE_BLOG', payload: updatedData });
  }

  return null;
};

export default BlogSSEListener;
