import { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useBlogContext } from '../contexts/BlogContext';
import { Author, Blog } from '../types';
import { useAuthorContext } from '../contexts/AuthorContext';
import CommentsList from '../components/CommentsList';
import '../styles/BlogPage.css'
import BlogList from '../components/BlogList';
import api, { bookmark, deleteBlog, follow, getFollowing, likeBlog, unbookmark, unfollow, unlikeBlog } from '../api';
import { useProfileContext } from '../contexts/ProfileContext';
import Loading from '../components/Loading';
import { marked } from 'marked';

const BlogPage = () => {
  const { state: { blogs, loading: blogsLoading } } = useBlogContext();
  const { state: { authors }} = useAuthorContext();
  const { user, loading: userLoading } = useProfileContext();
  const { id } = useParams();
  const navigate = useNavigate();
  const [blog, setBlog] = useState({} as Blog | undefined);
  const [parsed, setParsed] = useState("");
  const [author, setAuthor] = useState({} as Author);
  const [following, setFollowing] = useState(false);
  const [liked, setLiked] = useState(false);
  const [bookmarked, setBookmarked] = useState(false);
  const [loading, setLoading] = useState(true);
  const [randomIndex, setRandomIndex] = useState(0);
  const [alsoNum, setAlsoNum] = useState(3);


  useEffect(() => {
    setRandomIndex(Math.floor(Math.random() * blogs.length));
    if (window.innerWidth < 1000) {
      setAlsoNum(4);
    }
    const handleResize = () => {
      window.innerWidth < 1000 ? setAlsoNum(4) : alsoNum === 4 ? setAlsoNum(3) : "";
    }
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, [])
  useEffect(() => {
    setLoading(true);
    if (!blogsLoading) {
      const b = blogs.find(blog => blog.id === Number(id));
      console.log(b);
      setBlog(b);
      if (b) {
        const parsed = marked(b.content);
        if (typeof parsed === "string") {
          if (parsed.length === 0) 
            setParsed('<span className="placeholder">Write your blog...</span>');
          else
            setParsed(parsed);
        } else {
          parsed.then(data => {
            if (data.length === 0) 
              setParsed('<span className="placeholder">Write your blog...</span>');
            else
              setParsed(data);
            })
        }
      }

      setLoading(false);
    }
  }, [blogs, id]);

  useEffect(() => {
    console.log("in use effect")
    if (blog) {
      setAuthor(authors.find(author => author.id === blog.author_id) as Author);
      if (blog.likes?.findIndex(like => like === user.id) !== -1) {
        console.log("set liked to true", blog.likes)
        setLiked(true);
      } else {
        console.log("set liked to false", blog.likes)
        setLiked(false);
      }
    }
    api.get(`/authors/${user.id}/bookmark`).then(res => {
      const ids = res.data as number[];
      if (ids.includes(Number(id))) {
        setBookmarked(true)
      } else {
        setBookmarked(false)
      }
    }).catch(err => {
      console.error("Failed to load bookmarks: ", err);
    })
  }, [authors, blog]);
  useEffect(() => {
    if (!loading && !userLoading) {
      getFollowing(user.id).then(response => {
        if (response) {
          if (response.data.find((f: number) => f === author.id))  setFollowing(true);
          else setFollowing(false);
        }
      })
    }
  })

  const handleLike = () => {
    if (!liked) {
      likeBlog(Number(id)).then(res => {
        if (res) { 
          setLiked(true); 
          console.log("Successfully liked blog")
        } else { 
          console.log("Failed to like blog") 
        }
      });
    } else {
      unlikeBlog(Number(id)).then(res => {
        if (res) { 
          setLiked(false); 
          console.log("Successfully unliked blog")
        } else { 
          console.log("Failed to unlike blog") 
        }
      });
    }
  }
  const handleFollow = (e: any) => {
    e.stopPropagation();
    if (!following) {
      follow(author.id).then(res => {
        if (res) {
          console.log("Successfully followed author") 
          setFollowing(true)
        } else {
          console.log("Failed to follow author");
        }})
    } else {
      unfollow(author.id).then(res => {
        if (res) {
          console.log("Successfully unfollowed author") 
          setFollowing(false)
        } else {
          console.log("Failed to unfollow author");
        }})
    }
  }
  const handleBookmark = () => {
    if (!bookmarked) {
      bookmark(Number(id)).then(res => {
        if (res) {
          console.log("Successfully bookmarked blog")
          setBookmarked(true);
        } else {
          console.log("Failed to bookmark blog")
        }
      })
    } else {
      unbookmark(Number(id)).then(res => {
        if (res) {
          console.log("Successfull unbookmarked blog")
          setBookmarked(false);
        } else {
          console.log("Failed to unbookmark blog")
        }
      })
    }
  }
  const handleDelete = () => {
    deleteBlog(Number(id)).then(res => {
      if (res) {
        console.log("Successfully deleted blog")
        navigate("/app/blogs");
      } else {
        console.log("Failed to delete blog")
      }
    })
  }



  if (blogsLoading || loading) {
    return (
      <Loading full={true} />
    )
  }

  if (!blog && !loading) {
    return (
      <p>Blog not found</p>
    )
  } else if (blog && author) {
  
  return (
    <div className="blog-page">
      <img src={blog?.image} alt="" className="blog-image"/>
        <h1 className="section-title">{blog?.title}</h1>
        <div className="blog-details">
          <div className="date">{blog?.updated_at?.toLocaleString(undefined, { year: 'numeric', month: 'long', day: 'numeric'})}</div>
          <div className="blog-length">{Math.ceil(blog?.content?.split(' ').length / 200)} mins read</div>
          <div className="tag"># {blog.tag}</div>
          <div className="likes">{blog.likes?.length} likes</div>
          <button className="bookmark" onClick={handleBookmark}>
            { !bookmarked ? 
            <>
            <i className="far fa-bookmark"></i>
            <span>Bookmark</span>
            </> :
            <>
            <i className="fas fa-bookmark"></i>
            <span>Bookmarked</span>
            </>
            }
          </button>
          { user?.id === author?.id &&
            <>
              <button className="edit" onClick={() => navigate(`/app/new?id=${id}`)}><i className="fas fa-edit"></i> Edit</button>
              <button className="delete" onClick={handleDelete}><i className="fas fa-trash"></i> Delete</button>
            </>
          }
          </div>
        <article dangerouslySetInnerHTML={{ __html: parsed }}>
        </article>
        <section className="bottom">
          <div className="profile-mini" onClick={() => navigate(`/app/authors/${author.id}`)}>
            <img src={author?.image} alt="" className="profile-image" />
            <div>
              <span>{author?.name}</span>
              { user?.id !== author?.id ? !following ?
              <button className="follow" onClick={handleFollow}><i className="fas fa-plus"></i>  Follow</button> :
              <button className="unfollow" onClick={handleFollow}><i className="fas fa-check"></i>  Following</button> : null
              }
            </div>
          </div>
          <div className="like">
            { user?.id !== author?.id ? !liked ? 
              <button className="like" onClick={handleLike}><i className="far fa-heart"></i> Like</button> :
              <button className="unlike" onClick={handleLike}><i className="fas fa-heart"></i> Liked</button>  : null
            }
          </div>
        </section>
        <section className="more">
          <h1>You might also like</h1>
          <BlogList blogs={blogs.filter(b => b.id !== blog.id).slice(randomIndex, (randomIndex + alsoNum) % blogs.length )} mode="mini-grid" />
        </section>
        
        <CommentsList blogId={Number(id)}/>
    </div>
  );

  }
};

export default BlogPage;
