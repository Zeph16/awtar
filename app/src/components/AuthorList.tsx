import { Author } from "../types";
import '../styles/AuthorList.css'

function AuthorList({ authors }: { authors: Author[] }) {
  if (authors.length === 0) {
    return (
      <div className="empty-message">
        <p>No authors found</p>
      </div>
    )
  }
  return (
    <div className="authors-list">
      {authors.map(a => {
        return (
          <div key={a.id} className="author">
            <div className="author-img">
              <img src={a.image} alt={a.name} />
            </div>
            <div className="author-details">
              <h1>{a.name}</h1>
              <p>{a.username}</p>
            </div>
          </div>
        )
      })}
    </div>
  )
}

export default AuthorList
