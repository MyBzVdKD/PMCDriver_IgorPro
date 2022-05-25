#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=1	// Use modern global access method.


Function ImageAs1D(W_src, S_destWN, F_dir)//F_dir: 1:raw dir, 0: col dir
	wave W_src
	string S_destWN
	variable F_dir
	Variable numRows = DimSize(W_src,0)
	Variable numColumns = DimSize(W_src,1) 
   Make/O/N=(numRows*numColumns) $S_destWN
   wave W_dest=$S_destWN
   if(F_dir)
   	multithread W_dest=W_src[mod(p,numRows)][floor(p/numRows)]
   else
   	multithread W_dest=W_src[floor(p/numColumns)][mod(p,numColumns)]
	endif
End

Function PMC_Compensation(W_src)
	wave W_src
	variable V_nLC2=DimSize(W_src, 1)
	variable V_nLC3=DimSize(W_src, 2)
	variable V_sLC2=DimOffset(W_src, 1)
	variable V_sLC3=DimOffset(W_src, 2)
	variable V_dLC2=DimDelta(W_src, 1)
	variable V_dLC3=DimDelta(W_src, 2)
	variable V_eLC2=V_sLC2+V_dLC2*(V_nLC2-1)
	variable V_eLC3=V_sLC3+V_dLC3*(V_nLC3-1)
	//print V_nLC2, V_sLC2, V_dLC2, V_eLC2
	//print V_nLC3, V_sLC3, V_dLC3, V_eLC3
	GetPol_LC2LC3(nameofwave(W_src), V_sLC2, V_eLC2, V_dLC2, V_sLC3, V_eLC3, V_dLC3, 0)
	//GetParam_AmpFreq(nameofwave(W_src), V_sLC2, V_eLC2, V_dLC2, V_sLC3, V_eLC3, V_dLC3, 0)
	wave M_PolDIr=$nameofwave(W_src)+"_PolDir"
	wave M_ExtRatio=$nameofwave(W_src)+"_ExtRatio"
	multithread M_PolDIr=M_PolDIr[p][q]-(M_PolDIr[p][q]>pi)*pi 
	multithread M_PolDIr=M_PolDIr[p][q]+(M_PolDIr[p][q]<0)*pi
	multithread M_PolDIr*=180/pi;SetScale d 0,0,"deg",M_PolDIr
	M_ExtRatio=abs(M_ExtRatio)
	print nameofwave(W_src)+"_PolDir"
	print nameofwave(W_src)+"_ExtRatio"
	print nameofwave(W_src)+"_Intensity"
	end


end

Function PMC_Compensation_Int(W_src)
	wave W_src
	variable V_nLC2=DimSize(W_src, 1)
	variable V_nLC3=DimSize(W_src, 2)
	variable V_sLC2=DimOffset(W_src, 1)
	variable V_sLC3=DimOffset(W_src, 2)
	variable V_dLC2=DimDelta(W_src, 1)
	variable V_dLC3=DimDelta(W_src, 2)
	variable V_eLC2=V_sLC2+V_dLC2*(V_nLC2-1)
	variable V_eLC3=V_sLC3+V_dLC3*(V_nLC3-1)
	//print V_nLC2, V_sLC2, V_dLC2, V_eLC2
	//print V_nLC3, V_sLC3, V_dLC3, V_eLC3
	GetPol_LC2LC3(nameofwave(W_src), V_sLC2, V_eLC2, V_dLC2, V_sLC3, V_eLC3, V_dLC3, 0)
	//GetParam_AmpFreq(nameofwave(W_src), V_sLC2, V_eLC2, V_dLC2, V_sLC3, V_eLC3, V_dLC3, 0)
	wave M_PolDIr=$nameofwave(W_src)+"_PolDir"
	wave M_ExtRatio=$nameofwave(W_src)+"_ExtRatio"
	multithread M_PolDIr=M_PolDIr[p][q]-(M_PolDIr[p][q]>pi)*pi 
	multithread M_PolDIr=M_PolDIr[p][q]+(M_PolDIr[p][q]<0)*pi
	multithread M_PolDIr*=180/pi;SetScale d 0,0,"deg",M_PolDIr
	M_ExtRatio=abs(M_ExtRatio)
	print nameofwave(W_src)+"_PolDir"
	print nameofwave(W_src)+"_ExtRatio"
	print nameofwave(W_src)+"_Intensity"
	end


end

	
function /wave find_PolDir_ExtRatio(W_srcPolDir, W_srcExtRatio, V_PolDir_deg, V_ExtRatio)
	wave W_srcPolDir, W_srcExtRatio
	variable V_PolDir_deg, V_ExtRatio
	FindContour W_srcPolDir, V_PolDir_deg
	ImageLineProfile /S xWave=W_XContour, yWave=W_YContour, srcWave=W_srcExtRatio
	wave W_FindLevels, W_XContour, W_YContour
	FindLevels W_ImageLineProfile, V_ExtRatio
	make /O/n=2 W_Vol_LC2LC3={nan, nan}
	if(V_flag==2)
		return W_Vol_LC2LC3
	elseif(V_flag)	
		duplicate /O W_FindLevels, W_FindLevelsX, W_FindLevelsY
		variable i=0
		for(i=0; i<V_LevelsFound; i+=1)
			W_FindLevelsX[i]=W_XContour[W_FindLevels[i]]
			W_FindLevelsY[i]=W_YContour[W_FindLevels[i]]
		endfor

	endif
end
			wavestats /Q W_Sdev
		
		W_Vol_LC2LC3={W_XContour[W_FindLevels[V_minloc]], W_YContour[W_FindLevels[V_minloc]]}
		print W_Vol_LC2LC3, V_min, V_max
		print W_srcPolDir[ScaleToIndex(W_srcPolDir, W_Vol_LC2LC3[0], 0)][ScaleToIndex(W_srcPolDir, W_Vol_LC2LC3[1], 1)]
		print W_srcExtRatio[ScaleToIndex(W_srcExtRatio, W_Vol_LC2LC3[0], 0)][ScaleToIndex(W_srcExtRatio, W_Vol_LC2LC3[1], 1)]
		return W_Vol_LC2LC3
		
function /wave find_PolDir_ExtRatio2(W_srcPolDir, W_srcExtRatio, V_PolDir_deg, V_ExtRatio, V_PolDir_deg_Torr, V_ExtRatio_Torr)
	wave W_srcPolDir, W_srcExtRatio
	variable V_PolDir_deg, V_ExtRatio, V_PolDir_deg_Torr, V_ExtRatio_Torr
	FindContour W_srcPolDir, V_PolDir_deg
	wave W_XContour, W_YContour
	ImageLineProfile /S xWave=W_XContour, yWave=W_YContour, srcWave=W_srcExtRatio
	wave W_LineProfileX, W_LineProfileY
	wave W_ImageLineProfile
	make /O/n=12 W_Vol_LC2LC3=nan
	make /O /n=(1000, 17) W_Findvalues=nan
	variable i, V_T, V_nlist=50
	//Findvalue /T=1/V=(V_ExtRatio) W_ImageLineProfile
	variable V_p, V_q, V_x, V_y, V_value
	for(V_T=10;V_nlist>1;V_T*=0.99)
		V_value=0
		for(i=0;V_value!=-1; i+=1)
			Findvalue  /Z/S=(V_value+1)/T=(V_T)/V=(V_ExtRatio) W_ImageLineProfile
			//print V_value
			if(V_value!=-1)
				V_p=W_LineProfileX[V_value]
				V_q=W_LineProfileY[V_value]//;V_T
				W_Findvalues[i][0]=V_value//point on Line profile
				W_Findvalues[i][1]=V_p//point on W_srcPolDir W_srcExtRatio (LC2) 
				W_Findvalues[i][2]=V_q//point on W_srcPolDir W_srcExtRatio (LC3) 
				W_Findvalues[i][3]=W_srcExtRatio[V_p][V_q]
				W_Findvalues[i][4]=W_ImageLineProfile[V_value]//W_srcExtRatio on Line profile
				W_Findvalues[i][5]=W_srcPolDir[V_p][V_q]
				W_Findvalues[i][6]=abs(V_ExtRatio-W_Findvalues[i][3])//deviation of ExtRaeio
				W_Findvalues[i][7]=abs(V_PolDir_deg-W_Findvalues[i][5])//deviation of PolDir
				W_Findvalues[i][8]=sqrt(W_Findvalues[i][6]^2+W_Findvalues[i][7]^2)//root mean square of the deviation
				imagestats /G={V_p-1 ,V_p+1, V_q-1 ,V_q+1} W_srcExtRatio
				//print V_avg, V_sdev
				W_Findvalues[i][9]=V_avg
				W_Findvalues[i][10]=V_sdev
				imagestats /G={V_p-1 ,V_p+1, V_q-1 ,V_q+1} W_srcPolDir
				//print V_avg, V_sdev
				W_Findvalues[i][11]=V_avg
				W_Findvalues[i][12]=V_sdev
				W_Findvalues[i][13]=abs(V_ExtRatio-W_Findvalues[i][9])
				W_Findvalues[i][14]=abs(V_PolDir_deg-W_Findvalues[i][11])
				W_Findvalues[i][15]=sqrt(W_Findvalues[i][13]^2+W_Findvalues[i][14]^2)
				W_Findvalues[i][16]=sqrt(W_Findvalues[i][10]^2+W_Findvalues[i][12]^2)
				//print V_value, W_LineProfileX[V_value], W_LineProfileY[V_value],W_srcExtRatio[W_LineProfileX[V_value]][W_LineProfileY[V_value]], W_ImageLineProfile[V_value],W_srcPolDir[W_LineProfileX[V_value]][W_LineProfileY[V_value]]
				//print abs(V_PolDir_deg-W_srcPolDir[W_LineProfileX[V_value]][W_LineProfileY[V_value]]), abs(V_ExtRatio-W_srcExtRatio[W_LineProfileX[V_value]][W_LineProfileY[V_value]])
				//print sqrt((V_PolDir_deg-W_srcPolDir[W_LineProfileX[V_value]][W_LineProfileY[V_value]])^2+(V_ExtRatio-W_srcExtRatio[W_LineProfileX[V_value]][W_LineProfileY[V_value]])^2)			
			endif	
		endfor
		V_nlist=i-1
	endfor
	DeletePoints i-1,1000, W_Findvalues

	W_Vol_LC2LC3[0]=IndexToscale(W_srcExtRatio, V_p, 0 )
	W_Vol_LC2LC3[1]=IndexToscale(W_srcExtRatio, V_q, 1 )
	return W_Vol_LC2LC3
	end
	
