#!/bin/bash
#Here username are extracted and stored in file named old
#after 3 seconds of delay new usernames are queried and
#stored in file name new. Then both the files are compared
#and according it is know weather user is logged in/out.

echo "The current time is:"
date												#for current Date and TIme
echo ""

echo "The current users are:"
who | cut -d' ' -f1 | sort | uniq					#for current logged in users
echo ""

who | cut -d' ' -f1>old  							#storing username in to file 
while :												#infinite Loop
do
sleep 3												#delay of 3 seconds
who | cut -d' ' -f1>new								#quering list of user and storing in new file
in=`diff old new | grep ">" | wc -l`				#counter for new users
out=`diff old new | grep "<" | wc -l`				#counter for logged out users

if [ $in -eq 0 -a $out -eq 0 ]; then				#If there is no change in user list this block will be executed
	echo "No user has logged in/out in the last 3 seconds."
	echo ""
fi

if [ $in -gt 0 ]; then								#if there is/are any new user(s) then this block will be executed
	u=`diff old new | grep ">" | cut -d " " -f 2`	#extracting name of user(s)
	for i in {1..$in}; do
		u1=`echo $u | cut -d " " -f $i`
		echo "User $u1 has logged in."
	done
	echo ""
fi

if [ $out -gt 0 ]; then								#if there is/are any user(s) logging out this block will be executed
	q=`diff old new | grep "<" | cut -d " " -f 2`	#extracting name of user(s)
	for j in {1..$out}; do
		q1=`echo $q | cut -d " " -f $j`				
		echo "User $q1 has logged out."
	done
	echo ""
fi
cat new > old
done
