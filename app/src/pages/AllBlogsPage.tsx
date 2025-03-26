import { useEffect, useState } from "react";
import { useBlogContext } from "../contexts/BlogContext"
import '../styles/Explore.css'
import { Blog } from "../types";
import BlogList from "../components/BlogList";
import api from "../api";
import { useNavigate, useSearchParams } from "react-router-dom";

function AllBlogsPage() {
  const { state: { blogs, loading } } = useBlogContext();
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const [filteredBlogs, setFilteredBlogs] = useState<Blog[]>([]);
  const [searchStr, setSearchStr] = useState<string>(searchParams.get('search') || "");
  const [searchInfo, setSearchInfo] = useState<string>("");
  const [tag, setTag] = useState<string>("");
  const [sort, setSort] = useState<string>("Newest");
  const [allTags, setAllTags] = useState<string[]>([]);
  const [allTagsLoading, setAllTagsLoading] = useState<boolean>(true);

  useEffect(() => {
    setAllTagsLoading(true);
    api.get("/blogs/1/tags").then(res => {
      setAllTags(res.data);
      setAllTagsLoading(false);
    }).catch(err => {
      console.error("Failed to load tags: ", err);
      setAllTagsLoading(false);
    })
  }, []);
  useEffect(() => {
    setSearchStr(searchParams.get('search') || "")
  }, [searchParams])
  useEffect(() => {
    if (!loading) {
      let filtered = filterBlogs(blogs, searchStr, tag, sort);
      setFilteredBlogs(filtered);
    }
  }, [blogs]);
  const filterBlogs = (blogs: Blog[], searchStr: string, tag: string, sort: string) => {
    let filtered = blogs;
    if (searchStr !== "") {
      filtered = filtered.filter(blog => blog.title.toLowerCase().includes(searchStr.toLowerCase()));
    }
    if (tag !== "") {
      filtered = filtered.filter(blog => blog.tag === tag);
    }
    if (sort !== "") {
      switch (sort) {
        case "Newest":
          filtered = filtered.sort((a, b) => {
            return (b.created_at as any) - (a.created_at as any);
          });
          break;
        case "Oldest":
          filtered = filtered.sort((a, b) => {
            return (a.created_at as any) - (b.created_at as any);
          });
          break;
        case "Top":
          filtered = filtered.sort((a, b) => {
            return b.likes.length - a.likes.length;
          });
          break;
        case "A-Z":
          filtered = filtered.sort((a, b) => {
            return a.title.localeCompare(b.title);
          });
          break;
        case "Z-A":
          filtered = filtered.sort((a, b) => {
            return b.title.localeCompare(a.title);
          });
          break;
        default:
          break;
        }
    }

    let info = ""
    if (filtered.length === 0) {
      info += `No blogs found `;
    } else {
      info = `Showing <span>${filtered.length}</span> blogs`;
    }

    if (searchStr !== "") {
      info += ` matching <span>"${searchStr}"</span>`;
    }
    if (tag !== "") {
      info += ` in <span>${tag}</span>`;
    }
    if (sort !== "") {
      info += ` sorted by <span>${sort}</span>`;
    }
    setSearchInfo(info);
    return filtered;
  }
  const handleSearchChange = (e: any) => {
    setSearchStr(e.target.value);
    const filtered = filterBlogs(blogs, e.target.value, tag, sort);
    setFilteredBlogs(filtered);
    searchParams.set('search', e.target.value);
    navigate(`?${searchParams.toString()}`);
  }
  const handleTagChange = (e: any) => {
    setTag(e.target.value);
    const filtered = filterBlogs(blogs, searchStr, e.target.value, sort);
    setFilteredBlogs(filtered);
  }
  const handleSortChange = (e: any) => {
    setSort(e.target.value);
    const filtered = filterBlogs(blogs, searchStr, tag, e.target.value);
    setFilteredBlogs(filtered);
  }

  return (
    <div className="explore-page">
      <h1 className="section-title">Explore</h1>
      <div className="search">
        <div className="search-bar">
          <button><i className="fas fa-search"></i></button>
          <input type="text" placeholder="Search..." onChange={handleSearchChange} value={searchStr}/>
        </div>
        <div className="filters-and-info">
          <div className="search-info" dangerouslySetInnerHTML={{ __html: searchInfo }}></div>
          <div className="filters">
            { !allTagsLoading && 
            <select name="tag" id="tag" onChange={handleTagChange} value={tag}>
              <option value="">All</option>
              {allTags.map(tag => <option key={tag} value={tag}>{tag}</option>)}
            </select>
            }
            <select name="sort" id="sort" onChange={handleSortChange} value={sort}>
              <option value="Newest">Newest</option>
              <option value="Oldest">Oldest</option>
              <option value="Top">Top</option>
              <option value="A-Z">A-Z</option>
              <option value="Z-A">Z-A</option>
            </select>
          </div>
        </div>
      </div>
      <BlogList blogs={filteredBlogs} mode="mini-grid" searchStr={searchStr}/>
    </div>
  )
}

export default AllBlogsPage
