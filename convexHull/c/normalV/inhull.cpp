#include<fstream>
#include<vector>
#include<iterator>
#include<sstream>
#include<iostream>
#include <functional>  
#include <algorithm>    
#include<numeric>
#include<ctime>
#include <chrono>
using namespace std;
using namespace std::chrono;
vector< vector<double> > readIn2dData(const char* filename)
{
    /* Function takes a char* filename argument and returns a 
     * 2d dynamic array containing the data
     */

    vector< vector<double> > table; 
    fstream ifs;

    /*  open file  */
    ifs.open(filename);

    while (true)
    {
        string line;
        double buf;
        getline(ifs, line);
        stringstream ss(line, ios_base::out|ios_base::in|ios_base::binary);
        if (!ifs)
            // mainly catch EOF
            break;

        if (line[0] == '#' || line.empty())
            // catch empty lines or comment lines
            continue;


        vector<double> row;

        while (ss >> buf){
            row.push_back(buf);
	}

        table.push_back(row);


    }

    ifs.close();

    return table;
}
int main(){
//load a
vector< vector<double> > a=readIn2dData("a.txt");

//vector< vector<double> > a=readIn2dData("a.3D");
//load N
vector< vector<double> > N=readIn2dData("N.txt");

//vector< vector<double> > N=readIn2dData("N.3D");
//load testpts

vector< vector<double> > testpts=readIn2dData("test.txt");

//vector< vector<double> > testpts=readIn2dData("test.3D");

//parameter
int numFacet=a.size();
int dim=testpts[0].size();
int numTest=testpts.size();

//declare vector to store the results of comparison
vector<int>  CMP(numTest,1);


//calculate dot(a,N)


vector<double> aN(numFacet,0.0);

for (int i=0;i<numFacet;i++){
//for (int j=0;j<dim;j++){
//	cout<<N[i][j]<<' ';
//}
//cout<<endl;
//for (int j=0;j<dim;j++){
//cout<<"N is: "<<N[i][j]<<' ';
//}

aN[i]=inner_product(a[i].begin(),a[i].end(),N[i].begin(),0.0);
//cout<<aN[i]<<' ';
}
//cout<<endl;
//calculate dot(x,N) and compare with dot(a,N), then put the results in CMP, CMP=1 if in hull

vector <vector<double> > TN(numTest, vector<double> (numFacet,0.0));

high_resolution_clock::time_point t1 = high_resolution_clock::now();
for (int k=0;k<numTest;k++){
//vector<double> singleTN(numFacet,0.0);
for (int i=0;i<numFacet;i++){
TN[k][i]=inner_product(testpts[k].begin(),testpts[k].end(),N[i].begin(),0.0);
if(TN[k][i]>aN[i]){
	CMP[k]=-1;
//	cout<<k<<endl;
	break;
}
}
}

high_resolution_clock::time_point t2 = high_resolution_clock::now();
auto duration = duration_cast<microseconds>( t2 - t1 ).count();

//write results to file
ofstream writeResult;
writeResult.open("result.txt",std::ios_base::app);
for (int i=0;i<numTest;i++){
writeResult<<CMP[i]<<endl;
}

//double elapsed_time = double(clcEnd -2*clcMid-clcBegin) / CLOCKS_PER_SEC;

cout<<"elasped time is: "<< duration<<" microseconds"<<endl;

return 1;

}
