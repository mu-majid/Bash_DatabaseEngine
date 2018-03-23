#!/usr/bin/bash

# $1 is the name of the database you are currently using
clear
echo
list_tables $1
echo
echo -e "${GREEN}Deleting a record in a table in ${LBLUE}$1${GREEN} database${NC}"
echo

while [[ true ]]; do
	echo -ne "${PROMPT}Enter The Name Of The Table You Want To Update: ${NC}"
	
	#back 
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
		echo -e "${RED}Table Doesnot Exist!${NC}"
		continue
	fi

	break
done 


# Load The 2 arrays from the meta data file of the selected table
load_template $1 $table_name

echo 
echo -e "${YELLOW}Your Table's schema${NC}"
echo
awk -v var=$table_name 'BEGIN {FS=":"; print "\t\tTable Name: " var "\n"} {if(NR>1) printf $1"<"$2">\t\t"} END{printf "\n"}' "./Databases/$1/${table_name}_template"

while [[ true ]]; do
	echo -ne "${PROMPT}Enter The Primary Key Of The record To Be Deleted : ${NC}"

	if ! read delpkVal; then
		return
	fi

	# check existence of record
	if ! find_record_and_delete $1 "$table_name" "$delpkVal" ; then
		echo 
		echo -e "${RED}Record Not Found!${NC}"
		continue
	fi
	break
done
echo 
echo -e "${GREEN}Record Deleted Successfully${NC}"
echo "Press Enter To Return"
read
return