import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import './App.css';

function App() {
  const [token, setToken] = useState(localStorage.getItem('token'));
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [user, setUser] = useState('');
  const [task, setTask] = useState('');
  const [todos, setTodos] = useState([]);
  const [theme, setTheme] = useState(localStorage.getItem('theme') || 'dark');

  useEffect(() => {
    document.body.className = theme;
    localStorage.setItem('theme', theme);
  }, [theme]);

  useEffect(() => {
    if (token) {
      fetch('/api/me', { headers: { Authorization: token } })
        .then(r => r.json())
        .then(data => data.username ? setUser(data.username) : logout())
        .catch(() => logout());
    }
  }, [token]);

  useEffect(() => {
    if (user) loadTodos();
  }, [user]);

  const register = async () => {
    const res = await fetch('/api/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password })
    });
    if (res.ok) alert('Registered! Now login');
  };

  const login = async () => {
    const res = await fetch('/api/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password })
    });
    const data = await res.json();
    if (data.token) {
      localStorage.setItem('token', data.token);
      setToken(data.token);
      setUser(data.username);
    }
  };

  const logout = () => {
    localStorage.removeItem('token');
    setToken(null);
    setUser('');
    setTodos([]);
  };

  const loadTodos = async () => {
    const res = await fetch('/api/todos', { headers: { Authorization: token } });
    const data = await res.json();
    setTodos(data);
  };

  const addTodo = async (e) => {
    e.preventDefault();
    if (!task.trim()) return;
    await fetch('/api/todos', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Authorization: token },
      body: JSON.stringify({ task })
    });
    setTask('');
    loadTodos();
  };

  const toggleTodo = async (id) => {
    await fetch(`/api/todos/${id}`, {
      method: 'PUT',
      headers: { Authorization: token }
    });
    loadTodos();
  };

  const deleteTodo = async (id) => {
    await fetch(`/api/todos/${id}`, {
      method: 'DELETE',
      headers: { Authorization: token }
    });
    loadTodos();
  };

  if (!user) {
    return (
      <motion.div 
        className="container"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        <motion.div className="auth-card">
          <h1>Welcome</h1>
          <input 
            value={username} 
            onChange={e => setUsername(e.target.value)} 
            placeholder="Username" 
            className="input"
          />
          <input 
            value={password} 
            onChange={e => setPassword(e.target.value)} 
            type="password" 
            placeholder="Password" 
            className="input"
            onKeyPress={e => e.key === 'Enter' && login()}
          />
          <div className="btn-group">
            <motion.button 
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={login} 
              className="btn btn-primary"
            >
              Login
            </motion.button>
            <motion.button 
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={register} 
              className="btn btn-secondary"
            >
              Register
            </motion.button>
          </div>
        </motion.div>
      </motion.div>
    );
  }

  return (
    <motion.div 
      className="container"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
    >
      <div className="header">
        <h1>My Todos</h1>
        <div className="header-actions">
          <span className="username">{user}</span>
          <motion.button 
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')} 
            className="btn btn-icon"
          >
            {theme === 'dark' ? '☀️' : '🌙'}
          </motion.button>
          <motion.button 
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={logout} 
            className="btn btn-secondary"
          >
            Logout
          </motion.button>
        </div>
      </div>

      <form onSubmit={addTodo} className="add-todo">
        <input 
          value={task} 
          onChange={e => setTask(e.target.value)} 
          placeholder="What needs to be done?" 
          className="input"
        />
        <motion.button 
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
          type="submit" 
          className="btn btn-primary"
        >
          Add
        </motion.button>
      </form>

      <AnimatePresence>
        {todos.map(t => (
          <motion.div
            key={t._id}
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: 20 }}
            className={`todo-item ${t.done ? 'done' : ''}`}
          >
            <input 
              type="checkbox" 
              checked={t.done} 
              onChange={() => toggleTodo(t._id)}
              className="checkbox"
            />
            <span className="task">{t.task}</span>
            <motion.button 
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.9 }}
              onClick={() => deleteTodo(t._id)} 
              className="btn-delete"
            >
              ✕
            </motion.button>
          </motion.div>
        ))}
      </AnimatePresence>

      {todos.length === 0 && (
        <motion.div 
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="empty-state"
        >
          No todos yet. Add one above!
        </motion.div>
      )}
    </motion.div>
  );
}

export default App;
