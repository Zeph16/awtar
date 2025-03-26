import './Landing.css'

export default function Landing() {
  const login = () => {
    localStorage.setItem("user", "3.3b97703bfceb9db6b8108cf6a3b45874522cddebbf92552c930df75bf3b85ad8");
    window.location.href = "http://localhost:3000/app"
  }

  return (
    <>
      <header className="header-landing">
        <nav className="nav-landing">
          <div>
            <div className="open-menu">
              <span className="line"></span>
              <span className="line"></span>
              <span className="line"></span>
            </div>
            <h1>Awtar</h1>
          </div>
          <ul className="">
            <li className="close-menu-wrapper">
              <div className="close-menu">
                <span className="line"></span>
                <span className="line"></span>
              </div>
            </li>
            <li><a href="#hero">Home</a></li>
            <li><a href="#features">Features</a></li>
            <li><a href="#about">About Us</a></li>
            <li><a href="#categories">Categories</a></li>
          </ul>
          <div className="buttons">
            <button onClick={login}>Log In</button>
            <button onClick={login}>Sign Up</button>
          </div>
        </nav>
      </header>
      <main className="main-landing">
        <section className="hero">
          <div className="hero-content">
            <h1>Empowering Bloggers, Connecting Minds</h1>
            <p>Join the community of bloggers and writers from all around the world. Share your thoughts, ideas and experiences. Let your voice be heard.</p>
            <button className="primary">Get Started</button>
          </div>
          <div className="hero-image">
            <img src="http://localhost:8000/images/img4.jpg" alt="" />
          </div>
        </section>
        <section id="features">
          <div className="features-wrapper">
            <div className="feature">
              <span><i className="fas fa-edit"></i></span>
              <p className="feature-title">Write</p>
              <p className="feature-description">Write your thoughts, ideas and experiences. Share them with the world.</p>
            </div>
            <div className="feature">
              <span><i className="fas fa-book"></i></span>
              <p className="feature-title">Read</p>
              <p className="feature-description">Read the stories, thoughts and experiences of other writers and bloggers.</p>
            </div>
            <div className="feature">
              <span><i className="fas fa-users"></i></span>
              <p className="feature-title">Connect</p>
              <p className="feature-description">Connect with other writers and bloggers. Share your thoughts and ideas.</p>
            </div>
          </div>
        </section>
        <section id="about">
          <div className="about-image">
            <img src="http://localhost:8000/images/img2.jpg" alt="" />
          </div>
          <div className="about-content">
            <h1 className="section-title-landing">About Us</h1>
            <p className="section-description-landing">Awtar is a platform for bloggers and writers from all around the world. It is a place where you can share your thoughts, ideas and experiences. You can connect with other writers and bloggers. You can read the stories and experiences of other writers and bloggers. You can let your voice be heard.</p>
          </div>
        </section>
        <section id="categories">
          <h1 className="section-title-landing">Categories</h1>
          <div className="categories-wrapper">
            <div className="category">
              <span><i className="fas fa-laptop"></i></span>
              <p className="category-title">Technology</p>
            </div>
            <div className="category">
              <span><i className="fas fa-gamepad"></i></span>
              <p className="category-title">Gaming</p>
            </div>
            <div className="category">
              <span><i className="fas fa-heartbeat"></i></span>
              <p className="category-title">Health & Fitness</p>
            </div>
            <div className="category">
              <span><i className="fas fa-users"></i></span>
              <p className="category-title">Lifestyle</p>
            </div>
          </div>
        </section>
      </main>
      <footer className="footer-landing">
        <div className="get-started-landing">
          <h1 className="section-title-landing">Get Started</h1>
          <p className="section-description-landing">Join the community of bloggers and writers from all around the world. Share your thoughts, ideas and experiences. Let your voice be heard.</p>
          <button className="primary" onClick={login}>Sign Up</button>
        </div>
        <div className="footer-landing-div">
          <p>
            &copy; 2024 <span>Awtar</span>. All rights reserved.
          </p>
        </div>
      </footer>
    </>
  );
}
