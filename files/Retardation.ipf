#pragma rtGlobals=1		// Use modern global access method.


Function GetRetardation(wname, F_LC)
	String wname
	variable F_LC//0,1,2
	variable i
	Variable ch, Err
	Variable V_Start=100
	Variable V_Stop=10000
	Variable V_Step=100
	variable N_StepDeg=3601
	variable N_StepVol=(V_Stop-V_Start)/V_Step+1
	string S_Pwave="W_prof_GetRetardation"
	make /O $S_Pwave
	wave W_Profile=$S_Pwave
	string S_Pwave_SS="W_prof_GetRetardation_SS"
	
	variable I_DrvFreq, V_Frq
	variable V_time=DateTime
	wave W_config=$"Cfg_PMC"
	variable I_config_ON=4//LCD_ON
	Svar S_ListCell2Ch
	//Nvar V_LCD_WDuty, V_LCD_WFreq
	//V_LCD_WDuty=50
	//V_LCD_WFreq=1000
	wave Cfg_Cell2Ch=$"Cfg_Cell2Ch"
//	LCD_Control_pol("Initialize",1,"Radial") 

//--	NIDAQ_USB6211_Init()
//	SV_LCDFreqCTRL("GetRetardation", 1000, "1.00k Hz",  "V_LCD_WFreq")
//	PM_LCDWaveform("GetRetardation",2,"Square")
//SV_LCDDutyCTRL("GetRetardation",50,"50 %","V_LCD_WDuty")
//--	BC_Mark202_Init("GetRetardation")
	make /O /D /n=(N_StepDeg, N_StepVol) $wname=nan
	wave M_profiles=$wname
	SetScale/I x 0,360,"deg", M_profiles
	SetScale/I y V_Start,V_Stop,"Hz", M_profiles
	wave Cfg_PMC_Frq=$"Cfg_PMC_Frq"
	//j=V_Start
	//do
	variable V_default_Hz=1000//default frequency
	for(V_Frq=V_Start; V_Frq<=V_Stop; V_Frq+=V_Step)
		I_DrvFreq=round((V_Frq-V_Start)/V_Step)
		print I_DrvFreq, ": ", V_Frq,"Hz"

		i=0
		do
			Cfg_PMC_Frq[Cfg_Cell2Ch[i]]=(F_LC!=0)*V_Frq+(F_LC==0)*V_default_Hz
			//genStrPMC_sglCH("GetRetardation", Cfg_Cell2Ch[i], (F_LC==0)*j)
			i +=1
		While( i <8)
	
		do
			Cfg_PMC_Frq[Cfg_Cell2Ch[i]]=(F_LC!=1)*V_Frq+(F_LC==1)*V_default_Hz
			//genStrPMC_sglCH("GetRetardation", Cfg_Cell2Ch[i], (F_LC==1)*j)
			i +=1
		While( i <16)
		do
			Cfg_PMC_Frq[Cfg_Cell2Ch[i]]=(F_LC!=2)*V_Frq+(F_LC==2)*V_default_Hz
			//genStrPMC_sglCH("GetRetardation", Cfg_Cell2Ch[i], (F_LC==2)*j)
			i +=1
		While( i <24)
		genStrPMC_sglCHs("GetRetardation")//applying change
		sleep /S 2//Waiting for LCD stabilized

		PolarizationMeasurement1(S_Pwave)
		//for(i=1; i<dimsize(W_Profile, 0); i+=1)
		//	// if the fluctuation is too large, repeat PolarizationMeasurement2
		//	if(abs(W_Profile[i-1]-M_profiles[i])>0.005)
		//		PolarizationMeasurement2(S_Pwave, 10, 0)
		//		break
		//	endif
		//endfor
		
		interpolate2/T=3/N=(N_StepDeg) /F=0 /Y=$S_Pwave_SS W_Profile
		wave W_Profile_SS=$S_Pwave_SS
		SetScale/I x 0,360,"deg", W_Profile, W_Profile_SS
		M_profiles[][I_DrvFreq]=W_Profile_SS[p]
		//M_profiles[][I_DrvVolt]=cos(2*x/180*pi+tan(I_DrvVolt/100))//dummy data
		doupdate
	endfor
	//	j+=V_Step
	//While(j<=V_Stop+V_Step)
	//print "GetParam("+wname+", "+num2str(V_Start)+", "+num2str(V_Stop)+", "+num2str(V_Step)+",0)"
	GetParam(wname, V_Start, V_Stop, V_Step,0)       //by ashida 20080606
	//Display/k=1 $wname+"PolDir"
	//AppendToGraph/R $wname+"chisq"
	//ModifyGraph log(right)=1
	V_time=DateTime-V_time
	print V_time/60, "min"
	Print "end"
end



Function GetParam(S_BaseWN, V_StartVolt, V_EndVolt, V_DetVol, F_display)
	string S_BaseWN
	variable V_StartVolt, V_EndVolt, V_DetVol, F_display
	variable i, j
	wave M_profiles=$S_BaseWN
	variable N_x=dimsize(M_profiles, 0), N_y=dimsize(M_profiles, 1)
	string S_curProfName="W_profile"
	//print	(V_EndVolt-V_StartVolt)/V_DetVol+1
	make /O /N=((V_EndVolt-V_StartVolt)/V_DetVol+1) $S_BaseWN+"PolDir", $S_BaseWN+"ExtRatio", $S_BaseWN+"Intensity", $S_BaseWN+"PIntensity", $S_BaseWN+"chisq", $S_BaseWN+"max", $S_BaseWN+"min"
	SetScale/I x V_StartVolt,V_EndVolt,"V", $S_BaseWN+"PolDir", $S_BaseWN+"ExtRatio", $S_BaseWN+"Intensity", $S_BaseWN+"PIntensity", $S_BaseWN+"chisq", $S_BaseWN+"max", $S_BaseWN+"min"
	wave W_ExtRatio=$S_BaseWN+"ExtRatio"
	wave W_PolDir=$S_BaseWN+"PolDir"
 	wave W_Intensity=$S_BaseWN+"Intensity"
 	wave W_PIntensity=$S_BaseWN+"PIntensity"
 	wave W_chisq=$S_BaseWN+"chisq"
 	wave W_max=$S_BaseWN+"max"
 	wave W_min=$S_BaseWN+"min"
	W_ExtRatio=0
	//wave wv=$S_BaseWN+num2str((V_StartVolt+V_DetVol*i)*10)
	make /O /n=(dimsize(M_profiles, 0)) W_profile 
	wave W_curProf=$S_curProfName
	wave W_ResSinFit

	for(j=0; j<(V_EndVolt-V_StartVolt)/V_DetVol+1; j+=1)
	//	print i
		W_curProf[]=M_profiles[p][j]
		WaveStats /Q /Z W_curProf
		W_ResSinFit[0]=0
		if(Sinfitting(S_curProfName, V_avg, V_avg,  2*pi/180, -W_ResSinFit[0]+pi/2, 2)>0.1)
			Sinfitting(S_curProfName, V_avg, V_avg,  pi/180, 0, 5)
		endif
				//0: Polarization direction, 1: Extinction ratio, 2: Chi SQR, 3: Total Intensity, 4: Intensity at polarizationdirection
			//W_PolDir[j]=nan
			//W_chisq[j]=nan
			//W_Intensity[j]=nan
			//W_PIntensity[j]=nan
			//W_max[j]=nan
			//W_min[j]=nan
			//W_ExtRatio[j]=nan
			//print S_BaseWN+num2str((V_StartVolt+V_DetVol*j)*10)
		//else
			W_ExtRatio[j]=1/W_ResSinFit[1]//Extinction ratio by sin fitting
			W_PolDir[j]=W_ResSinFit[0]
//			if(j<1)
//					W_PolDir[j]-=round(W_PolDir[j]/pi)*pi
//			else
//					W_PolDir[j]-=round((W_PolDir[j]-W_PolDir[j-1])/pi*2)*pi/2
//			endif
		
			W_chisq[j]=W_ResSinFit[2]
			W_Intensity[j]=W_ResSinFit[3]
			W_PIntensity[j]=W_ResSinFit[4]//+W_ResSinFit[3]
	//		print j, W_PIntensity[j], W_ResSinFit[4]
			wavestats /Q W_curProf//W_current
			//W_PolDir[j]=V_minloc*pi/180
			//if(j<1)
			//		W_PolDir[j]-=round(W_PolDir[j]/pi)*pi
			//else
			//		W_PolDir[j]-=round((W_PolDir[j]-W_PolDir[j-1])/pi*2)*pi/2
			//endif
			W_max[j]=V_max
			W_min[j]=V_min
			W_ExtRatio[j]=V_max/V_min
		//endif
	endfor
	
//	Save/T/M="\r\n" original,fit_original,D061008_800nm_0,D061008_800nm_1,D061008_800nm_2,D061008_800nm_3,D061008_800nm_4,D061008_800nm_5,D061008_800nm_6,D061008_800nm_7,D061008_800nm_8,D061008_800nm_9,D061008_800nm_10,D061008_800nm_11,D061008_800nm_12,D061008_800nm_13,D061008_800nm_14,D061008_800nm_15 as "original++.itx"
//	Save/T/M="\r\n"/A D061008_800nm_16,D061008_800nm_17,D061008_800nm_18,D061008_800nm_19,D061008_800nm_20,D061008_800nm_21,D061008_800nm_22,D061008_800nm_23,D061008_800nm_24,D061008_800nm_25,D061008_800nm_26,D061008_800nm_27,D061008_800nm_28,D061008_800nm_29,D061008_800nm_30,D061008_800nm_31 as "original++.itx"
	

		SetScale/I x V_StartVolt,V_EndVolt,"V", W_PolDir, W_ExtRatio, W_Intensity, W_Intensity, W_PIntensity, W_chisq
		SetScale d 0,0,"rad", W_PolDir
		Interpolate2/T=3/N=(100*(V_EndVolt-V_StartVolt)/V_DetVol+1)/F=0 /Y=$S_BaseWN+"PolDir_SS" W_PolDir

//↓C1用
//	for(j=0; j<N_y; j+=1)
//		for(i=1; i<N_x; i+=1)
//			if(abs(M_profiles[i-1][j]-M_profiles[i][j])>0.005)
// 			W_ExtRatio[j]=nan
//	 			W_PolDir[j]=nan
//				W_chisq[j]=nan
//				W_Intensity[j]=nan
//				W_PIntensity[j]=nan
//				W_max[j]=nan
//				W_min[j]=nan
//				break
//			endif
//		endfor
//	endfor
	
	
	
	
	if(F_display)
		appendtograph  $S_BaseWN+"PolDir"
		appendtograph /R $S_BaseWN+"ExtRatio"
		//ShowTrc(S_BaseWN, S_BaseWN+"PolDir_ExtR", 0, 0, 1)//Display PolDir
		//ShowTrc(S_BaseWN, S_BaseWN+"PolDir_ExtR", 1, 1, 0)//AppendExtRatio
//		SetAxis right 0,0.03
		//Legend
		//TextBox/C/N=$S_BaseWN+"_PS" /F=0/A=MC/B=1 "["+S_BaseWN+"]"
		//AppendText "\\s("+S_BaseWN+"PolDir) Phase shift"
		//AppendText "\\s("+S_BaseWN+"ExtRatio) Extinction ratio"
//		SetAxis right 0,0.1 
//		ShowTrc(S_BaseWN, S_BaseWN+"Intensities", 2, 0, 1)
//		ShowTrc(S_BaseWN, S_BaseWN+"PIntensities", 3, 0, 1)
//		ShowTrc(S_BaseWN, S_BaseWN+"PIntensities", 4, 1, 0)
	endif
	
end

Function GetParam2(S_BaseWN, V_StartVolt, V_EndVolt, V_DetVol, F_display)
	string S_BaseWN
	variable V_StartVolt, V_EndVolt, V_DetVol, F_display
	variable i, j
	wave M_profiles=$S_BaseWN
	variable N_x=dimsize(M_profiles, 0), N_y=dimsize(M_profiles, 1)

	wave W_PolDir=$S_BaseWN+"PolDir"
	Interpolate2/T=3/N=(100*(V_EndVolt-V_StartVolt)/V_DetVol+1)/F=0 /Y=$S_BaseWN+"PolDir_SS" W_PolDir
end