end







	
			//print V_value
			if(V_value!=-1)
				V_p=W_LineProfileX[V_value]
				V_q=W_LineProfileY[V_value]//;V_T
				//print V_p, V_q
				W_Findvalues[i][0]=V_p//point on W_srcPolDir W_srcExtRatio (LC2) 
				W_Findvalues[i][1]=V_q//point on W_srcPolDir W_srcExtRatio (LC3) 
				W_Findvalues[i][2]=W_srcExtRatio[V_p][V_q]//ExtRatio
				W_Findvalues[i][3]=W_ImageLineProfile[V_value]//W_srcExtRatio on Line profile
				W_Findvalues[i][4]=W_srcPolDir[V_p][V_q]//PolDir
				W_Findvalues[i][5]=abs(V_ExtRatio-W_Findvalues[i][2])/V_ExtRatio//Error of ExtRaeio
				W_Findvalues[i][6]=abs(V_PolDir_deg-W_Findvalues[i][4])//Error of PolDir
				W_Findvalues[i][7]=sqrt(W_Findvalues[i][5]^2+W_Findvalues[i][6]^2)//root mean square of the deviation
				imagestats /G={V_p-1 ,V_p+1, V_q-1 ,V_q+1} W_srcExtRatio
				//print V_avg, V_sdev
				W_Findvalues[i][8]=V_avg//Averaged data near each pixel (ExtRaeio)
				W_Findvalues[i][9]=V_sdev//deviation near each pixel (ExtRaeio)
				imagestats /G={V_p-1 ,V_p+1, V_q-1 ,V_q+1} W_srcPolDir
				//print V_avg, V_sdev
				W_Findvalues[i][10]=V_avg//Averaged data near each pixel (PolDir)
				W_Findvalues[i][11]=V_sdev//deviation near each pixel (PolDir)
				W_Findvalues[i][12]=abs(V_ExtRatio-W_Findvalues[i][8])//Error of ExtRaeio
				W_Findvalues[i][13]=abs(V_PolDir_deg-W_Findvalues[i][10])//Error of PolDir
				W_Findvalues[i][14]=sqrt(W_Findvalues[i][12]^2+W_Findvalues[i][13]^2)
				W_Findvalues[i][15]=sqrt((W_Findvalues[i][9]/W_Findvalues[i][8])^2+(W_Findvalues[i][11]/W_Findvalues[i][10])^2)
				W_Findvalues[i][16]=V_T
				W_Findvalues[i][17]=1/(V_p*V_q)
				//print V_value, W_LineProfileX[V_value], W_LineProfileY[V_value],W_srcExtRatio[W_LineProfileX[V_value]][W_LineProfileY[V_value]], W_ImageLineProfile[V_value],W_srcPolDir[W_LineProfileX[V_value]][W_LineProfileY[V_value]]
				//print abs(V_PolDir_deg-W_srcPolDir[W_LineProfileX[V_value]][W_LineProfileY[V_value]]), abs(V_ExtRatio-W_srcExtRatio[W_LineProfileX[V_value]][W_LineProfileY[V_value]])
				//print sqrt((V_PolDir_deg-W_srcPolDir[W_LineProfileX[V_value]][W_LineProfileY[V_value]])^2+(V_ExtRatio-W_srcExtRatio[W_LineProfileX[V_value]][W_LineProfileY[V_value]])^2)			
			elseif(V_value==-1&&i<V_nlimit_min&&V_T==V_ExtRatio*V_InitialT)
				return W_Vol_LC2LC3
			endif	
		endfor
		V_nlist=i-1
	endfor
end

function /wave find_PolDir_ExtRatio3(W_srcPolDir, W_srcExtRatio, V_PolDir_deg, V_ExtRatio, V_PolDir_deg_Torr, V_ExtRatio_Torr)
	wave W_srcPolDir, W_srcExtRatio
	variable V_PolDir_deg, V_ExtRatio, V_PolDir_deg_Torr, V_ExtRatio_Torr
	FindContour W_srcPolDir, V_PolDir_deg
	wave W_XContour, W_YContour
	ImageLineProfile /S xWave=W_XContour, yWave=W_YContour, srcWave=W_srcExtRatio
	wave W_LineProfileX, W_LineProfileY
	wave W_ImageLineProfile
	make /O/n=16 W_Vol_LC2LC3=nan
	make /O /n=(1000, 18) W_Findvalues=nan
	variable i, V_T, V_nlist=50
	//Findvalue /T=1/V=(V_ExtRatio) W_ImageLineProfile
	variable V_p, V_q, V_x, V_y, V_value
	variable V_nlimit=10
	variable V_nlimit_min=3
	variable V_stepT=0.99
	variable V_InitialT=0.2
	//variable V_time=ticks
	for(V_T=V_ExtRatio*V_InitialT;V_nlist>V_nlimit;V_T*=V_stepT)
		V_value=0
		for(i=0;V_value!=-1; i+=1)
			Findvalue  /Z/S=(V_value+1)/T=(V_T)/V=(V_ExtRatio) W_ImageLineProfile
			//print V_value
			if(V_value!=-1)
				V_p=W_LineProfileX[V_value]
				V_q=W_LineProfileY[V_value]//;V_T
				//print V_p, V_q
				W_Findvalues[i][0]=V_p//point on W_srcPolDir W_srcExtRatio (LC2) 
				W_Findvalues[i][1]=V_q//point on W_srcPolDir W_srcExtRatio (LC3) 
				W_Findvalues[i][2]=W_srcExtRatio[V_p][V_q]//ExtRatio
				W_Findvalues[i][3]=W_ImageLineProfile[V_value]//W_srcExtRatio on Line profile
				W_Findvalues[i][4]=W_srcPolDir[V_p][V_q]//PolDir
				W_Findvalues[i][5]=abs(V_ExtRatio-W_Findvalues[i][2])/V_ExtRatio//Error of ExtRaeio
				W_Findvalues[i][6]=abs(V_PolDir_deg-W_Findvalues[i][4])//Error of PolDir
				W_Findvalues[i][7]=sqrt(W_Findvalues[i][5]^2+W_Findvalues[i][6]^2)//root mean square of the deviation
				imagestats /G={V_p-1 ,V_p+1, V_q-1 ,V_q+1} W_srcExtRatio
				//print V_avg, V_sdev
				W_Findvalues[i][8]=V_avg//Averaged data near each pixel (ExtRaeio)
				W_Findvalues[i][9]=V_sdev//deviation near each pixel (ExtRaeio)
				imagestats /G={V_p-1 ,V_p+1, V_q-1 ,V_q+1} W_srcPolDir
				//print V_avg, V_sdev
				W_Findvalues[i][10]=V_avg//Averaged data near each pixel (PolDir)
				W_Findvalues[i][11]=V_sdev//deviation near each pixel (PolDir)
				W_Findvalues[i][12]=abs(V_ExtRatio-W_Findvalues[i][8])//Error of ExtRaeio
				W_Findvalues[i][13]=abs(V_PolDir_deg-W_Findvalues[i][10])//Error of PolDir
				W_Findvalues[i][14]=sqrt(W_Findvalues[i][12]^2+W_Findvalues[i][13]^2)
				W_Findvalues[i][15]=sqrt((W_Findvalues[i][9]/W_Findvalues[i][8])^2+(W_Findvalues[i][11]/W_Findvalues[i][10])^2)
				W_Findvalues[i][16]=V_T
				W_Findvalues[i][17]=1/(V_p*V_q)
				//print V_value, W_LineProfileX[V_value], W_LineProfileY[V_value],W_srcExtRatio[W_LineProfileX[V_value]][W_LineProfileY[V_value]], W_ImageLineProfile[V_value],W_srcPolDir[W_LineProfileX[V_value]][W_LineProfileY[V_value]]
				//print abs(V_PolDir_deg-W_srcPolDir[W_LineProfileX[V_value]][W_LineProfileY[V_value]]), abs(V_ExtRatio-W_srcExtRatio[W_LineProfileX[V_value]][W_LineProfileY[V_value]])
				//print sqrt((V_PolDir_deg-W_srcPolDir[W_LineProfileX[V_value]][W_LineProfileY[V_value]])^2+(V_ExtRatio-W_srcExtRatio[W_LineProfileX[V_value]][W_LineProfileY[V_value]])^2)			
			elseif(V_value==-1&&i<V_nlimit_min&&V_T==V_ExtRatio*V_InitialT)
				return W_Vol_LC2LC3
			endif	
		endfor
		V_nlist=i-1
	endfor
	DeletePoints i-1,1000, W_Findvalues

	//Displayed Data on ExtRatio mapping
	wave W_ExtractedCol
	imagetransform /G=0 getCol W_Findvalues//X_coordinate point on contour plot
	multithread W_ExtractedCol=IndexToscale(W_srcExtRatio, W_ExtractedCol[p], 0 )
	Duplicate /O W_ExtractedCol, W_FindLevelsX
	
	imagetransform /G=1 getCol W_Findvalues//Y_coordinate point on contour plot
	multithread W_ExtractedCol=IndexToscale(W_srcExtRatio, W_ExtractedCol[p], 1 )
	Duplicate /O W_ExtractedCol, W_FindLevelsY

	imagetransform /G=2 getCol W_Findvalues//Found values of ExtRatio
	Duplicate /O W_ExtractedCol, W_FindLevels
	//Displayed Data on ExtRatio mapping
	
	imagetransform /G=6 getCol W_Findvalues//evaluation parameters
	wavestats /M=1/Q W_ExtractedCol
	
	
	if(W_Findvalues[V_minloc][5]>V_ExtRatio_Torr||W_Findvalues[V_minloc][6]>V_PolDir_deg_Torr)
		//V_time-=ticks
		//print -V_time/60, "sec"
		W_Vol_LC2LC3=nan
		return W_Vol_LC2LC3
	endif

	W_Vol_LC2LC3[0]=IndexToscale(W_srcExtRatio, W_Findvalues[V_minloc][0], 0 )//LC2_voltage
//	print IndexToscale(W_srcPolDir, W_Findvalues[V_minloc][1], 0 ), W_srcPolDir[W_Findvalues[V_minloc][1]]
	W_Vol_LC2LC3[1]=IndexToscale(W_srcExtRatio, W_Findvalues[V_minloc][1], 1 )//LC3_voltage
//	print IndexToscale(W_srcPolDir, W_Findvalues[V_minloc][2], 0 ), W_srcPolDir[W_Findvalues[V_minloc][2]]
	W_Vol_LC2LC3[2]=W_Findvalues[V_minloc][2]//ExtRatio
	W_Vol_LC2LC3[3]=W_Findvalues[V_minloc][4]//PolDir
	W_Vol_LC2LC3[4]=W_Findvalues[V_minloc][3]//W_srcExtRatio on Line profile
	W_Vol_LC2LC3[5]=W_Findvalues[V_minloc][5]//Error of ExtRaeio
	W_Vol_LC2LC3[6]=W_Findvalues[V_minloc][6]//Error of PolDir
	W_Vol_LC2LC3[7]=W_Findvalues[V_minloc][8]//Averaged data near each pixel (ExtRaeio)
	W_Vol_LC2LC3[8]=W_Findvalues[V_minloc][10]//Averaged data near each pixel (PolDir)
	W_Vol_LC2LC3[9]=W_Findvalues[V_minloc][9]//deviation near each pixel (ExtRaeio)
	W_Vol_LC2LC3[10]=W_Findvalues[V_minloc][11]//deviation near each pixel (PolDir)
	W_Vol_LC2LC3[11]=W_Findvalues[V_minloc][12]//Error of ExtRaeio including Averaged data near each pixel
	W_Vol_LC2LC3[12]=W_Findvalues[V_minloc][13]//Error of PolDir including Averaged data near each pixel
	W_Vol_LC2LC3[13]=W_Findvalues[V_minloc][15]
	W_Vol_LC2LC3[14]=W_Findvalues[V_minloc][16]//Torr. of Find value
	//imagetransform /G=13 getCol W_Findvalues
	//W_Vol_LC2LC3[0]=W_Findvalues[V_minloc][12]
	W_Vol_LC2LC3[15]=abs(W_Findvalues[V_minloc][2]-W_Findvalues[V_minloc][3])//Discretization error
	//print W_Vol_LC2LC3
	//V_time-=ticks
	//print -V_time/60, "sec"
	return W_Vol_LC2LC3
