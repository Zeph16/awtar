import { useEffect, useState } from "react";
import { useAuthorContext } from "../contexts/AuthorContext";
import { useProfileContext } from "../contexts/ProfileContext"
import { Author, Blog } from "../types";
import { useNavigate, useParams } from "react-router-dom";
import Loading from "../components/Loading";
import { deleteUser, follow, getFollowing, unfollow, updateUser } from "../api";
import '../styles/ProfilePage.css'
import { useBlogContext } from "../contexts/BlogContext";
import BlogList from "../components/BlogList";
import ConfirmationBox from "../components/ConfirmationBox";
import AuthorList from "../components/AuthorList";

function ProfilePage() {
  const navigate = useNavigate();
  const { user, loading: userLoading, setUser } = useProfileContext();
  const { state: { authors, loading: authorsLoading } } = useAuthorContext();
  const { state: { blogs, loading: blogsLoading } } = useBlogContext();
  const [authorBlogs, setAuthorBlogs] = useState([] as Blog[]);
  const [likedBlogs, setLikedBlogs] = useState([] as Blog[]);
  const [author, setAuthor] = useState({} as Author);
  const [loading, setLoading] = useState(true);
  const [notFound, setNotFound] = useState(false);
  const [following, setFollowing] = useState(false);
  const [updating, setUpdating] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [current, setCurrent] = useState("blogs" as "blogs" | "likes");
  const { id } = useParams();
  const [mode, setMode] = useState<"view" | "edit" | "followers" | "following">("view");

  // set input states for editing
  const [name, setName] = useState("");
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [bio, setBio] = useState("");
  const [image, setImage] = useState("");
  const [errors, setErrors] = useState({} as { [key: string]: string });

  const [confirmation, setConfirmation] = useState({ message: "", handleYes: () => {}, handleNo: () => {}});

  const images = [
    'http://localhost:8000/images/profile1.jpg',
    'http://localhost:8000/images/profile2.jpg',
    'http://localhost:8000/images/profile3.jpg',
    'http://localhost:8000/images/profile4.jpg',
    'http://localhost:8000/images/profile5.jpg',
    'http://localhost:8000/images/profile6.jpg',
  ];

  useEffect(() => {
    if (!blogsLoading) {
      setAuthorBlogs(blogs.filter(blog => blog.author_id === Number(id)));
      setLikedBlogs(blogs.filter(blog => blog.likes.some(l => l === Number(id))));
    }
  }, [blogs]);
  useEffect(() => {
    if (Object.keys(author).length === 0 && !loading) {
      setLoading(true);
    }

    if (!userLoading && Number(id) === user.id) {
      setAuthor(user);
      setName(user.name);
      setUsername(user.username);
      setEmail(user.email || "")
      setPassword(user.password || "")
      setBio(user.bio || "")
      setImage(user.image || "")
      setLoading(false);
    } else if (!authorsLoading && Number(id) !== user.id) {
      const a = authors.find(a => a.id === Number(id));
      if (!a) {
        setNotFound(true);
        setLoading(false);
      } else {
        setAuthor(a);
        setLoading(false);
      }
    }
  }, [user, authors])
  useEffect(() => {
    if (!loading && author.id !== user.id) {
      getFollowing(user.id).then(response => {
        if (response) {
          if (response.data.find((f: number) => f === author.id))  setFollowing(true);
          else setFollowing(false);
        }
      })
    }
  })

  const handleUpdate = () => {
    if (name.length === 0 || username.length === 0 || password.length === 0 || email.length === 0) {
      let err = {} as { [key: string]: string };
      if (name.length === 0) {
        err.name = "Name is required";
      } else {
        err.name = "";
      }
      if (username.length === 0) {
        err.username = "Username is required";
      } else {
        err.username = "";
      }
      if (password === "") { err.password = "Password is required";
      } else {
        err.password = "";
      }
      if (email === "") {
        err.email = "Email is required";
      } else {
        err.email = "";
      }
      
      setErrors(err);
      return;
    }

    if (password.length < 8) {
      setErrors({ password: "Password must be at least 8 characters" });
      return;
    }
    if (email.length > 0 && !email.includes('@')) {
      setErrors({ email: "Invalid email" });
      return;
    }
    setConfirmation({ message: "Are you sure you want to update your profile?", handleYes: update, handleNo: clearConfirm})
  }
  const handleFollow = () => {
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
  const update = () => {
    clearConfirm();
    setUpdating(true);
    updateUser(author.id, username, password, email, name, bio, image).then(res => {
      if (res) {
        console.log("Successfully updated user");
        setAuthor({ ...author, name, username, email, password, bio, image });
        setUser({ ...user, name, username, email, password, bio, image });
        setMode("view");
      } else {
        console.log("Failed to update user");
      }
      setUpdating(false);
    })
  }
  const logoutUser = () => {
    clearConfirm();
    localStorage.clear();
    navigate('/');
  }
  const deleteAccount = () => {
    clearConfirm();
    deleteUser(user.id).then(res => {
      if (res) {
        localStorage.clear();
        navigate('/');
      } else {
        console.log("Failed to delete user");
      }
    })
  }
  const clearConfirm = () => {
    setConfirmation({ message: "", handleYes: () => {}, handleNo: () => {}})
  }

  const renderView = () => {
    return (
      <div className="top">
        <div className="images">
          <div className="profile-image">
            <img src={author?.image} alt="" />
          </div>
        </div>
        <div className="profile-details">
          <h1>{author?.name} { user.id === author.id && <i className="fas fa-edit" onClick={() => setMode("edit")}></i> }</h1>
          <div className="followers">
            <div onClick={() => setMode("followers")}><span>{author?.followers.length}</span> followers</div>
            <span>.</span>
            <div onClick={() => setMode("following")}><span>{author?.following.length}</span> following</div>
          </div>
          {author?.username && 
            <>
            <h2>Username</h2>
            <p className="username">@{author?.username}</p>
            </>
          }
          {author?.email && 
            <>
            <h2>Email</h2>
            <p className="email">{author?.email}</p>
            </>
          }
          {author?.password && 
            <>
            <h2>Password <button className="show-password" onClick={() => setShowPassword(prev => !prev)}><i className="fas fa-eye"></i></button></h2>
            <p className="password">{ showPassword ? author?.password : "********" } </p>
            </>
          }
          {author?.bio && 
            <>
            <h2>Bio</h2>
            <p className="bio">{author?.bio}</p>
            </>
          }
          <div className="counts">
            <div>
              <h2>Total Blogs</h2>
              <p>{authorBlogs.length}</p>
            </div>
            <div>
              <h2>Likes Gained</h2>
              <p>{authorBlogs.reduce((acc, blog) => acc + blog.likes.length, 0)}</p>
            </div>
          </div>
          { user.id !== author.id ? 
            <div className="follow">
              <button className={`${following ? "unfollow" : "follow"}`}onClick={handleFollow}>{following ? <span><i className="fas fa-user-check"></i> Following</span> : <span><i className="fas fa-user-plus"></i> Follow</span>}</button>
            </div> :
            <div className="profile-buttons">
              <button className="logout" onClick={() => setConfirmation({ message: "Are you sure you want to logout?", handleYes: logoutUser, handleNo: clearConfirm })}><i className="fas fa-close"></i> Logout</button>
              <button className="delete" onClick={() => setConfirmation({ message: "Are you sure you want to delete your account? This action is not reversible.", handleYes: deleteAccount, handleNo: clearConfirm })}><i className="fas fa-trash"></i> Delete Account</button>
            </div>
          }
        </div>
      </div>
    )
  }
  const renderEdit = () => {
    function cancelEditing() {
      setName(author.name);
      setUsername(author.username);
      setEmail(author.email || "")
      setPassword(author.password || "")
      setBio(author.bio || "")
      setImage(author.image || "")
      setErrors({});
      setMode("view")
    }

    // THIS IS TRIGGERED WHEN EDITING
    return (
      <div className="top">
        <div className="images">
          <div className="profile-image">
            <img src={image} alt="" />
          </div>
          <div className="image-selector">
            {
              images.map((img, i) => {
                return (
                  <div className="image" key={i}>
                    { img === image ? <input type="radio" name="image" id={img} value={img} onChange={ (e) => setImage(e.target.value) } checked></input> :
                    <input type="radio" name="image" id={img} value={img} onChange={ (e) => setImage(e.target.value) }></input>
                    }
                    <label htmlFor={img}>
                      <img src={img} alt={`Image ${i + 1}`} />
                    </label>
                  </div>
                )
              })
            }
          </div>
        </div>
        <div className="profile-details">
          <span className="error">{errors.name}</span>
          { user.id === author.id && <div className="options">{ !updating ? <i className="fas fa-save" onClick={handleUpdate}></i> : <i className="fas fa-clock"></i> }<i className="fas fa-close" onClick={cancelEditing}></i></div> }
          <h2>Name</h2>
          <input type="text" value={name} onChange={e => setName(e.target.value)} />
          {author?.username && 
            <>
            <h2>Username <span className="error">{errors.username}</span></h2>
            <input type="text" value={username} onChange={e => setUsername(e.target.value)} />
            </>
          }
          {author?.email && 
            <>
            <h2>Email <span className="error">{errors.email}</span></h2>
            <input type="text" value={email} onChange={e => setEmail(e.target.value)} />
            </>
          }
          {author?.password && 
            <>
            <h2>Password <span className="error">{errors.password}</span></h2>
            <input type="text" value={password} onChange={e => setPassword(e.target.value)} />
            </>
          }
          {author?.bio && 
            <>
            <h2>Bio</h2>
            <textarea cols={3} value={bio} onChange={e => setBio(e.target.value)}></textarea>
            </>
          }
        </div>
      </div>
    )
  }
  const renderFollowers = () => {
    return (
      <div className="followers-list">
        <button className="back" onClick={() => setMode("view")}><i className="fas fa-arrow-left"></i> Back</button>
        <h1>{author.name}'s Followers</h1>
        <div className="author-list-wrapper">
          <AuthorList authors={authors.filter(a => author.followers.includes(a.id))} />
       </div>
      </div>
    )
  }
  const renderFollowing = () => {
    return (
      <div className="followers-list">
        <button className="back" onClick={() => setMode("view")}><i className="fas fa-arrow-left"></i> Back</button>
        <h1>{author.name}'s Following</h1>
        <div className="author-list-wrapper">
          <AuthorList authors={authors.filter(a => author.following.includes(a.id))} />
        </div>
      </div>
    )
  }

  


  if (loading || blogsLoading) {
    return <Loading full={true} />
  }
  
  else if (notFound) {

  return (
    <div className="profile-page">
      <div className="not-found">
        <h1>Author not found</h1>
      </div>
    </div>
  )

  } 


  else {

    return (
      <div className="profile-page">
        { confirmation.message !== "" && <ConfirmationBox message={confirmation.message} handleYes={confirmation.handleYes} handleNo={confirmation.handleNo} /> }
        <h1 className="section-title">Profile</h1>
        {
          mode === "view" ? renderView() :
          mode === "edit" ? renderEdit() :
          mode === "followers" ? renderFollowers() :
          mode === "following" ? renderFollowing() : null
        }
        <div className="bottom">
          <div className="buttons">
            <button onClick={() => setCurrent("blogs")} className={current === "blogs" ? "active" : ""}>Published Blogs</button>
            <button onClick={() => setCurrent("likes")} className={current === "likes" ? "active" : ""}>Liked Blogs</button>
          </div>
          <div className="list">
          { current === "blogs" && authorBlogs.length === 0 ? <div className="empty-message"><p>No blogs published</p></div> :
            current === "likes" && likedBlogs.length === 0 ? <div className="empty-message"><p>No blogs liked</p></div> :
            <BlogList blogs={current === "blogs" ? authorBlogs : likedBlogs} mode="top-down"/> }
          </div>
        </div>
      </div>
    )

  }
}

export default ProfilePage
