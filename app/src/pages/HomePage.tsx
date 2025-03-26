import { useBlogContext } from "../contexts/BlogContext"
import BlogList from "../components/BlogList";
import Loading from "../components/Loading";
import '../styles/HomePage.css'
import { useEffect, useState } from "react";
import { useProfileContext } from "../contexts/ProfileContext";
function HomePage() {
  const { state: { blogs, loading: blogLoading } } = useBlogContext();
  const { login } = useProfileContext();
  const [latest, setLatest] = useState(4);

  useEffect(() => {
    login();
    if (window.innerWidth < 1100) {
      setLatest(4); 
      console.log("latest set to 4");
    }
    const adjustLatest = () => {
      window.innerWidth < 1100 ? setLatest(4) : latest === 4 ? setLatest(3) : "";
    }
    window.addEventListener('resize', adjustLatest);
    return () => window.removeEventListener('resize', adjustLatest);
  }, [])
  if (blogLoading) {
    return (
     <Loading full={true}/>
    )
  }
  return (
    <div>
      <h1 className="section-title">Featured Blogs</h1>
      <BlogList blogs={blogs.slice(9,12)} mode="featured"/>
      <h1 className="section-title">Top Blogs</h1>
      <BlogList blogs={blogs.slice(6,9)} mode="top-down"/>
      <h1 className="section-title">Latest Blogs</h1>
      <BlogList blogs={blogs.slice(0,latest)} mode="grid"/>
      <BlogList blogs={blogs.slice(3,11)} mode="mini-grid"/>

    </div>
  )
}

export default HomePage