end

function /wave find_PolDir_ExtRatio4(W_srcPolDir, W_srcExtRatio, V_PolDir_deg, V_ExtRatio, V_PolDir_deg_Torr, V_ExtRatio_Torr)
	wave W_srcPolDir, W_srcExtRatio
	variable V_PolDir_deg, V_ExtRatio, V_PolDir_deg_Torr, V_ExtRatio_Torr
	wave W_XContour, W_YContour
	ImageLineProfile  xWave=W_XContour, yWave=W_YContour, srcWave=W_srcExtRatio
	wave W_LineProfileX, W_LineProfileY, W_ImageLineProfile
	make /O/n=16 W_Vol_LC2LC3=nan

	variable i, V_T
	//Findvalue /T=1/V=(V_ExtRatio) W_ImageLineProfile
	variable V_p, V_q, V_x, V_y, V_value
	variable V_nlimit=10
	variable V_nlimit_min=1
//	variable V_stepT=0.99
	variable V_InitialT=0.1
	//variable V_time=ticks

	V_T=FindOptTolerance(W_ImageLineProfile, V_ExtRatio, V_nlimit, V_ExtRatio*V_InitialT)
	wave W_Indexes=Findvalues(W_ImageLineProfile, V_ExtRatio, V_T)
	variable V_nIndexes=numpnts(W_Indexes)
	if(V_nIndexes<=V_nlimit_min)
		//print V_T, V_nIndexes,V_nlimit_min
		return W_Vol_LC2LC3
	endif	

	make /FREE /n=(V_nIndexes, 18) W_Findvalues=nan
	W_Findvalues[][0]=W_LineProfileX[W_Indexes[p]]//point on W_srcPolDir W_srcExtRatio (LC2) 
	W_Findvalues[][1]=W_LineProfileY[W_Indexes[p]]//point on W_srcPolDir W_srcExtRatio (LC3) 
	W_Findvalues[][2]=W_srcExtRatio[W_Findvalues[p][0]][W_Findvalues[p][1]]//ExtRatio
	W_Findvalues[][3]=W_ImageLineProfile[W_Indexes[p]]//W_srcExtRatio on Line profile
	W_Findvalues[][4]=W_srcPolDir[W_LineProfileX[W_Indexes[p]]][W_LineProfileY[W_Indexes[p]]]//PolDir
	W_Findvalues[][5]=abs(V_ExtRatio-W_Findvalues[p][2])/V_ExtRatio//Error of ExtRaeio
	W_Findvalues[][6]=abs(V_PolDir_deg-W_Findvalues[p][4])//Error of PolDir
	W_Findvalues[][7]=sqrt(W_Findvalues[p][5]^2+W_Findvalues[p][6]^2)//root mean square of the deviation
	W_Findvalues[][8]=AvgSdevNeighbor(W_srcExtRatio, W_Findvalues[p][0], W_Findvalues[p][1])[0]//Averaged data near each pixel (ExtRaeio)
	W_Findvalues[][9]=AvgSdevNeighbor(W_srcExtRatio, W_Findvalues[p][0], W_Findvalues[p][1])[1]//deviation near each pixel (ExtRaeio)
	W_Findvalues[][10]=AvgSdevNeighbor(W_srcPolDir, W_Findvalues[p][0], W_Findvalues[p][1])[0]//Averaged data near each pixel (PolDir)
	W_Findvalues[][11]=AvgSdevNeighbor(W_srcPolDir, W_Findvalues[p][0], W_Findvalues[p][1])[1]//deviation near each pixel (PolDir)
	W_Findvalues[][12]=abs(V_ExtRatio-W_Findvalues[p][8])//Error of ExtRaeio
	W_Findvalues[][13]=abs(V_PolDir_deg-W_Findvalues[p][10])//Error of PolDir
	W_Findvalues[][14]=sqrt(W_Findvalues[p][12]^2+W_Findvalues[p][13]^2)
	W_Findvalues[][15]=sqrt((W_Findvalues[p][9]/W_Findvalues[p][8])^2+(W_Findvalues[p][11]/W_Findvalues[p][10])^2)
	W_Findvalues[][16]=V_T
	W_Findvalues[][17]=1/(W_Findvalues[p][0]*W_Findvalues[p][1])
		
	//Displayed Data on ExtRatio mapping
	wave W_ExtractedCol
	imagetransform /G=0 getCol W_Findvalues//X_coordinate point on contour plot
	multithread W_ExtractedCol=IndexToscale(W_srcExtRatio, W_ExtractedCol[p], 0 )
	Duplicate /O W_ExtractedCol, W_FindLevelsX
	
	imagetransform /G=1 getCol W_Findvalues//Y_coordinate point on contour plot
	multithread W_ExtractedCol=IndexToscale(W_srcExtRatio, W_ExtractedCol[p], 1 )
	Duplicate /O W_ExtractedCol, W_FindLevelsY

	imagetransform /G=2 getCol W_Findvalues//Found values of ExtRatio
	Duplicate /O W_ExtractedCol, W_FindLevels
	//Displayed Data on ExtRatio mapping
	
	imagetransform /G=7 getCol W_Findvalues//evaluation parameters
	wavestats /M=1/Q W_ExtractedCol
	
	//Displayed Data on ExtRatio mapping
	make /n=1 /O W_OptLC2, W_OptLC3
		W_OptLC2=IndexToscale(W_srcExtRatio, W_Findvalues[V_minloc][0], 0 )
		W_OptLC3=IndexToscale(W_srcExtRatio, W_Findvalues[V_minloc][1], 1 )
	//Displayed Data on ExtRatio mapping
	
//	if(W_Findvalues[V_minloc][5]>V_ExtRatio_Torr||W_Findvalues[V_minloc][6]>V_PolDir_deg_Torr)
		//V_time-=ticks
		//print -V_time/60, "sec"
//		W_Vol_LC2LC3=nan
		//W_OptLC2=nan
		//W_OptLC3=nan
		//W_FindLevelsX=nan
		//W_FindLevelsY=nan
//		return W_Vol_LC2LC3
//	endif
	
	//if(W_Findvalues[V_minloc][0]==0)
	//print W_Findvalues
	//print V_nIndexes
	//print numtype(V_T), V_T,W_Findvalues[V_minloc][16]
	//print W_Findvalues[V_minloc][5], V_ExtRatio_Torr,W_Findvalues[V_minloc][6], V_PolDir_deg_Torr
	//print W_Findvalues[V_minloc][0], W_Findvalues[V_minloc][1] , W_Findvalues[V_minloc][2], W_Findvalues[V_minloc][3], W_Findvalues[V_minloc][4] , W_Findvalues[V_minloc][5] , W_Findvalues[V_minloc][6]  , W_Findvalues[V_minloc][7], W_Findvalues[V_minloc][8], W_Findvalues[V_minloc][9], W_Findvalues[V_minloc][10], W_Findvalues[V_minloc][11], W_Findvalues[V_minloc][12], W_Findvalues[V_minloc][13], W_Findvalues[V_minloc][14], W_Findvalues[V_minloc][15], W_Findvalues[V_minloc][16], W_Findvalues[V_minloc][17]
	//endif

	W_Vol_LC2LC3[0]=IndexToscale(W_srcExtRatio, W_Findvalues[V_minloc][0], 0 )//LC2_voltage
//	print IndexToscale(W_srcPolDir, W_Findvalues[V_minloc][1], 0 ), W_srcPolDir[W_Findvalues[V_minloc][1]]
	W_Vol_LC2LC3[1]=IndexToscale(W_srcExtRatio, W_Findvalues[V_minloc][1], 1 )//LC3_voltage
//	print IndexToscale(W_srcPolDir, W_Findvalues[V_minloc][2], 0 ), W_srcPolDir[W_Findvalues[V_minloc][2]]
	W_Vol_LC2LC3[2]=W_Findvalues[V_minloc][2]//ExtRatio
	W_Vol_LC2LC3[3]=W_Findvalues[V_minloc][4]//PolDir
	W_Vol_LC2LC3[4]=W_Findvalues[V_minloc][3]//W_srcExtRatio on Line profile
	W_Vol_LC2LC3[5]=W_Findvalues[V_minloc][5]//Error of ExtRaeio
	W_Vol_LC2LC3[6]=W_Findvalues[V_minloc][6]//Error of PolDir
	W_Vol_LC2LC3[7]=W_Findvalues[V_minloc][8]//Averaged data near each pixel (ExtRaeio)
	W_Vol_LC2LC3[8]=W_Findvalues[V_minloc][10]//Averaged data near each pixel (PolDir)
	W_Vol_LC2LC3[9]=W_Findvalues[V_minloc][9]//deviation near each pixel (ExtRaeio)
	W_Vol_LC2LC3[10]=W_Findvalues[V_minloc][11]//deviation near each pixel (PolDir)
	W_Vol_LC2LC3[11]=W_Findvalues[V_minloc][12]//Error of ExtRaeio including Averaged data near each pixel
	W_Vol_LC2LC3[12]=W_Findvalues[V_minloc][13]//Error of PolDir including Averaged data near each pixel
	W_Vol_LC2LC3[13]=W_Findvalues[V_minloc][15]
	W_Vol_LC2LC3[14]=W_Findvalues[V_minloc][16]//Torr. of Find value
	//imagetransform /G=13 getCol W_Findvalues
	//W_Vol_LC2LC3[0]=W_Findvalues[V_minloc][12]
	W_Vol_LC2LC3[15]=abs(W_Findvalues[V_minloc][2]-W_Findvalues[V_minloc][3])//Discretization error
	//print W_Vol_LC2LC3
	//V_time-=ticks
	//print -V_time/60, "sec"
	return W_Vol_LC2LC3
end

