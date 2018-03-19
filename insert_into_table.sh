#!/usr/bin/bash

# $1 is the name of the database you are currently using
clear
echo
list_tables $1
echo
echo -e "${GREEN}Inserting into table in ${LBLUE}$1${GREEN} database${NC}"
echo

while [[ true ]]; do
	echo -ne "${PROMPT}Enter The Name Of The Table You Want To Insert into: ${NC}"
	

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

#array that has the values of the insert statement
record=()

# Load The 2 arrays from the meta data file of the selected table
load_template $1 $table_name

echo 
echo "Your Table's schema"
echo
awk -v var=$table_name 'BEGIN {FS=":"; print "\t\tTable Name: " var "\n"} {if(NR>1) printf $1"<"$2">\t\t"} END{printf "\n"}' "./Databases/$1/${table_name}_template"
echo 
echo -e "${YELLOW}Please Pay Attention To Column Name And Datatype\nWhile Inserting To Avoid ${RED}Data Corruption${NC}"


while [[ true ]]; do
	echo 
	echo -ne "${PROMPT}Enter Value Of Primary Key ($pkName) : ${Nc}"
	
	if ! read pk_value; then
		return
	fi

	#check for empty string
	if ! is_not_null "$pk_value"; then
		echo 
		echo -e "${RED}Value Cannot Be Null!${NC}"
		continue
	fi

	#check data type of pk
	if ! check_type "${types[0]}" "$pk_value" ; then
		echo 
		echo -e "${RED}Type Didnot Match, Please Refer to The Schema!${NC}"
		continue
	fi

	#check uniqueness of Pk
	if  is_not_unique "$1" "$table_name" "$pk_value"; then
		echo 
		echo -e "${RED}Primary Key Must Be Unique!${NC}"
		continue
	fi
	break

done

record+=("$pk_value")

for (( i = 1; i < $numColumns-1; i++ )); do
	echo 
	echo -ne "${PROMPT}Enter Value Of (${names[$i]}) : ${Nc}"
	while [[ true ]]; do
		
		if ! read val; then
			return
		fi
		#check for empty string
		if ! is_not_null "$val"; then
			echo 
			echo -e "${RED}Value Cannot Be Null!${NC}"
			continue
		fi

		#check data type of pk
		if ! check_type "${types[$i]}" "$val" ; then
			echo 
			echo -e "${RED}Type Didnot Match, Please Refer to The Schema!${NC}"
			continue
		fi
		break
	done
	record+=("$val")
done

for (( i = 0; i < $numColumns; i++ )); do
	echo -n "${record[$i]}:" >> "./Databases/$1/$table_name"
done

echo
echo -e "${GREEN}Data Inserted to $table_name Successfully${NC}"
echo "Press Enter to Return!"
read
return





