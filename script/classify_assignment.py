#!/usr/bin/env python

import sys
import os
import re
import getpass
import string



def isAssignment(s):
    if '=' not in s:
        return False,None
    equs = []
    nequs = []
    less = []
    larger = []
    for ele in re.finditer('==',s):
        equs.append(ele.start())
    for ele in re.finditer('!=',s):
        nequs.append(ele.start())
    for ele in re.finditer('<=',s):
        less.append(ele.start())
    for ele in re.finditer('>=',s):
        larger.append(ele.start())

    for i in xrange(len(s)):
        if s[i] == '=':
            if i in equs: continue
            if i>0:
                if i-1 in equs: continue
                if i-1 in nequs: continue
                if i-1 in less: continue
                if i-1 in larger: continue
                return True,i
    return False,None


def extractCodeFromDot(infile,outfilename):
    outfile = open(outfilename,'w+')
    with open(infile) as f:
        for line in f:
            line = line.strip()
            if 'label' in line and 'code:' in line:
                line = line.split("\\")[0][12:]
                res,equalInd = isAssignment(line)
                if len(line.split()) > 1 and res:
                    outfile.write(line)
                    outfile.write('@')
                    outfile.write(str(equalInd))
                    outfile.write('\n')
    outfile.close()



def is_coef(stmt):
    stmt = stmt.replace(" ","")
    ischar_l = ischar_r = False
    letters = string.ascii_lowercase+string.ascii_uppercase
    for i in xrange(len(stmt)):
        char = stmt[i]
        if char in ['*','/']:
            if i>0 and stmt[i-1] == ')':
                j = i-2
                while j>=0 and stmt[j] != '(':
                    j -= 1
                for l in stmt[j+1:i-1]:
                    if l in letters: ischar_l = True

                if i+1<len(stmt) and stmt[i+1]=='(':
                    j = i+2
                    while j<len(stmt) and stmt[j] != ')':
                         j += 1
                    for l in stmt[i+2:j]:
                        if l in letters: ischar_r = True
                else:
                    ischar_r = stmt[i+1] in letters
            else:
                j = i-1
                while j >= 0 and stmt[j] not in ['+','-','*','/',' ','^','!','~']:
                    if stmt[j] in letters:
                        ischar_l = True
                        break
                    else:
                        j -= 1
                if i+1<len(stmt) and stmt[i+1]=='(':
                    j = i+2
                    while j<len(stmt) and stmt[j] != ')':
                         j += 1
                    for l in stmt[i+2:j]:
                        if l in letters: ischar_r = True
                else:
                    ischar_r = stmt[i+1] in letters
		if char == '*':
			if i>0 and stmt[i-1] == '[':
				ischar_l = False

    if ischar_l and ischar_r: return False
    return True
        




            

def conNonLinear(s,ind):
    ind = int(ind)
    if '%=' in s or \
       '*=' in s or \
       '^=' in s or \
       '|=' in s or \
       '&=' in s or \
       '~=' in s:
        return True

    rightS = s[ind+1:]

    if '^' in rightS or '%' in rightS:
        return True
    if conBitOP(rightS): return True
    if not is_coef(rightS): return True
    return False




def conBitOP(s):
    bitor = []
    bitand = []
    for ele in re.finditer('||',s):
        bitor.append(ele.start())
    for ele in re.finditer('&&',s):
        bitand.append(ele.start())
    for i in xrange(len(s)):
        if s[i] == '|':
            if i in bitor: continue
            if i>0 and i-1 in bitor: continue
            return True
        if s[i] == '&':
            if i in bitand: continue
            if i>0 and i-1 in bitand: continue
            return True
    return False

def calRatio(dataFile):
    linearS = nonS = 0
    l_file = open(dataFile+'.linear','w+')
    n_file = open(dataFile + '.nonlinear','w+')
    with open(dataFile) as f:
        for line in f:
            line = line.strip()
            statement, equalInd = line.split('@')
            if conNonLinear(statement,equalInd):
                nonS += 1
                n_file.write(statement)
                n_file.write('\n')
            else:
                linearS += 1
                l_file.write(statement)
                l_file.write('\n')
    l_file.close()
    n_file.close()
    return linearS, nonS
           

def process_one(infilename,outfolder):
    statementFileName = outfolder+'/'+os.path.basename(infilename)+'.extract'
    extractCodeFromDot(infilename,statementFileName)
    return  calRatio(statementFileName)
   


def main(): # scan the target folder and process each of them
    if len(sys.argv)!=3:
              print "provide the target folder, output folder and run!\n"
              sys.abort()
    USER = getpass.getuser()
    TARGET_FOLDER = sys.argv[1]
    STMT_FOLDER = sys.argv[2]
    try:
        os.mkdir(STMT_FOLDER)
    except:
        pass

    files = []
    linear_total = 0
    non_total = 0

    for f in os.listdir(TARGET_FOLDER):
        if os.path.isfile(TARGET_FOLDER+'/'+f) and f[-3:] == 'dot':
            files.append(TARGET_FOLDER+'/'+f)
    for infilename in files:
        #print "now processing the dot file %s: \n" % infilename
        curlinear,curnonlinear = process_one(infilename,STMT_FOLDER)
        print "%s, %d, %d\n" %(infilename,curlinear,curnonlinear)
        linear_total += curlinear
        non_total += curnonlinear

    print "In total: %d / %d = %0.3f" % (non_total,non_total+linear_total,float(non_total)/(non_total+linear_total))

   	


if __name__ == '__main__':
    main()
