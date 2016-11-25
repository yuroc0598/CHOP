#include<fstream>
#include<vector>
#include<iterator>
#include<sstream>
#include<iostream>
#include <functional>  
#include <algorithm>    
#include<numeric>
#include<ctime>
using namespace std;
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
//load convex hull
vector< vector<double> > train=readIn2dData("train.txt");

//load testing points
//clock_t clcBegin=clock();
vector< vector<double> > test=readIn2dData("test.txt");
//parameter
int numTrain=train.size();
int numTest=test.size();
int dim=train[0].size();
//get minus vector
vector< vector<vector<double> > > minus(numTest,vector<vector<double> >(numTrain,vector <double>(dim,0)));

//get sum vector
vector< vector<double> > sum(numTest,vector<double>(dim,0));

for (int k=0;k<numTest;k++){
for (int i=0;i<numTrain;i++){
transform (train[i].begin(), train[i].end(), test[k].begin(), minus[k][i].begin(),std::minus<double>());
for(int j=0;j<dim;j++){
sum[k][j]+=minus[k][i][j];
}
}
}

/*print sum
for (int k=0;k<numTest;k++){
for(int j=0;j<dim;j++){
	cout<<sum[k][j]<<' ';
}
cout<<endl;
}
*/

//get multiplication vector

vector< vector<double> > prod(numTest,vector<double>(numTrain,0.0));

for(int k=0;k<numTest;k++){

for(int i=0;i<numTrain;i++){
prod[k][i]=std::inner_product(minus[k][i].begin(), minus[k][i].end(), sum[k].begin(), 0.0);
//cout<<prod[k][i]<<' ';
}
//cout<<endl;
}


//get sign
vector<int> sign(numTest,-1);
for(int k=0;k<numTest;k++){
for(int i=0;i<numTrain;i++){
if(prod[k][i]<=0){    
sign[k]=1;
break;
}
}
}

//clock_t clcEnd=clock();
//double elapsedTime=1000*double(clcEnd-clcBegin)/(CLOCKS_PER_SEC);
//print sign
ofstream writeSign;
writeSign.open("preSign.txt");

for(int k=0;k<numTest;k++){
	writeSign<<sign[k]<<endl;

}
writeSign.close();

//cout<<"clocks: "<<double(clcEnd-clcBegin)<<'\t'<<"time(ms): "<<elapsedTime<<endl;
return 1;

}
