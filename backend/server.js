const express = require('express');
const mongoose = require('mongoose');
const crypto = require('crypto');

const app = express();
app.use(express.json());

mongoose.connect(process.env.MONGO_URL || 'mongodb://mongo:27017/appdb');

const User = mongoose.model('User', { username: String, password: String });
const Todo = mongoose.model('Todo', { userId: String, task: String, done: Boolean });

const auth = async (req, res, next) => {
  const token = req.headers.authorization;
  if (!token) return res.status(401).json({error: 'Unauthorized'});
  const user = await User.findById(token);
  if (!user) return res.status(401).json({error: 'Unauthorized'});
  req.userId = token;
  req.username = user.username;
  next();
};

app.post('/api/register', async (req, res) => {
  const {username, password} = req.body;
  const hash = crypto.createHash('sha256').update(password).digest('hex');
  const user = new User({username, password: hash});
  await user.save();
  res.json({success: true});
});

app.post('/api/login', async (req, res) => {
  const {username, password} = req.body;
  const hash = crypto.createHash('sha256').update(password).digest('hex');
  const user = await User.findOne({username, password: hash});
  if (!user) return res.status(401).json({error: 'Invalid credentials'});
  res.json({token: user._id.toString(), username: user.username});
});

app.get('/api/me', auth, (req, res) => {
  res.json({username: req.username});
});

app.get('/api/todos', auth, async (req, res) => {
  const todos = await Todo.find({userId: req.userId});
  res.json(todos);
});

app.post('/api/todos', auth, async (req, res) => {
  const todo = new Todo({userId: req.userId, task: req.body.task, done: false});
  await todo.save();
  res.json(todo);
});

app.put('/api/todos/:id', auth, async (req, res) => {
  const todo = await Todo.findOne({_id: req.params.id, userId: req.userId});
  todo.done = !todo.done;
  await todo.save();
  res.json(todo);
});

app.delete('/api/todos/:id', auth, async (req, res) => {
  await Todo.deleteOne({_id: req.params.id, userId: req.userId});
  res.json({success: true});
});

app.listen(3000, () => console.log('Backend running on port 3000'));
