#!/usr/bin/bash

clear
echo
list_databases
echo
echo "Using Database"
while [[ true ]]; do
	echo -ne "${PROMPT}Enter The Name Of The Database : ${NC}"
	read db_name

	#check if empty string entered
	if ! is_not_null $db_name; then
		echo
		echo -e "${RED}Name Cannot Be Null!${NC}"
		return
	fi

	#check if database doesnot exist
	if ! find_database $db_name; then
		echo
		echo -e "${RED}$db_name Does not Exist!${NC}"
		return
	fi
	break
done

while [[ $keep_alive=true ]]; do
	clear
	echo
	echo -e "${YELLOW}*********************************"
	echo -e "* You're Now In ${LBLUE}$db_name${YELLOW} Database"
	echo -e "*********************************${NC}"
	echo
	echo "1.Show Table"
	echo "2.Create Table"
	echo "3.Delete Table"
	echo "4.Insert into Table"
	echo "5.Update Table"
	echo "6.Delete Row"
	echo "7.Back to main menu"
	echo
	echo -ne "${PROMPT}Enter your choice : ${NC}"

	read

	case $REPLY in
		1 )
			. ./show_table.sh $db_name;;
		2 )
			. ./create_table.sh $db_name;;
		3 )
			. ./delete_table.sh $db_name;;
		4 )
			. ./insert_into_table.sh $db_name;;
		5 )
			. ./update_table.sh $db_name;;
		6 )
			. ./delete_row.sh $db_name;;
		7 )
			. ./main.sh;;
		* )
			echo -e "${RED}Please Choose A Valid Option${NC}";;
	esac
done