function /wave AvgSdevNeighbor(W_src, V_p, V_q)
	wave W_src
	variable V_p, V_q
	make /free /n=2 W_AvgSdev
	W_AvgSdev[0]=(W_src[V_p][V_q]+W_src[V_p+1][V_q]+W_src[V_p-1][V_q]+W_src[V_p][V_q+1]+W_src[V_p][V_q-1])/5
	W_AvgSdev[1]=sqrt((W_AvgSdev[0]-(W_src[V_p][V_q])^2+(W_AvgSdev[0]-W_src[V_p+1][V_q])^2+(W_AvgSdev[0]-W_src[V_p-1][V_q])^2+(W_AvgSdev[0]-W_src[V_p][V_q+1])^2+(W_AvgSdev[0]-W_src[V_p][V_q-1])^2)/4)
	return W_AvgSdev
end
imagestats /G={V_p-1 ,V_p+1, V_q-1 ,V_q+1} W_srcExtRatio


function /wave find_PolDir_ExtRatio3Log_Multithread_x(W_srcPolDir, W_srcExtRatio, V_PolDir_deg, V_ExtRatioBase, V_nExtRatio, V_PolDir_deg_Torr, V_ExtRatio_Torr)
	wave W_srcPolDir, W_srcExtRatio
	variable V_PolDir_deg, V_ExtRatioBase, V_nExtRatio, V_PolDir_deg_Torr, V_ExtRatio_Torr
	FindContour W_srcPolDir, V_PolDir_deg
	wave W_XContour, W_YContour
	ImageLineProfile /S xWave=W_XContour, yWave=W_YContour, srcWave=W_srcExtRatio
	wave W_LineProfileX, W_LineProfileY
	wave W_ImageLineProfile
	make /free /O/n=(V_nExtRatio, 17) W_Vol_LC2LC3=nan
	
	//Findvalue /T=1/V=(V_ExtRatio) W_ImageLineProfile
	variable V_p, V_q, V_x, V_y


	multithread W_Vol_LC2LC3=scanExtRatio(W_srcPolDir, W_srcExtRatio, V_ExtRatioBase^(dimOffset(W_Vol_LC2LC3, 1)+dimDelta(W_Vol_LC2LC3, 1)*p), V_PolDir_deg)[q]
end
	
	imagetransform /G=6 getCol W_Findvalues//evaluation parameters
	wavestats /M=1/Q W_ExtractedCol
	
	
	if(W_Findvalues[V_minloc][5]<V_ExtRatio_Torr)
//		print "ExtRatio: ", V_min, "<",V_ExtRatio_Torr
		if(W_Findvalues[V_minloc][6]<V_PolDir_deg_Torr)
//			print "PolDir: ",W_Findvalues[V_minloc][14], "<",V_PolDir_deg_Torr
//			print "[",W_Findvalues[V_minloc][1], W_Findvalues[V_minloc][2],"]", W_Findvalues[V_minloc][3], W_Findvalues[V_minloc][5]

		else
//			print "PolDir: ",W_Findvalues[V_minloc][14], ">",V_PolDir_deg_Torr, " NG"
			W_Vol_LC2LC3=nan
			return W_Vol_LC2LC3
		endif
	else
//		print "ExtRatio: ", W_Findvalues[V_minloc][5], ">",V_ExtRatio_Torr, V_minloc, " NG"
		W_Vol_LC2LC3=nan
		return W_Vol_LC2LC3
	endif
	W_Vol_LC2LC3[0]=IndexToscale(W_srcExtRatio, W_Findvalues[V_minloc][0], 0 )//LC2_voltage
//	print IndexToscale(W_srcPolDir, W_Findvalues[V_minloc][1], 0 ), W_srcPolDir[W_Findvalues[V_minloc][1]]
	W_Vol_LC2LC3[1]=IndexToscale(W_srcExtRatio, W_Findvalues[V_minloc][1], 1 )//LC3_voltage
//	print IndexToscale(W_srcPolDir, W_Findvalues[V_minloc][2], 0 ), W_srcPolDir[W_Findvalues[V_minloc][2]]
	W_Vol_LC2LC3[2]=W_Findvalues[V_minloc][5]//Error of ExtRaeio
	W_Vol_LC2LC3[3]=W_Findvalues[V_minloc][6]//Error of PolDir
	W_Vol_LC2LC3[4]=W_Findvalues[V_minloc][8]//Averaged data near each pixel (ExtRaeio)
	W_Vol_LC2LC3[5]=W_Findvalues[V_minloc][10]//Averaged data near each pixel (PolDir)
	W_Vol_LC2LC3[6]=W_Findvalues[V_minloc][9]//deviation near each pixel (ExtRaeio)
	W_Vol_LC2LC3[7]=W_Findvalues[V_minloc][11]//deviation near each pixel (PolDir)
	W_Vol_LC2LC3[8]=W_Findvalues[V_minloc][12]//Error of ExtRaeio including Averaged data near each pixel
	W_Vol_LC2LC3[9]=W_Findvalues[V_minloc][13]//Error of PolDir including Averaged data near each pixel
	W_Vol_LC2LC3[10]=W_Findvalues[V_minloc][15]
	W_Vol_LC2LC3[11]=W_Findvalues[V_minloc][16]//Torr. of Find value
	//imagetransform /G=13 getCol W_Findvalues
	//W_Vol_LC2LC3[0]=W_Findvalues[V_minloc][12]
	W_Vol_LC2LC3[12]=abs(W_Findvalues[V_minloc][2]-W_Findvalues[V_minloc][3])//Discretization error
	//print W_Vol_LC2LC3
	return W_Vol_LC2LC3
end

threadsafe function /wave scanExtRatio(W_srcPolDir, W_srcExtRatio, V_ExtRatio, V_PolDir_deg)
	wave W_srcPolDir, W_srcExtRatio
	variable V_ExtRatio, V_PolDir_deg
	wave W_ImageLineProfile
	variable V_T, V_value, V_nlist=50
	variable V_p, V_q, i
	wave W_LineProfileX, W_LineProfileY, W_ImageLineProfile
	make /O /free /n=(1000, 18) W_Findvalues=nan

	//for(V_T=V_ExtRatio*0.2;V_nlist>10;V_T*=0.95)
		V_value=0
		for(i=0;V_value!=-1; i+=1)
			Findvalue /UOFV/Z/S=(V_value+1)/T=(V_T)/V=(V_ExtRatio) W_ImageLineProfile
			
		endfor
		V_nlist=i-1
	//endfor
	DeletePoints i-1,1000, W_Findvalues
	return W_Findvalues
end

	for(V_T=V_ExtRatio*0.2;V_nlist>10;V_T*=0.95)
		V_value=0
		for(i=0;V_value!=-1; i+=1)
			Findvalue /Z/S=(V_value+1)/T=(V_T)/V=(V_ExtRatio) W_ImageLineProfile
			
			print V_value
			if(V_value!=-1)
				V_p=W_LineProfileX[V_value]
				V_q=W_LineProfileY[V_value]//;V_T
				//print V_p, V_q
				W_Findvalues[i][0]=V_p//point on W_srcPolDir W_srcExtRatio (LC2) 
				W_Findvalues[i][1]=V_q//point on W_srcPolDir W_srcExtRatio (LC3) 
				W_Findvalues[i][2]=W_srcExtRatio[V_p][V_q]
				W_Findvalues[i][3]=W_ImageLineProfile[V_value]//W_srcExtRatio on Line profile
				W_Findvalues[i][4]=W_srcPolDir[V_p][V_q]
				W_Findvalues[i][5]=abs(V_ExtRatio-W_Findvalues[i][2])/V_ExtRatio//Error of ExtRaeio
				W_Findvalues[i][6]=abs(V_PolDir_deg-W_Findvalues[i][4])//Error of PolDir
				W_Findvalues[i][7]=sqrt(W_Findvalues[i][5]^2+W_Findvalues[i][6]^2)//root mean square of the deviation
				imagestats /G={V_p-1 ,V_p+1, V_q-1 ,V_q+1} W_srcExtRatio
				//print V_avg, V_sdev
				W_Findvalues[i][8]=V_avg//Averaged data near each pixel (ExtRaeio)
				W_Findvalues[i][9]=V_sdev//deviation near each pixel (ExtRaeio)
				imagestats /G={V_p-1 ,V_p+1, V_q-1 ,V_q+1} W_srcPolDir
				//print V_avg, V_sdev
				W_Findvalues[i][10]=V_avg//Averaged data near each pixel (PolDir)
				W_Findvalues[i][11]=V_sdev//deviation near each pixel (PolDir)
				W_Findvalues[i][12]=abs(V_ExtRatio-W_Findvalues[i][8])//Error of ExtRaeio
				W_Findvalues[i][13]=abs(V_PolDir_deg-W_Findvalues[i][10])//Error of PolDir
				W_Findvalues[i][14]=sqrt(W_Findvalues[i][12]^2+W_Findvalues[i][13]^2)
				W_Findvalues[i][15]=sqrt((W_Findvalues[i][9]/W_Findvalues[i][8])^2+(W_Findvalues[i][11]/W_Findvalues[i][10])^2)
				W_Findvalues[i][16]=V_T
				W_Findvalues[i][17]=1/(V_p*V_q)
				//print V_value, W_LineProfileX[V_value], W_LineProfileY[V_value],W_srcExtRatio[W_LineProfileX[V_value]][W_LineProfileY[V_value]], W_ImageLineProfile[V_value],W_srcPolDir[W_LineProfileX[V_value]][W_LineProfileY[V_value]]
				//print abs(V_PolDir_deg-W_srcPolDir[W_LineProfileX[V_value]][W_LineProfileY[V_value]]), abs(V_ExtRatio-W_srcExtRatio[W_LineProfileX[V_value]][W_LineProfileY[V_value]])
				//print sqrt((V_PolDir_deg-W_srcPolDir[W_LineProfileX[V_value]][W_LineProfileY[V_value]])^2+(V_ExtRatio-W_srcExtRatio[W_LineProfileX[V_value]][W_LineProfileY[V_value]])^2)			
			endif	
		endfor
		V_nlist=i-1
	endfor
	DeletePoints i-1,1000, W_Findvalues
	return W_Findvalues
end


function createDrivingMatrix(W_srcPolDir, W_srcExtRatio, S_wnLC, V_sPolDir, V_ePolDir, V_dPolDir, V_sExtRatio, V_eExtRatio, V_dExtRatio)
	wave W_srcPolDir, W_srcExtRatio
	string S_wnLC
	variable V_sPolDir, V_ePolDir, V_dPolDir, V_sExtRatio, V_eExtRatio, V_dExtRatio
	variable V_nPolDir=(V_ePolDir-V_sPolDir)/V_dPolDir+1
	variable V_nExtRatio=(V_eExtRatio-V_sExtRatio)/V_dExtRatio+2
	variable V_time=ticks
	//print V_nPolDir, V_nExtRatio
	//print  V_sPolDir, V_ePolDir, V_dPolDir, V_sExtRatio, V_eExtRatio, V_dExtRatio
	make /O /n=(V_nPolDir, V_nExtRatio-1, 17) $S_wnLC
	make /free /n=17 W_results
	wave W_LC=$S_wnLC
	//W_LC=nan
	SetScale/I x V_sPolDir,V_ePolDir,"deg", W_LC
	SetScale/I y V_sExtRatio, V_eExtRatio,"", W_LC
	SetScale d 0,0,"", W_LC
	variable V_iPolDir, V_iExtRatio
	variable V_p, V_q
	
	for(V_iExtRatio=V_sExtRatio; V_iExtRatio<=V_eExtRatio; V_iExtRatio+=V_dExtRatio)
		for(V_iPolDir=V_sPolDir; V_iPolDir<=V_ePolDir; V_iPolDir+=V_dPolDir)
			//print V_iExtRatio, (V_iExtRatio-V_sExtRatio)/V_dExtRatio
			//print V_iPolDir, (V_iPolDir-V_sPolDir)/V_dPolDir
			V_p=(V_iPolDir-V_sPolDir)/V_dPolDir
			V_q=(V_iExtRatio-V_sExtRatio)/V_dExtRatio
			W_results=find_PolDir_ExtRatio3(W_srcPolDir, W_srcExtRatio, V_iPolDir, V_iExtRatio, V_dPolDir, V_dExtRatio)[p]
			//print W_results
			multithread W_LC[V_p][V_q][]=W_results[r]
			//doupdate
		endfor
	endfor
	V_time-=ticks
	print -V_time/60/60, "min"