Function GetRetardation_old(wname)        
	String wname
	variable i, j
	Variable ch, Err
	Variable V_Start=0
	Variable V_Stop=7.1
	Variable V_Step=0.1
	variable V_time=DateTime
	wave W_config=$"Cfg_PMC"
	variable I_config_ON=4//LCD_ON
	Svar S_ListCell2Ch
	Nvar V_LCD_WDuty, V_LCD_WFreq
	V_LCD_WDuty=50
	V_LCD_WFreq=1000
	wave Cfg_LCD_amp_ch
	LCD_Control_pol("Initialize",1,"Radial")     
//--	BP_Mark202_DefaultCFG("GetRetardation")
//--	NIDAQ_USB6211_Init()
	
	SV_LCDFreqCTRL("GetRetardation", 1000, "1.00k Hz",  "V_LCD_WFreq")
	PM_LCDWaveform("GetRetardation",2,"Square")
	SV_LCDDutyCTRL("GetRetardation",50,"50 %","V_LCD_WDuty")
//--	BC_Mark202_Init("GetRetardation")
	
	j=V_Start
	do
//		waiting(50000, 2000000)
		//make/O/N=(200)  wave2
		//SetScale/P x 0,5e-6,"s" wave2
		//wave2= j*sin(2*Pi*x*Freq)

		if(W_config[I_config_ON])//Trun LCD off if it driving
//--			LCD_Ctrl_ButtonProc("GetRetardation")
		endif
		i=0
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=0
			i +=1
		While( i <8)
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <16)
		LCDwaveformGenerator("LCD_Control_pol")
//--		LCD_Ctrl_ButtonProc("GetRetardation")//Trun LCD ON
		//ch=8
		//do
		//	fDAQmx_WriteChan("Dev4", ch, 0, -10, 10)
		//	ch +=1
		//While( ch <24)

		//DAQmx_WaveformGen/DEV="Dev4" "wave2,8;wave2,9;wave2,10;wave2,11;wave2,12;wave2,13;wave2,14;wave2,15;"
		
		sleep /S 2
		//Sigma_RStage_Init_Button("")

		PolarizationMeasurement2(wname+num2str(j*10), 10, 1)
//		Display/k=1 $wname+num2str(j*10)
		//fDAQmx_WaveformStop("Dev4")
//		ch=8
//		do
//			fDAQmx_WriteChan("USB6211_1", ch, 0, -10, 10)
//			ch +=1
//		While( ch <24)
		
		do
			wavestats /Q /M=1 $wname+num2str(j*10)
			print V_npnts
			if(V_npnts<180)
				PolarizationMeasurement2(wname+num2str(j*10), 10, 1)
			else
				break
			endif
		while(1)
		
		//print j
		
		//add 20070608
		//wavestats/q $wname+num2str(j*10)
		//Err=Sinfitting(wname+num2str(j*10), V_avg, V_avg,  2*pi/180, pi/2, 2)
		//if(Err>1)
		//	j-=V_Step
		//endif
		j+=V_Step
	While(j<V_Stop)
	//print "GetParam("+wname+", "+num2str(V_Start)+", "+num2str(V_Stop)+", "+num2str(V_Step)+",0)"
	GetParam(wname, V_Start, V_Stop, V_Step,0)
	Display/k=1 $wname+"PolDir"
	AppendToGraph/R $wname+"chisq"
	ModifyGraph log(right)=1
	V_time=DateTime-V_time
	print V_time/60, "min"
	Print "end"
	
end








Function GetRetardation_old2(wname)          //20151118釘宮使用
	String wname
	//string W_prof_
	//wave kx01
	
	//wave  W_prof_0=$"W_prof_0"
	
	variable i, j
	variable k=1
	Variable ch, Err
	Variable V_Start=0
	Variable V_Stop=10
	Variable V_Step=0.01//0.1
	variable V_time=DateTime
	wave W_config=$"Cfg_PMC"
	variable I_config_ON=4 //LCD_ON
	Svar S_ListCell2Ch
	

	variable I_DrvVolt
	variable N_StepDeg=360
	variable N_StepVol=(V_Stop-V_Start)/V_Step+1
	string S_Pwave="W_prof_GetRetardation"
	
	//wave W_prof_GetRetardation=$"W_prof_GetRetardation"
	make /O $S_Pwave
	wave W_Profile=$S_Pwave
	string S_Pwave_SS="W_prof_GetRetardation_SS"
	make /O /D /n=(N_StepDeg, N_StepVol) $wname//=nan
	wave M_profiles=$wname
	SetScale/I x 0,360,"deg", M_profiles
	SetScale/I y V_Start,V_Stop-0.1,"V", M_profiles

	
	//wave W_config=$"Cfg_PMC"
	//variable I_config_Freq=5//DrivingFrequency

	//variable I_config_DNo=6//DevNoもともと6
	//Svar L_LCDWavelist
	
	//Nvar V_LCD_WDuty, V_LCD_WFreq
	//V_LCD_WDuty=50
	//V_LCD_WFreq=1000
	wave  Cfg_LCD_amp_ch=$"Cfg_LCD_amp_ch"//wave Cfg_LCD_amp_ch
	//LCD_Control_pol("Initialize",1,"Radial")                 //とりあえず消してみた
//--	BP_Mark202_DefaultCFG("GetRetardation")
//--	NIDAQ_USB6211_Init()
	
	//SV_LCDFreqCTRL("GetRetardation", 1000, "1.00k Hz",  "V_LCD_WFreq")
	//PM_LCDWaveform("GetRetardation",2,"Square")
	//SV_LCDDutyCTRL("GetRetardation",50,"50 %","V_LCD_WDuty")
//--	BC_Mark202_Init("GetRetardation")
	
	j=V_Start
	do
	

//		waiting(50000, 2000000)
		//make/O/N=(200)  wave2
		//SetScale/P x 0,5e-6,"s" wave2
		//wave2= j*sin(2*Pi*x*Freq)
		
		I_DrvVolt=round((j-V_Start)/V_Step)
		print I_DrvVolt

		if(W_config[I_config_ON])//Trun LCD off if it driving
			LCD_Ctrl_ButtonProc("GetRetardation")
		endif
		
		i=0
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <8)
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <16)
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <24)
		doupdate
		//LCDwaveformGenerator3("LCD_Control_pol")
		LCD_Ctrl_ButtonProc("GetRetardation")//Trun LCD ON
		//ch=8
		//do
		//	fDAQmx_WriteChan("Dev4", ch, 0, -10, 10)
		//	ch +=1
		//While( ch <24)

		//DAQmx_WaveformGen/DEV="Dev4" "wave2,8;wave2,9;wave2,10;wave2,11;wave2,12;wave2,13;wave2,14;wave2,15;"
		
		//DAQmx_WaveformGen/DEV="Dev3" L_LCDWavelist
		
		sleep /S 3
		//Sigma_RStage_Init_Button("")
		
		PolarizationMeasurement3(S_Pwave);DoUpdate
		//DoUpdate //[ /E=e  /W=targWin  /SPIN=ticks ]
		//wavestats /Q /M=1 S_Pwave
		
		
//		Display/k=1 $wname+num2str(j*10)
		//fDAQmx_WaveformStop("Dev4")
//		ch=8
//		do
//			fDAQmx_WriteChan("USB6211_1", ch, 0, -10, 10)
//			ch +=1
//		While( ch <24)
		
		//do
			//wavestats /Q /M=1 $wname+num2str(j*10)
			//print V_npnts
			//if(V_npnts<180)
				//PolarizationMeasurement1(wname)
			//else
				//break
			//endif
		//while(1)
		
		//print j
		
		//add 20070608
		//wavestats/q $wname+num2str(j*10)
		//Err=Sinfitting(wname+num2str(j*10), V_avg, V_avg,  2*pi/180, pi/2, 2)
		//if(Err>1)
		//	j-=V_Step
		//endif
		
		//if(j>=0.1)
				interpolate2/T=3/N=(N_StepDeg) /F=0 /Y=$S_Pwave_SS W_Profile
				wave W_Profile_SS=$S_Pwave_SS
				SetScale/I x 0,360,"deg", W_Profile, W_Profile_SS
			//wave W_prof_GetRetardation=$"W_prof_GetRetardation"
				M_profiles[][I_DrvVolt]=W_Profile_SS[p]
//				M_profiles[][I_DrvVolt]=W_Profile[p]
			//M_profiles[][I_DrvVolt]=W_profile[p]
			//M_profiles[][I_DrvVolt]=cos(2*x/180*pi+tan(I_DrvVolt/100))//dummy data
			doupdate
		//endif
		
		
		
		j+=V_Step
	While(j<V_Stop)
	//print "GetParam("+wname+", "+num2str(V_Start)+", "+num2str(V_Stop)+", "+num2str(V_Step)+",0)"
	

	GetParam(wname, V_Start, V_Stop, V_Step,0)
	Display/k=1 $wname+"PolDir";print wname+"PolDir and "+wname+"chisq are displayed"
	AppendToGraph/R $wname+"chisq"
	ModifyGraph log(right)=1
	V_time=DateTime-V_time
	print V_time/60, "min"
	Print "end"
	
end


Function GetRetardation_old3(wname)          //20180118_3枚がさね用
	String wname
	//string W_prof_
	//wave kx01
	
	//wave  W_prof_0=$"W_prof_0"
	
	variable i, j
	variable k=1
	Variable ch, Err
	Variable V_Start=0
	Variable V_Stop=10.1
	Variable V_Step=0.01//0.1
	variable V_time=DateTime
	wave W_config=$"Cfg_PMC"
	variable I_config_ON=4//LCD_ON
	Svar S_ListCell2Ch
	
	
	variable I_DrvVolt
	variable N_StepDeg=360
	variable N_StepVol=(V_Stop-V_Start)/V_Step+1
	string S_Pwave="W_prof_GetRetardation"
	
	//wave W_prof_GetRetardation=$"W_prof_GetRetardation"
	make /O $S_Pwave
	wave W_Profile=$S_Pwave
	string S_Pwave_SS="W_prof_GetRetardation_SS"
	make /O /D /n=(N_StepDeg, N_StepVol) $wname//=nan
	wave M_profiles=$wname
	SetScale/I x 0,360,"deg", M_profiles
	SetScale/I y V_Start,V_Stop-0.1,"V", M_profiles

	
	//wave W_config=$"Cfg_PMC"
	//variable I_config_Freq=5//DrivingFrequency

	//variable I_config_DNo=6//DevNoもともと6
	//Svar L_LCDWavelist
	
	//Nvar V_LCD_WDuty, V_LCD_WFreq
	//V_LCD_WDuty=50
	//V_LCD_WFreq=1000
	wave  Cfg_LCD_amp_ch=$"Cfg_LCD_amp_ch"//wave Cfg_LCD_amp_ch
	//LCD_Control_pol("Initialize",1,"Radial")                 //とりあえず消してみた
//--	BP_Mark202_DefaultCFG("GetRetardation")
//--	NIDAQ_USB6211_Init()
	
	//SV_LCDFreqCTRL("GetRetardation", 1000, "1.00k Hz",  "V_LCD_WFreq")
	//PM_LCDWaveform("GetRetardation",2,"Square")
	//SV_LCDDutyCTRL("GetRetardation",50,"50 %","V_LCD_WDuty")
//--	BC_Mark202_Init("GetRetardation")
	
	j=V_Start
	do
	

