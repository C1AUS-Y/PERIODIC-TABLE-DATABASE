#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then 
  GET_ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number=$1")
else
  GET_ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where name = '$1' or symbol = '$1'")
fi

if [[ -z $GET_ATOMIC_NUMBER ]]
then
  echo -e "I could not find that element in the database."
  exit
fi

#GET OTHER INFORMATION FOR PRINTING MEOW
ELEMENTS=$($PSQL "select elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type from elements join properties on elements.atomic_number=properties.atomic_number join types on properties.type_id=types.type_id where elements.atomic_number=$GET_ATOMIC_NUMBER")

echo "$ELEMENTS" | while IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
done