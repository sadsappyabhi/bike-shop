#!/bin/bash
#set a variable so that psql database can be queried with $($PSQL "query here")
PSQL="psql -X --username=freecodecamp --dbname=bikes --tuples-only -c"

echo -e "\n~~~~~ Bike Rental Shop ~~~~~\n"

MAIN_MENU() {
  #if MAIN_MENU is called with an argument ($1), echo the argument
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "How may I help you?" 
  echo -e "\n1. Rent a bike\n2. Return a bike\n3. Exit"
  read MAIN_MENU_SELECTION

  case $MAIN_MENU_SELECTION in
    1) RENT_MENU ;;
    2) RETURN_MENU ;;
    3) EXIT ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

RENT_MENU() {
  # get available bikes
  AVAILABLE_BIKES=$($PSQL "SELECT bike_id, type, size FROM bikes WHERE available = true ORDER BY bike_id")
  

  # if no bikes available
  # -z checks if $AVAILABLE_BIKES is null
  if [[ -z $AVAILABLE_BIKES ]]
  then
    # send to main menu
    MAIN_MENU "Sorry, we don't have any bikes available right now."
  else
    # display available bikes
    echo -e "\nHere are the bikes we have available:"
    #bar refers to the | symbol in the psql output - this reads them into variables but then omits them when printing
    echo "$AVAILABLE_BIKES" | while read BIKE_ID BAR TYPE BAR SIZE
      do
        echo "$BIKE_ID $TYPE $SIZE"
      done
    # ask for bike to rent

    # if input is not a number

    # send to main menu

  fi
}

RETURN_MENU() {
  echo "Return Menu"
}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU

