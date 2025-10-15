const Book = require("../models/bookModel.js");

// List all books (normalize for UI)
exports.listAll = async function (req, res) {
  try {
    if (req.query.bookname) {
      const b = await Book.findOne({ bookname: { $regex: req.query.bookname, $options: "i" } }).lean();
      if (!b) return res.json(null);
      return res.json({
        id: b._id,
        bookNo: b.bookId || b.bookNo,
        title: b.title || b.bookname,   // <-- UI 'title' bekliyor
        status: b.status,
        rentedBy: b.rentedBy || null,
        rentedDate: b.rentedDate || null
      });
    }

    const docs = await Book.find({}).lean();
    const out = docs.map(b => ({
      id: b._id,
      bookNo: b.bookId || b.bookNo,
      title: b.title || b.bookname,     // <-- kritik eşleme
      status: b.status,
      rentedBy: b.rentedBy || null,
      rentedDate: b.rentedDate || null
    }));
    res.json(out);
  } catch (err) {
    console.error(err);
    res.status(500).send(err);
  }
};

// Find by ID (normalized)
exports.findOne = async (req, res) => {
  try {
    const b = await Book.findById(req.params.bookId).lean();
    if (!b) return res.status(404).send({ message: "Book not found with id " + req.params.bookId });
    res.json({
      id: b._id,
      bookNo: b.bookId || b.bookNo,
      title: b.title || b.bookname,
      status: b.status,
      rentedBy: b.rentedBy || null,
      rentedDate: b.rentedDate || null
    });
  } catch (err) {
    res.status(500).send({ message: "Error retrieving Book with id " + req.params.bookId });
  }
};

exports.findByName = (req, res) => {
  Book.findOne({ bookname: req.params.name })
    .then(book => book
      ? res.send(book)
      : res.status(404).send({ message: "Book not found with name " + req.params.name }))
    .catch(() => res.status(500).send({ message: "Error retrieving Book with name " + req.params.name }));
};

exports.create = (req, res) => {
  const newBook = new Book(req.body);
  newBook.save((err, book) => err ? res.status(500).send(err) : res.json(book));
};

exports.update = (req, res) => {
  if (!req.body) return res.status(400).send({ message: "Book content can not be empty" });
  Book.findByIdAndUpdate(
    req.params.bookId,
    { status: req.body.status, rentedBy: req.body.rentedBy, rentedDate: req.body.rentedDate },
    { new: true }
  )
    .then(book => book
      ? res.send(book)
      : res.status(404).send({ message: "Book not found with id " + req.params.bookId }))
    .catch(err =>
      err.kind === "ObjectId"
        ? res.status(404).send({ message: "Book not found with id " + req.params.bookId })
        : res.status(500).send({ message: "Error updating book with id " + req.params.bookId })
    );
};

exports.delete = (req, res) => {
  const bookId = req.params.bookId;
  if (!bookId) return res.status(400).send({ message: "You haven't set a valid book ID" });
  Book.deleteOne({ _id: bookId })
    .then(() => res.status(200).send({ message: "Deleted successfully" }))
    .catch(err => res.status(500).send({ message: `Error deleting Book with id ${bookId}`, error: err }));
};

exports.borrowBook = (req, res) => {
  Book.findByIdAndUpdate(
    req.params.bookId,
    { status: "rented", rentedBy: req.body.rentedBy || "unknown", rentedDate: new Date().toISOString() },
    { new: true }
  )
    .then(book => book
      ? res.json(book)
      : res.status(404).send({ message: "Book not found with id " + req.params.bookId }))
    .catch(err => res.status(500).send({ message: err.message || "Error borrowing book" }));
};

exports.returnBook = (req, res) => {
  Book.findByIdAndUpdate(
    req.params.bookId,
    { status: "available", rentedBy: "none", rentedDate: "none" },
    { new: true }
  )
    .then(book => book
      ? res.json(book)
      : res.status(404).send({ message: "Book not found with id " + req.params.bookId }))
    .catch(err => res.status(500).send({ message: err.message || "Error returning book" }));
};
