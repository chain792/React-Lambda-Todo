import { useRef, useState } from "react"

const AddForm = (props) => {
  const [title, setTitle] = useState('')
  const inputRef = useRef(null)
  const handleTextChange = (e) => {
    setTitle(e.currentTarget.value)
  }
  const handleSubmit = (e) => {
    e.preventDefault();
    props.onSubmit(title)
    setTitle('')
    inputRef.current.focus()
  }
  return (
    <form onSubmit={handleSubmit}>
      <input 
        type="text"
        value={title}
        onChange={handleTextChange}
        ref={inputRef}
      />
      <button>Add</button>
    </form>
  )
}

export default AddForm
