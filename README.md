# Modeling a list of FIFA players using SQL

1. `extractColumnsCSV.py` reads the input file `players.csv` and generates an output file `jugadores.csv` with a selection of the columns
2. `0_PrepareDatabase.sql` creates a database and schema in the server where it is executed
3. `1_leerCSV.sql` reads the csv file and makes initial transformations, like creating new columns
4. `2_DimCalendario.sql` creates a calendar table to use as a dimension
5. `3_DimOthers.sql` normalizes the table creating several dimensions
6. `4_ConnectDimToFact.sql` creates foreign key columns to allow the connection between the tables
7. A Power BI file `fifa.pbix` is connected to the model to test it