//		waiting(50000, 2000000)
		//make/O/N=(200)  wave2
		//SetScale/P x 0,5e-6,"s" wave2
		//wave2= j*sin(2*Pi*x*Freq)
		
		I_DrvVolt=round((j-V_Start)/V_Step)
		print I_DrvVolt

		if(W_config[I_config_ON])//Trun LCD off if it driving
			LCD_Ctrl_ButtonProc("GetRetardation")
		endif
		
		//LC1
		Cfg_LCD_amp_ch[13]=0
		Cfg_LCD_amp_ch[14]=0
		Cfg_LCD_amp_ch[16]=0
		Cfg_LCD_amp_ch[17]=0
		Cfg_LCD_amp_ch[19]=0
		Cfg_LCD_amp_ch[20]=0
		Cfg_LCD_amp_ch[22]=0
		Cfg_LCD_amp_ch[23]=0
		
		//LC2
		Cfg_LCD_amp_ch[1]=j
		Cfg_LCD_amp_ch[2]=j
		Cfg_LCD_amp_ch[4]=j
		Cfg_LCD_amp_ch[5]=j
		Cfg_LCD_amp_ch[7]=j
		Cfg_LCD_amp_ch[8]=j
		Cfg_LCD_amp_ch[10]=j
		Cfg_LCD_amp_ch[11]=j
		//LC3
		Cfg_LCD_amp_ch[0]=1.3
		Cfg_LCD_amp_ch[3]=1.3
		Cfg_LCD_amp_ch[6]=1.3
		Cfg_LCD_amp_ch[9]=1.3
		Cfg_LCD_amp_ch[12]=1.3
		Cfg_LCD_amp_ch[15]=1.3
		Cfg_LCD_amp_ch[18]=1.3
		Cfg_LCD_amp_ch[21]=1.3






		doupdate
		//LCDwaveformGenerator3("LCD_Control_pol")
		LCD_Ctrl_ButtonProc("GetRetardation")//Trun LCD ON
		//ch=8
		//do
		//	fDAQmx_WriteChan("Dev4", ch, 0, -10, 10)
		//	ch +=1
		//While( ch <24)

		//DAQmx_WaveformGen/DEV="Dev4" "wave2,8;wave2,9;wave2,10;wave2,11;wave2,12;wave2,13;wave2,14;wave2,15;"
		
		//DAQmx_WaveformGen/DEV="Dev3" L_LCDWavelist
		
		sleep /S 2
		//Sigma_RStage_Init_Button("")
		
		PolarizationMeasurement1(S_Pwave);DoUpdate
		//DoUpdate //[ /E=e  /W=targWin  /SPIN=ticks ]
		//wavestats /Q /M=1 S_Pwave
		
		
//		Display/k=1 $wname+num2str(j*10)
		//fDAQmx_WaveformStop("Dev4")
//		ch=8
//		do
//			fDAQmx_WriteChan("USB6211_1", ch, 0, -10, 10)
//			ch +=1
//		While( ch <24)
		
		//do
			//wavestats /Q /M=1 $wname+num2str(j*10)
			//print V_npnts
			//if(V_npnts<180)
				//PolarizationMeasurement1(wname)
			//else
				//break
			//endif
		//while(1)
		
		//print j
		
		//add 20070608
		//wavestats/q $wname+num2str(j*10)
		//Err=Sinfitting(wname+num2str(j*10), V_avg, V_avg,  2*pi/180, pi/2, 2)
		//if(Err>1)
		//	j-=V_Step
		//endif
		
		//if(j>=0.1)
				interpolate2/T=3/N=(N_StepDeg) /F=0 /Y=$S_Pwave_SS W_Profile
				wave W_Profile_SS=$S_Pwave_SS
				SetScale/I x 0,360,"deg", W_Profile, W_Profile_SS
			//wave W_prof_GetRetardation=$"W_prof_GetRetardation"
				M_profiles[][I_DrvVolt]=W_Profile_SS[p]
//				M_profiles[][I_DrvVolt]=W_Profile[p]
			//M_profiles[][I_DrvVolt]=W_profile[p]
			//M_profiles[][I_DrvVolt]=cos(2*x/180*pi+tan(I_DrvVolt/100))//dummy data
			doupdate
		//endif
		
		
		
		j+=V_Step
	While(j<V_Stop)
	//print "GetParam("+wname+", "+num2str(V_Start)+", "+num2str(V_Stop)+", "+num2str(V_Step)+",0)"
	GetParam(wname, V_Start, V_Stop, V_Step,0)
	Display/k=1 $wname+"PolDir"
	AppendToGraph/R $wname+"chisq"
	ModifyGraph log(right)=1
	V_time=DateTime-V_time
	print V_time/60, "min"
	Print "end"
	
end

Function GetRetardation_fv(wname)          //2019
	String wname
	//string W_prof_
	//wave kx01
	
	//wave  W_prof_0=$"W_prof_0"
	
	Variable ch, Err

	Variable V_rStart=0
	Variable V_rStop=360
	Variable V_rStep=1
	
	Variable V_vStart=0
	Variable V_vStop=10
	Variable V_vStep=0.05
	
	//MLC2177
	//Variable V_fStart=100
	//Variable V_fStop=2000//10000
	//Variable V_fStep=50//200

	//MLC2132
	Variable V_fStart=100
	Variable V_fStop= 30000
	Variable V_fStep=100
	
	
	variable V_time=DateTime
	wave W_config=$"Cfg_PMC"
	variable I_config_ON=4 //LCD_ON
	variable V_USB_ComNo=W_config[9]
	//Svar S_ListCell2Ch
	wave Cfg_PMC_amp, Cfg_PMC_frq

	variable I_DrvVolt
	variable N_StepsDeg=(V_rStop-V_rStart)/V_rStep+1
	variable N_StepsVol=(V_vStop-V_vStart)/V_vStep+1
	variable N_StepsFrq=(V_fStop-V_fStart)/V_fStep+1
//	variable N_Steps=(V_vStop-V_vStart)/V_vStep+1
	print wname, "=(",N_StepsDeg, N_StepsVol, N_StepsFrq, ")"
	string S_Pwave="W_prof_GetRetardation"
	make /O/n=(N_StepsDeg+1) $S_Pwave
	wave W_Profile=$S_Pwave
	string S_Pwave_SS="W_prof_GetRetardation_SS"
	make /O /D /n=(N_StepsDeg, N_StepsVol, N_StepsFrq) $wname//=nan
	wave M_profiles=$wname; M_profiles=nan
	SetScale/P x V_rStart,V_rStep,"deg", M_profiles, W_Profile
	SetScale/P y V_vStart,V_vStep,"V", M_profiles
	SetScale/P z V_fStart,V_fStep,"Hz", M_profiles

//	variable I_config_Freq=5//DrivingFrequency

	//variable I_config_DNo=6//DevNoもともと6
	//Svar L_LCDWavelist
	
	//Nvar V_LCD_WDuty, V_LCD_WFreq
	//V_LCD_WDuty=50
	//V_LCD_WFreq=1000
	wave  Cfg_LCD_amp_ch=$"Cfg_LCD_amp_ch"//wave Cfg_LCD_amp_ch
	//LCD_Control_pol("Initialize",1,"Radial")                 //とりあえず消してみた
//--	BP_Mark202_DefaultCFG("GetRetardation")
//--	NIDAQ_USB6211_Init()
	
	//SV_LCDFreqCTRL("GetRetardation", 1000, "1.00k Hz",  "V_LCD_WFreq")
	//PM_LCDWaveform("GetRetardation",2,"Square")
	//SV_LCDDutyCTRL("GetRetardation",50,"50 %","V_LCD_WDuty")
//--	BC_Mark202_Init("GetRetardation")
	VDTOperationsPort2 $"COM"+num2str(V_USB_ComNo)
	if(W_config[I_config_ON]==0)//Trun LCD ON if it's not driving
		BP_LCD_Stat_Stop("GetRetardation_fv")
	endif
	variable V_v, V_f, I_v, I_f

	for(V_f=V_fStart;V_f<=V_fStop;V_f+=V_fStep)

		for(V_v=V_vStart;V_v<=V_vStop;V_v+=V_vStep)
			Cfg_PMC_amp=V_v
			Cfg_PMC_frq=V_f
			BP_PMC_refresh_2ch("GetRetardation_fv")
			VDTOperationsPort2 $"COM1"
			PolarizationMeasurement3(S_Pwave)
			VDTOperationsPort2 $"COM"+num2str(V_USB_ComNo)
			I_v=round((V_v-V_vStart)/V_vStep)
			I_f=round((V_f-V_fStart)/V_fStep)
			multithread M_profiles[][I_v][I_f]=W_Profile[p]
			print I_v,I_f,V_v,V_f,"<",V_fStop
			doupdate
		endfor
	endfor
	
	if(W_config[I_config_ON])//Trun LCD OFF if it's driving
		BP_LCD_Stat_Stop("GetRetardation_fv")
	endif
	
	
	V_time=DateTime-V_time
	print V_time/60, "min"
	end
	
	
//		waiting(50000, 2000000)
		//make/O/N=(200)  wave2
		//SetScale/P x 0,5e-6,"s" wave2
		//wave2= j*sin(2*Pi*x*Freq)
		
		I_DrvVolt=round((j-V_Start)/V_Step)
		print I_DrvVolt

		if(W_config[I_config_ON])//Trun LCD ON if it's not driving
			LCD_Ctrl_ButtonProc("GetRetardation")
		endif
		
		i=0
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <8)
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <16)
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <24)
		doupdate
		//LCDwaveformGenerator3("LCD_Control_pol")
		LCD_Ctrl_ButtonProc("GetRetardation")//Trun LCD ON
		//ch=8
		//do
		//	fDAQmx_WriteChan("Dev4", ch, 0, -10, 10)
		//	ch +=1
		//While( ch <24)

		//DAQmx_WaveformGen/DEV="Dev4" "wave2,8;wave2,9;wave2,10;wave2,11;wave2,12;wave2,13;wave2,14;wave2,15;"
		
		//DAQmx_WaveformGen/DEV="Dev3" L_LCDWavelist
		
		sleep /S 3
		//Sigma_RStage_Init_Button("")
		
		PolarizationMeasurement3(S_Pwave);DoUpdate
		//DoUpdate //[ /E=e  /W=targWin  /SPIN=ticks ]
		//wavestats /Q /M=1 S_Pwave
		
		
//		Display/k=1 $wname+num2str(j*10)
		//fDAQmx_WaveformStop("Dev4")
//		ch=8
//		do
//			fDAQmx_WriteChan("USB6211_1", ch, 0, -10, 10)
//			ch +=1
//		While( ch <24)
		
		//do
			//wavestats /Q /M=1 $wname+num2str(j*10)
			//print V_npnts
			//if(V_npnts<180)
				//PolarizationMeasurement1(wname)
			//else
				//break
			//endif
		//while(1)
		
		//print j
		
		//add 20070608
		//wavestats/q $wname+num2str(j*10)
		//Err=Sinfitting(wname+num2str(j*10), V_avg, V_avg,  2*pi/180, pi/2, 2)
		//if(Err>1)
		//	j-=V_Step
		//endif
		
		//if(j>=0.1)
				interpolate2/T=3/N=(N_StepDeg) /F=0 /Y=$S_Pwave_SS W_Profile
				wave W_Profile_SS=$S_Pwave_SS
				SetScale/I x 0,360,"deg", W_Profile, W_Profile_SS
			//wave W_prof_GetRetardation=$"W_prof_GetRetardation"
				M_profiles[][I_DrvVolt]=W_Profile_SS[p]
//				M_profiles[][I_DrvVolt]=W_Profile[p]
			//M_profiles[][I_DrvVolt]=W_profile[p]
			//M_profiles[][I_DrvVolt]=cos(2*x/180*pi+tan(I_DrvVolt/100))//dummy data
			doupdate
		//endif
		
		
		
//	endfor
	//print "GetParam("+wname+", "+num2str(V_Start)+", "+num2str(V_Stop)+", "+num2str(V_Step)+",0)"
	

	GetParam(wname, V_Start, V_Stop, V_Step,0)
	Display/k=1 $wname+"PolDir";print wname+"PolDir and "+wname+"chisq are displayed"
	AppendToGraph/R $wname+"chisq"
	ModifyGraph log(right)=1
	V_time=DateTime-V_time
	print V_time/60, "min"
	Print "end"
	
end

function sweep_ch00()
	wave Cfg_PMC_amp
	variable i=8
	do
		do
			Cfg_PMC_amp=i
			BP_PMC_refresh_2ch("GetRetardation_fv")
			i+=0.2
		while(i<9.9)
		do
			Cfg_PMC_amp=i
			BP_PMC_refresh_2ch("GetRetardation_fv")
			i-=0.2
		while(i>7)
	while(1)
end

