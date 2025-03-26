import { useEffect } from 'react';
import api from '../api';
import { Notification } from '../types';

import { useNotificationContext } from '../contexts/NotificationContext';
import { useProfileContext } from '../contexts/ProfileContext';

function NotificationSSEListener() {
  const { dispatch } = useNotificationContext();
  const { id } = useProfileContext();

  useEffect(() => {
    const eventSource = new EventSource('http://localhost:8000/index.php?sse=1');

    eventSource.addEventListener('newNotification', handleEvent);
    eventSource.addEventListener('removedNotification', handleEvent);

    return () => {
      eventSource.close();
    };
  }, [id]);

  const handleEvent = async (event: MessageEvent) => {
    if (Number(event.data) === id) {
      const response = await api.get<Notification[]>(`/authors/${id}/notifications`);
      const notifications = response.data;
      dispatch({ type: 'SET_NOTIFICATIONS', payload: notifications });
    } else {
    }
  }

  return null;
};

export default NotificationSSEListener;
