#include <iostream>
#include <fstream>
#include <stdio.h>
#include <string.h>
using namespace std;

void defang( char* str, char* dfstr, int dfsize , int flag)
{

//instrument>>>>
//--------branch counter--------------
int cf=0;
int cs1=0;int cs2=0;int cs3=0;
//--------string length--------------------
int l1=strlen(str);
int l2=strlen(dfstr);
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


    char* cp1;
    char* cp2;
    for ( cp1 = str, cp2 = dfstr,cf=0;
	  *cp1 != '\0' && cp2 - dfstr < dfsize - 1;
	  ++cp1, ++cp2,++cf )
	{
	switch ( *cp1 )
	    {
	    case '<':
	    *cp2++ = '&';
	    *cp2++ = 'l';
	    *cp2++ = 't';
	    *cp2 = ';';
        cs1++;
	    break;
	    case '>':
	    *cp2++ = '&';
	    *cp2++ = 'g';
	    *cp2++ = 't';
	    *cp2 = ';';
        cs2++;
	    break;
	    default:
	    *cp2 = *cp1;
        cs3++;
	    break;
	    }
	}
    *cp2 = '\0';
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
int tag;
if(strlen(dfstr)>49){tag=-1;}else{tag=1;}

ofstream write_tag;
ofstream write_vector;
if(flag ==1){

write_tag.open("label.train",std::ios_base::app);
write_vector.open("matrix.train",std::ios_base::app);


}
else{
write_tag.open("label.predict",std::ios_base::app);
write_vector.open("matrix.predict",std::ios_base::app);
}

write_tag<<tag<<endl;
write_vector<<tag<<' '<<l1<<' '<<l2<<' '<<cf<<' '<<cs1<<' '<<cs2<<' '<<cs3<<' '<<dfsize<<endl;
write_tag.close();
write_vector.close();
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    }

//int main(int argc, char* argv[])
int main()
{

int bound=50;
char origin[40];
char dest[bound];
string line;
ifstream inputfile;
inputfile.open("input.train");

for (int i=0;i<100;i++){
getline(inputfile, line);
strcpy(origin,line.c_str());
defang(origin,dest,sizeof(dest),1);
}


inputfile.close();

inputfile.open("input.predict");

for (int i=0;i<100;i++){
getline(inputfile, line);
strcpy(origin,line.c_str());
defang(origin,dest,sizeof(dest),2);
}


inputfile.close();



return 0;

}

