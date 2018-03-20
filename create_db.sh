#!/usr/bin/bash

clear
echo
list_databases
echo
echo -e "${GREEN}Creating Database${NC}"

while [[ true ]]; do
	echo -ne "${PROMPT}Enter The Name Of The Database : ${NC}"

	if ! read db_name; then
		return
	fi

	#rejecting spaces in column name
	if [[ "$db_name" = *" "* ]]; then
		echo 
		echo -e "${RED}Spaces Are Not Allowed!${NC}"
		continue
	fi

	#disallowing special characters in db names
	if [[ $db_name == *['!'@#\$%^\&*()-+\.\/]* ]]; then
		echo 
		echo -e "${RED} ! @ # $ % ^ () + . -  are not allowed!${NC}"
		continue
	fi

	#check if empty string entered
	if ! is_not_null $db_name; then
		echo
		echo -e "${RED}Name Cannot Be Null${NC}"
		continue
	fi

	#check if input name exist otherwise create db
	if find_database $db_name; then
		echo
		echo -e "${RED}Database already exists, Please Enter Another Name!${NC}"
		continue	
	else
		#create the database folder
		mkdir "./Databases/$db_name"
		echo
		echo -e "${GREEN} $db_name Database Created Successfully${NC}"
		return	
	fi
done





