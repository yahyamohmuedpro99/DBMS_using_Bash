# Bash DBMS (Database Management System)

This Bash script provides a simple command-line interface for managing databases and tables. It allows you to create databases, connect to them, create tables, insert data, perform queries, and more.

## Getting Started

To use the Bash DBMS, follow the steps below:

1. Clone or download the repository containing the script.
2. Make sure you have Bash installed on your system.
3. Open a terminal and navigate to the directory where the script is located.

## Usage

To start the Bash DBMS, run the following command:

```bash
./dbmsf.sh
```

The main menu will be displayed with the following options:

1. **Create DB**: Create a new database.
2. **Connect DB**: Connect to an existing database.
3. **List DB**: List all existing databases.
4. **Drop DB**: Delete a database.
5. **Exit**: Exit the DBMS.

### Database Operations

#### Create DB

To create a new database, select option 1 from the main menu. You will be prompted to enter a name for the database. Make sure the name does not start with a number and does not contain special characters. Once created, the database will be stored in the `databases` directory.

#### Connect DB

To connect to an existing database, select option 2 from the main menu. Enter the name of the database you want to connect to. If the database exists, you will be connected to it, and the tables menu will be displayed.

#### List DB

Selecting option 3 from the main menu will list all existing databases.

#### Drop DB

To delete a database, choose option 4 from the main menu. Enter the name of the database you want to delete. The database and all its associated tables will be permanently deleted.

### Table Operations

Once you are connected to a database, you can perform various operations on tables.

#### Create Table

To create a new table, select option 1 from the tables menu. Enter a name for the table, specify the number of columns, and provide names and types for each column. You can also choose a primary key for the table if desired.

#### List Tables

To list all tables in the connected database, choose option 2 from the tables menu.

#### Drop Table

To delete a table from the connected database, select option 3 from the tables menu. Enter the name of the table you want to delete.

#### Insert Into Table

Option 4 allows you to insert data into a table. Enter the table name, and then provide the values for each column.

#### Select From Table

Choose option 5 to perform a select query on a table. Enter the table name and provide the conditions for the query.

#### Delete From Table

Option 6 enables you to delete rows from a table based on specified conditions. Enter the table name and provide the conditions for deletion.

#### Update Table

Select option 7 to update rows in a table. Enter the table name, specify the columns to update, and provide the new values.

#### Back To Main Menu

To return to the main menu from the tables menu, select option 8.

#### Exit

To exit the DBMS, choose option 9.

## Error Handling

Errors and exceptions are logged in the `.error.log` file located in the script's directory. If any errors occur during database or table operations, check the log file for more information.

## Contributing

Contributions to the Bash DBMS are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request on the project's repository.

## License

The Bash DBMS is open-source software released under the [MIT License](https://opensource.org/licenses/MIT). Feel free to use, modify, and distribute it according to the terms of the license.
