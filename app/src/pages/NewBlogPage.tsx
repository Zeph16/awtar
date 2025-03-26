import { useState, useRef, useEffect } from "react"
import { useNavigate, useSearchParams } from "react-router-dom";
import { marked } from "marked";
import '../styles/NewBlogPage.css'
import api, { getBlog, postBlog, updateBlog } from "../api";
import Loading from "../components/Loading";
import { useProfileContext } from "../contexts/ProfileContext";

function NewBlogPage() {
  const navigate = useNavigate();
  const { id: userId } = useProfileContext();
  const [searchParams] = useSearchParams();
  const [editing, setEditing] = useState(0);
  const [notFound, setNotFound] = useState(false);
  const [title, setTitle] = useState("");
  const [content, setContent] = useState("");
  const [tag, setTag] = useState("");
  const [image, setImage] = useState("");
  const [errors, setErrors] = useState({} as { [key: string]: string });
  const [parsed, setParsed] = useState(`<span class="placeholder">Write your blog...</span>`);
  const [focused, setFocused] = useState(false);
  const [publishing, setPublishing] = useState(false);
  const [published, setPublished] = useState(false);
  const [tags, setTags] = useState([] as {id: number, name: string}[]);
  const [tagsLoading, setTagsLoading] = useState(false);
  const input = useRef<HTMLTextAreaElement>(null);

  const images = [
    "http://localhost:8000/images/blog1.jpg",
    "http://localhost:8000/images/blog2.jpg",
    "http://localhost:8000/images/blog3.jpg",
    "http://localhost:8000/images/blog4.jpg",
    "http://localhost:8000/images/blog5.jpg",
    "http://localhost:8000/images/blog6.jpg",
  ];


  useEffect(() => {
    setTagsLoading(true);
    api.get("/blogs/1/tags").then(res => {
      setTags(res.data);
      setTagsLoading(false);
    }).catch(err => {
      console.error("Failed to load tags: ", err);
      setTagsLoading(false);
    })
    window.addEventListener('keydown', handleKey);
    return () => {
      window.removeEventListener('keydown', handleKey);
    };
  }, []);
  useEffect(() => {
    if (searchParams.get('id')) {
      const id = searchParams.get('id');
      console.log("editing: ", id);
      setEditing(Number(id));
      getBlog(Number(id)).then(blog => {
      if (blog) {
        console.log("Blog: ", blog);
        if (blog.author_id !== userId) {
            console.log("Unauthorized to edit this blog");
            setNotFound(true);
        }
        setTitle(blog.title);
        setContent(blog.content);
        setTag(blog.tag);
        setImage(blog.image);
        setParsed(marked(blog.content) as string);
      }
      }).catch(err => {
        console.error("Failed to get blog: ", err);
        setNotFound(true);
      })
    }
  }, [searchParams]);
  useEffect(() => {
    if (focused) {
      input?.current?.focus();
    }
  }, [focused])
  function handleKey(e: any) {
    if (e.key === 'Escape' && document.activeElement === input?.current) {
      input?.current?.blur();
      setFocused(false);
    }
  }
  function handleClick() {
    setFocused(true);
    input?.current?.focus();
  }
  function handleBlur() {
    setFocused(false);
  }
  function handleTitle(e: any) {
    setTitle(e.target.value);
  }
  function handleContent(e: any) {
    console.log({ prop: e.target.value });
    setContent(e.target.value)
    const parsed = marked(e.target.value);
    if (typeof parsed === "string") {
      if (parsed.length === 0) 
        setParsed('<span class="placeholder">Write your blog...</span>');
      else
        setParsed(parsed);
    } else {
      parsed.then(data => {
        if (data.length === 0) 
          setParsed('<span class="placeholder">Write your blog...</span>');
        else
          setParsed(data);
        })
    }
  }
  function handleTag(e: any) {
    setTag(e.target.value);
  }
  function handleImage(e: any) {
    setImage(e.target.value);
  }
  function publish() {
    const err = {} as { [key: string]: string };
    if (title.length === 0 || content.length === 0 || tag.length === 0 || image.length === 0) {
      if (title.length === 0) {
        err.title = "Title is required";
      } else {
        err.title = "";
      }
      if (content.length === 0) {
        err.content = "Content is required";
      } else {
        err.content = "";
      }
      if (tag === "") {
        err.tag = "Tag is required";
      } else {
        err.tag = "";
      }
      if (image === "") {
        err.image = "Image is required";
      } else {
        err.image = "";
      }
      setErrors(err);
      return;
    }


    setPublishing(true);
    console.log("Publishing...")
    if (editing !== 0) {
      updateBlog(editing, title, content, tag, image).then(res => {
        if (!res) {
          console.error("Failed to update blog");
          setPublishing(false);
        } else {
          setPublished(true);
          setTimeout(() => {
            navigate(`/blogs/${editing}`);
          }, 3000);
          console.log("Updated blog");
        }
      })
    } else {
      postBlog(title, content, tag, image).then(res => {
        if (!res) {
          console.error("Failed to publish blog");
          setPublishing(false);
        } else {
          setPublished(true);
          setTimeout(() => {
            navigate(`/app/blogs/${res.data.id}`);
          }, 3000);
          console.log("Published blog: ", res.data);
          }
      })
    }
  }

  if (notFound) {
    return (
      <div className="new-blog-page">
        <div className="not-found">
          <h1>Blog not found</h1>
        </div>
      </div>
    )
  }
  
  else {
  return (
    <div className="new-blog-page">
      <h1 className="section-title">
        { editing !== 0 ? "Update your blog" : "Create a Blog" }
      </h1>
      <label htmlFor="title">Title <span className="error">{errors.title}</span></label>
      <input type="text" placeholder="Set a title..." id="title" value={title} onChange={handleTitle} />
      <label htmlFor="content">Content <span className="error">{errors.content}</span></label>
      <div className="input-div" onClick={handleClick}>
        { focused ? 
        <textarea id="content" ref={input} onBlur={handleBlur} onChange={handleContent} value={content}/> :
        <div dangerouslySetInnerHTML={{ __html: parsed }}>
        </div> 
        }
      </div>
      <label>Tag <span className="error">{errors.tag}</span></label>
      <div className="radios">
        { tagsLoading ? 
          <Loading full={false} /> :
          tags.map((t: any) => { return (
              <>
                { t === tag ? <input type="radio" name="tag" id={t} value={t} onChange={handleTag} checked></input> :
                <input type="radio" name="tag" id={t} value={t} onChange={handleTag}></input>
                }
                <label htmlFor={t}>
                  {t}
                </label>
              </>
            )
          })
        }
      </div>
      <label>Image <span className="error">{errors.image}</span></label>
      <div className="images">
        {
          images.map((img, i) => {
            return (
              <div className="image" key={i}>
                { img === image ? <input type="radio" name="image" id={img} value={img} onChange={handleImage} checked></input> :
                <input type="radio" name="image" id={img} value={img} onChange={handleImage}></input>
                }
                <label htmlFor={img}>
                  <img src={img} alt={`Image ${i + 1}`} />
                </label>
              </div>
            )
          })
        }
      </div>
      {
        editing !== 0 && !publishing ? 
          <button className="publish" onClick={publish}>Update Blog</button> :
          editing === 0 && !publishing ? 
          <button className="publish" onClick={publish}>Publish Blog</button> :
          editing !== 0 && publishing ? 
            <button className="publish">Blog Updated! Redirecting...</button> :
            editing === 0 && publishing ?
              <button className="publish">Blog Published! Redirecting...</button> :
              publishing && !published ?
                <button className="publish"><Loading full={false} /></button> :
                <></>
      }
    </div>
  );
  }
}

export default NewBlogPage
