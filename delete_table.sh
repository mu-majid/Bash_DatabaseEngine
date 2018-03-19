#!/usr/bin/bash

# $1 is the name of the database you are currently using
clear   
echo
list_tables $1
echo
echo -e "${RED}Deleting a table in $1 database${NC}"
echo 
while [[ true ]]; do
 	echo -ne "${PROMPT}Enter The Name Of The Table : ${NC}"
	
	if ! read table_name; then
		return
	fi

	#check for empty string
	if ! is_not_null $table_name; then
		echo 
		echo -e "${RED}Name Cannot Be Null!${NC}"
		continue
	fi

	#check for existing table name
	if ! find_table $1 $table_name; then
		echo 
		echo -e "${RED}Table Does not Exist!${NC}"
		continue
	fi

	break
 done 

#deleting tabel and its template
rm -r "./Databases/$1/$table_name"
rm -r "./Databases/$1/${table_name}_template"

echo
echo -e "${GREEN}Table $table_name Deleted!${NC}"
echo "press Enter to return"
read
return

