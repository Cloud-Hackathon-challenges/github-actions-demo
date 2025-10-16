const express = require("express");
const books = require("../controllers/bookController");
const router = express.Router();

// CORS middleware
router.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept"
  );
  res.header("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS");
  if (req.method === "OPTIONS") return res.sendStatus(200);
  next();
});

// CRUD routes
router.route("/books").get(books.listAll);
router.route("/books").post(books.create);
router.route("/books/:bookId").get(books.findOne);
router.route("/books/:bookId").put(books.update);
router.route("/books/:bookId").delete(books.delete);

// 🔹 Borrow & Return endpoints (frontend 'POST' bekliyor)
router.post("/books/:bookId/borrow", books.borrowBook);
router.post("/books/:bookId/return", books.returnBook);

module.exports = router;
