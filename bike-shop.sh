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
        #Formats the output to '1) 27" Mountain Bike' from '1 Mountain 27'
        echo "$BIKE_ID) $SIZE\" $TYPE Bike"
      done
    # ask for bike to rent
     echo -e "\nWhich one would you like to rent?"
    read BIKE_ID_TO_RENT 
    # if input is not a number

      if [[ ! $BIKE_ID_TO_RENT =~ ^[0-9]+$ ]]
      then
    # send to main menu
      MAIN_MENU "That is not a valid bike number."
      else
        #get bike availability
        BIKE_AVAILABILITY=$($PSQL "SELECT available FROM bikes WHERE bike_id = $BIKE_ID_TO_RENT AND available = true")
        #This line used to testing purposes only (testing the query)
        #echo "$BIKE_AVAILABILITY"
        #if not available
        if [[ -z $BIKE_AVAILABILITY ]]
        then
        #send to main menu
        MAIN_MENU "That bike is not available."
        fi
      fi
  fi
}

RETURN_MENU() {
  echo "Return Menu"
}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU

