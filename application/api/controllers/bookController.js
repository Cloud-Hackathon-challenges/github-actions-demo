const Book = require("../models/bookModel.js");

// List all books or filter by name
exports.listAll = function (req, res) {
  if (req.query.bookname) {
    Book.findOne({ bookname: { $regex: req.query.bookname } }, function (err, book) {
      if (err) return res.status(500).send(err);
      res.json(book);
    });
  } else {
    Book.find({}, function (err, books) {
      if (err) return res.status(500).send(err);
      res.json(books);
    });
  }
};

// Find a single book by ID
exports.findOne = (req, res) => {
  Book.findById(req.params.bookId)
    .then((book) => {
      if (!book) {
        return res.status(404).send({ message: "Book not found with id " + req.params.bookId });
      }
      res.send(book);
    })
    .catch((err) => {
      if (err.kind === "ObjectId") {
        return res.status(404).send({ message: "Book not found with id " + req.params.bookId });
      }
      return res.status(500).send({ message: "Error retrieving Book with id " + req.params.bookId });
    });
};

// Find a single book by Name
exports.findByName = (req, res) => {
  Book.findOne({ bookname: req.params.name })
    .then((book) => {
      if (!book) {
        return res.status(404).send({ message: "Book not found with name " + req.params.name });
      }
      res.send(book);
    })
    .catch((err) => {
      return res.status(500).send({ message: "Error retrieving Book with name " + req.params.name });
    });
};

// Create a new book
exports.create = (req, res) => {
  const newBook = new Book(req.body);
  console.log("New Book created:", req.body);
  newBook.save((err, book) => {
    if (err) return res.status(500).send(err);
    res.json(book);
  });
};

// Update book information
exports.update = (req, res) => {
  if (!req.body) {
    return res.status(400).send({ message: "Book content can not be empty" });
  }

  Book.findByIdAndUpdate(req.params.bookId, {
    status: req.body.status,
    rentedBy: req.body.rentedBy,
    rentedDate: req.body.rentedDate,
  }, { new: true })
    .then((book) => {
      if (!book) {
        return res.status(404).send({ message: "Book not found with id " + req.params.bookId });
      }
      console.log(`Book updated: ${book.bookId}:${book.bookname}`);
      res.send(book);
    })
    .catch((err) => {
      if (err.kind === "ObjectId") {
        return res.status(404).send({ message: "Book not found with id " + req.params.bookId });
      }
      return res.status(500).send({ message: "Error updating book with id " + req.params.bookId });
    });
};

// Delete a book
exports.delete = (req, res) => {
  const bookId = req.params.bookId;
  if (!bookId) {
    return res.status(400).send({ message: "You haven't set a valid book ID" });
  }

  Book.deleteOne({ _id: bookId })
    .then(() => res.status(200).send({ message: "Deleted successfully" }))
    .catch((err) =>
      res.status(500).send({ message: `Error deleting Book with id ${bookId}`, error: err })
    );
};

// Borrow a book
exports.borrowBook = (req, res) => {
  Book.findByIdAndUpdate(
    req.params.bookId,
    { status: "rented", rentedBy: req.body.rentedBy || "unknown", rentedDate: new Date().toISOString() },
    { new: true }
  )
    .then((book) => {
      if (!book) {
        return res.status(404).send({ message: "Book not found with id " + req.params.bookId });
      }
      res.json(book);
    })
    .catch((err) => res.status(500).send({ message: err.message || "Error borrowing book" }));
};

// Return a book
exports.returnBook = (req, res) => {
  Book.findByIdAndUpdate(
    req.params.bookId,
    { status: "available", rentedBy: "none", rentedDate: "none" },
    { new: true }
  )
    .then((book) => {
      if (!book) {
        return res.status(404).send({ message: "Book not found with id " + req.params.bookId });
      }
      res.json(book);
    })
    .catch((err) => res.status(500).send({ message: err.message || "Error returning book" }));
};
