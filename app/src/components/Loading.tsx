import '../styles/Loading.css'
function Loading({ full } : { full: boolean }) {
  return (
    <div className={`loading-indicator ${full ? 'full' : ''}`}>
      <div className="loading-spinner">
        <div className="spinner-inner"></div>
      </div>
    </div>
  )
}

export default Loading
