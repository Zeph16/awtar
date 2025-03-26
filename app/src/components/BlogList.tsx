import { useState } from 'react';
import { useAuthorContext } from '../contexts/AuthorContext'
import '../styles/BlogList.css'
import { Blog } from '../types'
import BlogItem from './BlogItem';

function BlogList({ blogs, mode, searchStr }: { blogs: Blog[], mode: 'featured' | 'grid' | 'mini-grid' | 'top-down', searchStr?: string }) {
  const { state: { authors } } = useAuthorContext();
  const [currentSlide, setCurrentSlide] = useState(0);

  const totalSlides = Math.ceil(blogs.length);
  

  const handlePrevious = () => {
    setCurrentSlide((prevSlide) => (prevSlide === 0 ? totalSlides - 1 : prevSlide - 1));
  };

  const handleNext = () => {
    setCurrentSlide((prevSlide) => (prevSlide === totalSlides - 1 ? 0 : prevSlide + 1));
  };
  switch (mode) {
    case 'featured':
      return (
        <div className="blog-list slider">
        <div
          className="slider-items"
          style={{
            transform: `translateX(-${currentSlide * 100}%)`,
          }}
        >
            {
              blogs.map((blog: Blog) => {
                return (
                    <BlogItem key={blog.id} blog={blog} searchStr={searchStr} author={authors.find(author => author.id === blog.author_id)!} mode="full" />
                )})
            }
          </div>
          <button onClick={handlePrevious}>
            <i className="fas fa-chevron-left"></i>
          </button>
          <button onClick={handleNext}>
            <i className="fas fa-chevron-right"></i>
          </button>
        </div>
      )
    case 'grid':
      return (
        <div className={'blog-list grid'}>
          {
            blogs.map((blog: Blog) => {
              return <BlogItem key={blog.id} blog={blog} searchStr={searchStr} author={authors.find(author => author.id === blog.author_id)!} mode="cell" />
            })
          }
        </div>
      )
    case 'mini-grid':
      return (
        <div className={'blog-list mini-grid'}>
          {
            blogs.map((blog: Blog) => {
              return <BlogItem key={blog.id} blog={blog} searchStr={searchStr} author={authors.find(author => author.id === blog.author_id)!} mode="mini" />
            })
          }
        </div>
      )
    case 'top-down':
      return (
        <div className={'blog-list top-down'}>
          {
            blogs.map((blog: Blog) => {
              return <BlogItem key={blog.id} blog={blog} searchStr={searchStr} author={authors.find(author => author.id === blog.author_id)!} mode="long" />
            })
          }
        </div>
      )
    default:
      return null;
  }
}

export default BlogList
