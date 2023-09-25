#!/bin/bash
#databases management system using Bash 
mkdir databases 2>> ./.error.log
clear
echo "Welcome To databases"
function mainMenu {
  echo -e "\n+---------Main Menu-------------+"
  echo "| 1. Create DB                  |"
  echo "| 2. connect DB                 |"
  echo "| 3. list DB                    |"
  echo "| 4. Drop DB                    |"
  echo "| 5. Exit                       |"
  echo "+-------------------------------+"
  read -p "enter choich " ch
  case $ch in
    1)  createDB ;;
    2)  connectDB ;;
    3)  ls ./databases ; mainMenu;;
    4)  dropDB ;;
    5) exit ;;
    *) echo " Wrong Choice " ; mainMenu;
  esac
}
function createDB {
  # Prompt the user to enter a database name
  echo -e "Enter Database Name: \c"
  read dbName

  # Check if the database name starts with a number
  if [[ $dbName =~ ^[0-9] ]]; then
    echo "Error: Database name cannot start with a number."
    mainMenu
    return
  fi

  # Check if the database name contains special characters
  if [[ $dbName =~ [^a-zA-Z0-9_] ]]; then
    echo "Error: Database name cannot contain special characters."
    mainMenu
    return
  fi

  # Create the database directory if constraints are met
  mkdir ./databases/$dbName

  # Check if the directory creation was successful
  if [[ $? == 0 ]]; then
    echo "Database Created Successfully"
  else
    echo "Error Creating Database $dbName"
  fi

  # Return to the main menu
  mainMenu
}

function createTable {
  # Declare an array to store column names
  declare -a columnNames

  # Prompt the user to enter a table name
  echo -e "Table Name: \c"
  read tableName

  # Check if the table name doesn't start with a character (letter)
  if [[ ! $tableName =~ ^[a-zA-Z] ]]; then
    echo "Error: Table name must start with a letter."
    tablesMenu
    return
  fi

  # Check if the table and column names do not contain special characters or spaces
  if [[ $tableName =~ [^a-zA-Z0-9_] || $tableName =~ [[:space:]] ]]; then
    echo "Error: Table name cannot contain special characters or spaces."
    tablesMenu
    return
  fi

  # Check if the table already exists
  if [[ -f $tableName ]]; then
    echo "Error: Table $tableName already exists. Choose another name."
    tablesMenu
    return
  fi

  # Prompt the user to enter the number of columns
  echo -e "Number of Columns: \c"
  read colsNum
  counter=1
  sep="|"
  rSep="\n"
  pKey=""
  metaData="Field"$sep"Type"$sep"key"
  uniquePKeys=()

  while [ $counter -le $colsNum ]
  do
    # Prompt the user to enter the name of the column
    echo -e "Name of Column No.$counter: \c"
    read colName

    # Check if the column name is empty, contains special characters, or spaces
    if [[ -z $colName || $colName =~ [^a-zA-Z0-9_] || $colName =~ [[:space:]] ]]; then
      echo "Error: Invalid column name. Column name cannot be empty, should not contain special characters, and must not have spaces."
      tablesMenu
      return
    fi

    # Check if the column name is not repeated
    if [[ " ${columnNames[@]} " =~ " ${colName} " ]]; then
      echo "Error: Column name $colName is repeated. Each column name must be unique."
      tablesMenu
      return
    else
      columnNames+=("$colName")
    fi

    # Prompt the user to select the type of the column
    echo -e "Type of Column $colName: "
    select var in "int" "str"
    do
      case $var in
        int ) colType="int";break;;
        str ) colType="str";break;;
        * ) echo "Wrong Choice" ;;
      esac
    done

    if [[ $pKey == "" ]]; then
      # Prompt the user to make a column a Primary Key
      echo -e "Make Primary Key for $colName? "
      select var in "yes" "no"
      do
        case $var in
          yes ) 
            pKey="PK"
            # Check if the primary key is unique
            if [[ " ${uniquePKeys[@]} " =~ " ${colName} " ]]; then
              echo "Error: Primary Key $colName is repeated. Each primary key must be unique."
              tablesMenu
              return
            else
              uniquePKeys+=("$colName")
            fi
            metaData+=$rSep$colName$sep$colType$sep$pKey;
            break;;
          no )
            metaData+=$rSep$colName$sep$colType$sep""
            break;;
          * ) echo "Wrong Choice" ;;
        esac
      done
    else
      metaData+=$rSep$colName$sep$colType$sep""
    fi

    if [[ $counter == $colsNum ]]; then
      temp=$temp$colName
    else
      temp=$temp$colName$sep
    fi

    ((counter++))
  done

  touch .$tableName
  echo -e $metaData  >> .$tableName
  touch $tableName
  echo -e $temp >> $tableName

  if [[ $? == 0 ]]; then
    echo "Table Created Successfully"
    tablesMenu
  else
    echo "Error Creating Table $tableName"
    tablesMenu
  fi
}


