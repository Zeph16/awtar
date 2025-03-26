import { useEffect, useState } from "react";
import { Blog } from "../types";
import api from "../api";
import { useProfileContext } from "../contexts/ProfileContext";
import Loading from "../components/Loading";
import BlogList from "../components/BlogList";
import { useBlogContext } from "../contexts/BlogContext";
import '../styles/Bookmarks.css'

function BookmarksPage() {
  const { state: { blogs, loading: blogsLoading }} = useBlogContext();
  const [bookmarks, setBookmarks] = useState<Blog[]>([]);
  const [loading, setLoading] = useState(true);
  const { user, loading: userLoading } = useProfileContext();

  useEffect(() => {
    if (!loading) setLoading(true);
    if (!userLoading || !blogsLoading) {
      api.get(`/authors/${user.id}/bookmark`).then(res => {
        const ids = res.data;
        const bookmarkedBlogs = blogs.filter(blog => ids.includes(blog.id));
        setBookmarks(bookmarkedBlogs);
        setLoading(false);
      }).catch(err => {
        console.error("Failed to load bookmarks: ", err);
        setLoading(false);
      })
    }
  }, [user, blogs])
  if (loading) {
  return (
    <div className="bookmarks-page">
      <h1 className="section-title">Bookmarks</h1>
      <Loading full={true} />
    </div>
  )
  } else if (bookmarks.length === 0) {
    return (
      <div className="bookmarks-page">
        <h1 className="section-title">Bookmarks</h1>
        <div className="empty-message">
          <p>You have no bookmarks yet.</p> 
          <p>Go to the <a href="/blogs">blogs page</a> to find some interesting blogs to bookmark!</p></div>
      </div>
    )
  } else {
    return (
      <div className="bookmarks-page">
        <h1 className="section-title">Bookmarks</h1>
        <BlogList blogs={bookmarks} mode="top-down" />
      </div>
    )
  }
}

export default BookmarksPage
