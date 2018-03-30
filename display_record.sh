#!/usr/bin/bash

# $1 is the name of the database you are currently using
clear
echo
list_tables $1
echo
echo -e "${GREEN}Showing Record in table in ${LBLUE}$1${GREEN} database${NC}"
echo

while [[ true ]]; do
	echo -ne "${PROMPT}Enter The Name Of The Table You Want To Show a record in: ${NC}"
	

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
echo 

while [[ true ]]; do
	echo -ne "${PROMPT}Enter The Primary Key Of The record To Be Shown : ${NC}"

	if ! read pkVal; then
		return
	fi

	# check existence of record
	if ! find_record $1 $table_name $pkVal ; then
		echo 
		echo -e "${RED}Record Not Found!${NC}"
		continue
	fi
	break
done

#old record as string converted to array
OIFS=$IFS
IFS=":"
old_record_array=($old_record) #pk name age track \n
IFS=$OIFS
#length of the array minus 1 (due to \n) represents number of columns in the table
length="${#old_record_array[@]}"

# show the old record to the user 
echo 
echo -e "${YELLOW}Here Is The Record Found.${NC}"
awk -v var=$table_name 'BEGIN {FS=":"; print "\t\tTable Name: " var "\n"} {if(NR>1) printf " "$1"<"$2">\t\t"} END{printf "\n"}' "./Databases/$1/${table_name}_template"

awk -v var=$lineNumber 'BEGIN{FS=":";OFS="\t\t\t";ORS="\n";}{  if(NR==var){ $1=$1; print " "substr($0, 1, length($0)-2)}}' "./Databases/$1/$table_name"

echo
echo "Press Enter to Return!"
read
return
