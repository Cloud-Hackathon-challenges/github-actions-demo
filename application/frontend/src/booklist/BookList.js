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
    busy: false,
  };

  componentDidMount() {
    this.fetchData();
  }

  fetchData = async () => {
    try {
      const res = await fetch("/api/books");
      const data = res.ok ? await res.json() : [];
      this.setState({ data });
    } catch (e) {
      console.error("list fetch failed", e);
      this.setState({ data: [] });
    }
  };

  borrowBook = async (id) => {
    const rentedBy = window.prompt("Lütfen adınızı girin") || "unknown";
    this.setState({ busy: true });
    try {
      await fetch(`/api/books/${id}/borrow`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ rentedBy }),
      });
    } finally {
      this.setState({ busy: false });
      this.fetchData();
    }
  };

  returnBook = async (id) => {
    this.setState({ busy: true });
    try {
      await fetch(`/api/books/${id}/return`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
      });
    } finally {
      this.setState({ busy: false });
      this.fetchData();
    }
  };

  render() {
    const { classes } = this.props;
    const { data, busy } = this.state;

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
            {data.map((d) => (
              <TableRow key={d.id}>
                <TableCell>{d.title}</TableCell>
                <TableCell>
                  {d.status === "rented" ? "Ausgeliehen" : "Verfügbar"}
                </TableCell>
                <TableCell>
                  {d.status === "available" ? (
                    <Button
                      onClick={() => this.borrowBook(d.id)}
                      disabled={busy}
                    >
                      BORROW
                    </Button>
                  ) : (
                    <Button
                      onClick={() => this.returnBook(d.id)}
                      disabled={busy}
                    >
                      RETURN
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
