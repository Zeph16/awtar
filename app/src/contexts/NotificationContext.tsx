import { createContext, useContext, useEffect, useReducer } from 'react';
import api from '../api';
import { Notification } from '../types';
import { useProfileContext } from './ProfileContext';

interface NotificationState {
  notifications: Notification[];
  loading: boolean
}

type NotificationAction =
  | { type: 'SET_NOTIFICATIONS'; payload: Notification[] }
  | { type: 'MARK_NOTIFICATION_AS_READ'; payload: number }
  | { type: 'ADD_NOTIFICATION'; payload: Notification }
  | { type: 'REMOVE_NOTIFICATION'; payload: number }
  | { type: 'SET_LOADING'; payload: boolean }

interface NotificationContextValue {
  state: NotificationState;
  dispatch: React.Dispatch<NotificationAction>;
}

const NotificationContext = createContext<NotificationContextValue>(null as unknown as NotificationContextValue);
export const useNotificationContext = () => useContext(NotificationContext);

const initialState: NotificationState = {
  notifications: [],
  loading: true
};

const reducer = (state: NotificationState, action: NotificationAction): NotificationState => {
  switch (action.type) {
    case 'SET_NOTIFICATIONS':
      return {
        ...state,
        notifications: action.payload,
      };
    case 'MARK_NOTIFICATION_AS_READ':
      return {
        ...state,
        notifications: state.notifications.map((notification) =>
          notification.id === action.payload
            ? { ...notification, is_read: true }
            : notification
        ),
      };
    case 'ADD_NOTIFICATION':
      return {
        ...state,
        notifications: [action.payload, ...state.notifications],
      };
    case 'REMOVE_NOTIFICATION':
      return {
        ...state,
        notifications: state.notifications.filter(
          (notification) => notification.id !== action.payload
        ),
      };
    case 'SET_LOADING':
      return {
        ...state,
        loading: action.payload
      }
    default:
      return state;
  }
};

function NotificationContextProvider({ children }: { children: React.ReactNode }) {
  const [state, dispatch] = useReducer(reducer, initialState);
  const { id } = useProfileContext();
  useEffect(() => {
    fetchNotifications();
  }, [id]);

  const fetchNotifications = async (): Promise<void> => {
    dispatch({ type: 'SET_LOADING', payload: true });
    try {
      const response = await api.get<Notification[]>(`/authors/${id}/notifications`);
      console.log("Notifications: ", response.data.length)
      dispatch({ type: 'SET_NOTIFICATIONS', payload: response.data });
    } catch (error) {
      console.error('Error fetching notifications:', error);
    }
    dispatch({ type: 'SET_LOADING', payload: false });
  };

  const contextValue: NotificationContextValue = {
    state,
    dispatch,
  };

  return <NotificationContext.Provider value={contextValue}>{children}</NotificationContext.Provider>;
};

export default NotificationContextProvider;
