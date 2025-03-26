import { Routes, Route, useLocation } from 'react-router-dom'
import { useEffect, useLayoutEffect, useState } from 'react'
import NavBar from './components/NavBar'
import AllBlogsPage from './pages/AllBlogsPage'
import BlogPage from './pages/BlogPage'
import BookmarksPage from './pages/BookmarksPage'
import HomePage from './pages/HomePage'
import NewBlogPage from './pages/NewBlogPage'
import NotFound from './pages/NotFound'
import NotificationsPage from './pages/NotificationsPage'
import ProfilePage from './pages/ProfilePage'
import BlogSSEListener from './listeners/BlogSSEListener'
import './App.css'
import '@fortawesome/fontawesome-free/css/all.min.css';
import AuthorSSEListener from './listeners/AuthorSSEListener'
import { BrowserRouter } from 'react-router-dom'
import Footer from './components/Footer'

import BlogContextProvider from './contexts/BlogContext.tsx'
import AuthorContextProvider from './contexts/AuthorContext.tsx';
import NotificationContextProvider from './contexts/NotificationContext.tsx';
import ProfileContextProvider from './contexts/ProfileContext.tsx';
import Landing from './Landing.tsx'

const Wrapper = ({children} : {children: React.ReactNode}) => {
  const location = useLocation();
  useLayoutEffect(() => {
    document.documentElement.scrollTo(0, 0);
  }, [location.pathname]);
  return children
} 

function App() {
  const [isNavFixed, setIsNavFixed] = useState<boolean>(false);
  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 0) {
        setIsNavFixed(true);
      } else {
        setIsNavFixed(false);
      }
    };

    window.addEventListener('scroll', handleScroll);

    return () => {
      window.removeEventListener('scroll', handleScroll);
    };
  }, []);

  if (window.location.href === "http://localhost:3000/") {
    return <Landing />
  } else {
    return (
        <ProfileContextProvider>
          <BlogContextProvider>
            <AuthorContextProvider>
              <NotificationContextProvider>
                <BrowserRouter>
                  <Wrapper>
                    <>
                      <NavBar isNavFixed={isNavFixed}/>
                      <BlogSSEListener />
                      <AuthorSSEListener />
                      <main className={`container ${isNavFixed ? "adjust-container" : ""}`}>
                        <Routes>
                          <Route path="/app" element={<HomePage />} />
                          <Route path="/app/blogs" element={<AllBlogsPage />} />
                          <Route path="/app/blogs/:id" element={<BlogPage />} />
                          <Route path="/app/new" element={<NewBlogPage />} />
                          <Route path="/app/bookmarks" element={<BookmarksPage />} />
                          <Route path="/app/notifications" element={<NotificationsPage />} />
                          <Route path="/app/authors/:id" element={<ProfilePage />} />

                          <Route path="*" element={<NotFound />} />
                        </Routes>
                      </main>
                      <Footer />
                    </>
                  </Wrapper>
                </BrowserRouter>
              </NotificationContextProvider>
            </AuthorContextProvider>
          </BlogContextProvider>
        </ProfileContextProvider>
    )
  }
}

export default App
