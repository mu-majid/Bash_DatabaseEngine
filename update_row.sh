#!/usr/bin/bash

# $1 is the name of the database you are currently using
clear
echo
list_tables $1
echo
echo -e "${GREEN}Updating table in ${LBLUE}$1${GREEN} database${NC}"
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
echo "Your Table's schema"
echo
awk -v var=$table_name 'BEGIN {FS=":"; print "\t\tTable Name: " var "\n"} {if(NR>1) printf $1"<"$2">\t\t"} END{printf "\n"}' "./Databases/$1/${table_name}_template"
echo 
echo -e "${YELLOW}Please Pay Attention To Column Datatype\nWhile Updating To Avoid ${RED}Data Corruption${NC}"

while [[ true ]]; do
	echo -ne "${PROMPT}Enter The Primary Key Of The record To Be Updated : ${NC}"

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
echo -e "${YELLOW}Here Is The Record Found.${NC}}"
awk -v var=$table_name 'BEGIN {FS=":"; print "\t\tTable Name: " var "\n"} {if(NR>1) printf $1"<"$2">\t\t"} END{printf "\n"}' "./Databases/$1/${table_name}_template"

awk -F: -v var=$lineNumber '{  if(NR==var){  for(i = 1; i < NF; i++) {printf "   "$i"\t\t"} printf "\n" }}' "./Databases/$1/$table_name"

#loading template for the table for column name and datatype
load_template $1 $table_name #names and numColumns and types

echo "$numColumns"
echo "${names[@]}"
echo "${types[*]}"

for (( i = 1; i < $numColumns-2; i++ )); do
	echo 
	while [[ true ]]; do
		echo -ne "${PROMPT}Enter Column Name You Want To Update In The Record : ${Nc}"
		if ! read colName; then
			return
		fi
		#check for empty string
		if ! is_not_null "$colName"; then
			echo 
			echo -e "${RED}Column Name Cannot Be Null!${NC}"
			continue
		fi

		#rejecting colons in column name
		if [[ "$colName" = *:* ]]; then
			echo 
			echo -e "${RED}Colons Are Not Allowed\nPlease Refer To The Schema Above!${NC}"
			continue
		fi

		#check existence of colName
		if ! find_column names[@] "$colName" ; then
			echo 
			echo -e "${RED}Column Not Found, Please Refer To The Schema Above!${NC}"
			continue
		fi
		break
	done
	#from indxx you can get the name and datatype of that column from names and types arrays
	# prompt the user for new value and check for type
	while [[ true ]]; do
		#statements
	done

done



# 	record+=("$val")
# done

