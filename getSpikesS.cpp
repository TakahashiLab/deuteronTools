#include "mex.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <matrix.h>

void makeOutputs(short *wv,short *raw,int step,double *seq,int X,int seqLen){
	int i,j;	
	int ind=0;
	
	int counter=0;
	for(i=0;i<seqLen;i++){
	  ind=seq[i];
	  for (j=(ind-1)*step*X;j<ind*step*X;j++){
	    wv[counter]=(short)raw[j];
            counter++;
	  }
	}

	return;	
}

	
void mexFunction(int nOUT, mxArray *pOUT[],int nINP, const mxArray *pINP[])
{
    	/* check number of arguments */
       if (nINP != 3 || nOUT !=1)
           mexErrMsgTxt("y=getSpikes(x,step,cluster)\n");
       
	/* read inputs */
	short *raw=(short *)mxGetPr(pINP[0]);
	mwSize X=mxGetM(pINP[0]);
	mwSize Y=mxGetN(pINP[0]);

	mwSize step=(int)mxGetScalar(pINP[1]);

	double *seq=mxGetPr(pINP[2]);
	mwSize seqX=mxGetM(pINP[2]);
	mwSize seqY=mxGetN(pINP[2]);
	mwSize seqS=seqY*step;
	
	/* create outputs */
	if (seqY==0){
      	  	const mwSize wvDims[] = {X,seqS};
		pOUT[0] = mxCreateNumericArray(2, wvDims, mxINT16_CLASS, mxREAL);
		short *wv = (short *)mxGetPr(pOUT[0]);
	}
	else{
	  const mwSize wvDims[] = {X,seqY*step};
	  pOUT[0] = mxCreateNumericArray(2, wvDims, mxINT16_CLASS, mxREAL);
	  short *wv = (short *)mxGetPr(pOUT[0]);
          makeOutputs(wv,raw,step,seq,X,seqY);
	}

}







