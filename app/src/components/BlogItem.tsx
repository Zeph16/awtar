import { Author, Blog } from "../types"
import { useNavigate } from "react-router-dom";
import '../styles/BlogItem.css'
import { stripHtml } from "../utils";
import { marked } from "marked";

function BlogItem({ blog, author, mode, searchStr }: { blog: Blog, author: Author, mode: 'cell' | 'mini' | 'long' | 'full', searchStr?: string }) {
  const navigate = useNavigate();
  const handleBlogClick = () => {
    navigate(`/app/blogs/${blog.id}`);
  }
  const handleAuthorClick = (e: any) => {
    e.stopPropagation();
    navigate(`/app/authors/${author.id}`);
  }
  const highlightTitle = (title: string) => {
    if (searchStr) {
      const index = title.toLowerCase().indexOf(searchStr.toLowerCase());
      if (index !== -1) {
      return (
        <>
          <span>{title.slice(0, index)}</span>
          <span className="highlight">{title.slice(index, index + searchStr.length)}</span> <span>{title.slice(index + searchStr.length)}</span>
        </>
      )
      }
    }
    return title;
  }
  const parseContent = (content: string) => {
    const html = marked(content);
    let stripped = ""
    if (typeof html === "string") {
      stripped = stripHtml(html);
    } else {
      html.then(res => { stripped = stripHtml(res) })
    }
    return stripped.slice(0, 200) + "...";
  }

  switch (mode) {
    case 'cell':
      return (
        <div className="blog-item cell" onClick={handleBlogClick}>
          <div className="image-container">
            <img src={blog?.image} alt="" />
          </div>
          <h1>{highlightTitle(blog?.title)}</h1>
          <div>
            <div className="profile-mini" onClick={handleAuthorClick}>
              <img src={author?.image} alt="" className="profile-image" />
              <span>{author?.name}</span>
            </div>
            <div className="date">{blog?.updated_at.toLocaleString(undefined, { year: 'numeric', month: 'long', day: 'numeric'})}</div>
          </div>
          <div className="tag"># {blog?.tag}</div>
        </div>
      )
    case 'mini':
      return (
        <div className="blog-item mini" onClick={handleBlogClick} >
          <div className="image-container">
            <img src={blog?.image} alt="" />
          </div>
          <div className="right">
            <h1>{highlightTitle(blog?.title)}</h1>
            <div>
              <div className="date">{blog?.updated_at.toLocaleString(undefined, { year: 'numeric', month: 'long', day: 'numeric'})}</div>
              <div className="tag"># {blog?.tag}</div>
            </div>
          </div>
        </div>
      )
    case 'long':
      return (
        <div className="blog-item long" onClick={handleBlogClick}>
          <div className="image-container">
            <img src={blog?.image} alt="" />
          </div>
          <div className="bottom">
            <h1>{highlightTitle(blog?.title)}</h1>
            <div className="profile-and-tag">
              <div className="profile-mini" onClick={handleAuthorClick}>
                <img src={author?.image} alt="" className="profile-image" />
                <span>{author?.name}</span>
              </div>
              <div className="tag"># {blog?.tag}</div>
            </div>
            <p className="content">
              {parseContent(blog?.content)}
            </p>
            <div className="date">{blog?.updated_at.toLocaleString(undefined, { year: 'numeric', month: 'long', day: 'numeric'})}</div>
          </div>
        </div>
      )
    case 'full':
      return (
        <div className="blog-item full" onClick={handleBlogClick}>
          <div className="image-container">
            <img src={blog?.image} alt="" />
          </div>
          <div className="bottom">
            <h1>{highlightTitle(blog?.title)}</h1>
            <div className="profile-and-tag" onClick={handleAuthorClick}>
              <div className="profile-mini">
                <img src={author?.image} alt="" className="profile-image" />
                <span>{author?.name}</span>
              </div>
              <div className="date">{blog?.updated_at.toLocaleString(undefined, { year: 'numeric', month: 'long', day: 'numeric'})}</div>
              <div className="tag"># {blog?.tag}</div>
            </div>
          </div>
        </div>
      )
    default:
      return null;
  }
}

export default BlogItem
