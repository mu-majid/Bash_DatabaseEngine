#!/usr/bin/bash

clear


keep_alive=true

#calling helper functions
. ./helperfunctions.sh
#loading colors file
. ./colors.sh
while [[ $keep_alive=true ]]; do
	echo
	echo -e "${YELLOW}Welcome to Bash DataBase Engine!"
	echo "********************************"
	echo
	echo "Simple Database System Written in Bash"
	echo "This Engine Support Basic CRUD Operations"
	echo "Please Note Only Supported Datatypes are Int, Str, And Alphanumeric"
	echo
	echo -e "${LBLUE}Author : Muhammad Majid Kamel${YELLOW}"
	echo 
	echo "********************************"
	echo -e "${NC}"
	echo "1.Create Database "
	echo "2.Use Existing Database "
	echo "3.Delete a Database "
	echo "4.Display a Database "
	echo "5.Exit "
	echo 
	echo -ne "${PROMPT}Enter your choice : ${NC}"

	read choice

	case $choice in
		1 )
			. ./create_db.sh;;
		2 )
			. ./use_db.sh;;
		3 )
			. ./delete_db.sh;;
		4 )
			. ./display_db.sh;;
		5 )
			echo "Bye Bye :("
			exit;;
		* )
			echo -e "${RED}Please Enter A Valid Choice!!${NC}";;
	esac
done