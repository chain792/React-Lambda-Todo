const Todo = (props) => {
  const handleDeleteClick = () => {
    props.onDeleteClick(props.todo.id)
  }

  const handleChecboxChange = () => {
    props.onCheckboxChange(props.todo.id, !props.todo.isCompleted)
  }

  return (
    <li>
      <label>
        <input 
          type="checkbox" 
          checked={props.todo.isCompleted}
          onChange={handleChecboxChange}
        />
        <span>
          {props.todo.title}
        </span>
      </label>
      <button onClick={handleDeleteClick}>Del</button>
    </li>
  )
}

export default Todo