end

function createDrivingMatrixLog(W_srcPolDir, W_srcExtRatio, S_wnLC, V_sPolDir, V_ePolDir, V_dPolDir, V_ExtRatioBase, V_nExtRatio)
	wave W_srcPolDir, W_srcExtRatio
	string S_wnLC
	variable V_sPolDir, V_ePolDir, V_dPolDir, V_ExtRatioBase, V_nExtRatio
	variable V_nPolDir=(V_ePolDir-V_sPolDir)/V_dPolDir+1
	variable V_time=ticks
	//print V_nPolDir, V_nExtRatio
	//print  V_sPolDir, V_ePolDir, V_dPolDir, V_sExtRatio, V_eExtRatio, V_dExtRatio
	make /O /n=(V_nPolDir, V_nExtRatio+1, 17) $S_wnLC
	make /free /n=17 W_results
	wave W_LC=$S_wnLC
	W_LC=nan
	SetScale/I x V_sPolDir,V_ePolDir,"deg", W_LC
	SetScale/I y 0, 1,num2str(V_ExtRatioBase)+"^x", W_LC
	SetScale d 0,0,"", W_LC
	variable V_iPolDir, V_iExtRatio
	variable V_p, V_q
	variable V_exponent=0
	variable i=0
	for(V_iPolDir=V_sPolDir; V_iPolDir<=V_ePolDir; V_iPolDir+=V_dPolDir)
		
		for(V_iExtRatio=V_ExtRatioBase^0; V_ExtRatioBase^(V_exponent-1/V_nExtRatio)<=V_ExtRatioBase; V_exponent+=1/V_nExtRatio)
			V_iExtRatio=V_ExtRatioBase^V_exponent
			//print V_iExtRatio, (V_iExtRatio-V_sExtRatio)/V_dExtRatio
			//print V_iPolDir, (V_iPolDir-V_sPolDir)/V_dPolDir
			V_p=(V_iPolDir-V_sPolDir)/V_dPolDir
			V_q=i
			W_results=find_PolDir_ExtRatio3(W_srcPolDir, W_srcExtRatio, V_iPolDir, V_iExtRatio, V_dPolDir*0.1, V_iExtRatio*0.1)[p]
			multithread W_LC[V_p][V_q][]=W_results[r]
			//doupdate
		endfor
		//print V_iExtRatio, i
		i+=1
	endfor
	V_time-=ticks
	print -V_time/60/60, "min"
end

function createDrivingMatrixLog2(W_srcPolDir, W_srcExtRatio, S_wnLC, V_sPolDir, V_ePolDir, V_dPolDir, V_ExtRatioBase, V_nExtRatio)
	wave W_srcPolDir, W_srcExtRatio
	string S_wnLC
	variable V_sPolDir, V_ePolDir, V_dPolDir, V_ExtRatioBase, V_nExtRatio
	variable V_nPolDir=(V_ePolDir-V_sPolDir)/V_dPolDir+1
	variable V_time=ticks
	//print V_nPolDir, V_nExtRatio
	//print  V_sPolDir, V_ePolDir, V_dPolDir, V_sExtRatio, V_eExtRatio, V_dExtRatio
	make /O /n=(V_nPolDir, V_nExtRatio+1, 17) $S_wnLC
	make /free /n=17 W_results
	wave W_LC=$S_wnLC
	W_LC=nan
	SetScale/I x V_sPolDir,V_ePolDir,"deg", W_LC
	SetScale/I y 0, 1,num2str(V_ExtRatioBase)+"^x", W_LC
	SetScale d 0,0,"", W_LC
	variable V_iPolDir, V_iExtRatio
	variable V_PolDir_deg_Torr=V_dPolDir
	variable V_ExtRatio_Torr=V_iExtRatio*0.2
	variable V_p, V_q
	variable V_exponent=0
	variable i=0
	newmovie /F=25 as S_wnLC
	for(V_iPolDir=V_sPolDir; V_iPolDir<=V_ePolDir; V_iPolDir+=V_dPolDir)
		print V_iPolDir
		FindContour W_srcPolDir, V_iPolDir
		wave W_LineProfileX, W_LineProfileY, W_ImageLineProfile
		V_exponent=0
		i=0
		for(V_iExtRatio=V_ExtRatioBase^V_exponent; V_ExtRatioBase^(V_exponent-1/V_nExtRatio)<=V_ExtRatioBase; V_exponent+=1/V_nExtRatio)
			V_iExtRatio=V_ExtRatioBase^V_exponent
			//print V_iExtRatio, (V_iExtRatio-V_sExtRatio)/V_dExtRatio
			//print V_iPolDir, (V_iPolDir-V_sPolDir)/V_dPolDir
			V_p=(V_iPolDir-V_sPolDir)/V_dPolDir
			V_q=i
			//print V_p,V_q
			W_results=find_PolDir_ExtRatio4(W_srcPolDir, W_srcExtRatio, V_iPolDir, V_iExtRatio, V_PolDir_deg_Torr, V_ExtRatio_Torr)[p]
			multithread W_LC[V_p][V_q][]=W_results[r]
			i+=1
			TextBox/C/N=PoldirExtratio "PolDir="+num2str(V_iPolDir)+", ExtRatio="+num2str(V_iExtRatio)
			doupdate
			//AddMovieFrame
		endfor
		//print V_iExtRatio, i
	endfor
	//CloseMovie
	V_time-=ticks
	print -V_time/60/60, "min"
end

function createDrivingMatrixLog3(W_srcPolDir, W_srcExtRatio, S_wnLC, V_sPolDir, V_ePolDir, V_dPolDir, V_ExtRatioBase, V_nExtRatio)
	wave W_srcPolDir, W_srcExtRatio
	string S_wnLC
	variable V_sPolDir, V_ePolDir, V_dPolDir, V_ExtRatioBase, V_nExtRatio
	variable V_nPolDir=(V_ePolDir-V_sPolDir)/V_dPolDir+1
	variable V_time=ticks
	//print V_nPolDir, V_nExtRatio
	//print  V_sPolDir, V_ePolDir, V_dPolDir, V_sExtRatio, V_eExtRatio, V_dExtRatio
	make /O /n=(V_nPolDir, V_nExtRatio+1, 17) $S_wnLC
	make /free /n=17 W_results
	wave W_LC=$S_wnLC
	W_LC=nan
	SetScale/I x V_sPolDir,V_ePolDir,"deg", W_LC
	SetScale/I y 0, 1,num2str(V_ExtRatioBase)+"^x", W_LC
	SetScale d 0,0,"", W_LC
	variable V_iPolDir, V_iExtRatio
	variable V_PolDir_deg_Torr=V_dPolDir
	variable V_ExtRatio_Torr=V_iExtRatio*0.1
	variable V_p, V_q
	variable V_exponent=0
	variable k,j,i=0
	variable V_nImageLineProfile
	//newmovie /F=25 as S_wnLC
	for(V_iPolDir=V_sPolDir; V_iPolDir<=V_ePolDir; V_iPolDir+=V_dPolDir)
//	V_iPolDir=160
//		print V_iPolDir
		FindContour W_srcPolDir, V_iPolDir
		ImageLineProfile /S xWave=W_XContour, yWave=W_YContour, srcWave=W_srcPolDir, width=2
		wave W_LineProfileX, W_LineProfileY, W_ImageLineProfile, W_XContour, W_YContour, W_LineProfileStdv
		V_nImageLineProfile=numpnts(W_ImageLineProfile)
		variable V_d
		k=0
		for(j=0;j<V_nImageLineProfile;j+=1)
			if(numtype(W_XContour[k])==2)
				k+=1
				//print k
			endif
//			if(abs(W_ImageLineProfile[j]-V_iPolDir)>V_PolDir_deg_Torr||W_LineProfileStdv[j]>60)
			imagestats /G={W_LineProfileX[j]-1 ,W_LineProfileX[j]+1, W_LineProfileY[j]-1 ,W_LineProfileY[j]+1 } W_srcPolDir
			if(V_sdev>45)
//			if(abs(W_srcPolDir[(W_LineProfileX[j])+1][(W_LineProfileY[j]+1)]-W_srcPolDir[(W_LineProfileX[j])-1][(W_LineProfileY[j]-1)])>30)
			//if(abs(W_srcPolDir[round(W_LineProfileX[j])][round(W_LineProfileY[j])]-V_iPolDir)>V_iPolDir*0.1)
			
//		if(W_LineProfileStdv[j]>60)
				W_XContour[k]=nan
				W_YContour[k]=nan
			endif
			k+=1
		endfor
		
		for(k=0;(numtype(W_XContour[0])==2||(numtype(W_XContour[0])!=2&&numtype(W_XContour[1])==2))&&k<1000;k+=1)
			DeletePoints 0, 1, W_XContour,W_YContour;V_nImageLineProfile=numpnts(W_XContour)
		endfor

		V_nImageLineProfile=numpnts(W_XContour)
		for(j=0;j<V_nImageLineProfile;j+=1) 			
			if(numtype(W_XContour[j+1])==2&&numtype(W_XContour[j])==2&&j+1<V_nImageLineProfile)
				//do
				for(;numtype(W_XContour[j+1])==2&&j+1<V_nImageLineProfile;)
					//print W_XContour[j+1], W_XContour[j+1]
					DeletePoints j+1, 1, W_XContour,W_YContour
					V_nImageLineProfile=numpnts(W_XContour)
					//print W_XContour[j+1]
				endfor
				//while(numtype(W_XContour[j+1])==2)
			elseif(numtype(W_XContour[j])!=2&&numtype(W_XContour[j+1])==2&&numtype(W_XContour[j-1])==2)
				DeletePoints j, 1, W_XContour,W_YContour;V_nImageLineProfile=numpnts(W_XContour)
			endif
		endfor

		for(k=0;((numtype(W_XContour[numpnts(W_XContour)-2])==2&&numtype(W_XContour[numpnts(W_XContour)-1])!=2))&&k<100;k+=1)
			DeletePoints numpnts(W_XContour)-1, 1, W_XContour,W_YContour;V_nImageLineProfile=numpnts(W_XContour)
		endfor
		imageLineProfile xWave=W_XContour, yWave=W_YContour, srcWave=W_srcExtratio//, width=2
		//doupdate