Function Getpolarization_V(wname, V_vStart2, V_vStop2, V_vStart3, V_vStop3, V_frq)          //2020
	String wname
	variable V_vStart2, V_vStop2, V_vStart3, V_vStop3, V_frq
	//string W_prof_
	//wave kx01
	
	//wave  W_prof_0=$"W_prof_0"
	
	Variable ch, Err

	Variable V_rStart=0
	Variable V_rStop=360
	Variable V_rStep=1
	
	//Variable V_vStart=0
	//Variable V_vStop=10
	Variable V_vStep=0.05
	
	
	//MLC2177
	//Variable V_fStart=100
	//Variable V_fStop=2000//10000
	//Variable V_fStep=50//200

	//MLC2132
	//Variable V_fStart=100
	//Variable V_fStop= 30000
	//Variable V_fStep=100
	
	
	variable V_time=DateTime
	wave W_config=$"Cfg_PMC"
	variable I_config_ON=4 //LCD_ON
	variable V_USB_ComNo=W_config[9]
	//Svar S_ListCell2Ch
	wave Cfg_PMC_amp, Cfg_PMC_frq

	variable I_DrvVolt
	variable N_StepsDeg=(V_rStop-V_rStart)/V_rStep+1
	variable N_StepsVol2=(V_vStop2-V_vStart2)/V_vStep+1
	variable N_StepsVol3=(V_vStop3-V_vStart3)/V_vStep+1
//	variable N_Steps=(V_vStop-V_vStart)/V_vStep+1
	print wname, "=(",N_StepsDeg, N_StepsVol2, N_StepsVol3,")@", V_frq, "Hz"
	string S_Pwave="W_prof_GetRetardation"
	make /O/n=(N_StepsDeg+1) $S_Pwave
	wave W_Profile=$S_Pwave
	string S_Pwave_SS="W_prof_GetRetardation_SS"
	make /O /D /n=(N_StepsDeg, N_StepsVol2, N_StepsVol3) $wname//=nan
	wave M_profiles=$wname; M_profiles=nan
	SetScale/P x V_rStart,V_rStep,"deg", M_profiles, W_Profile
	SetScale/P y V_vStart2,V_vStep,"V", M_profiles
	SetScale/P z V_vStart3,V_vStep,"V", M_profiles


//	variable I_config_Freq=5//DrivingFrequency

	//variable I_config_DNo=6//DevNoもともと6
	//Svar L_LCDWavelist
	
	//Nvar V_LCD_WDuty, V_LCD_WFreq
	//V_LCD_WDuty=50
	//V_LCD_WFreq=1000
	wave  Cfg_LCD_amp_ch=$"Cfg_LCD_amp_ch"//wave Cfg_LCD_amp_ch
	//LCD_Control_pol("Initialize",1,"Radial")                 //とりあえず消してみた
//--	BP_Mark202_DefaultCFG("GetRetardation")
//--	NIDAQ_USB6211_Init()
	
	//SV_LCDFreqCTRL("GetRetardation", 1000, "1.00k Hz",  "V_LCD_WFreq")
	//PM_LCDWaveform("GetRetardation",2,"Square")
	//SV_LCDDutyCTRL("GetRetardation",50,"50 %","V_LCD_WDuty")
//--	BC_Mark202_Init("GetRetardation")
	VDTOperationsPort2 $"COM"+num2str(V_USB_ComNo)
	if(W_config[I_config_ON]==0)//Trun LCD ON if it's not driving
		BP_LCD_Stat_Stop("GetRetardation_fv")
	endif
	variable V_v2, V_v3, I_v2, I_v3
	for(V_v3=V_vStart3;V_v3<=V_vStop3;V_v3+=V_vStep)
		for(V_v2=V_vStart2;V_v2<=V_vStop2;V_v2+=V_vStep)
			Cfg_PMC_amp[0]=V_v2
			Cfg_PMC_amp[4]=V_v3
			Cfg_PMC_frq=V_frq
			BP_PMC_refresh_2ch("GetRetardation_fv")
			VDTOperationsPort2 $"COM1"
			PolarizationMeasurement3(S_Pwave)
			VDTOperationsPort2 $"COM"+num2str(V_USB_ComNo)
			I_v2=round((V_v2-V_vStart2)/V_vStep)
			I_v3=round((V_v3-V_vStart3)/V_vStep)
			multithread M_profiles[][I_v2][I_v3]=W_Profile[p]
			print I_v2,V_v3
			doupdate
		endfor
	endfor	
	if(W_config[I_config_ON])//Trun LCD OFF if it's driving
		BP_LCD_Stat_Stop("GetRetardation_fv")
	endif
	
	
	V_time=DateTime-V_time
	print V_time/60, "min"
	end
	
	
//		waiting(50000, 2000000)
		//make/O/N=(200)  wave2
		//SetScale/P x 0,5e-6,"s" wave2
		//wave2= j*sin(2*Pi*x*Freq)
		
		I_DrvVolt=round((j-V_Start)/V_Step)
		print I_DrvVolt

		if(W_config[I_config_ON])//Trun LCD ON if it's not driving
			LCD_Ctrl_ButtonProc("GetRetardation")
		endif
		
		i=0
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <8)
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <16)
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <24)
		doupdate
		//LCDwaveformGenerator3("LCD_Control_pol")
		LCD_Ctrl_ButtonProc("GetRetardation")//Trun LCD ON
		//ch=8
		//do
		//	fDAQmx_WriteChan("Dev4", ch, 0, -10, 10)
		//	ch +=1
		//While( ch <24)

		//DAQmx_WaveformGen/DEV="Dev4" "wave2,8;wave2,9;wave2,10;wave2,11;wave2,12;wave2,13;wave2,14;wave2,15;"
		
		//DAQmx_WaveformGen/DEV="Dev3" L_LCDWavelist
		
		sleep /S 3
		//Sigma_RStage_Init_Button("")
		
		PolarizationMeasurement3(S_Pwave);DoUpdate
		//DoUpdate //[ /E=e  /W=targWin  /SPIN=ticks ]
		//wavestats /Q /M=1 S_Pwave
		
		
//		Display/k=1 $wname+num2str(j*10)
		//fDAQmx_WaveformStop("Dev4")
//		ch=8
//		do
//			fDAQmx_WriteChan("USB6211_1", ch, 0, -10, 10)
//			ch +=1
//		While( ch <24)
		
		//do
			//wavestats /Q /M=1 $wname+num2str(j*10)
			//print V_npnts
			//if(V_npnts<180)
				//PolarizationMeasurement1(wname)
			//else
				//break
			//endif
		//while(1)
		
		//print j
		
		//add 20070608
		//wavestats/q $wname+num2str(j*10)
		//Err=Sinfitting(wname+num2str(j*10), V_avg, V_avg,  2*pi/180, pi/2, 2)
		//if(Err>1)
		//	j-=V_Step
		//endif
		
		//if(j>=0.1)
				interpolate2/T=3/N=(N_StepDeg) /F=0 /Y=$S_Pwave_SS W_Profile
				wave W_Profile_SS=$S_Pwave_SS
				SetScale/I x 0,360,"deg", W_Profile, W_Profile_SS
			//wave W_prof_GetRetardation=$"W_prof_GetRetardation"
				M_profiles[][I_DrvVolt]=W_Profile_SS[p]
//				M_profiles[][I_DrvVolt]=W_Profile[p]
			//M_profiles[][I_DrvVolt]=W_profile[p]
			//M_profiles[][I_DrvVolt]=cos(2*x/180*pi+tan(I_DrvVolt/100))//dummy data
			doupdate
		//endif
		
		
		
//	endfor
	//print "GetParam("+wname+", "+num2str(V_Start)+", "+num2str(V_Stop)+", "+num2str(V_Step)+",0)"
	

	GetParam(wname, V_Start, V_Stop, V_Step,0)
	Display/k=1 $wname+"PolDir";print wname+"PolDir and "+wname+"chisq are displayed"
	AppendToGraph/R $wname+"chisq"
	ModifyGraph log(right)=1
	V_time=DateTime-V_time
	print V_time/60, "min"
	Print "end"
	
end

Function /wave GetIntensity_V(wname, V_vStart2, V_vStop2, V_vStart3, V_vStop3, V_frq)          //2020
	String wname
	variable V_vStart2, V_vStop2, V_vStart3, V_vStop3, V_frq
	//string W_prof_
	//wave kx01
	
	//wave  W_prof_0=$"W_prof_0"
	
	Variable ch, Err

	
	//Variable V_vStart=0
	//Variable V_vStop=10
	Variable V_vStep=0.1//0.05
	
	//MLC2177
	//Variable V_fStart=100
	//Variable V_fStop=2000//10000
	//Variable V_fStep=50//200

	//MLC2132
	//Variable V_fStart=100
	//Variable V_fStop= 30000
	//Variable V_fStep=100
	
	
	variable V_time=DateTime
	wave W_config=$"Cfg_PMC"
	variable I_config_ON=4 //LCD_ON
	variable V_USB_ComNo=W_config[9]
	//Svar S_ListCell2Ch
	wave Cfg_PMC_amp, Cfg_PMC_frq

	variable I_DrvVolt
	variable N_StepsVol2=(V_vStop2-V_vStart2)/V_vStep+1
	variable N_StepsVol3=(V_vStop3-V_vStart3)/V_vStep+1
//	variable N_Steps=(V_vStop-V_vStart)/V_vStep+1
	print wname, "=(", N_StepsVol2, N_StepsVol3,")@", V_frq, "Hz"
	make /O /D /n=(N_StepsVol2, N_StepsVol3) $wname//=nan
	wave M_profiles=$wname; M_profiles=nan
	SetScale/P x V_vStart2,V_vStep,"V", M_profiles
	SetScale/P y V_vStart3,V_vStep,"V", M_profiles


//	variable I_config_Freq=5//DrivingFrequency

	//variable I_config_DNo=6//DevNoもともと6
	//Svar L_LCDWavelist
	
	//Nvar V_LCD_WDuty, V_LCD_WFreq
	//V_LCD_WDuty=50
	//V_LCD_WFreq=1000
	wave  Cfg_LCD_amp_ch=$"Cfg_LCD_amp_ch"//wave Cfg_LCD_amp_ch
	//LCD_Control_pol("Initialize",1,"Radial")                 //とりあえず消してみた
//--	BP_Mark202_DefaultCFG("GetRetardation")
//--	NIDAQ_USB6211_Init()
	
	//SV_LCDFreqCTRL("GetRetardation", 1000, "1.00k Hz",  "V_LCD_WFreq")
	//PM_LCDWaveform("GetRetardation",2,"Square")
	//SV_LCDDutyCTRL("GetRetardation",50,"50 %","V_LCD_WDuty")
//--	BC_Mark202_Init("GetRetardation")
	VDTOperationsPort2 $"COM"+num2str(V_USB_ComNo)
	if(W_config[I_config_ON]==0)//Trun LCD ON if it's not driving
		BP_LCD_Stat_Stop("GetRetardation_fv")
	endif
	make /O/D /n=1 W_testInt
	SetScale/I x 0,0.5,"", W_testInt
	variable V_v2, V_v3, I_v2, I_v3
	for(V_v3=V_vStart3;V_v3<=V_vStop3;V_v3+=V_vStep)
		for(V_v2=V_vStart2;V_v2<=V_vStop2;V_v2+=V_vStep)
			Cfg_PMC_amp[0]=V_v2
			Cfg_PMC_amp[4]=V_v3
			Cfg_PMC_frq=V_frq
			BP_PMC_refresh_2ch("GetRetardation_fv")
			I_v2=round((V_v2-V_vStart2)/V_vStep)
			I_v3=round((V_v3-V_vStart3)/V_vStep)
			DAQmx_Scan /DEV="USB6259_1" /STRT=0 /BKG=0 /AVE=500000  waves="W_testInt, 0/RSE"
			if(V_v2==V_vStart2)
				sleep /S 2
			endif
			fDAQmx_ScanStart("USB6259_1", 2)
			M_profiles[I_v2][I_v3]=W_testInt[0]//NIDAQ_USB6259_Obs(100, 0, 10, 0)
			
			//doupdate
		endfor
		print V_v3
	endfor	
	if(W_config[I_config_ON])//Trun LCD OFF if it's driving
		BP_LCD_Stat_Stop("GetRetardation_fv")
	endif
	
	
	V_time=DateTime-V_time
	print V_time/60, "min"
	end
	
	
