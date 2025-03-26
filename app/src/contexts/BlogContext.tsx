import { createContext, useReducer, useContext, useEffect } from 'react';
import { Blog } from '../types';
import api from '../api';
import { randomBlogImage } from '../utils';

interface BlogState {
  blogs: Blog[];
  loading: boolean;
}

interface BlogContextValue {
  state: BlogState;
  dispatch: React.Dispatch<BlogAction>;
}

type BlogAction =
  | { type: 'ADD_BLOG'; payload: Blog }
  | { type: 'DELETE_BLOG'; payload: Number }
  | { type: 'UPDATE_BLOG'; payload: any }
  | { type: 'SET_BLOGS'; payload: Blog[] }
  | { type: 'SET_LOADING'; payload: boolean };

const blogReducer = (state: BlogState, action: BlogAction): BlogState => {
  switch (action.type) {
    case 'ADD_BLOG':
      return {
        blogs: [...state.blogs, action.payload],
        loading: state.loading
      };
    case 'DELETE_BLOG':
      return {
        blogs: state.blogs.filter((blog) => blog.id !== action.payload),
        loading: state.loading
      };
    case 'UPDATE_BLOG':
      return {
        blogs: state.blogs.map((blog) =>
          blog.id === action.payload.id ? {...blog, ...action.payload} : blog
        ),
        loading: state.loading
      };
    case 'SET_BLOGS':
      return {
        blogs: action.payload,
        loading: state.loading
      };
    case 'SET_LOADING':
      return {
        blogs: state.blogs,
        loading: action.payload
      };
    default:
      return state;
  }
};


const BlogContext = createContext<BlogContextValue>({} as BlogContextValue);

export const useBlogContext = () => useContext(BlogContext);

function BlogContextProvider({ children }: { children: React.ReactNode}) {
  const initialState: BlogState = { blogs: [], loading: true };
  const [state, dispatch] = useReducer(blogReducer, initialState);

  useEffect(() => {
    dispatch({ type: 'SET_LOADING', payload: true });
    fetchData(dispatch).then(() => {
      dispatch({ type: 'SET_LOADING', payload: false });
    }).catch((error) => {
      console.error('Error fetching data in BlogContext:', error);
      dispatch({ type: 'SET_LOADING', payload: false });
    });
  }, []);

  const contextValue: BlogContextValue = { state, dispatch };

  return (
    <BlogContext.Provider value={contextValue}>{children}</BlogContext.Provider>
  );
};

async function fetchData(dispatch: React.Dispatch<BlogAction>) {
  const response = await api.get('/blogs');
  let blogs = response.data;
  blogs = blogs.map((blog: Blog) => {
    return { ...blog, image: blog.image || randomBlogImage(), created_at: new Date(blog.created_at), updated_at: new Date(blog.updated_at)}
  })
  dispatch({ type: 'SET_BLOGS', payload: blogs });
}



export default BlogContextProvider;
