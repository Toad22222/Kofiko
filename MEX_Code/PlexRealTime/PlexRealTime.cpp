#include <stdio.h>
#include "mex.h"
#include <string>
#include <math.h>
#include "windows.h"
#include "plexon.h"
bool PlexonInitialized = false;

void GetChannelNames(int nlhs, mxArray *plhs[]) {
  // int freq[64],channels[64],gains[64];
  // PL_GetSlowInfo64(freq, channels, gains);
  
  mxArray *mxAnalog = mxCreateCellMatrix(1, 64);
  mxArray *mxSpikes = mxCreateCellMatrix(1, 64);

  char name[1000];
  for (int j=0;j<64;j++) {
	  PL_GetName(1+j, name);
	  mxSetCell(mxSpikes, j, mxCreateString(name));

	  PL_GetSlowChanName(j, name);
	  mxSetCell(mxAnalog, j, mxCreateString(name));
  }

  plhs[0] = mxSpikes;
  plhs[1] = mxAnalog;

}


/* Entry Points */
void mexFunction( int nlhs, mxArray *plhs[], 
				 int nrhs, const mxArray *prhs[] ) 
{



	static char buff[80+1];
	buff[0]=0;
	mxGetString(prhs[0],buff,80);


	if (strcmp(buff,"InitPlexon") == 0) {
		int res = PL_InitClientEx3(0, NULL, NULL);
		PlexonInitialized = true;
		plhs[0] = mxCreateDoubleScalar(res);
		if (res==1) {
			int freq[64],channels[64],gains[64];
			PL_GetSlowInfo64(freq, channels, gains);
			//LFP_Freq = freq[0];
		}
		return;
	}

	if (strcmp(buff,"GetChannelNames") == 0) {
		if (!PlexonInitialized) {
			mexPrintf("Please Initialize Plexon first!");
			return;
		}
		GetChannelNames(nlhs,plhs);
		return;
	}


	if (strcmp(buff,"GetTimeStampTick") == 0) {
		if (!PlexonInitialized) {
			mexPrintf("Please Initialize Plexon first!");
			return;
		}
		plhs[0] = mxCreateDoubleScalar(PL_GetTimeStampTick());
		return;
	}	


}