function connectDB {
  echo -e "Enter Database Name: \c"
  read dbName
  cd ./databases/$dbName 2>>./.error.log
  if [[ $? == 0 ]]; then
    echo "Database $dbName was Successfully Selected"

    #when user select connect to database tablemenu appear 
    tablesMenu
  else
    echo "Database $dbName wasn't found"
    mainMenu
  fi
}

function dropDB {
  echo -e "Enter Database Name: \c"
  read dbName
  rm -r ./databases/$dbName 2>>./.error.log
  if [[ $? == 0 ]]; then
    echo "Database Dropped Successfully"
  else
    echo "Database Not found"
  fi
  mainMenu
}

function tablesMenu {
  echo -e "\n+--------Tables Menu------------+"
  echo "| 1. Create Table               |"
  echo "| 2. List Tables                |"
  echo "| 3. Drop Table                 |"
  echo "| 4. Insert Into Table          |"
  echo "| 5. Select From Table          |"
  echo "| 6. Delete From Table          |"
  echo "| 7. Update Table               |"
  echo "| 8. Back To Main Menu          |"
  echo "| 9. Exit                       |"
  echo "+-------------------------------+"
  echo -e "Enter Choice: \c"
  read ch
  case $ch in
    1)  createTable ;;
    2)  ls .; tablesMenu ;;
    3)  dropTable;;
    4)  insert;;
    5)  clear; selectMenu ;;
    6)  deleteFromTable;;
    7)  updateTable;;
    8)  clear; cd ../.. 2>>./.error.log; mainMenu ;;
    9)  exit ;;
    *) echo " Wrong Choice " ; tablesMenu;
  esac

}
function createTable {
  # Declare an array to store column names
  declare -a columnNames

  # Prompt the user to enter a table name
  echo -e "Table Name: \c"
  read tableName

  # Check if the table name doesn't start with a character (letter)
  if [[ ! $tableName =~ ^[a-zA-Z] ]]; then
    echo "Error: Table name must start with a letter."
    tablesMenu
    return
  fi

  # Check if the table and column names do not contain special characters or spaces
  if [[ $tableName =~ [^a-zA-Z0-9_] || $tableName =~ [[:space:]] ]]; then
    echo "Error: Table name cannot contain special characters or spaces."
    tablesMenu
    return
  fi

  # Check if the table already exists
  if [[ -f $tableName ]]; then
    echo "Error: Table $tableName already exists. Choose another name."
    tablesMenu
    return
  fi

  # Prompt the user to enter the number of columns
  echo -e "Number of Columns: \c"
  read colsNum
  counter=1
  sep="|"
  rSep="\n"
  pKey=""
  metaData="Field"$sep"Type"$sep"key"
  uniquePKeys=()

  while [ $counter -le $colsNum ]
  do
    # Prompt the user to enter the name of the column
    echo -e "Name of Column No.$counter: \c"
    read colName

    # Check if the column name is empty or contains special characters or spaces
    if [[ -z $colName || $colName =~ [^a-zA-Z0-9_] || $colName =~ [[:space:]] ]]; then
      echo "Error: Invalid column name. Column name cannot be empty and should not contain special characters or spaces."
      tablesMenu
      return
    fi

    # Check if the column name is not repeated
    if [[ " ${columnNames[@]} " =~ " ${colName} " ]]; then
      echo "Error: Column name $colName is repeated. Each column name must be unique."
      tablesMenu
      return
    else
      columnNames+=("$colName")
    fi

    # Prompt the user to select the type of the column
    echo -e "Type of Column $colName: "
    select var in "int" "str"
    do
      case $var in
        int ) colType="int";break;;
        str ) colType="str";break;;
        * ) echo "Wrong Choice" ;;
      esac
    done

    if [[ $pKey == "" ]]; then
      # Prompt the user to make a column a Primary Key
      echo -e "Make Primary Key for $colName? "
      select var in "yes" "no"
      do
        case $var in
          yes ) 
            pKey="PK"
            # Check if the primary key is unique
            if [[ " ${uniquePKeys[@]} " =~ " ${colName} " ]]; then
              echo "Error: Primary Key $colName is repeated. Each primary key must be unique."
              tablesMenu
              return
            else
              uniquePKeys+=("$colName")
            fi
            metaData+=$rSep$colName$sep$colType$sep$pKey;
            break;;
          no )
            metaData+=$rSep$colName$sep$colType$sep""
            break;;
          * ) echo "Wrong Choice" ;;
        esac
      done
    else
      metaData+=$rSep$colName$sep$colType$sep""
    fi

    if [[ $counter == $colsNum ]]; then
      temp=$temp$colName
    else
      temp=$temp$colName$sep
    fi

    ((counter++))
  done

  touch .$tableName
  echo -e $metaData  >> .$tableName
  touch $tableName
  echo -e $temp >> $tableName

  if [[ $? == 0 ]]; then
    echo "Table Created Successfully"
    tablesMenu
  else
    echo "Error Creating Table $tableName"
    tablesMenu
  fi
}


