#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

main_menu() {
  #parse user input
  if [[ -z $ELEMENT_INPUT ]]
  then
    CASE=0
  elif [[ $ELEMENT_INPUT =~ ^-?[0-9]+(\.[0-9]+)?$ ]]
  then
    CASE=1
  elif [[ $ELEMENT_INPUT =~ ^[a-zA-Z][a-zA-Z]?$ ]]
  then
    CASE=2
  elif [[ $ELEMENT_INPUT =~ [a-zA-Z]+ ]]
  then
    CASE=3
  else
    CASE=4
  fi

  case $CASE in
    0) echo "Please provide an input." ;;
    1) atomic_number_menu ;;
    2) symbol_menu ;;
    3) name_menu ;;
    4) echo "I could not find that element in the database." ;;
  esac
}

atomic_number_menu() {
  ATOMIC_NUMBER=$ELEMENT_INPUT
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
   if [[ -z $NAME ]]; then echo "I could not find that element in the database."; exit; fi
  TYPE=$($PSQL "SELECT type FROM types AS t JOIN properties AS p ON p.type_id = t.type_id WHERE atomic_number=$ATOMIC_NUMBER")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  exit
}

symbol_menu() {
  SYMBOL=$ELEMENT_INPUT
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL'")
  if [[ -z $ATOMIC_NUMBER ]]; then echo "I could not find that element in the database."; exit; fi
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types AS t JOIN properties AS p ON p.type_id = t.type_id WHERE atomic_number=$ATOMIC_NUMBER")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  exit
}

name_menu() {
  NAME=$ELEMENT_INPUT
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME'")
  if [[ -z $ATOMIC_NUMBER ]]; then echo "I could not find that element in the database."; exit; fi
  TYPE=$($PSQL "SELECT type FROM types AS t JOIN properties AS p ON p.type_id = t.type_id WHERE atomic_number=$ATOMIC_NUMBER")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  exit
}

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
else
  ELEMENT_INPUT=$1
  main_menu
fi