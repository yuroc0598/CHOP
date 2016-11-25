#!/bin/bash

#--------------------------------------check number of arguments------------------------

#if  [ "$#" -eq 2 ] && [ $2 -eq clean ]
#then
#    rm -f $qhullDir/sample/sample.$programName
#    exit 1
#fi

if  [ "$#" -ne 1 ]
then
    printf "invalid argument\n Usage: ./preprocess Name_of_function\n"
    exit 1
fi


#-------------------------------check if directory exists------------------------

qhullDir=~/workspace/bug/git_bug/convexHull/c/qhull/test
cppDir=~/workspace/bug/git_bug/convexHull/c/normalV
programName=$1

if [ ! -d $qhullDir ]
then
    printf "qhull test dir does not exist\n"
    exit
fi


if [ ! -d $cppDir ]
then
    printf "cpp normalV dir does not exist\n"
    exit
fi

cd $qhullDir
#--------------------------------- 0 --------------------------------------
#expand the initial sample points, add the corner points

#get the maximum element of each axis and the total number of additional points is the number of dimension

cp sample/sample.$programName.bak sample/sample.$programName
sed '1d' sample/sample.$programName > sample/sample.$programName.2ToEnd

awk '
{
	for (i=1;i<=NF;i++){
		if($i > max[i]){
		max[i]=$i
		}
	}
}
END{
for (j=1;j<=NF;j++){
	for(k=1;k<j;k++){
		printf("0 ")
	}
	printf (max[j])
	for(m=1;m<=NF-j;m++){
		printf(" 0")
	}
printf("\n")
}
}

' < sample/sample.$programName.2ToEnd  >> sample/sample.$programName
#rm tmp file
rm sample/sample.$programName.2ToEnd


#change the sample file, update the number of points 
awk 'NR==1{$2+=$1}1' <sample/sample.$programName >>sample/sample.$programName.add 
mv sample/sample.$programName.add sample/sample.$programName 

#--------------------------------- 1 ------------------------------------
# obtain the normal vectors
cat sample/sample.$programName |../qhull -n > N/N.$programName.tmp
# delete the first two rows which are number of vectors and dimension
sed -i -e '1,2d'  N/N.$programName.tmp
# trim the repeated spaces
cat N/N.$programName.tmp |tr -s ' '> N/N.$programName.trim
# delete the last column which is normal vector offsets
awk 'NF{NF--};1' <N/N.$programName.trim >N/N.$programName
# delete tmp files
rm N/N.$programName.tmp N/N.$programName.trim


#--------------------------------- 2 -----------------------------------

#obtain one point from each facet, aka, the matrix 'a'

#get the tesselation
cat sample/sample.$programName |../qhull Fv > a_index/a_index.$programName.Fv
#delete the first row which is numer of vectors
sed -i -e '1d' a_index/a_index.$programName.Fv
#trim spaces
cat a_index/a_index.$programName.Fv |tr -s ' ' >a_index/a_index.$programName.trim
#only take the second column, because the first column is number of points on that facets
cut -d ' ' -f 2 a_index/a_index.$programName.trim >a_index/a_index.$programName
#delete tmp file
rm a_index/a_index.$programName.Fv a_index/a_index.$programName.trim
# according the index file get the coordinates to build 'a'
while read line
do
	LN=$((line + 2))
	sed  "${LN}q;d" sample/sample.$programName
done < a_index/a_index.$programName  >a/a.$programName

#---------------------------------- 3 --------------------------------
# copy a.program and N.program to the folder where do the determination

cp a/a.$programName $cppDir/a/
cp N/N.$programName $cppDir/N/
cd $cppDir
cp a/a.$programName a.txt
cp N/N.$programName N.txt
cp test/test.$programName test.txt
./check
cp result.txt result/result.$programName
#rm tmp file
rm -f a.txt N.txt result.txt test.txt

#---------------------------------- 4 ---------------------------------------------
# analyse the result , compare it with the ground truth 

#concatenate the result file and the ground truth file
paste -d ' ' groundT/groundT.$programName result/result.$programName > compare/compare.$programName
#analyse the accuracy
awk 'BEGIN{
correct=0;
falpos=0;
falneg=0;
bothin=0;
bothout=0;
}
{
	if($1==1 && $2==1){correct+=1;bothin+=1;}
	if($1==-1 && $2==-1){correct+=1;bothout+=1;}
	if($1==-1 && $2==1){falpos+=1;}
	if($1==1 && $2==-1){falneg+=1;}
}
END{print "correct: " correct "; both inside: " bothin "; both outside: " bothout  "; false positive: " falpos "; false negtive: "  falneg}
' < compare/compare.$programName  > analysis/analysis.$programName
# rm tmp file
#rm -f compare.$programName





