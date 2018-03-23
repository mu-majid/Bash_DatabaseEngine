#!/usr/bin/bash

clear
echo
list_databases
echo
echo -e "${RED}Deleting Database${NC}"
echo -ne "${PROMPT}Enter The Name Of The Database : ${NC}"
read db_name

#check if empty string entered
if ! is_not_null $db_name ; then
	echo
	echo -e "${RED}Name Cannot Be Null${NC}"
	return
fi

#check if database exist
if find_database $db_name; then
	#Delete the specified database
	rm -r "./Databases/$db_name"
	echo
	echo -e "${GREEN}You Deleted $db_name Database ${NC}"
else
	echo
	echo -e "${RED}Database ${LBLUE}$db_name${RED} Not Found${NC}"
fi
