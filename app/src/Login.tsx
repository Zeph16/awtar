import { useState } from 'react'

export const Login = () => {
  const [image, setImage] = useState("");
  const images = [
    'http://localhost:8000/images/profile1.jpg',
    'http://localhost:8000/images/profile2.jpg',
    'http://localhost:8000/images/profile3.jpg',
    'http://localhost:8000/images/profile4.jpg',
    'http://localhost:8000/images/profile5.jpg',
    'http://localhost:8000/images/profile6.jpg',
  ];

  const login = () => {
    localStorage.setItem("user", "3.3b97703bfceb9db6b8108cf6a3b45874522cddebbf92552c930df75bf3b85ad8");
    window.location.href = "http://localhost:3000/app"
  }

  return (
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
  )
}
