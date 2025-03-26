import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:8000',
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('user');

  if (token) {
    config.headers['X-Token'] = token;
  }

  return config;
});


export async function getBlog(id: number) {
  try {
    const response = await api.get(`/blogs/${id}`);
    return response.data;
  } catch {
    return false;
  }
}
export async function getFollowers(id: number) {
  try {
    const response = await api.get(`/authors/${id}/followers`);
    return response.data;
  } catch {
    return false;
  }
}
export async function getFollowing(id: number) {
  try {
    return await api.get(`/authors/${id}/following`);
  } catch {
    return false;
  }
}
export async function follow(id: number) {
  try {
    await api.post(`/authors/${id}/follow`);
    console.log("Following author...");
    return true;
  } catch {
    return false;
  }
}
export async function unfollow(id: number) {
  try {
    await api.delete(`/authors/${id}/follow`);
    return true;
  } catch {
    return false;
  }
}
export async function postBlog(title: string, content: string, tag: string, image: string) {
  try {
    const response = await api.post('/blogs', {
      title: title,
      content: content,
      tag: tag,
      image: image
    });
    return response.data;
  } catch {
    return false;
  }
}
export async function updateBlog(id: number, title: string, content: string, tag: string, image: string) {
  try {
    await api.put(`/blogs/${id}`, {
      title: title,
      content: content,
      tag: tag,
      image: image
    });
    return true;
  } catch {
    return false;
  }
}
export async function deleteBlog(id: number) {
  try {
    await api.delete(`/blogs/${id}`);
    return true;
  } catch {
    return false;
  }
}
export async function likeBlog(id: number) {
  try {
    await api.post(`/blogs/${id}/likes`)
    return true;
  } catch {
    return false;
  }
}
export async function unlikeBlog(id: number) {
  try {
    await api.delete(`/blogs/${id}/likes`)
    return true;
  } catch {
    return false;
  }
}


export async function postComment(comment: string, blogId: number) {
  try {
    await api.post(`/blogs/${blogId}/comments`, {
                      content: comment
                    }) 
    return true;
  } catch {
    return false;
  }
}
export async function updateComment(comment: string, id:number) {
  try {
    await api.put(`/blogs/1/comments/${id}`, {
                      content: comment
                    }) 
    return true;
  } catch {
    return false;
  }
}
export async function deleteComment(id: number) {
  try {
    await api.delete(`/blogs/1/comments/${id}`)
    return true;
  } catch {
    return false;
  }
}
export async function likeComment(id: number) {
  try {
    await api.post(`/blogs/1/likes/${id}`)
    return true;
  } catch {
    return false;
  }
}
export async function unlikeComment(id: number) {
  try {
    await api.delete(`/blogs/1/likes/${id}`)
    return true;
  } catch {
    return false;
  }
}
export async function bookmark(id: number) {
  try {
    await api.post(`/authors/1/bookmark/${id}`)
    return true;
  } catch {
    return false;
  }
}
export async function unbookmark(id: number) {
  try {
    await api.delete(`/authors/1/bookmark/${id}`)
    return true;
  } catch {
    return false;
  }
}
export async function getCommentById(id: number) {
  try {
    const response = await api.get(`/blogs/1/comments/${id}`)
    return response.data;
  } catch {
    return false;
  }
}
export async function readNotification(id: number) {
  try {
    await api.put(`/authors/1/notifications/${id}`)
    return true;
  } catch {
    return false;
  }
}
export async function deleteNotification(id: number) {
  try {
    await api.delete(`/authors/1/notifications/${id}`)
    return true;
  } catch {
    return false;
  }
}
export async function readAllNotifications() {
  try {
    await api.put(`/authors/1/notifications`)
    return true;
  } catch {
    return false;
  }
}
export async function deleteAllNotifications() {
  try {
    await api.delete(`/authors/1/notifications`)
    return true;
  } catch {
    return false;
  }
}
export async function updateUser(id: number, username: string, password: string, email: string, name: string, bio: string, image: string) {
  try {
    await api.put(`/authors/${id}`, {
      username: username,
      password: password,
      email: email,
      name: name,
      bio: bio,
      image: image
    });
    return true;
  } catch {
    return false;
  }
}
export async function deleteUser(id: number) {
  try {
    await api.delete(`/authors/${id}`);
    return true;
  } catch {
    return false;
  }
}

export default api;
