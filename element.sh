#!/bin/bash

#connect to the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c" 

#if the user gives no argument
if [[ ! $1 ]]
then
  echo Please provide an element as an argument.

else
  #if the argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")

    #if the element is not found
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."

    #if the element is found
    else
      #get element info from the database
      ATOMIC_INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id)  WHERE atomic_number=$ATOMIC_NUMBER")
      echo $ATOMIC_INFO | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
      do
        echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
  
  #if the argument is not a number
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")

    #if the element is not found
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."

    #if the element is found
    else
    ATOMIC_INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id)  WHERE atomic_number=$ATOMIC_NUMBER")
    echo $ATOMIC_INFO | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
    fi
  fi
fi