//return 0
		V_exponent=0
		i=0
		for(V_iExtRatio=V_ExtRatioBase^V_exponent; V_ExtRatioBase^(V_exponent-1/V_nExtRatio)<=V_ExtRatioBase; V_exponent+=1/V_nExtRatio)
			V_iExtRatio=V_ExtRatioBase^V_exponent
			//print V_iExtRatio, (V_iExtRatio-V_sExtRatio)/V_dExtRatio
			//print V_iPolDir, (V_iPolDir-V_sPolDir)/V_dPolDir
			V_p=(V_iPolDir-V_sPolDir)/V_dPolDir
			V_q=i
			//print V_p,V_q
			W_results=find_PolDir_ExtRatio4(W_srcPolDir, W_srcExtRatio, V_iPolDir, V_iExtRatio, V_PolDir_deg_Torr, V_ExtRatio_Torr)[p]
			multithread W_LC[V_p][V_q][]=W_results[r]
			i+=1
			//TextBox/C/N=PoldirExtratio "PolDir="+num2str(V_iPolDir)+", ExtRatio="+num2str(V_iExtRatio)
			//doupdate
			//AddMovieFrame
		endfor
		//print V_iExtRatio, i
	endfor
	//CloseMovie
	V_time-=ticks
	print -V_time/60/60, "min"
end

function createDrivingMatrixLog_Multithread(W_srcPolDir, W_srcExtRatio, S_wnLC, V_sPolDir, V_ePolDir, V_dPolDir, V_ExtRatioBase, V_nExtRatio)
	wave W_srcPolDir, W_srcExtRatio
	string S_wnLC
	variable V_sPolDir, V_ePolDir, V_dPolDir, V_ExtRatioBase, V_nExtRatio
	variable V_nPolDir=(V_ePolDir-V_sPolDir)/V_dPolDir+1
	variable V_time=ticks
	//print V_nPolDir, V_nExtRatio
	//print  V_sPolDir, V_ePolDir, V_dPolDir, V_sExtRatio, V_eExtRatio, V_dExtRatio
	make /O /n=(V_nPolDir, V_nExtRatio+1, 17) $S_wnLC
	make /free /n=17 W_results
	wave W_LC=$S_wnLC
	//W_LC=nan
	SetScale/I x V_sPolDir,V_ePolDir,"deg", W_LC
	SetScale/I y 0, 1,"log"+num2str(V_ExtRatioBase)+"x", W_LC
	SetScale d 0,0,"", W_LC
	variable V_iPolDir, V_iExtRatio
	variable V_p, V_q
	variable V_exponent=0
	variable i=0
	for(V_iExtRatio=V_ExtRatioBase^0; V_ExtRatioBase^(V_exponent-1/V_nExtRatio)<=V_ExtRatioBase; V_exponent+=1/V_nExtRatio)
		for(V_iPolDir=V_sPolDir; V_iPolDir<=V_ePolDir; V_iPolDir+=V_dPolDir)
		V_iExtRatio=V_ExtRatioBase^V_exponent
			//print V_iExtRatio, (V_iExtRatio-V_sExtRatio)/V_dExtRatio
			//print V_iPolDir, (V_iPolDir-V_sPolDir)/V_dPolDir
			V_p=(V_iPolDir-V_sPolDir)/V_dPolDir
			V_q=i
			W_results=find_PolDir_ExtRatio3Log_Multithread_x(W_srcPolDir, W_srcExtRatio, V_iPolDir, V_ExtRatioBase, V_nExtRatio, V_dPolDir, 0.1)[p]
			multithread W_LC[V_p][V_q][]=W_results[r]
			//doupdate
		endfor
		//print V_iExtRatio, i
		i+=1
	endfor
	V_time-=ticks
	print -V_time/60/60, "min"
end


function /wave checkCompData(M_MergedData, M_DrvData)
	wave M_MergedData, M_DrvData
	variable F_param
	Duplicate /O M_MergedData, $nameofwave(M_DrvData)+"_Param"
	wave M_Param=$nameofwave(M_DrvData)+"_Param"
	copyscales M_MergedData, M_Param
	Redimension/N=(-1,-1, 17) M_Param
	M_Param[][][]=M_MergedData[p][q][M_DrvData[p][q][3]][r]//M_DrvData[p][q][3]
	return M_Param
end
	//M_Dir=M_PolDir_src[M_comp[p][q][0]][M_comp[p][q][0]]
	M_Dir=M_DrvData[scaletoindex(M_PolDir_src, M_comp[p][q][0], 0)][scaletoindex(M_PolDir_src, M_comp[p][q][0], 1)]
	//M_ExtRatio=M_ExtRatio_src[M_comp[p][q][1]][M_comp[p][q][1]]
	M_ExtRatio=M_DrvData[scaletoindex(M_ExtRatio_src, M_comp[p][q][0], 0)][scaletoindex(M_ExtRatio_src, M_comp[p][q][0], 1)]
end



function /wave extractDrivingVoltage(W_Src, V_PolDIr, V_ExtRatio)
	wave W_Src
	variable V_PolDIr, V_ExtRatio
	make /free /n=2 W_LC2LC3
	print log(V_ExtRatio)/log(50)
	W_LC2LC3[0]=W_Src[scaleToIndex(W_Src, V_PolDIr, 0)][scaleToIndex(W_Src, log(V_ExtRatio)/log(50), 1)][0]
	W_LC2LC3[1]=W_Src[scaleToIndex(W_Src, V_PolDIr, 0)][scaleToIndex(W_Src, log(V_ExtRatio)/log(50), 1)][1]
	return W_LC2LC3
end


function GetParam_AmpFreq(S_BaseWN, V_StartVol, V_EndVol, V_DetVol, V_StartFrq, V_EndFrq, V_DetFrq, F_display)
	string S_BaseWN
	variable V_StartVol, V_EndVol, V_DetVol, V_StartFrq, V_EndFrq, V_DetFrq, F_display
	variable I_Frq=0
	wave M_profilesVolFrq=$S_BaseWN
	duplicate /O/RMD=[][][0,0] M_profilesVolFrq, $S_BaseWN+"_Vol"
	wave M_profilesVol=$S_BaseWN+"_Vol"
	
	make /O/D /N=((V_EndVol-V_StartVol)/V_DetVol+1, (V_EndFrq-V_StartFrq)/V_DetFrq+1) $S_BaseWN+"_PolDir", $S_BaseWN+"_ExtRatio", $S_BaseWN+"_Intensity", $S_BaseWN+"_PIntensity", $S_BaseWN+"_chisq", $S_BaseWN+"_max", $S_BaseWN+"_min"
	SetScale/P x V_StartVol,V_DetVol,"V", $S_BaseWN+"_PolDir", $S_BaseWN+"_ExtRatio", $S_BaseWN+"_Intensity", $S_BaseWN+"_PIntensity", $S_BaseWN+"_chisq", $S_BaseWN+"_max", $S_BaseWN+"_min"
	SetScale/P y V_StartFrq,V_DetFrq,"Hz", $S_BaseWN+"_PolDir", $S_BaseWN+"_ExtRatio", $S_BaseWN+"_Intensity", $S_BaseWN+"_PIntensity", $S_BaseWN+"_chisq", $S_BaseWN+"_max", $S_BaseWN+"_min"
	SetScale d 0,0,"rad",$S_BaseWN+"_PolDir"
	wave M_ExtRatio=$S_BaseWN+"_ExtRatio"
	wave M_PolDir=$S_BaseWN+"_PolDir"
 	wave M_Intensity=$S_BaseWN+"_Intensity"
 	wave M_PIntensity=$S_BaseWN+"_PIntensity"
 	wave M_chisq=$S_BaseWN+"_chisq"
 	wave M_max=$S_BaseWN+"_max"
 	wave M_min=$S_BaseWN+"_min"
 	M_ExtRatio=nan
	M_PolDir=nan
 	M_Intensity=nan
 	M_PIntensity=nan
 	M_chisq=nan
 	M_max=nan
 	M_min=nan
	wave W_ExtRatio=$S_BaseWN+"_VolExtRatio"
	wave W_PolDir=$S_BaseWN+"_VolPolDir"
 	wave W_Intensity=$S_BaseWN+"_VolIntensity"
 	wave W_PIntensity=$S_BaseWN+"_VolPIntensity"
 	wave W_chisq=$S_BaseWN+"_Volchisq"
 	wave W_max=$S_BaseWN+"_Volmax"
 	wave W_min=$S_BaseWN+"_Volmin"
	variable i
	for(I_Frq=0; V_StartFrq+I_Frq*V_DetFrq<=V_EndFrq; I_Frq+=1)
		M_profilesVol=M_profilesVolFrq[p][q][I_Frq]
		//print I_Frq, nameofwave(W_ExtRatio), nameofwave(M_ExtRatio), nameofwave(W_PolDir), nameofwave(M_PolDir)
		GetParam(nameofwave(M_profilesVol), V_StartVol, V_EndVol, V_DetVol, F_display)
		multithread M_ExtRatio[][I_Frq]=W_ExtRatio[p]
		multithread M_PolDir[][I_Frq]=W_PolDir[p]/2+pi/2
		multithread M_PIntensity[][I_Frq]=W_PIntensity[p]
		multithread M_Intensity[][I_Frq]=W_Intensity[p]
		multithread M_chisq[][I_Frq]=W_chisq[p]
		multithread M_max[][I_Frq]=W_max[p]
		multithread M_min[][I_Frq]=W_min[p]
		doupdate
	endfor
	


	killwaves M_profilesVol
	killwaves W_ExtRatio
	killwaves W_PolDir
 	killwaves W_Intensity
 	killwaves W_PIntensity
 	killwaves W_chisq
 	killwaves W_max
 	killwaves W_min
	//GetParam_AmpFreq("M_7um_PA1193", 0, 10, 0.01, 100, 2000, 200, 1)
	//findXi2D(M_MLC2132_7um_RLED_45_2_190901_PolDir, M_MLC2132_7um_RLED_45_2_190901_ExtRatio, 1, 1, 1, 1,0)
end

