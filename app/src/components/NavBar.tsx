import { Link, NavLink, useLocation } from "react-router-dom";
import { useNotificationContext } from "../contexts/NotificationContext"
import { useProfileContext } from "../contexts/ProfileContext"
import { useNavigate } from "react-router-dom";
import "../styles/NavBar.css";
import { useEffect, useState } from "react";
import NotificationSSEListener from "../listeners/NotificationSSEListener";
import Popup from "./Popup";
import { Notification } from "../types";
import { readNotification } from "../api";

interface Popup {
  notification: Notification,
  popped: boolean
}
function NavBar({isNavFixed}: {isNavFixed: boolean}) {
  const navigate = useNavigate();
  const location = useLocation();
  const { user } = useProfileContext();
  const { state: { notifications, loading: notifsLoading }, dispatch } = useNotificationContext();
  const [isSearchOpen, setIsSearchOpen] = useState<boolean>(false);
  const [isMenuOpen, setIsMenuOpen] = useState<boolean>(false);
  const [searchText, setSearchText] = useState<string>("");
  const [isDarkMode, setIsDarkMode] = useState<boolean>(false);
  const [popups, setPopups] = useState([] as Popup[]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!notifsLoading) setLoading(false);
  }, [notifsLoading]);
  useEffect(() => {
    if (!loading) {
      const notification = notifications.sort((a, b) => b.id - a.id)[0];
      console.log("Popup: ", notification);
      if (notification && !notification.is_read && !(popups.map(p => p.notification.id).includes(notification.id)) && location.pathname !== "/app/notifications") {
        console.log("popups: ", popups)
        setPopups([...popups, { notification, popped: false }]);
        setTimeout(() => {
          setPopups(popups.map(p => p.notification.id === notification.id ? { notification, popped: true } : p));
        }, 5000);
      }
    }
  }, [notifications]);

  const handleSearchClick = () => {
    if (searchText !== "") {
      setIsSearchOpen(false);
      setIsMenuOpen(false);
      navigate(`/app/blogs?search=${searchText}`);
    }
  }

  const handleMenuExpand = () => {
    setIsMenuOpen(!isMenuOpen);
  }

  const handleSearchExpand = () => {
    setIsSearchOpen(!isSearchOpen);
    setSearchText("");
  }

  const handleSearchChange = (e: any) => {
    setSearchText(e.target.value);
  }

  const handleDarkModeClick = () => {
    setIsDarkMode(!isDarkMode);
    const root = document.documentElement;
    if (!isDarkMode) {
      root.style.setProperty('--background-color', "#1A120B");
      root.style.setProperty('--tertiary-color', "#3C2A21")
      root.style.setProperty('--secondary-color', "#D5CEA3")
      root.style.setProperty('--primary-color', "#E5E5CB");
    } else {
      root.style.setProperty('--background-color', "#F5F5F5");
      root.style.setProperty('--tertiary-color', "#F2EAD3");
      root.style.setProperty('--secondary-color', "#DFD7BF");
      root.style.setProperty('--primary-color', "#3F2305");
    }
  }

  const markAsRead = (notification: number) => {
    setPopups(popups.map(p => p.notification.id === notification ? { notification: p.notification, popped: true } : p))
    readNotification(notification).then((res: boolean) => {
      if (res) {
        dispatch({ type: 'MARK_NOTIFICATION_AS_READ', payload: notification });
      } else {
        console.error("Error marking notification as read");
      }
    })
  }

  return (
    <header className={isNavFixed ? "header-fixed" : ""}>
      <NotificationSSEListener />
      <div className="popups">
      { location.pathname !== "/app/notifications" && popups.filter(p => !p.popped).map(p => <Popup key={p.notification.id} notification={p.notification} markAsRead={() => markAsRead(p.notification.id)} />)}
      </div>
      <nav>
        <div>
          <div className={`hamburger ${isMenuOpen ? 'active' : ''}`}
            onClick={handleMenuExpand}>
            <div className="line1"></div>
            <div className="line2"></div>
            <div className="line3"></div>
          </div>
          <h1 className="logo">
            <Link to="/app">Awtar</Link>
          </h1>
        </div>
        <ul className={`nav-links ${isMenuOpen ? 'active' : ''}`}>
          <li className="close">
            <i className="fas fa-times" onClick={handleMenuExpand}></i>
          </li>
          <li onClick={() => setIsMenuOpen(false)}><NavLink to="/">Home</NavLink></li>
          <li onClick={() => setIsMenuOpen(false)}><NavLink to="/blogs">Blogs</NavLink></li>
          <li onClick={() => setIsMenuOpen(false)}><NavLink to="/bookmarks">Bookmarks</NavLink></li>
          <li>
            <div className={`search ${isSearchOpen || isMenuOpen ? "expanded" : ""}`}>
              {!isMenuOpen ? isSearchOpen ? <i className="fas fa-times" onClick={handleSearchExpand}></i> : <i className="fas fa-search" onClick={handleSearchExpand}></i> : ''}
              <input type="text" placeholder="Search" value={searchText} onChange={handleSearchChange} onKeyDown={(e) => e.key === "Enter" ? handleSearchClick() : ""}/>
              <i className="fas fa-search" onClick={handleSearchClick}></i>
            </div>
          </li>
        </ul>
        <div className="profile">
          <div className="new-blog">
            <Link to="/app/new">
              <i className="fas fa-plus"></i>
              <span>New Blog</span>
            </Link>
          </div>
          <div className="notifications">
            <Link to="/app/notifications">
              <i className="fas fa-bell"></i>
              <div className="notifications-count">{notifsLoading ? "-" : notifications.filter(n => !n.is_read).length}</div>
            </Link>
          </div>
          <div className="dark-mode">
            <i className="fas fa-moon" onClick={handleDarkModeClick}></i>
          </div>
          <div className="profile-img">
            <Link to={`/app/authors/${user.id}`}><img src="http://localhost:8000/images/default.jpg" alt="profile" /></Link>
          </div>
        </div>
      </nav>
    </header>
  )
}

export default NavBar
