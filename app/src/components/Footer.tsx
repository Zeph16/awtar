import '../styles/Footer.css'
function Footer() {
  return (
    <footer className="footer-app">
      <div>
        <p>
          &copy; {new Date().getFullYear()} <span>Awtar</span>. All rights reserved.
        </p>
      </div>
    </footer>
  )
}

export default Footer