//		waiting(50000, 2000000)
		//make/O/N=(200)  wave2
		//SetScale/P x 0,5e-6,"s" wave2
		//wave2= j*sin(2*Pi*x*Freq)
		
		I_DrvVolt=round((j-V_Start)/V_Step)
		print I_DrvVolt

		if(W_config[I_config_ON])//Trun LCD ON if it's not driving
			LCD_Ctrl_ButtonProc("GetRetardation")
		endif
		
		i=0
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <8)
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <16)
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <24)
		doupdate
		//LCDwaveformGenerator3("LCD_Control_pol")
		LCD_Ctrl_ButtonProc("GetRetardation")//Trun LCD ON
		//ch=8
		//do
		//	fDAQmx_WriteChan("Dev4", ch, 0, -10, 10)
		//	ch +=1
		//While( ch <24)

		//DAQmx_WaveformGen/DEV="Dev4" "wave2,8;wave2,9;wave2,10;wave2,11;wave2,12;wave2,13;wave2,14;wave2,15;"
		
		//DAQmx_WaveformGen/DEV="Dev3" L_LCDWavelist
		
		sleep /S 3
		//Sigma_RStage_Init_Button("")
		
		PolarizationMeasurement3(S_Pwave);DoUpdate
		//DoUpdate //[ /E=e  /W=targWin  /SPIN=ticks ]
		//wavestats /Q /M=1 S_Pwave
		
		
//		Display/k=1 $wname+num2str(j*10)
		//fDAQmx_WaveformStop("Dev4")
//		ch=8
//		do
//			fDAQmx_WriteChan("USB6211_1", ch, 0, -10, 10)
//			ch +=1
//		While( ch <24)
		
		//do
			//wavestats /Q /M=1 $wname+num2str(j*10)
			//print V_npnts
			//if(V_npnts<180)
				//PolarizationMeasurement1(wname)
			//else
				//break
			//endif
		//while(1)
		
		//print j
		
		//add 20070608
		//wavestats/q $wname+num2str(j*10)
		//Err=Sinfitting(wname+num2str(j*10), V_avg, V_avg,  2*pi/180, pi/2, 2)
		//if(Err>1)
		//	j-=V_Step
		//endif
		
		//if(j>=0.1)
				interpolate2/T=3/N=(N_StepDeg) /F=0 /Y=$S_Pwave_SS W_Profile
				wave W_Profile_SS=$S_Pwave_SS
				SetScale/I x 0,360,"deg", W_Profile, W_Profile_SS
			//wave W_prof_GetRetardation=$"W_prof_GetRetardation"
				M_profiles[][I_DrvVolt]=W_Profile_SS[p]
//				M_profiles[][I_DrvVolt]=W_Profile[p]
			//M_profiles[][I_DrvVolt]=W_profile[p]
			//M_profiles[][I_DrvVolt]=cos(2*x/180*pi+tan(I_DrvVolt/100))//dummy data
			doupdate
		//endif
		
		
		
//	endfor
	//print "GetParam("+wname+", "+num2str(V_Start)+", "+num2str(V_Stop)+", "+num2str(V_Step)+",0)"
	

	GetParam(wname, V_Start, V_Stop, V_Step,0)
	Display/k=1 $wname+"PolDir";print wname+"PolDir and "+wname+"chisq are displayed"
	AppendToGraph/R $wname+"chisq"
	ModifyGraph log(right)=1
	V_time=DateTime-V_time
	print V_time/60, "min"
	Print "end"
	
end




function GetIntensity_Vf(wname, V_vStart2, V_vStop2, V_vStart3, V_vStop3, V_fStart, V_fStop)
	String wname
	variable V_vStart2, V_vStop2, V_vStart3, V_vStop3, V_fStart, V_fStop
	Variable V_vStep=0.05
	Variable V_fStep=100
	variable N_StepsVol2=(V_vStop2-V_vStart2)/V_vStep+1
	variable N_StepsVol3=(V_vStop3-V_vStart3)/V_vStep+1
	variable N_Stepsf=(V_fStop-V_fStart)/V_fStep+1
	make /O /D /n=(N_StepsVol2, N_StepsVol3, N_Stepsf) $wname
	wave M_profiles=$wname;
	M_profiles=nan
	SetScale/P y V_vStart2,V_vStep,"V", M_profiles
	SetScale/P z V_vStart3,V_vStep,"V", M_profiles
	SetScale/P x V_fStart,V_fStep,"Hz", M_profiles
	variable V_time=DateTime
	variable V_f
	for(V_f=V_fStart;V_f<=V_fStop;V_f+=100)
		M_profiles[][][ScaleToIndex(M_profiles, V_f, 2 )]=GetIntensity_V(wname+"tmp", V_vStart2, V_vStop2, V_vStart3, V_vStop3, V_f) [p][q]
	endfor
	V_time=DateTime-V_time
	print V_time/60, "min"
end 



//Function GetPol_2LC_fv(wname, V_vStart2, V_vStop2, V_vStep2, V_fStart2, V_fStop2, V_fStep2, V_vStart3, V_vStop3, V_vStep3, V_fStart3, V_fStop3, V_fStep3)  
	String wname
	variable V_vStart2, V_vStop2, V_vStep2, V_fStart2, V_fStop2, V_fStep2, V_vStart3, V_vStop3, V_vStep3, V_fStart3, V_fStop3, V_fStep3
	//string W_prof_
	//wave kx01
	
	//wave  W_prof_0=$"W_prof_0"
	
	Variable ch, Err

	Variable V_rStart=0
	Variable V_rStop=360
	Variable V_rStep=1
	
//	Variable V_vStart=0
//	Variable V_vStop=10
//	Variable V_vStep=0.05
	
	//MLC2177
	//Variable V_fStart=100
	//Variable V_fStop=2000//10000
	//Variable V_fStep=50//200

	//MLC2132
//	Variable V_fStart=100
//	Variable V_fStop= 30000
//	Variable V_fStep=100
	
	
	variable V_time=DateTime
	wave W_config=$"Cfg_PMC"
	variable I_config_ON=4 //LCD_ON
	variable V_USB_ComNo=W_config[9]
	//Svar S_ListCell2Ch
	wave Cfg_PMC_amp, Cfg_PMC_frq

	variable I_DrvVolt
	variable N_StepsDeg=(V_rStop-V_rStart)/V_rStep+1
	variable N_StepsVol2=(V_vStop2-V_vStart2)/V_vStep2+1
	variable N_StepsFrq2=(V_fStop2-V_fStart2)/V_fStep2+1
	variable N_StepsVol3=(V_vStop3-V_vStart3)/V_vStep3+1
	variable N_StepsFrq3=(V_fStop3-V_fStart3)/V_fStep3+1
//	variable N_Steps=(V_vStop-V_vStart)/V_vStep+1
	print wname, "=(",N_StepsDeg, N_StepsVol2, N_StepsFrq2, ")"
	print wname, "=(",N_StepsDeg, N_StepsVol3, N_StepsFrq3, ")"
	string S_Pwave="W_prof_GetRetardation"
	make /O/n=(N_StepsDeg+1) $S_Pwave
	wave W_Profile=$S_Pwave
	string S_Pwave_SS="W_prof_GetRetardation_SS"
	make /O /D /n=(N_StepsDeg, N_StepsVol, N_StepsFrq) $wname//=nan
	wave M_profiles=$wname; M_profiles=nan
	SetScale/P x V_rStart,V_rStep,"deg", M_profiles, W_Profile
	SetScale/P y V_vStart,V_vStep,"V", M_profiles
	SetScale/P z V_fStart,V_fStep,"Hz", M_profiles

//	variable I_config_Freq=5//DrivingFrequency

	//variable I_config_DNo=6//DevNoもともと6
	//Svar L_LCDWavelist
	
	//Nvar V_LCD_WDuty, V_LCD_WFreq
	//V_LCD_WDuty=50
	//V_LCD_WFreq=1000
	wave  Cfg_LCD_amp_ch=$"Cfg_LCD_amp_ch"//wave Cfg_LCD_amp_ch
	//LCD_Control_pol("Initialize",1,"Radial")                 //とりあえず消してみた
//--	BP_Mark202_DefaultCFG("GetRetardation")
//--	NIDAQ_USB6211_Init()
	
	//SV_LCDFreqCTRL("GetRetardation", 1000, "1.00k Hz",  "V_LCD_WFreq")
	//PM_LCDWaveform("GetRetardation",2,"Square")
	//SV_LCDDutyCTRL("GetRetardation",50,"50 %","V_LCD_WDuty")
//--	BC_Mark202_Init("GetRetardation")
	VDTOperationsPort2 $"COM"+num2str(V_USB_ComNo)
	if(W_config[I_config_ON]==0)//Trun LCD ON if it's not driving
		BP_LCD_Stat_Stop("GetRetardation_fv")
	endif
	variable V_v, V_f, I_v, I_f

	for(V_f=V_fStart;V_f<=V_fStop;V_f+=V_fStep)

		for(V_v=V_vStart;V_v<=V_vStop;V_v+=V_vStep)
			Cfg_PMC_amp=V_v
			Cfg_PMC_frq=V_f
			BP_PMC_refresh("GetRetardation_fv")
			VDTOperationsPort2 $"COM1"
			PolarizationMeasurement3(S_Pwave)
			VDTOperationsPort2 $"COM"+num2str(V_USB_ComNo)
			I_v=round((V_v-V_vStart)/V_vStep)
			I_f=round((V_f-V_fStart)/V_fStep)
			multithread M_profiles[][I_v][I_f]=W_Profile[p]
			print I_v,I_f,V_v,V_f,"<",V_fStop
			doupdate
		endfor
	endfor
	
	if(W_config[I_config_ON])//Trun LCD OFF if it's driving
		BP_LCD_Stat_Stop("GetRetardation_fv")
	endif
	
	
	V_time=DateTime-V_time
	print V_time/60, "min"
	end
	
	
//		waiting(50000, 2000000)
		//make/O/N=(200)  wave2
		//SetScale/P x 0,5e-6,"s" wave2
		//wave2= j*sin(2*Pi*x*Freq)
		
		I_DrvVolt=round((j-V_Start)/V_Step)
		print I_DrvVolt

		if(W_config[I_config_ON])//Trun LCD ON if it's not driving
			LCD_Ctrl_ButtonProc("GetRetardation")
		endif
		
		i=0
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <8)
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <16)
		do
			Cfg_LCD_amp_ch[str2num(StringFromList(i, S_ListCell2Ch))-8]=j
			i +=1
		While( i <24)
		doupdate
		//LCDwaveformGenerator3("LCD_Control_pol")
		LCD_Ctrl_ButtonProc("GetRetardation")//Trun LCD ON
		//ch=8
		//do
		//	fDAQmx_WriteChan("Dev4", ch, 0, -10, 10)
		//	ch +=1
		//While( ch <24)

		//DAQmx_WaveformGen/DEV="Dev4" "wave2,8;wave2,9;wave2,10;wave2,11;wave2,12;wave2,13;wave2,14;wave2,15;"
		
		//DAQmx_WaveformGen/DEV="Dev3" L_LCDWavelist
		
		sleep /S 3
		//Sigma_RStage_Init_Button("")
		
		PolarizationMeasurement3(S_Pwave);DoUpdate
		//DoUpdate //[ /E=e  /W=targWin  /SPIN=ticks ]
		//wavestats /Q /M=1 S_Pwave
		
		
//		Display/k=1 $wname+num2str(j*10)
		//fDAQmx_WaveformStop("Dev4")
//		ch=8
//		do
//			fDAQmx_WriteChan("USB6211_1", ch, 0, -10, 10)
//			ch +=1
//		While( ch <24)
		
		//do
			//wavestats /Q /M=1 $wname+num2str(j*10)
			//print V_npnts
			//if(V_npnts<180)
				//PolarizationMeasurement1(wname)
			//else
				//break
			//endif
		//while(1)
		
		//print j
		
		//add 20070608
		//wavestats/q $wname+num2str(j*10)
		//Err=Sinfitting(wname+num2str(j*10), V_avg, V_avg,  2*pi/180, pi/2, 2)
		//if(Err>1)
		//	j-=V_Step
		//endif
		
		//if(j>=0.1)
				interpolate2/T=3/N=(N_StepDeg) /F=0 /Y=$S_Pwave_SS W_Profile
				wave W_Profile_SS=$S_Pwave_SS
				SetScale/I x 0,360,"deg", W_Profile, W_Profile_SS
			//wave W_prof_GetRetardation=$"W_prof_GetRetardation"
				M_profiles[][I_DrvVolt]=W_Profile_SS[p]
//				M_profiles[][I_DrvVolt]=W_Profile[p]
			//M_profiles[][I_DrvVolt]=W_profile[p]
			//M_profiles[][I_DrvVolt]=cos(2*x/180*pi+tan(I_DrvVolt/100))//dummy data
			doupdate
		//endif
		
		
		