function dropTable {
  echo -e "Enter Table Name: \c"
  read tName
  rm $tName .$tName 2>>./.error.log
  if [[ $? == 0 ]]
  then
    echo "Table Dropped Successfully"
  else
    echo "Error Dropping Table $tName"
  fi
  tablesMenu
}


function insert {
  echo -e "Table Name: \c"
  read tableName
  if ! [[ -f $tableName ]]; then
    echo "Table $tableName isn't existed, choose another Table"
    tablesMenu
    return
  fi
  colsNum=$(awk 'END{print NR}' .$tableName)
  sep="|"
  rSep="\n"
  for ((i = 2; i <= colsNum; i++)); do
    colName=$(awk 'BEGIN{FS="|"}{ if(NR=='$i') print $1}' .$tableName)
    colType=$(awk 'BEGIN{FS="|"}{if(NR=='$i') print $2}' .$tableName)
    colKey=$(awk 'BEGIN{FS="|"}{if(NR=='$i') print $3}' .$tableName)
    echo -e "$colName ($colType) = \c"
    read data

    # Validate Input
    if [[ $colType == "int" ]]; then
      while ! [[ $data =~ ^[0-9]*$ ]]; do
        echo -e "Invalid DataType!!"
        echo -e "$colName ($colType) = \c"
        read data
      done
    elif [[ $colType == "str" ]]; then
      # String data type, no validation needed
      :
    else
      echo "Error: Unsupported data type $colType."
      tablesMenu
      return
    fi

    if [[ $colKey == "PK" ]]; then
      while true; do
        if [[ $data =~ ^[`awk 'BEGIN{FS="|" ; ORS=" "}{if(NR != 1)print $(('$i'-1))}' $tableName`]$ ]]; then
          echo -e "Invalid input for Primary Key!!"
        else
          break
        fi
        echo -e "$colName ($colType) = \c"
        read data
      done
    fi

    # Set row
    if [[ $i == $colsNum ]]; then
      row=$row$data$rSep
    else
      row=$row$data$sep
    fi
  done
  echo -e $row"\c" >>$tableName
  if [[ $? == 0 ]]; then
    echo "Data Inserted Successfully"
  else
    echo "Error Inserting Data into Table $tableName"
  fi
  row=""
  tablesMenu
}

function updateTable {
  echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter Condition Column name: \c"
  read field
  fid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $tName)
  if [[ $fid == "" ]]; then
    echo "Not Found"
    tablesMenu
  else
    echo -e "Enter Condition Value: \c"
    read val
    res=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$val'") print $'$fid'}' $tName)
    if [[ $res == "" ]]; then
      echo "Value Not Found"
      tablesMenu
    else
      NR=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$val'") print NR}' $tName)
      oldValue=$(awk 'BEGIN{FS="|"}{if(NR=='$NR'){for(i=1;i<=NF;i++){if(i=='$setFid') print $i}}}' $tName)
      echo $oldValue
      sed -i ''$NR's/'$oldValue'/'$newValue'/g' $tName
      if [[ $? == 0 ]]; then
        echo "Row Updated Successfully"
      else
        echo "Error Updating Row in Table $tName"
      fi
      tablesMenu
    fi
  fi
}

function deleteFromTable {
  echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter Condition Column name: \c"
  read field
  fid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $tName)
  if [[ $fid == "" ]]
  then
    echo "Not Found"
    tablesMenu
  else
    echo -e "Enter Condition Value: \c"
    read val
    res=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$val'") print $'$fid'}' $tName 2>>./.error.log)
    if [[ $res == "" ]]
    then
      echo "Value Not Found"
      tablesMenu
    else
      NR=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$val'") print NR}' $tName 2>>./.error.log)
      sed -i ''$NR'd' $tName 2>>./.error.log
      echo "Row Deleted Successfully"
      tablesMenu
    fi
  fi
}

function selectMenu {
  echo -e "\n\n+---------------Select Menu--------------------+"
  echo "| 1. Select All Columns of a Table              |"
  echo "| 2. Select Specific Column from a Table        |"
  echo "| 3. Back To Tables Menu                        |"
  echo "| 4. Back To Main Menu                          |"
  echo "| 5. Exit                                       |"
  echo "+----------------------------------------------+"
  echo -e "Enter Choice: \c"
  read ch
  case $ch in
    1) selectAll ;;
    2) selectCol ;;
    3) clear; tablesMenu ;;
    4) clear; cd ../.. 2>>./.error.log; mainMenu ;;
    5) exit ;;
    *) echo " Wrong Choice " ; selectMenu;
  esac
}

function selectAll {
  echo -e "Enter Table Name: \c"
  read tName
  column -t -s '|' $tName 2>>./.error.log
  if [[ $? != 0 ]]
  then
    echo "Error Displaying Table $tName"
  fi
  selectMenu
}

function selectCol {
  echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter Column Number: \c"
  read colNum
  awk 'BEGIN{FS="|"}{print $'$colNum'}' $tName
  selectMenu
}

mainMenu
