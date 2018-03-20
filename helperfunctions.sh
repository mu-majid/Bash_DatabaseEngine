#!/usr/bin/bash

#function to test if the user input is null
function is_not_null
{
	return $(test -n "$1")
}

#search for database
function find_database {
	return $(test -d "./Databases/$1")
}

#search for tables $1-> db, $2->tablename
function find_table {
	return $(test -f "./Databases/$1/$2")
}

#listing all databases
function list_databases {
	echo "Here Is A List Of Your Databases"
	echo "********************************"
	echo 
	ls -1 "./Databases"
	echo 
	echo "********************************"
}

#listing all tables in databse passed as first argument
function list_tables {
	echo "Here Is A List Of Your Tables In $1 Database"
	echo "********************************"
	echo 
	# -v option to invert the matching pattern
	ls -1 "./Databases/$1" | grep -v "_template"
	echo 
	echo "********************************"
}

#check if name of a column already exist in a table
#takes col_name and the array cols_names and number of cols
# $1 colname, $2 array of names, 
function repeated_col_name {
	arr=$2
	foundflag=1
	for col in "${arr[@]}"; do
		if [[ "$col" == "$1" ]]; then
			foundflag=0
		fi
	done
	return $found
}

# loading template file of a table
function load_template {
	tblname=$2
	names=()
	types=()

	temp1=($(cut -d: -f1 ./Databases/$1/${tblname}_template))
	temp2=($(cut -d: -f2 ./Databases/$1/${tblname}_template))

	#name of the primary key column
	pkName=${temp2[0]}

	#populating names array
	for i in "${temp1[@]:1}"; do
		names+=("$i")
	done

	#populating types array
	for j in "${temp2[@]:1}"; do
		types+=("$j")
	done

	#getting number of columns in table
	numColumns=$(wc -l "./Databases/$1/${tblname}_template" | cut -f1 -d" ")
}

#check if entered value $2 match refrence value $1 //1->success , 0->not matched
function check_type {
	case "$1" in
		int )
			if [[ "$2" =~ ^[0-9]+$ ]]; then
				return 0
			else return 1
			fi
			;;
		str )
			if [[ "$2" =~ ^[A-Za-z0-9" "]+$ ]]; then
				return 0
			else return 1
			fi
			;;
		* )
			return 1
			;;
	esac
}

#check uniqueness of primary key based on the fact that the records are stored
#with primary key as the first field
# $1 database, $2 table name, $3 pk value
function is_not_unique {
	foundflagg=1
	for field in $(cut -f1 -d: "./Databases/$1/$2"); do

		if [[ $field = "$3" ]]; then
			foundflagg=0
			break
		fi
	done
	return $foundflagg
}

#find value of entered primary key based on the fact that the records are stored
#with primary key as the first field
# $1 database, $2 table name, $3 pk value
function find_record {
	foundflagg=1
	lineNumber=1
	for field in $(cut -f1 -d: "./Databases/$1/$2"); do

		if [[ $field = "$3" ]]; then
			foundflagg=0
			rec=($(cut -d: -f1- "./Databases/$1/$2"))
			let indx=$lineNumber-1
			old_record="${rec[$indx]}"
			break
		fi
		let lineNumber=$lineNumber+1
	done

	return $foundflagg
}

# find colName in a table
function find_column {
 
    declare -a array=("${!1}")
    seeking=$2
    inflag=1
    indxx=0
    for element in "${array[@]}"; do
        if [[ $element == $seeking ]]; then
            inflag=0
            break
        fi
        let indxx=$indxx+1
    done
    return $inflag
}