function GetPol_LC2LC3(S_BaseWN, V_StartVol_LC2, V_EndVol_LC2, V_DetVol_LC2, V_StartVol_LC3, V_EndVol_LC3, V_DetVol_LC3, F_display)
	string S_BaseWN
	variable V_StartVol_LC2, V_EndVol_LC2, V_DetVol_LC2, V_StartVol_LC3, V_EndVol_LC3, V_DetVol_LC3, F_display
	wave M_profilesVolFrq=$S_BaseWN
	duplicate /O/RMD=[][][0,0] M_profilesVolFrq, $S_BaseWN+"_Vol"
	wave M_profilesVol=$S_BaseWN+"_Vol"
	
	make /O/D /N=((V_EndVol_LC2-V_StartVol_LC2)/V_DetVol_LC2+1, (V_EndVol_LC3-V_StartVol_LC3)/V_DetVol_LC3+1) $S_BaseWN+"_PolDir", $S_BaseWN+"_ExtRatio", $S_BaseWN+"_Intensity", $S_BaseWN+"_PIntensity", $S_BaseWN+"_chisq", $S_BaseWN+"_max", $S_BaseWN+"_min"
	SetScale/P x V_StartVol_LC2,V_DetVol_LC2,"V", $S_BaseWN+"_PolDir", $S_BaseWN+"_ExtRatio", $S_BaseWN+"_Intensity", $S_BaseWN+"_PIntensity", $S_BaseWN+"_chisq", $S_BaseWN+"_max", $S_BaseWN+"_min"
	SetScale/P y V_StartVol_LC3,V_DetVol_LC3,"V", $S_BaseWN+"_PolDir", $S_BaseWN+"_ExtRatio", $S_BaseWN+"_Intensity", $S_BaseWN+"_PIntensity", $S_BaseWN+"_chisq", $S_BaseWN+"_max", $S_BaseWN+"_min"
	SetScale d 0,0,"rad",$S_BaseWN+"_PolDir"
	wave M_ExtRatio=$S_BaseWN+"_ExtRatio"
	wave M_PolDir=$S_BaseWN+"_PolDir"
 	wave M_Intensity=$S_BaseWN+"_Intensity"
 	wave M_PIntensity=$S_BaseWN+"_PIntensity"
 	wave M_chisq=$S_BaseWN+"_chisq"
 	wave M_max=$S_BaseWN+"_max"
 	wave M_min=$S_BaseWN+"_min"
 	M_ExtRatio=nan
	M_PolDir=nan
 	M_Intensity=nan
 	M_PIntensity=nan
 	M_chisq=nan
 	M_max=nan
 	M_min=nan
	variable i
	variable I_LC3=0
	for(I_LC3=0; V_StartVol_LC3+I_LC3*V_DetVol_LC3<=V_EndVol_LC3; I_LC3+=1)
		M_profilesVol=M_profilesVolFrq[p][q][I_LC3]
		//print I_LC3, nameofwave(W_ExtRatio), nameofwave(M_ExtRatio), nameofwave(W_PolDir), nameofwave(M_PolDir)
		GetParam(nameofwave(M_profilesVol), V_StartVol_LC2, V_EndVol_LC2, V_DetVol_LC2, F_display)
		if(I_LC3==0)
			wave W_ExtRatio=$S_BaseWN+"_VolExtRatio"
			wave W_PolDir=$S_BaseWN+"_VolPolDir"
		 	wave W_Intensity=$S_BaseWN+"_VolIntensity"
		 	wave W_PIntensity=$S_BaseWN+"_VolPIntensity"
		 	wave W_chisq=$S_BaseWN+"_Volchisq"
		 	wave W_max=$S_BaseWN+"_Volmax"
		 	wave W_min=$S_BaseWN+"_Volmin"
		endif
		multithread M_ExtRatio[][I_LC3]=W_ExtRatio[p]
		multithread M_PolDir[][I_LC3]=W_PolDir[p]/2
		multithread M_PIntensity[][I_LC3]=W_PIntensity[p]
		multithread M_Intensity[][I_LC3]=W_Intensity[p]
		multithread M_chisq[][I_LC3]=W_chisq[p]
		multithread M_max[][I_LC3]=W_max[p]
		multithread M_min[][I_LC3]=W_min[p]
		//doupdate
	endfor

	killwaves M_profilesVol
	killwaves W_ExtRatio
	killwaves W_PolDir
 	killwaves W_Intensity
 	killwaves W_PIntensity
 	killwaves W_chisq
 	killwaves W_max
 	killwaves W_min
	//GetParam_AmpFreq("M_7um_PA1193", 0, 10, 0.01, 100, 2000, 200, 1)
	//findXi2D(M_MLC2132_7um_RLED_45_2_190901_PolDir, M_MLC2132_7um_RLED_45_2_190901_ExtRatio, 1, 1, 1, 1,0)
end




function FillingRate(L_waves, V_sPolDir, V_ePolDir, V_sExtRatio, V_eExtRatio)
	string L_waves//"PMC_test_300Hz_LC;PMC_test_200Hz_LC;PMC_test_100Hz_LC;PMC_test_1000Hz_LC;PMC_test_10000Hz_LC"
	variable V_sPolDir, V_ePolDir, V_sExtRatio, V_eExtRatio
	variable V_n=itemsinlist(L_waves)
	variable i=0
	//print i, StringFromList(i, L_waves)
	wave M_aplane=$StringFromList(i, L_waves)
	duplicate /O M_aplane, M_dest
	Redimension/N=(-1,-1) M_dest
	M_dest=M_aplane[p][q][0]
	for(i=1;i<V_n;I+=1)
		//print i, StringFromList(i, L_waves)
		//imagetransform /O/P=(i-1) insertZplane M_dest
		//InsertPoints /M=2 dimsize(M_dest, 2), 1, M_dest
		wave M_aplane=$StringFromList(i, L_waves)
		M_dest=0/(NumType(M_aplane[p][q][r])*NumType(M_dest[p][q][r])==0)+1
		//M_dest[][]=M_aplane[p][q][0]
	endfor
	variable V_Ps=ScaleToIndex(M_dest, V_sPolDir, 0 )
	variable V_Pe=ScaleToIndex(M_dest, V_ePolDir, 0 )
	variable V_Qs=ScaleToIndex(M_dest, V_sExtRatio, 1 )
	variable V_Qe=ScaleToIndex(M_dest, V_eExtRatio, 1 )
	ExtractPartialMatrix(M_dest, "M_dest_Ext", V_Ps, V_Pe, V_Qs, V_Qe, 0, 0, 0, 0)
	wave M_dest_Ext
	variable V_dimsizeP=dimsize(M_dest_Ext, 0)
	variable V_dimsizeQ=dimsize(M_dest_Ext, 1)
	redimension /N=(V_dimsizeP*V_dimsizeQ) M_dest_Ext
	wavestats  /Q M_dest_Ext
	//M_AveImage=M_AveImage[p][q]/M_AveImage[p][q]
	//imagestats /Q/G={ScaleToIndex(M_dest, V_sPolDir, 0 ) ,ScaleToIndex(M_dest, V_ePolDir, 0 ), ScaleToIndex(M_dest, V_sExtRatio, 1 ) ,ScaleToIndex(M_dest, V_eExtRatio, 1 ) } M_AveImage
	//V_fillingrate=V_avg/V_npnts
	//killwaves M_StdvImage//M_AveImage
	//killwaves M_dest_Ext, M_dest
	return (V_npnts-V_numNaNs)/V_npnts
end

function FillingRate2(L_waves, V_sPolDir, V_ePolDir, V_ExtRatioBase, V_sExtRatio, V_eExtRatio)
	string L_waves//"PMC_test_300Hz_LC;PMC_test_200Hz_LC;PMC_test_100Hz_LC;PMC_test_1000Hz_LC;PMC_test_10000Hz_LC"
	variable V_sPolDir, V_ePolDir, V_ExtRatioBase, V_sExtRatio, V_eExtRatio
	variable V_n=itemsinlist(L_waves)
	variable i=0
	//print i, StringFromList(i, L_waves)
	wave M_aplane=$StringFromList(i, L_waves)
	duplicate /O M_aplane, M_dest
	Redimension/N=(-1,-1) M_dest
	M_dest=M_aplane[p][q][0]
	for(i=1;i<V_n;I+=1)
		//print i, StringFromList(i, L_waves)
		//imagetransform /O/P=(i-1) insertZplane M_dest
		//InsertPoints /M=2 dimsize(M_dest, 2), 1, M_dest
		wave M_aplane=$StringFromList(i, L_waves)
		M_dest=0/(NumType(M_aplane[p][q][r])*NumType(M_dest[p][q][r])==0)+1
		//M_dest[][]=M_aplane[p][q][0]
	endfor
	variable V_Ps=ScaleToIndex(M_dest, V_sPolDir, 0 )
	variable V_Pe=ScaleToIndex(M_dest, V_ePolDir, 0 )
	print log(V_sExtRatio)/log(V_ExtRatioBase), log(V_eExtRatio)/log(V_ExtRatioBase)
	variable V_Qs=ScaleToIndex(M_dest, log(V_sExtRatio)/log(V_ExtRatioBase), 1 )
	variable V_Qe=ScaleToIndex(M_dest, log(V_eExtRatio)/log(V_ExtRatioBase), 1 )
	ExtractPartialMatrix(M_dest, "M_dest_Ext", V_Ps, V_Pe, V_Qs, V_Qe, 0, 0, 0, 0)
	wave M_dest_Ext
	variable V_dimsizeP=dimsize(M_dest_Ext, 0)
	variable V_dimsizeQ=dimsize(M_dest_Ext, 1)
	redimension /N=(V_dimsizeP*V_dimsizeQ) M_dest_Ext
	wavestats  /Q M_dest_Ext
	//M_AveImage=M_AveImage[p][q]/M_AveImage[p][q]
	//imagestats /Q/G={ScaleToIndex(M_dest, V_sPolDir, 0 ) ,ScaleToIndex(M_dest, V_ePolDir, 0 ), ScaleToIndex(M_dest, V_sExtRatio, 1 ) ,ScaleToIndex(M_dest, V_eExtRatio, 1 ) } M_AveImage
	//V_fillingrate=V_avg/V_npnts
	//killwaves M_StdvImage//M_AveImage
	//killwaves M_dest_Ext, M_dest
	return (V_npnts-V_numNaNs)/V_npnts
end

function /wave GenMergedData(L_waves, S_MNdest, V_sPolDir, V_ePolDir, V_sExtRatio, V_eExtRatio)
	string L_waves, S_MNdest//"PMC_test_300Hz_LC;PMC_test_200Hz_LC;PMC_test_100Hz_LC;PMC_test_1000Hz_LC;PMC_test_10000Hz_LC"
	variable V_sPolDir, V_ePolDir, V_sExtRatio, V_eExtRatio
	variable V_nWaves=itemsinlist(L_waves)
	variable i=0
	print i, StringFromList(i, L_waves)
	wave M_aplane=$StringFromList(i, L_waves)
	duplicate /O M_aplane, $S_MNdest
	wave M_dest=$S_MNdest
	Redimension/N=(-1,-1, V_nWaves, Dimsize(M_aplane, 2)) M_dest
	M_dest[][][i][]=M_aplane[p][q][s]
	for(i=1;i<V_nWaves;I+=1)
		print i, StringFromList(i, L_waves)
		//imagetransform /O/P=(i-1) insertZplane M_dest
		wave M_aplane=$StringFromList(i, L_waves)
		M_dest[][][i][]=M_aplane[p][q][s]
	endfor
	return M_dest