//	endfor
	//print "GetParam("+wname+", "+num2str(V_Start)+", "+num2str(V_Stop)+", "+num2str(V_Step)+",0)"
	

	GetParam(wname, V_Start, V_Stop, V_Step,0)
	Display/k=1 $wname+"PolDir";print wname+"PolDir and "+wname+"chisq are displayed"
	AppendToGraph/R $wname+"chisq"
	ModifyGraph log(right)=1
	V_time=DateTime-V_time
	print V_time/60, "min"
	Print "end"
	
end





//	20070608 Kanamaru
Function GetPol(wname,Vol)
	String	wname
	Variable	Vol
	Variable	Freq=1000
	Variable	ch, k
	Variable	V_Start=0
	Variable	V_Stop=7.1
	Variable	V_Step=0.1
	variable	V_time
	LCD_Control_pol("Initialize",1,"Radial") 
//--	BP_Mark202_DefaultCFG("GetRetardation")
//--	NIDAQ_USB6211_Init()
	fDAQmx_WaveformStop("Dev4")

	make/O/N=(200)  wave2
	SetScale/P x 0,5e-6,"s" wave2
	wave2= Vol*sin(2*Pi*x*Freq)

	ch=8
	do
		fDAQmx_WriteChan("Dev4", ch, 0, -10, 10)
		ch +=1
	While( ch <24)

	DAQmx_WaveformGen/DEV="Dev4" "wave2,8;wave2,9;wave2,10;wave2,11;wave2,12;wave2,13;wave2,14;wave2,15;"
	sleep /S 4
//--	BC_Mark202_Init("")
	PolarizationMeasurement2(wname+num2str(Vol*10), 10, 1)
	fDAQmx_WaveformStop("Dev4")

	Display/k=1 $wname+num2str(Vol*10)
end



Function GetParam_old(S_BaseWN, V_StartVolt, V_EndVolt, V_DetVol, F_display)
	string S_BaseWN
	variable V_StartVolt, V_EndVolt, V_DetVol, F_display
	variable i, j
	print	(V_EndVolt-V_StartVolt)/V_DetVol+1
	make /O /N=((V_EndVolt-V_StartVolt)/V_DetVol+1) $S_BaseWN+"PolDir", $S_BaseWN+"ExtRatio", $S_BaseWN+"Intensity", $S_BaseWN+"PIntensity", $S_BaseWN+"chisq", $S_BaseWN+"max", $S_BaseWN+"min"
	SetScale/I x V_StartVolt,V_EndVolt,"V", $S_BaseWN+"PolDir", $S_BaseWN+"ExtRatio", $S_BaseWN+"Intensity", $S_BaseWN+"PIntensity", $S_BaseWN+"chisq", $S_BaseWN+"max", $S_BaseWN+"min"
	wave W_ExtRatio=$S_BaseWN+"ExtRatio", W_PolDir=$S_BaseWN+"PolDir", W_Intensity=$S_BaseWN+"Intensity", W_PIntensity=$S_BaseWN+"PIntensity", W_chisq=$S_BaseWN+"chisq", W_max=$S_BaseWN+"max", W_min=$S_BaseWN+"min"
	W_ExtRatio=0
	wave wv=$S_BaseWN+num2str((V_StartVolt+V_DetVol*i)*10)
	for(i=0; i<(V_EndVolt-V_StartVolt)/V_DetVol+1; i+=1)
//		print i
		wave W_current=$S_BaseWN+num2str((V_StartVolt+V_DetVol*i)*10)
		wave W_ResSinFit
		WaveStats /Q /Z W_current
		W_ResSinFit[0]=0
		if(Sinfitting(S_BaseWN+num2str((V_StartVolt+V_DetVol*i)*10), V_avg, V_avg,  2*pi/180, -W_ResSinFit[0]+pi/2, 2)>0.1)
			Sinfitting(S_BaseWN+num2str((V_StartVolt+V_DetVol*i)*10), V_avg, V_avg,  pi/180, 0, 5)
		endif
				//0: Polarization direction, 1: Extinction ratio, 2: Chi SQR, 3: Total Intensity, 4: Intensity at polarizationdirection
			//W_PolDir[i]=nan
			//W_chisq[i]=nan
			//W_Intensity[i]=nan
			//W_PIntensity[i]=nan
			//W_max[i]=nan
			//W_min[i]=nan
			//W_ExtRatio[i]=nan
			//print S_BaseWN+num2str((V_StartVolt+V_DetVol*i)*10)
		//else
			W_ExtRatio[i]=1/W_ResSinFit[1]//Extinction ratio by sin fitting
			W_PolDir[i]=W_ResSinFit[0]
			if(i<1)
					W_PolDir[i]-=round(W_PolDir[i]/pi)*pi
			else
					W_PolDir[i]-=round((W_PolDir[i]-W_PolDir[i-1])/pi*2)*pi/2
			endif
			W_chisq[i]=W_ResSinFit[2]
			W_Intensity[i]=W_ResSinFit[3]
			W_PIntensity[i]=W_ResSinFit[4]+W_ResSinFit[3]
			wavestats /Q W_current
			W_max[i]=V_max
			W_min[i]=V_min
			//W_ExtRatio[i]=V_max/V_min
		//endif
	endfor
	
//	Save/T/M="\r\n" original,fit_original,D061008_800nm_0,D061008_800nm_1,D061008_800nm_2,D061008_800nm_3,D061008_800nm_4,D061008_800nm_5,D061008_800nm_6,D061008_800nm_7,D061008_800nm_8,D061008_800nm_9,D061008_800nm_10,D061008_800nm_11,D061008_800nm_12,D061008_800nm_13,D061008_800nm_14,D061008_800nm_15 as "original++.itx"
//	Save/T/M="\r\n"/A D061008_800nm_16,D061008_800nm_17,D061008_800nm_18,D061008_800nm_19,D061008_800nm_20,D061008_800nm_21,D061008_800nm_22,D061008_800nm_23,D061008_800nm_24,D061008_800nm_25,D061008_800nm_26,D061008_800nm_27,D061008_800nm_28,D061008_800nm_29,D061008_800nm_30,D061008_800nm_31 as "original++.itx"
	

		SetScale/I x V_StartVolt,V_EndVolt,"V", W_PolDir, W_ExtRatio, W_Intensity, W_Intensity, W_PIntensity, W_chisq
		SetScale d 0,0,"rad", W_PolDir
		Interpolate2/T=3/N=(100*(V_EndVolt-V_StartVolt)/V_DetVol+1)/F=0 /Y=$S_BaseWN+"PolDir_SS" W_PolDir
	if(F_display)
		appendtograph  $S_BaseWN+"PolDir"
		appendtograph /R $S_BaseWN+"ExtRatio"
		//ShowTrc(S_BaseWN, S_BaseWN+"PolDir_ExtR", 0, 0, 1)//Display PolDir
		//ShowTrc(S_BaseWN, S_BaseWN+"PolDir_ExtR", 1, 1, 0)//AppendExtRatio
//		SetAxis right 0,0.03
		//Legend
		//TextBox/C/N=$S_BaseWN+"_PS" /F=0/A=MC/B=1 "["+S_BaseWN+"]"
		//AppendText "\\s("+S_BaseWN+"PolDir) Phase shift"
		//AppendText "\\s("+S_BaseWN+"ExtRatio) Extinction ratio"
//		SetAxis right 0,0.1 
//		ShowTrc(S_BaseWN, S_BaseWN+"Intensities", 2, 0, 1)
//		ShowTrc(S_BaseWN, S_BaseWN+"PIntensities", 3, 0, 1)
//		ShowTrc(S_BaseWN, S_BaseWN+"PIntensities", 4, 1, 0)
	endif
end

function ShowTrc(S_BaseWN, S_Winame, F_Data, F_Append, F_L_axis)
	//Display the variation of paramaters as a graph
	//S_BaseWN	:The Basename of target wave
	//S_Winame	:The target Window's name
	//F_Data		:Specify the wave to display or append to graph as shonw below
	//0: PhaseDelay, 1: ExtinctionRatio, 2: Intensity, 3: Intensity at polarization direction, 4: ChiSquare of fitting
	//F_Append	:if you wanna append the waves to exsisting graph, please input non-zero
	//F_L_axis	:if you wanna reference the left axis as the vertical axis, please input non-zero
	string S_BaseWN, S_Winame
	variable F_Data, F_Append, F_L_axis
	switch(F_Data)
		case 0://PhaseDelay
			if (F_Append)
				Appendtograph /W=$S_Winame $S_BaseWN+"PolDir", $S_BaseWN+"PolDir_SS"
			else
				Display /N=$S_Winame $S_BaseWN+"PolDir", $S_BaseWN+"PolDir_SS"
			endif
			ModifyGraph mode($S_BaseWN+"PolDir")=3,marker($S_BaseWN+"PolDir")=8,standoff(left)=0
			ModifyGraph rgb($S_BaseWN+"PolDir_SS")=(0,0,0)
			PiLabelgenerator("W_PiLabel", "W_PiLaPos", -4*pi, 4*pi, pi/2, 2)
			if(F_L_axis)
				Label left "Phase delay / \\U"
			else 
				Label right "Phase delay / \\U"
			endif
			break
		case 1://ExtinctionRatio
			if(F_Append)
				if(F_L_axis)
					Appendtograph/W=$S_Winame /L $S_BaseWN+"ExtRatio"
					ModifyGraph lowTrip(left)=0.001
				else
					Appendtograph/W=$S_Winame /R $S_BaseWN+"ExtRatio"
					ModifyGraph lowTrip(right)=0.001
				endif
			else
				if(F_L_axis)
					display /N=$S_Winame /L $S_BaseWN+"ExtRatio"
				else
					display /N=$S_Winame /R $S_BaseWN+"ExtRatio"
				endif
				
			endif
			ModifyGraph lstyle($S_BaseWN+"ExtRatio")=1,rgb($S_BaseWN+"ExtRatio")=(0,0,0),standoff(right)=0
			if(F_L_axis)
				Label Left "Extinction Ratio"
			else 
				Label right "Extinction Ratio"
			endif
			break
		case 2://Intensity
			if(F_Append)
				if(F_L_axis)
					Appendtograph/W=$S_Winame /L $S_BaseWN+"Intensity"
				else
					Appendtograph/W=$S_Winame /R $S_BaseWN+"Intensity"
				endif
			else
				if(F_L_axis)
					Display /N=$S_Winame /L $S_BaseWN+"Intensity"
				else
					Display /N=$S_Winame /R $S_BaseWN+"Intensity"
				endif
			endif
			wavestats /Q $S_BaseWN+"Intensity"
			if(F_L_axis)
				Label left "Intensity A.U."
			else 
				Label right  "Intensity A.U."
			endif
			break
		case 3://Intensity in polarized angle
			if(F_Append)
				if(F_L_axis)
					Appendtograph/W=$S_Winame /L $S_BaseWN+"PIntensity"
				else
					Appendtograph/W=$S_Winame /R $S_BaseWN+"PIntensity"
				endif
			else
				if(F_L_axis)
					Display /N=$S_Winame /L $S_BaseWN+"PIntensity"
				else
					Display /N=$S_Winame /R $S_BaseWN+"PIntensity"
				endif
				
			endif
			wavestats /Q $S_BaseWN+"PIntensity"
			if(F_L_axis)
				Label left "Intensity in polarized direction A.U."
			else 
				Label right  "Intensity in polarized direction A.U."
			endif
			break
		case 4://Chi SQ
			if(F_Append)
				if(F_L_axis)
					Appendtograph/W=$S_Winame /L $S_BaseWN+"chisq"
				else
					Appendtograph/W=$S_Winame /R $S_BaseWN+"chisq"
				endif
				
			else
				if(F_L_axis)
					Display /N=$S_Winame /L $S_BaseWN+"chisq"
				else
					Display /N=$S_Winame /R $S_BaseWN+"chisq"
				endif
			endif
			if(F_L_axis)
				Label left "\F'Symbol'c\M\S2"
			else 
				Label right  "\F'Symbol'c\M\S2"
			endif
			ModifyGraph lstyle($S_BaseWN+"chisq")=1,rgb($S_BaseWN+"chisq")=(0,0,0)
			break		
		default:
			break
	endswitch
end


Reduction(round(W_PiPoswave[i]/V_dMajor*V_divSubminor), round(pi/V_dMajor*V_divSubminor), )

