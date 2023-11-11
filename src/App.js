import { useEffect, useState } from 'react';
import Todo from './components/Todo';
import AddForm from './components/AddForm';
import axios from 'axios';

const App = () => {
  const [todos, setTodos] = useState([])

  const getTodos = () => {
    axios.get(`${process.env.REACT_APP_BASE_URL}/todo`
    ).then(res => {
      setTodos(res.data)
    }).catch(e => {
      console.log(e)
    })
  }

  useEffect(() => {
    getTodos()
  },[])

  const updateTodos = (newTodos) => {
    setTodos(newTodos)
    localStorage.setItem('todos', JSON.stringify(newTodos))
  }

  const handleAddFormSubmit = (title) => {
    if (!title) return

    axios.post(`${process.env.REACT_APP_BASE_URL}/todo`, {
      title
    }).then(() => {
      getTodos()
    }).catch(e => {
      console.log(e)
    })
  }

  const handleTodoCheckboxChange = (id, isCompleted) => {
    axios.patch(`${process.env.REACT_APP_BASE_URL}/todo?id=${id}`, {
      isCompleted
    }).then(() => {
      getTodos()
    }).catch(e => {
      console.log(e)
    })
  }

  const handleTodoDeleteClick = (id) => {
    axios.delete(`${process.env.REACT_APP_BASE_URL}/todo?id=${id}`
    ).then(() => {
      getTodos()
    }).catch(e => {
      console.log(e)
    })
  }

  const todoItems = todos.map((todo) => {
    return (
      <Todo
        key={todo.id}
        todo={todo}
        onDeleteClick={handleTodoDeleteClick}
        onCheckboxChange={handleTodoCheckboxChange}
      />
    )
  })

  return (
    <div className="container">
      <h1>Todoリスト</h1>
      <ul>
        {todoItems}
      </ul>
      <AddForm
        onSubmit={handleAddFormSubmit}
      />
    </div>
  )
}

export default App;