end

function GenDrivingDataSet(M_Dataset, W_Freq, S_MN_dest, F_Param)
	wave M_Dataset,W_Freq
	string S_MN_dest
	variable F_Param
	imagetransform /CHIX=(F_Param) getChunk M_Dataset
	wave M_Chunk
	copyscales M_Dataset, M_Chunk
	duplicate /O M_Chunk, $S_MN_dest
	wave M_DrvData=$S_MN_dest
	Redimension/N=(-1,-1, 6) M_DrvData
	M_DrvData[][][3]=extractBeamValue(M_Chunk, p, q, 1)
	M_DrvData[][][0,1]=M_Dataset[p][q][M_DrvData[p][q][3]][r]
	M_DrvData[][][2]=W_Freq(M_DrvData[p][q][3])*(1+0/(2-NumType(M_DrvData[p][q][3]))/2)
	M_DrvData[][][4,5]=M_Dataset[p][q][M_DrvData[p][q][3]][r-2]
end

function autoCompensation(S_WNbase, V_vStart, V_vStop, V_sFrq, V_eFrq, V_ExtRatioBase, V_nExtRatio,V_baseline)
	string S_WNbase
	variable V_vStart, V_vStop, V_sFrq, V_eFrq
	variable V_ExtRatioBase, V_nExtRatio, V_baseline
	variable V_sExtRatio=1
	variable V_eExtRatio=V_ExtRatioBase
	variable V_sPolDir =0
	variable V_ePolDir=179
	variable V_dPolDir=1
	variable V_dFrq=100
	S_WNbase+="_"+num2str(V_vStart)+"_"+num2str(V_vStop)+"V_"
	string S_WNorg
	variable V_Frq, i=0
	make/Free /n=5000 W_Frq=nan
	make /O/n=((V_eFrq-V_sFrq)/V_dFrq+1) W_fillingrate=nan
	string L_Mlist=""
	//variable V_fillRate
	//newmovie /F=25 as S_WNbase
	for(V_Frq=V_sFrq; V_Frq<=V_eFrq||W_fillingrate[i]>=1; V_Frq+=V_dFrq,L_Mlist+=";",i+=1)
		W_Frq[i]=V_Frq
		S_WNorg=S_WNbase+num2str(V_frq)+"Hz"
	//	print i, V_Frq, S_WNorg
		Getpolarization_V(S_WNorg, V_vStart, V_vStop, V_vStart, V_vStop, V_frq)
		wave M_original=$S_WNorg
		M_original-=V_baseline
		PMC_Compensation(M_original)
		wave M_PolDir=$S_WNorg+"_PolDir"
		wave M_ExtRatio=$S_WNorg+"_ExtRatio"
		createDrivingMatrixLog3(M_PolDir, M_ExtRatio, S_WNorg+"_Dataset", V_sPolDir, V_ePolDir, V_dPolDir, V_ExtRatioBase, V_nExtRatio)
		wave M_Dataset=$S_WNorg+"_Dataset"
		print "Dataset: ", S_WNorg+"_Dataset"
		L_Mlist+=nameofwave(M_Dataset)
		print "DatasetList", L_Mlist
	//	L_Mlist+=S_WNorg;print L_Mlist
		GenMergedData(L_Mlist, S_WNbase+"MergedData", 0, 179, V_sExtRatio, V_eExtRatio)
		W_fillingrate[i]=FillingRate2(L_Mlist, 0, 179, V_ExtRatioBase, V_sExtRatio, V_eExtRatio)
	//	print L_Mlist ,0, 179, V_ExtRatioBase, V_sExtRatio, V_eExtRatio
	
	print S_WNbase+"MergedData"
	//	print W_fillingrate[i]	
	//AddMovieFrame	
	endfor
	wave M_MergedData=$S_WNbase+"MergedData"
	L_Mlist= RemoveEnding(L_Mlist , ";")
	wavetransform zapNaNs W_Frq
	GenDrivingDataSet(M_MergedData, W_Frq, S_WNbase+"DriveData", 5)
	CloseMovie
	return 0
end

function autoCompensation2(S_WNbase, V_vStart, V_vStop, V_sFrq, V_eFrq, V_ExtRatioBase, V_nExtRatio,V_baseline)
	string S_WNbase
	variable V_vStart, V_vStop, V_sFrq, V_eFrq
	variable V_ExtRatioBase, V_nExtRatio, V_baseline
	variable V_sExtRatio=1
	variable V_eExtRatio=V_ExtRatioBase
	variable V_sPolDir =0
	variable V_ePolDir=179
	variable V_dPolDir=1
	variable V_dFrq=100
	S_WNbase+="_"+num2str(V_vStart)+"_"+num2str(V_vStop)+"V_"
	string S_WNorg
	variable V_Frq, i=0
	make/Free /n=5000 W_Frq=nan
	make /O/n=((V_eFrq-V_sFrq)/V_dFrq+1) W_fillingrate=nan
	string L_Mlist=""
	//variable V_fillRate
	newmovie /F=25 as S_WNbase
	for(V_Frq=V_sFrq; V_Frq<=V_eFrq||W_fillingrate[i]>=1; V_Frq+=V_dFrq,L_Mlist+=";",i+=1)
		W_Frq[i]=V_Frq
		S_WNorg=S_WNbase+num2str(V_frq)+"Hz"
	//	print i, V_Frq, S_WNorg
//		Getpolarization_V(S_WNorg, V_vStart, V_vStop, V_vStart, V_vStop, V_frq)
		wave M_original=$S_WNorg
//		M_original-=V_baseline
//		PMC_Compensation(M_original)
		wave M_PolDir=$S_WNorg+"_PolDir"
		wave M_ExtRatio=$S_WNorg+"_ExtRatio"
		createDrivingMatrixLog3(M_PolDir, M_ExtRatio, S_WNorg+"_Dataset", V_sPolDir, V_ePolDir, V_dPolDir, V_ExtRatioBase, V_nExtRatio)
		wave M_Dataset=$S_WNorg+"_Dataset"
		print "Dataset: ", S_WNorg+"_Dataset"
		L_Mlist+=nameofwave(M_Dataset)
		print "DatasetList", L_Mlist
	//	L_Mlist+=S_WNorg;print L_Mlist
		GenMergedData(L_Mlist, S_WNbase+"MergedData", 0, 179, V_sExtRatio, V_eExtRatio)
		W_fillingrate[i]=FillingRate2(L_Mlist, 0, 179, V_ExtRatioBase, V_sExtRatio, V_eExtRatio)
	//	print L_Mlist ,0, 179, V_ExtRatioBase, V_sExtRatio, V_eExtRatio
	
	//print S_WNbase+"MergedData"
	//	print W_fillingrate[i]	
		
	//endfor
		
		//wave M_MergedData=$S_WNbase+"MergedData"
		GenDrivingDataSet($S_WNbase+"MergedData", W_Frq, S_WNbase+"DriveData", 5)
		duplicate /O $S_WNbase+"DriveData", $S_WNbase+"DriveData"+num2str(V_frq)+"Hz"
		TextBox/C/N=text0 num2str(i)
		AddMovieFrame
	endfor
	L_Mlist= RemoveEnding(L_Mlist , ";")
	wavetransform zapNaNs W_Frq
	CloseMovie
	return 0
end

//
//autoCompensation("PMC_1064nm", 2, 10, 100, 2000, 50, 50, 0.13734)
//autoCompensation2("PMC_520nm", 4, 10, 100, 2000, 50, 50, 0)

function autoCompensation_PostProcess(S_WNbase, V_vStart, V_vStop, V_sFrq, V_eFrq, V_ExtRatioBase, V_nExtRatio,V_baseline)
	string S_WNbase
	variable V_vStart, V_vStop, V_sFrq, V_eFrq
	variable V_ExtRatioBase, V_nExtRatio, V_baseline
	variable V_sExtRatio=1
	variable V_eExtRatio=V_ExtRatioBase
	variable V_sPolDir =0
	variable V_ePolDir=179
	variable V_dPolDir=1
	variable V_dFrq=100
	S_WNbase+="_"+num2str(V_vStart)+"_"+num2str(V_vStop)+"V_"
	string S_WNorg
	variable V_Frq, i=0
	make/Free /n=5000 W_Frq=nan
	make /O/n=((V_eFrq-V_sFrq)/V_dFrq+1) W_fillingrate=nan
	string L_Mlist=""
	//variable V_fillRate
	for(V_Frq=V_sFrq; V_Frq<=V_eFrq||W_fillingrate[i]>=1; V_Frq+=V_dFrq,L_Mlist+=";",i+=1)
		W_Frq[i]=V_Frq
		S_WNorg=S_WNbase+num2str(V_frq)+"Hz"
	//	print i, V_Frq, S_WNorg
//		Getpolarization_V(S_WNorg, V_vStart, V_vStop, V_vStart, V_vStop, V_frq)
		wave M_original=$S_WNorg
//		M_original-=V_baseline
//		PMC_Compensation(M_original)
		wave M_PolDir=$S_WNorg+"_PolDir"
		wave M_ExtRatio=$S_WNorg+"_ExtRatio"
		createDrivingMatrixLog3(M_PolDir, M_ExtRatio, S_WNorg+"_Dataset", V_sPolDir, V_ePolDir, V_dPolDir, V_ExtRatioBase, V_nExtRatio)
		wave M_Dataset=$S_WNorg+"_Dataset"
		print "Dataset: ", S_WNorg+"_Dataset"
		L_Mlist+=nameofwave(M_Dataset)
		print "DatasetList", L_Mlist
	//	L_Mlist+=S_WNorg;print L_Mlist
		GenMergedData(L_Mlist, S_WNbase+"MergedData", 0, 179, V_sExtRatio, V_eExtRatio)
		W_fillingrate[i]=FillingRate2(L_Mlist, 0, 179, V_ExtRatioBase, V_sExtRatio, V_eExtRatio)
	//	print L_Mlist ,0, 179, V_ExtRatioBase, V_sExtRatio, V_eExtRatio
	
	//print S_WNbase+"MergedData"
	//	print W_fillingrate[i]	
		
	//endfor
		
		//wave M_MergedData=$S_WNbase+"MergedData"
		GenDrivingDataSet($S_WNbase+"MergedData", W_Frq, S_WNbase+"DriveData", 5)
		duplicate /O $S_WNbase+"DriveData", $S_WNbase+"DriveData"+num2str(V_frq)+"Hz"
		TextBox/C/N=text0 num2str(i)
	endfor
	L_Mlist= RemoveEnding(L_Mlist , ";")
	wavetransform zapNaNs W_Frq
	return 0
end

function getavgs(V_times)
	variable V_times
	variable i
	make /free /n=(V_times) W_tmp
	for(i=0;i<V_times;i+=1)
	print i
		PolarizationMeasurement3("test1")
		wavestats /Q test1
		W_tmp[i]=V_avg
	endfor
	wavestats W_tmp
	return V_avg
end

autoCompensation("PMC_520nm", 4, 10, 100, 300, 50, 50)