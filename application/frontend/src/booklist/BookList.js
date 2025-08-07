import React from "react";
import PropTypes from "prop-types";
import { withStyles } from "@material-ui/core/styles";
import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import Paper from "@material-ui/core/Paper";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";
import Button from "@material-ui/core/Button";

const styles = {
  root: { marginTop: 3, overflowX: "auto" },
  table: { minWidth: 300 },
};

class BookList extends React.Component {
  state = {
    data: [],
  };

  componentDidMount() {
    this.fetchData();
  }

  fetchData = () => {
    fetch("/api/books")
      .then((res) => (res.ok ? res.json() : []))
      .then((data) => this.setState({ data }));
  };

  borrowBook = (id) => {
    fetch(`/api/books/${id}/borrow`, { method: "POST" }).then(() =>
      this.fetchData()
    );
  };

  returnBook = (id) => {
    fetch(`/api/books/${id}/return`, { method: "POST" }).then(() =>
      this.fetchData()
    );
  };

  render() {
    const { classes } = this.props;
    return (
      <Paper className={classes.root}>
        <Table className={classes.table}>
          <TableHead>
            <TableRow>
              <TableCell>Titel</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Action</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {this.state.data.map((d) => (
              <TableRow key={d._id}>
                <TableCell>{d.bookname}</TableCell>
                <TableCell>
                  {d.status === "rented" ? "Ausgeliehen" : "Verfügbar"}
                </TableCell>
                <TableCell>
                  {d.status === "available" ? (
                    <Button onClick={() => this.borrowBook(d._id)}>
                      Borrow
                    </Button>
                  ) : (
                    <Button onClick={() => this.returnBook(d._id)}>
                      Return
                    </Button>
                  )}
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </Paper>
    );
  }
}

BookList.propTypes = {
  classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(BookList);
