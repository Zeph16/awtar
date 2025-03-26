import '../styles/ConfirmationBox.css'
function ConfirmationBox({ message, handleYes, handleNo }: { message: string, handleYes: () => void, handleNo: () => void }) {
  return (
    <div className="confirm-wrapper" onClick={handleNo}>
      <div className="confirm" onClick={(e) => e.stopPropagation()}>
        <p>{message}</p>
        <div className="buttons">
          <button className="yes" onClick={handleYes}>Yes</button>
          <button className="no" onClick={handleNo}>No</button>
        </div>
      </div>
    </div>
  )
}

export default ConfirmationBox
