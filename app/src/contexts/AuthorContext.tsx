import { createContext, useContext, useEffect, useReducer } from 'react';
import { Author } from '../types';
import api from '../api';
import { randomUserImage } from '../utils';

interface AuthorState {
  authors: Author[];
  loading: boolean;
}

type AuthorAction =
  | { type: 'ADD_AUTHOR'; payload: Author }
  | { type: 'DELETE_AUTHOR'; payload: Number }
  | { type: 'UPDATE_AUTHOR'; payload: Author }
  | { type: 'SET_AUTHORS'; payload: Author[] }
  | { type: 'SET_LOADING'; payload: boolean };

const initialState: AuthorState = {
  authors: [],
  loading: true
};

const authorReducer = (state: AuthorState, action: AuthorAction): AuthorState => {
  switch (action.type) {
    case 'ADD_AUTHOR':
      return { ...state, authors: [...state.authors, action.payload] };
    case 'DELETE_AUTHOR':
      return {
        ...state,
        authors: state.authors.filter((author) => author.id !== action.payload),
      };
    case 'UPDATE_AUTHOR':
      return {
        ...state,
        authors: state.authors.map((author) =>
          author.id === action.payload.id ? { ...author, ...action.payload } : author
        ),
      };
    case 'SET_AUTHORS':
      return { ...state, authors: action.payload };
    case 'SET_LOADING':
      return { ...state, loading: action.payload };
    default:
      return state;
  }
};
interface AuthorContextValue {
  state: AuthorState;
  dispatch: React.Dispatch<AuthorAction>;
}
const AuthorContext = createContext<AuthorContextValue>({} as AuthorContextValue);
export const useAuthorContext = () => useContext(AuthorContext);

function AuthorContextProvider({ children }: { children: React.ReactNode }) {
  const [state, dispatch] = useReducer(authorReducer, initialState);

  useEffect(() => {
    const fetchAuthors = async () => {
      dispatch({ type: 'SET_LOADING', payload: true })
      try {
        const response = await api.get('/authors');
        const authors = response.data;
        authors.forEach((author: Author) => {
          if (!author.image) author.image = randomUserImage();
        })
        console.log('Authors:')
        console.log(authors)

        dispatch({ type: 'SET_AUTHORS', payload: authors });
      } catch (error) {
        console.error('Error fetching authors:', error);
      }
      dispatch({ type: 'SET_LOADING', payload: false })
    };

    fetchAuthors();
  }, []);
  return (
    <AuthorContext.Provider value={{ state, dispatch }}>
      {children}
    </AuthorContext.Provider>
  );
};


export default AuthorContextProvider;
