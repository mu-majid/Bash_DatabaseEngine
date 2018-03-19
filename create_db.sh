#!/usr/bin/bash

clear
echo
list_databases
echo
echo -e "${GREEN}Creating Database${NC}"
echo -ne "${PROMPT}Enter The Name Of The Database : ${NC}"

if ! read db_name; then
	return
fi

#check if empty string entered
if ! is_not_null $db_name; then
	echo
	echo "Name Cannot Be Null"
	return
fi

#check if input name exist otherwise create db
if find_database $db_name; then
	echo
	echo "Database already exists, Please Enter Another Name!"	
else
	#create the database folder
	mkdir "./Databases/$db_name"
	echo
	echo " $db_name Database Created Successfully"	
	
fi




