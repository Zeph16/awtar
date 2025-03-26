import { createContext, useContext, useEffect, useState } from 'react';
import api from '../api';
import { Author } from '../types';
import { randomUserImage } from '../utils';

interface ProfileContextValue {
  user: Author;
  id: number;
  loading: boolean;
  login: () => void;
  logout: () => void;
  setUser: (user: Author) => void;
}

const ProfileContext = createContext<ProfileContextValue>({} as ProfileContextValue);
export const useProfileContext = () => useContext(ProfileContext);

function ProfileContextProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<Author>({} as Author);
  const [id, setId] = useState(localStorage.getItem('user') ? Number(localStorage.getItem('user')!.split('.')[0]) : 0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    console.log('Running use effect in profile')
    const userData = localStorage.getItem('user');
    if (userData) {
      const userId = Number(userData.split('.')[0]);
      setId(userId);

      setLoading(true);
      api.get(`/authors/${userId}`)
        .then((response) => { setUser({...response.data, image: response.data.image || randomUserImage()}); setLoading(false); })
        .catch((error) => {
          console.error('Failed to fetch user data:', error);
        });
    }
  }, []);

  const login = () => {
    console.log('Running login function in profile')
    const userData = localStorage.getItem('user');
    if (userData) {
      const userId = Number(userData.split('.')[0]);
      setId(userId);

      setLoading(true);
      api.get(`/authors/${userId}`)
        .then((response) => { setUser({...response.data, image: response.data.image || randomUserImage()}); setLoading(false); })
        .catch((error) => {
          console.error('Failed to fetch user data:', error);
        });
    }
  }

  const logout = (): void => {
    localStorage.removeItem('user');
    window.location.href = 'http://localhost:3000/'; 
  };

  return (
    <ProfileContext.Provider value={{ user, loading, login, logout, id, setUser }}>
      {children}
    </ProfileContext.Provider>
  );
};

export default ProfileContextProvider;