//function Reduction(V_devided, V_devide, F_output)
	variable V_devided, V_devide, F_output
	variable COPY_V_devided = abs(V_devided), COPY_V_devide = abs(V_devide)
	variable V_CommonDivisor, V_residue, V_residue2, V_AnsDevided, V_AnsDevide


	if(COPY_V_devide >= COPY_V_devided)
		V_CommonDivisor = COPY_V_devided+1
		V_residue = mod(COPY_V_devide, V_CommonDivisor)
		V_residue2 = mod(COPY_V_devided, V_CommonDivisor)
		do
			V_CommonDivisor -= 1
			V_residue = mod(COPY_V_devide, V_CommonDivisor)
			V_residue2 = mod(COPY_V_devided, V_CommonDivisor)
		while((V_residue != 0) || (V_residue2 != 0))
	else
		V_CommonDivisor = COPY_V_devide
		V_residue = mod(COPY_V_devide, V_CommonDivisor)
		V_residue2 = mod(COPY_V_devided, V_CommonDivisor)
		do
			V_CommonDivisor -= 1
			V_residue = mod(COPY_V_devide, V_CommonDivisor)
			V_residue2 = mod(COPY_V_devided, V_CommonDivisor)
		while((V_residue != 0) || (V_residue2 != 0))
	endif
	if(((V_devided > 0) && (V_devide > 0)) || ((V_devided < 0) && (V_devide < 0)))
		V_AnsDevided = COPY_V_devided / V_CommonDivisor
		V_AnsDevide = COPY_V_devide / V_CommonDivisor
	else
		V_AnsDevided = -1*COPY_V_devided / V_CommonDivisor
		V_AnsDevide = COPY_V_devide / V_CommonDivisor
	endif

	if(F_output)
		return V_AnsDevide
	else
		return V_AnsDevided
	endif
//end

Function Sinfitting(S_wname, V_y0, V_A, V_frq, V_phy, F_output)
//S_wname:	Target Wavename in string
//V_y0:		The 1st guess of Offset of sin curve
//V_A:		The 1st guess of Amplitude of sin curve
//V_frq:		The value of Frequency of sin curve (FIXED) 
//V_phy:		The 1st guess of phase delay of sin curve
//F_output:	Specify the return value as shown below
//0: Polarization direction, 1: Extinction ratio, 2: Chi SQR, 3: Total Intensity, 4: Intensity at polarizationdirection
	string S_wname
	variable V_y0, V_A, V_frq, V_phy, F_output
	variable V_ExtRatio=0, V_PolDir, V_chisq, V_intensity,j
	wave W_current=$S_wname
	wave W_coef=W_coef
	K0 = V_y0; K1 = V_A; K2 = V_frq ;K3 = V_phy
	Make/O/T/N=4 T_Constraints
	Make/O/N=7 W_ResSinFit
	T_Constraints = {"K0 > 0","K1 > 0","K3 < 2*pi"}
//	T_Constraints = {"K0 > 0","K1 > 0","K3 > 0","K3 < 2*pi"}
//	T_Constraints = {"K0 > 0","K1 > 0","K3 > -100","K3 < 100"}
	CurveFit /Q/N/ODR=2 sin W_current[30,360] /D  //F={0.997300, 7} 
//	doupdate
	//CurveFit/G /Q  /H="0000" sin  W_current /D /F={0.997300, 7} 
	//C=T_Constraints
//	CurveFit/G /Q  /H="0000" sin  W_current /D //C=T_Constraints
//	F={0.999999, 4}  
	V_ExtRatio=(W_coef[0]-W_coef[1])/(W_coef[0]+W_coef[1])
	if(V_ExtRatio>1)
		V_ExtRatio=V_ExtRatio^-1
	endif
	V_PolDir=-W_coef[3]+pi/2

	j=0
	do
		if(W_coef[j]<0)
			W_coef[j]*=-1
		endif
		j+=1
	while(j<2)

	W_ResSinFit={V_PolDir, V_ExtRatio, V_chisq, W_coef[0], W_coef[1], W_coef[2], W_coef[3]}//C0+C1*sin(C2*x+C3)
	
	
	switch(F_output)
		case 0:	//Polarization direction
			return V_PolDir
		case 1:	//Extinction ratio
			return V_ExtRatio
		case 2:	//Chi SQR
			return V_chisq
		case 3:	//Total Intensity
			return W_coef[0]*2*pi
		case 4:	//Intensity at polarizationdirection
			return W_coef[1]
		default:
			break
	endswitch
	
end

Function PolarizationMeasurement1(wname)          //NIUSB6259用に改造
	string wname
	string W_prof_
	variable div
	variable i=0,k 
	variable ch=1
	
	variable Range=1
	variable V_PLSperDEG=200//1/0.4
	Make/O /D /N=360 $wname//(360*(V_PLSperDEG)+1)  $wname
	
	
	print (360*(V_PLSperDEG)+1)
	wave w1=$wname
	w1=Nan

	Silent 1

	fDAQmx_ScanStop("USB6259_1");print fDAQmx_ErrorString();
	//fDAQmx_waveformstop("USB6259_1");print fDAQmx_ErrorString();
	//string  S_cmd="fDAQmx_ScanGetAvailable(\"USB6259_1\");PMpostprocess("+nameofwave(w1)+");print 1"
	//fDAQmx_ScanGetAvailable("USB6259_1")
	DAQmx_Scan /DEV="USB6259_1"  /STRT=0 /BKG /AVE=1 /CLK={ "/USB6259_1/pfi8",0} waves=wname+", 0/RSE";print fDAQmx_ErrorString();
	//fDAQmx_ScanGetAvailable("USB6259_1")						     //↑トリガーのポート      //↑ディテクターのポート
	
	
//	DAQmx_Scan /DEV="USB6259_1"  /STRT=0 /BKG /CLK={ "/USB6259_1/pfi8",0} waves=wname+",0/RSE,0,10";print fDAQmx_ErrorString();
	
	//DAQmx_Scan /DEV="USB6259_1" /STRT=1 /BKG  waves=wname+", 0/RSE";print fDAQmx_ErrorString();
//	fDAQmx_ScanStart("USB6259_1", 0);print fDAQmx_ErrorString();
//AVE=(V_PLSperDEG)
//TRIG={ "/USB6259_1/ao/starttrigger"} 
//TRIG={ "/USB6259_1/pfi8",0}
	print fDAQmx_ErrorString();  
	         //wave W_P0CW
	         //GConstDrvPls("", "W_P0CW", 1.2e5, 360, 1, 0.005)         //2次曲線パターン
//	GConstDrvPls("", "W_P0CW", 1e5, 360, 1, 0.004)             //2次曲線パターン

//	Make/O/n=(360*100/100000*1e6) W_P0CW;setscale /I x, 0, (360*260)/100000,"s", W_P0CW;W_P0CW=5*round(mod(x, 1/100000)*100000)-3//速度一定パターン
//	EdgeCnt_shape(W_P0CW, 3, 90000)
	         //print EdgeCnt(W_P0CW, 5)
	//	Make/O/n=(361*V_PLSperDEG*2) W_P0CW
	//	setscale /I x, 0, 360*V_PLSperDEG/10000, "sec", W_P0CW//10kHz
	//	W_P0CW[]=5*round(mod(p, 2))
	//fDAQmx_ScanStart("USB6259_1", 0)
	//NIDAQ_DIO_wv(1, "USB6259_1", "/PCIe6363_1/ao0", "W_P0CW", 0, S_cmd)     
	         //execute "DAQmx_WaveformGen /DEV=\"USB6259_1\" /STRT=0 /NPRD=1 /BKG=0 /EOSH=\"postprc()\" \"W_P0CW,0;\""
			//print fDAQmx_ErrorString(); 
	//print fDAQmx_ScanStart("USB6259_1", 0) 
	



	print "ScanSTART: ", fDAQmx_ScanStart("USB6259_1", 0);
	//fDAQmx_ScanGetAvailable("USB6259_1")
	Sigma_Rotation_Stage_Goto2(360)
	fDAQmx_ScanGetAvailable("USB6259_1")
	//print "WaveformGenerationSTART: ", fDAQmx_WaveformStart("USB6259_1", 1)
	sleep /S 0.1
	print fDAQmx_ErrorString()
	
	
	wavestats /M=1 /Q w1
	Redimension/N=360 w1//(V_npnts) w1
	doupdate
	//Extract /O w1, w1, w1!=nan

	//setscale /I x, 0, 360, "deg", w1
	
	//SetAxis bottom 0,360
	//ModifyGraph tick=2,mirror=2,fSize=24,axThick=5
	//ModifyGraph lsize=8
	//doupdate
	
end



Function PolarizationMeasurement3(wname)   //s1000, f30000, a100
	string wname
	string W_prof_
	variable div
	variable i=0,k 
	variable ch=1
	
	variable Range=1
	variable V_PLSperDEG=2//1/0.4//最初は2,へらしたらスピードを上げても測れるようになった。
//	Make/O /D /N=360 $wname//(360*(V_PLSperDEG)+1)  $wname
	Make/O /D /N=(360) $wname//  $wname

	
//	print (360*(V_PLSperDEG)+1)
	wave w1=$wname
	w1=Nan

	Silent 1

	fDAQmx_ScanStop("USB6259_1");print fDAQmx_ErrorString();
	//fDAQmx_waveformstop("USB6259_1");print fDAQmx_ErrorString();
	//string  S_cmd="fDAQmx_ScanGetAvailable(\"USB6259_1\");PMpostprocess("+nameofwave(w1)+");print 1"
	//fDAQmx_ScanGetAvailable("USB6259_1")
//	DAQmx_Scan /DEV="USB6259_1"  /STRT=0 /BKG /AVE=1 /CLK={ "/USB6259_1/pfi8",0} waves=wname+", 0/RSE";print fDAQmx_ErrorString();
	//DAQmx_Scan /DEV="USB6259_1"  /STRT=0 /BKG /AVE=(0)  waves=wname+", 0/RSE";print fDAQmx_ErrorString();
	DAQmx_Scan /DEV="USB6259_1" /STRT=0 /BKG /AVE=200 /CLK={"/USB6259_1/pfi8",0} waves=wname+", 0/RSE";print fDAQmx_ErrorString();

	//fDAQmx_ScanGetAvailable("USB6259_1")						     //↑トリガーのポート      //↑ディテクターのポート
	
	
//	DAQmx_Scan /DEV="USB6259_1"  /STRT=0 /BKG /CLK={ "/USB6259_1/pfi8",0} waves=wname+",0/RSE,0,10";print fDAQmx_ErrorString();
	
	//DAQmx_Scan /DEV="USB6259_1" /STRT=1 /BKG  waves=wname+", 0/RSE";print fDAQmx_ErrorString();
//	fDAQmx_ScanStart("USB6259_1", 0);print fDAQmx_ErrorString();
//AVE=(V_PLSperDEG)
//TRIG={ "/USB6259_1/ao/starttrigger"} 
//TRIG={ "/USB6259_1/pfi8",0}
	print fDAQmx_ErrorString();  
	         //wave W_P0CW
	         //GConstDrvPls("", "W_P0CW", 1.2e5, 360, 1, 0.005)         //2次曲線パターン
//	GConstDrvPls("", "W_P0CW", 1e5, 360, 1, 0.004)             //2次曲線パターン

//	Make/O/n=(360*100/100000*1e6) W_P0CW;setscale /I x, 0, (360*260)/100000,"s", W_P0CW;W_P0CW=5*round(mod(x, 1/100000)*100000)-3//速度一定パターン
//	EdgeCnt_shape(W_P0CW, 3, 90000)
	         //print EdgeCnt(W_P0CW, 5)
	//	Make/O/n=(361*V_PLSperDEG*2) W_P0CW
	//	setscale /I x, 0, 360*V_PLSperDEG/10000, "sec", W_P0CW//10kHz
	//	W_P0CW[]=5*round(mod(p, 2))
	//fDAQmx_ScanStart("USB6259_1", 0)
	//NIDAQ_DIO_wv(1, "USB6259_1", "/PCIe6363_1/ao0", "W_P0CW", 0, S_cmd)     
	         //execute "DAQmx_WaveformGen /DEV=\"USB6259_1\" /STRT=0 /NPRD=1 /BKG=0 /EOSH=\"postprc()\" \"W_P0CW,0;\""
			//print fDAQmx_ErrorString(); 
	//print fDAQmx_ScanStart("USB6259_1", 0) 
	



	print "ScanSTART: ", fDAQmx_ScanStart("USB6259_1", 0);
	//fDAQmx_ScanGetAvailable("USB6259_1")
	Sigma_Rotation_Stage_Goto2(360)
//variable j
//for(j=0;j<=1000000;j+=1)
//endfor
	fDAQmx_ScanGetAvailable("USB6259_1")
	//print "WaveformGenerationSTART: ", fDAQmx_WaveformStart("USB6259_1", 1)
	//sleep /S 1
	print fDAQmx_ErrorString()
	fDAQmx_ScanStop("USB6259_1")
	
	wavestats /M=1 /Q  w1
	//Redimension/N=360 w1//(V_npnts) w1
	doupdate
	//Extract /O w1, w1, w1!=nan

	//setscale /I x, 0, 360, "deg", w1
	
	//SetAxis bottom 0,360
	//ModifyGraph tick=2,mirror=2,fSize=24,axThick=5
	//ModifyGraph lsize=8
	//doupdate
	
end




function PMpostprocess(w1)
	wave w1
	variable V_offset=-1
	w1-=V_Offset
	wavestats /M=1 /Q w1
	Redimension/N=(V_npnts+1) w1
	wavetransform /O flip w1
	w1=w1[p+1]
	wavetransform /O flip w1
	w1[0]=w1[V_npnts-1]
	doupdate
	//Extract /O w1, w1, w1!=nan
	setscale /I x, 0, 360, "deg", w1
end

Function PolarizationMeasurement(wname, div)
	string wname
	variable div
	variable i=0,k
	variable ch=1
	variable ATime=10
	variable Range=1
	nvar V_Offset
	//-0.000733775
	Make/O/N=(360/div+1) $wname
	wave w1=$wname
	setscale /I x, 0, 360, "deg", w1
	do
		Silent 1
//--		w1[i]=NIDAQ_USB6211_Obs(ATime,ch,Range, V_Offset)
//		print i*div, "deg"
		i+=1
//--		Sigma_Rotation_Stage_Goto(i*div)
//		Waiting(50000, 1000000)
//		Waiting(50000, 2*50000)

	while(i<=360/div)
end

Function PolarizationMeasurement2_old(wname, div, F_Power)
	string wname
	variable div, F_Power
	variable i=0,k
	variable ch=1
	
	variable Range=1
	nvar V_Offset, V_Chameleon_Power
	V_Offset=0
	//Make/O/N=(360/div+1) $wname
	Make/O /D /N=(361*40) $wname
	wave w1=$wname
	w1=Nan

	variable V_PLSperDEG=25///500:10のとき

	Silent 1


	fDAQmx_ScanStop("USB6211_1")
	fDAQmx_waveformstop("USB6211_1")
	//fDAQmx_ResetDevice("USB6211_1")
	//DAQmx_Scan /DEV="USB6211_1" /STRT=0 /AVE=50/BKG=1 /CLK={ "/USB6211_1/pfi0",0}  waves=wname+", 1/RSE"//
	DAQmx_Scan /DEV="USB6211_1" /STRT=0 /AVE=50/BKG=1 /CLK={ "/USB6211_1/pfi0",1}  waves=wname+", 1/RSE"//
//	DAQmx_Waveformgen /DEV="USB6211_1"/STRT=0/NPRD=1 /CLK={ "/USB6211_1/pfi2", 1} /TRIG={ "/USB6211_1/pfi2", 1, 0} S_OutWnameX+", 0;"+S_OutWnameY+", 1;"
//	DAQmx_Scan /DEV="USB6211_1" /STRT=0 /BKG=1/AVE=1/CLK={ "/USB6211_1/pfi2",0} /TRIG={ "/USB6211_1/pfi2", 1, 0} waves=S_InWname+", 0/RSE"
	fDAQmx_ScanStart("USB6211_1", 0)
	//Execute "Polarizer_Goto_GPIB(360)"

//--	Mark202_PolarizerGoto("PolarizationMeasurement2",360, V_PLSperDEG, 1, F_axis, F_GPIB)
	fDAQmx_ScanGetAvailable("USB6211_1")
	//w1-=V_Offset
	wavestats /M=1 /Q w1
	Redimension/N=(V_npnts) w1
	doupdate
	//Extract /O w1, w1, w1!=nan

	setscale /I x, 0, 360, "deg", w1
end

Function PolarizationMeasurement2(wname, div, F_Power)
	string wname
	variable div, F_Power
	variable i=0
	variable k
	variable ch=1
	variable ATime=10
	variable Range=1
	nvar V_Offset 
	
	//V_Offset=0
	V_Offset =0
	//V_Offset =0.00956684
	//V_Offset=-0.0206032
	
	Make/O/N=(360/div+1) $wname
	wave w1=$wname
	setscale /I x, 0, 360, "deg", w1
	w1[0]=NIDAQ_PCIe6363_Obs(ATime,ch,Range, V_Offset)
	do
		Silent 1
//		print i*div, "deg"
		i+=1
//		Sigma_Rotation_Stage_Goto(div)
		w1[i]=NIDAQ_PCIe6363_Obs(ATime,ch,Range, V_Offset)
//		Waiting(50000, 1000000)
//		Waiting(50000, 2*50000)
print i
	while(i<360/div)
end

Function PolDirfitting(S_wname)
	string S_wname
	wave  W_wname=$S_wname, W_ResSinFit=W_ResSinFit
	wavestats /Q/Z W_wname
	Sinfitting(S_wname, V_avg, V_avg,  2*pi/180, pi/2, 0)
//	W_ResSinFit={V_PolDir, V_ExtRatio, V_chisq, W_coef[0], W_coef[1], W_coef[2], W_coef[3]}
//	Sinfitting(S_wname, V_avg, V_avg,  2*pi/180, pi/2, 0)
	W_ResSinFit[0]-=trunc(W_ResSinFit[0]/2/pi)*2*pi
	print "Polatization direction=",W_ResSinFit[0]/pi*90
	print "Extinction ratio=",W_ResSinFit[1]
end 


Function Rtd2Frq(S_Wname, V_Rtd_rad, V_WL_nm)
	string S_Wname
	variable V_Rtd_rad, V_WL_nm
	variable i
	wave M_Frq2Rtd=$S_Wname
	variable V_n=dimsize(M_Frq2Rtd, 0)
	variable V_WL_m=V_WL_nm/1e9
	for(i=0; i<V_n-1; i+=1)
		if((M_Frq2Rtd[i](V_WL_m)-V_Rtd_rad)*(M_Frq2Rtd[i+1](V_WL_m)-V_Rtd_rad)<0)
			return pnt2x(M_Frq2Rtd, i)+(pnt2x(M_Frq2Rtd, i+1)-pnt2x(M_Frq2Rtd, i))*(V_Rtd_rad-M_Frq2Rtd[i])/(M_Frq2Rtd[i+1]-M_Frq2Rtd[i])
		elseif((M_Frq2Rtd[i]-V_Rtd_rad-2*pi)*(M_Frq2Rtd[i+1]-V_Rtd_rad-2*pi)<0)
			return pnt2x(M_Frq2Rtd, i)+(pnt2x(M_Frq2Rtd, i+1)-pnt2x(M_Frq2Rtd, i))*(V_Rtd_rad+2*pi-M_Frq2Rtd[i])/(M_Frq2Rtd[i+1]-M_Frq2Rtd[i])
		elseif((M_Frq2Rtd[i]-V_Rtd_rad+2*pi)*(M_Frq2Rtd[i+1]-V_Rtd_rad+2*pi)<0)
			return pnt2x(M_Frq2Rtd, i)+(pnt2x(M_Frq2Rtd, i+1)-pnt2x(M_Frq2Rtd, i))*(V_Rtd_rad-2*pi-M_Frq2Rtd[i])/(M_Frq2Rtd[i+1]-M_Frq2Rtd[i])
		endif
	endfor
	for(i=0; i<V_n-1; i+=1)
		if(abs(M_Frq2Rtd[i]) < abs(V_Rtd_rad) && abs(M_Frq2Rtd[i+1]) > abs(V_Rtd_rad))
			return pnt2x(M_Frq2Rtd, i)+(pnt2x(M_Frq2Rtd, i+1)-pnt2x(M_Frq2Rtd, i))*(V_Rtd_rad-M_Frq2Rtd[i])/(M_Frq2Rtd[i+1]-M_Frq2Rtd[i])
		elseif(abs(M_Frq2Rtd[i]) < abs(V_Rtd_rad+2*pi) && abs(M_Frq2Rtd[i+1]) > abs(V_Rtd_rad+2*pi))
			return pnt2x(M_Frq2Rtd, i)+(pnt2x(M_Frq2Rtd, i+1)-pnt2x(M_Frq2Rtd, i))*(V_Rtd_rad+2*pi-M_Frq2Rtd[i])/(M_Frq2Rtd[i+1]-M_Frq2Rtd[i])
		endif
	endfor
	print "Error"
end

pnt2xMD(w,dim,pqrs)




function OriginalPolarization(ctrlName, V_wavelength)
	string ctrlName
	variable V_wavelength
	Nvar V_Chameleon_WAVELENGTH
	Silent 1

	string S_BaseFilename=BaseNameGenerator("OriginalPolarization", V_wavelength)
	print "Start_Original Wave"
	string S_OrgWN=S_BaseFilename+"Original"
//	PolarizerInitZero(S_OrgWN, 1)
//--	BC_Mark202_Init("")
	PolarizationMeasurement(S_OrgWN, 1)
	PolDirfitting(S_OrgWN)
	Wave wn=$S_OrgWN
	wavestats wn
	silent 0
end



function RetardationDataAquisition(ctrlName, V_wavelength, F_LC)
	string ctrlName
	variable F_LC
	variable V_wavelength
	Nvar V_Chameleon_WAVELENGTH
	//if(YorN("RetardationDataAquisition", "Start Retardation Data Aquisition", "Shutter check OK?"))

		string S_BaseFilename=BaseNameGenerator("RetardationDataAquisition", V_wavelength)+"_"+num2str(F_LC)
		GetRetardation(S_BaseFilename, F_LC)
	//endif
end

Function Peak2valley(ctrlName,BGNoise)
	String	ctrlName
	variable	BGNoise	//average of BackGround Noise
	WaveStats/Q $ctrlName
	print "      Ex_ratio 1 =", (V_min-BGNoise)/(V_max-BGNoise),"      Ex_ratio 2 =", V_min/V_max,"      wavepoint =",V_npnts
End

Function GetBG(ctrlName)
	String	ctrlName
	nvar V_offset	//average of BackGround Noise

//--	BC_Mark202_Init("")
	PolarizationMeasurement2(ctrlName,1, 1)
	Display/k=1 $ctrlName
	wavestats/q $ctrlName
	print "      BackGround  =",V_avg

	V_offset=V_avg
	return V_avg
End

Function Peak2valley2(wname1, wname2)
	String	wname1, wname2
	Variable	BGNosie
	
	BGNosie = GetBG(wname2)
//--	BC_Mark202_Init("")
	PolarizationMeasurement2(wname1,1,1)
	Peak2valley(wname1,BGNosie)
	display $wname1
End

Function Peak2valley3(wname1, wname2)
	String	wname1, wname2
	Variable	BGNosie
	
//	BGNosie = GetBG(wname2)
//--	BC_Mark202_Init("")
	PolarizationMeasurement2(wname1,1,1)
	wavestats/Q $wname1
//	print "      minval =", V_min,"      minval - BackGround =", V_min - BGNosie,"      wavepoint =",V_npnts
	print "      minval =", V_min,	"      wavepoint =",V_npnts
	display $wname1
End


function genDatabase(ctrlName, V_statWLnm, V_endWLnm, V_statFrqHz, V_endFreqHz)
	string ctrlName
	variable V_statWLnm, V_endWLnm, V_statFrqHz, V_endFreqHz
	variable V_ny=V_endWLnm-V_statWLnm
	variable V_nx=V_endFreqHz-V_statFrqHz
	Make/O/N=(V_nx,V_ny)/D M_Phase_Frq_WL;DelayUpdate
	SetScale/I x V_statFrqHz,V_endFreqHz,"Hz", M_Phase_Frq_WL;DelayUpdate
	SetScale/I y V_statWLnm/1e-9,V_endWLnm/1e-9,"m", M_Phase_Frq_WL;DelayUpdate
	SetScale d 0,0,"rad", M_Phase_Frq_WL
end



