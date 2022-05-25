#pragma rtGlobals=1		// Use modern global access method.
//LCDPannelWindow
variable /G V_PolCorrection
string /G S_CompCurve_Bname

Function PMC_GetConfig(V_No)
	variable V_No
	wave W_config=$"Cfg_PMC"
	return W_config[V_No]
end

Function PMC_OverWriteConfig(V_No, V_Val)
	variable V_No, V_Val
	wave W_config=$"Cfg_PMC"
	W_config[V_No]=V_Val
end

//W_LCDFreq={V_WaveLength, V_x, V_y, V_Cell1, V_Cell2, V_Cell3, V_Cell4, V_Cell5, V_Cell6, V_Cell7, V_Cell8, V_Cell9, V_Cell10, V_Cell11, V_Cell12, V_Cell13, V_Cell14, V_Cell15, V_Cell16}
//V_No, 
//WS_NameLCDSetting=S_Name+V_WaveLength

Window LCSLM_Ctrl_Config() : Table
	PauseUpdate; Silent 1		// building window...
	Edit/W=(62.25,95.75,427.5,305) Cfg_PMC_Name,Cfg_PMC as "LCSLM_Ctrl_Config"
	ModifyTable width(Cfg_PMC_Name)=155
EndMacro

Window LCD_Control() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(1036,189,1528,572) as "LCD_Control"
	ShowTools/A
	SetDrawLayer UserBack
	SetDrawEnv translate= 160,559,rotate= -181.285,rsabout
	SetDrawEnv translate= 283.911,831.848,rotate= -178.715,scale= 1.07273,0.6,rsabout
	SetDrawEnv translate= 289.244,801.96,rotate= -178.715,scale= 1,0.8,rsabout
	SetDrawEnv translate= 288.683,826.954,rotate= -178.715,scale= 5.71186,4,rsabout
	SetDrawEnv linethick= 5,linepat= 2,linefgc= (65280,16384,16384),dash= 1,arrow= 1,arrowfat= 1
	DrawLine 233.981758424549,800.329032951635,288.981758424549,827.329032951634
	SetDrawEnv gstart
	DrawOval 188,289,244,355
	DrawLine 215,289,215,354
	DrawLine 199,346,232,298
	DrawLine 236,341,193,301
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 242,313,"9"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 219,294,"10"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 188,295,"11"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 175,322,"12"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 180,348,"13"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 194,364,"14"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 224,365,"15"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 243,339,"16"
	DrawLine 188,328,244,316
	SetDrawEnv fname= "Arial"
	DrawText 192,340,"16"
	SetDrawEnv fname= "Arial"
	DrawText 201,352,"17"
	SetDrawEnv fname= "Arial"
	DrawText 217,351,"18"
	SetDrawEnv fname= "Arial"
	DrawText 227,335,"19"
	SetDrawEnv fname= "Arial"
	DrawText 225,318,"20"
	SetDrawEnv fname= "Arial"
	DrawText 217,310,"21"
	SetDrawEnv fname= "Arial"
	DrawText 191,325,"23"
	SetDrawEnv gstart
	DrawText 183,269,"Polarization"
	DrawText 186,283,"Control"
	SetDrawEnv gstop
	SetDrawEnv fname= "Arial"
	DrawText 199,310,"22"
	SetDrawEnv gstop
	SetDrawEnv gstart
	DrawOval 280,304,336,370
	DrawLine 307,304,307,369
	DrawLine 280,343,336,331
	DrawLine 290,360,326,313
	DrawLine 328,356,285,316
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 277,363,"5"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 273,340,"4"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 289,311,"3"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 317,309.999999999996,"2"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 332,326,"1"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 335,355,"8"
	SetDrawEnv fname= "Arial"
	DrawText 288,357,"8"
	SetDrawEnv fname= "Arial"
	DrawText 299,365,"9"
	SetDrawEnv fname= "Arial"
	DrawText 292,326,"14"
	SetDrawEnv fname= "Arial"
	DrawText 308,326,"13"
	SetDrawEnv fname= "Arial"
	DrawText 318,336,"12"
	SetDrawEnv fname= "Arial"
	DrawText 318,349,"11"
	SetDrawEnv fname= "Arial"
	DrawText 308,364,"10"
	SetDrawEnv fname= "Arial"
	DrawText 282,342,"15"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 317,379,"7"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 291,379,"6"
	SetDrawEnv gstop
	DrawText 317,291,"PhaseControl"
	SetDrawEnv gstart
	DrawOval 105,277,161,343
	DrawLine 132,277,132,342
	DrawLine 105,316,161,304
	DrawLine 115,333,151,286
	DrawLine 153,329,110,289
	DrawText 118,264,"QWP"
	SetDrawEnv fname= "Arial"
	DrawText 134,339,"26"
	SetDrawEnv fname= "Arial"
	DrawText 144,322,"27"
	SetDrawEnv fname= "Arial"
	DrawText 144,308,"28"
	SetDrawEnv fname= "Arial"
	DrawText 133,297,"29"
	SetDrawEnv fname= "Arial"
	DrawText 117,300,"30"
	SetDrawEnv fname= "Arial"
	DrawText 109,313,"31"
	SetDrawEnv fname= "Arial"
	DrawText 110,330,"24"
	SetDrawEnv fname= "Arial"
	DrawText 120,338,"25"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 142,352,"23"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 114,354,"22"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 95,337,"21"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 91,307,"20"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 111,282,"19"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 142,282.999999999996,"18"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 157,299,"17"
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 160,328,"24"
	SetDrawEnv gstop
	SetDrawEnv arrow= 1
	DrawLine 6,306,94,293
	SetDrawEnv gstart
	SetDrawEnv fname= "Arial",textrgb= (65280,0,0)
	DrawText 365,319,"CellNo."
	SetDrawEnv fname= "Arial"
	DrawText 365,333,"Ch.No."
	SetDrawEnv gstop
	SetDrawEnv arrow= 1
	DrawLine 48,346,48,256
	SetDrawEnv fname= "Arial"
	DrawText 104,297,"x"
	DrawText 34,267,"y"
	SetDrawEnv linethick= 5,linepat= 2,linefgc= (65280,16384,16384),dash= 1,arrow= 1,arrowfat= 1
	DrawLine 229.434065403542,795.225743112034,284.434065403542,822.225743112034
	SetDrawEnv linethick= 5,linepat= 2,linefgc= (65280,16384,16384),dash= 1,arrow= 1,arrowfat= 1
	DrawLine 229.434065403542,795.225743112034,284.434065403542,822.225743112034
	SetDrawEnv linethick= 5,linepat= 2,linefgc= (65280,16384,16384),dash= 1,arrow= 1,arrowfat= 1
	DrawLine 229.434065403542,795.225743112034,284.434065403542,822.225743112034
	SetVariable CH00,pos={0,10},size={115,18},proc=SVP_PMC_SetFreq,title="CH00"
	SetVariable CH00,font="Arial",format="%3.3W0PHz"
	SetVariable CH00,limits={10,100000,1},value= Cfg_PMC_Frq[0]
	SetVariable CH01,pos={1,29},size={115,18},proc=SVP_PMC_SetFreq,title="CH01"
	SetVariable CH01,font="Arial",format="%3.3W0PHz"
	SetVariable CH01,limits={10,100000,1},value= Cfg_PMC_Frq[1]
	SetVariable CH02,pos={1,50},size={115,18},proc=SVP_PMC_SetFreq,title="CH02"
	SetVariable CH02,font="Arial",format="%3.3W0PHz"
	SetVariable CH02,limits={10,100000,1},value= Cfg_PMC_Frq[2]
	SetVariable CH03,pos={1,70},size={115,18},proc=SVP_PMC_SetFreq,title="CH03"
	SetVariable CH03,font="Arial",format="%3.3W0PHz"
	SetVariable CH03,limits={10,100000,1},value= Cfg_PMC_Frq[3]
	SetVariable CH04,pos={1,90},size={115,18},proc=SVP_PMC_SetFreq,title="CH04"
	SetVariable CH04,font="Arial",format="%3.3W0PHz"
	SetVariable CH04,limits={10,100000,1},value= Cfg_PMC_Frq[4]
	SetVariable CH05,pos={1,110},size={115,18},proc=SVP_PMC_SetFreq,title="CH05"
	SetVariable CH05,font="Arial",format="%3.3W0PHz"
	SetVariable CH05,limits={10,100000,1},value= Cfg_PMC_Frq[5]
	SetVariable CH06,pos={1,130},size={115,18},proc=SVP_PMC_SetFreq,title="CH06"
	SetVariable CH06,font="Arial",format="%3.3W0PHz"
	SetVariable CH06,limits={10,100000,1},value= Cfg_PMC_Frq[6]
	SetVariable CH07,pos={1,150},size={115,18},proc=SVP_PMC_SetFreq,title="CH07"
	SetVariable CH07,font="Arial",format="%3.3W0PHz"
	SetVariable CH07,limits={10,100000,1},value= Cfg_PMC_Frq[7]
	SetVariable CH08,pos={1,170},size={115,18},proc=SVP_PMC_SetFreq,title="CH08"
	SetVariable CH08,font="Arial",format="%3.3W0PHz"
	SetVariable CH08,limits={10,100000,1},value= Cfg_PMC_Frq[8]
	SetVariable CH09,pos={1,190},size={115,18},proc=SVP_PMC_SetFreq,title="CH09"
	SetVariable CH09,font="Arial",format="%3.3W0PHz"
	SetVariable CH09,limits={10,100000,1},value= Cfg_PMC_Frq[9]
	SetVariable CH10,pos={1,209},size={115,18},proc=SVP_PMC_SetFreq,title="CH10"
	SetVariable CH10,font="Arial",format="%3.3W0PHz"
	SetVariable CH10,limits={10,100000,1},value= Cfg_PMC_Frq[10]
	SetVariable CH11,pos={1,228},size={115,18},proc=SVP_PMC_SetFreq,title="CH11"
	SetVariable CH11,font="Arial",format="%3.3W0PHz"
	SetVariable CH11,limits={10,100000,1},value= Cfg_PMC_Frq[11]
	SetVariable CH12,pos={121,11},size={115,18},proc=SVP_PMC_SetFreq,title="CH12"
	SetVariable CH12,font="Arial",format="%3.3W0PHz"
	SetVariable CH12,limits={10,100000,1},value= Cfg_PMC_Frq[12]
	SetVariable CH13,pos={121,31},size={115,18},proc=SVP_PMC_SetFreq,title="CH13"
	SetVariable CH13,font="Arial",format="%3.3W0PHz"
	SetVariable CH13,limits={10,100000,1},value= Cfg_PMC_Frq[13]
	SetVariable CH14,pos={121,51},size={115,18},proc=SVP_PMC_SetFreq,title="CH14"
	SetVariable CH14,font="Arial",format="%3.3W0PHz"
	SetVariable CH14,limits={10,100000,1},value= Cfg_PMC_Frq[14]
	SetVariable CH15,pos={121,71},size={115,18},proc=SVP_PMC_SetFreq,title="CH15"
	SetVariable CH15,font="Arial",format="%3.3W0PHz"
	SetVariable CH15,limits={10,100000,1},value= Cfg_PMC_Frq[15]
	PopupMenu popup0,pos={382,69},size={60,20},proc=LCD_Control_pol
	PopupMenu popup0,help={"Select Polarization Mode"},font="Arial"
	PopupMenu popup0,mode=1,popvalue="Radial",value= #"\"Radial;Xpol;Ypol;Azimuth;LaguerreGauss\""
	PopupMenu Popup_WL,pos={309,126},size={113,20},proc=Pop_ChangeWL,title="Wavelength"
	PopupMenu Popup_WL,font="Arial"
	PopupMenu Popup_WL,mode=3,popvalue="650",value= #"Gen_WavelengthList(\"M_LCD_Driving_Param\", \"S_ListWL\")"
	CheckBox PhaseInversion,pos={274,71},size={104,15},proc=C_PhaseInv,title="PhaseInversion"
	CheckBox PhaseInversion,font="Arial",value= 1
	SetVariable setvar0,pos={281,47},size={184,18},proc=SV_Angle,title="Current PolAngle"
	SetVariable setvar0,font="Arial",format="%g deg"
	SetVariable setvar0,limits={0,360,1},value= Cfg_PMC[1]
	ValDisplay TuningAngle,pos={276,95},size={98,16},title="Tuning",font="Arial"
	ValDisplay TuningAngle,format="%g deg",limits={0,0,0},barmisc={0,1000}
	ValDisplay TuningAngle,value= #"Cfg_PMC[5]"
	Button Gen,pos={261,126},size={32,20},proc=BP_LCSLM_GenChVset,title="Gen"
	Button Gen,font="Arial"
	SetVariable CH16,pos={121,90},size={115,18},proc=SVP_PMC_SetFreq,title="CH16"
	SetVariable CH16,font="Arial",format="%3.3W0PHz"
	SetVariable CH16,limits={10,100000,1},value= Cfg_PMC_Frq[16]
	SetVariable CH17,pos={121,110},size={115,18},proc=SVP_PMC_SetFreq,title="CH17"
	SetVariable CH17,font="Arial",format="%3.3W0PHz"
	SetVariable CH17,limits={10,100000,1},value= Cfg_PMC_Frq[17]
	SetVariable CH18,pos={121,130},size={115,18},proc=SVP_PMC_SetFreq,title="CH18"
	SetVariable CH18,font="Arial",format="%3.3W0PHz"
	SetVariable CH18,limits={10,100000,1},value= Cfg_PMC_Frq[18]
	SetVariable CH19,pos={121,150},size={115,18},proc=SVP_PMC_SetFreq,title="CH19"
	SetVariable CH19,font="Arial",format="%3.3W0PHz"
	SetVariable CH19,limits={10,100000,1},value= Cfg_PMC_Frq[19]
	SetVariable CH20,pos={121,169},size={115,18},proc=SVP_PMC_SetFreq,title="CH20"
	SetVariable CH20,font="Arial",format="%3.3W0PHz"
	SetVariable CH20,limits={10,100000,1},value= Cfg_PMC_Frq[20]
	SetVariable CH21,pos={121,189},size={115,18},proc=SVP_PMC_SetFreq,title="CH21"
	SetVariable CH21,font="Arial",format="%3.3W0PHz"
	SetVariable CH21,limits={10,100000,1},value= Cfg_PMC_Frq[21]
	SetVariable CH22,pos={121,209},size={115,18},proc=SVP_PMC_SetFreq,title="CH22"
	SetVariable CH22,font="Arial",format="%3.3W0PHz"
	SetVariable CH22,limits={10,100000,1},value= Cfg_PMC_Frq[22]
	SetVariable CH23,pos={121,229},size={115,18},proc=SVP_PMC_SetFreq,title="CH23"
	SetVariable CH23,font="Arial",format="%3.3W0PHz"
	SetVariable CH23,limits={10,100000,1},value= Cfg_PMC_Frq[23]
	CheckBox QWP,pos={276,26},size={49,14},proc=CB_QWP,title="QWP",font="Verdana"
	CheckBox QWP,value= 1
	Display/W=(254,156,484,274)/HOST=#  W_PolDir
	ModifyGraph userticks(left)={W_PiLaPos,W_PiLabel}
	
	//Button LCD_Ctrl,pos={365,277},size={80,30},proc=LCD_Ctrl_ButtonProc,title="Stop"
	//Button LCD_Ctrl,font="Arial",fColor=(65280,48896,48896)
	//PopupMenu popup0,pos={321,230},size={59,20},proc=LCD_Control_pol
	//PopupMenu popup0,help={"Select Polarization Mode"},font="Arial"
	//PopupMenu popup0,mode=2,popvalue="Xpol",value= #"\"Radial;Xpol;Ypol;Azimuth;LaguerreGauss\""
	//PopupMenu Popup_WL,pos={239,286},size={124,23},proc=Pop_ChangeWL,title="Wavelength"
	//PopupMenu Popup_WL,font="Arial"
	//PopupMenu Popup_WL,mode=7,popvalue="800",value= #"Gen_WavelengthList(\"W_LCDSettings\", \"S_ListWL\")"
	//CheckBox PhaseInversion,pos={216,231},size={104,15},proc=C_PhaseInv,title="PhaseInversion"
	//CheckBox PhaseInversion,font="Arial",value= 1
	//PopupMenu wave,pos={242,8},size={157,23},proc=PM_LCDWaveform,title="LCDWaveform"
	//PopupMenu wave,font="Arial"
	//PopupMenu wave,mode=2,popvalue="Square",value= #"\"Sin;Square;Triangle;\""
	//SetVariable LCD_WDuty,pos={349,33},size={89,18},proc=SV_LCDDutyCTRL,title="Duty"
	//SetVariable LCD_WDuty,font="Arial",format="%g %"
	//SetVariable LCD_WDuty,limits={50,50,1},value= V_LCD_WDuty
	//SetVariable setvar0,pos={223,207},size={184,18},proc=SetVarProc,title="Current PolAngle"
	//SetVariable setvar0,limits={0,360,1},value= Cfg_PMC[1]
	//ValDisplay PolCorAngle,pos={221,254},size={197,17},title="PolarizationCorrection"
	//ValDisplay PolCorAngle,font="Arial",format="%g deg"
	//ValDisplay PolCorAngle,limits={0,0,0},barmisc={0,1000}
	//ValDisplay PolCorAngle,value= #"Cfg_PMC[7]"
	//SetVariable CompCurveBaseName,pos={10,289},size={193,18},title="CompensationCurve"
	//SetVariable CompCurveBaseName,font="Arial",value= S_CompCurve_Bname
	//Button Gen,pos={204,288},size={32,20},proc=BP_LCSLM_GenChVset,title="Gen"
	//Button Gen,font="Arial"
	//Display/W=(243,56,442,201)/HOST=#  LCD_Ctrl_Wave8
	//ModifyGraph margin(left)=11,margin(bottom)=34,margin(right)=28
	RenameWindow #,G0
	SetActiveSubwindow ##
EndMacro

Function AddLCDSettings(V_WaveLength)
	Variable V_WaveLength
	Variable i
	wave W_LCD=M_LCD_Driving_Param
	variable V_n=dimsize(W_LCD, 0)
	for(i=0; i<V_n; i+=1)//search Wavelength
		if(W_LCD[i][0]==V_WaveLength)
			return i
		elseif(W_LCD[i][0]>V_WaveLength)
			InsertPoints i, 1, W_LCD
			W_LCD[i][0]=V_WaveLength
			return i
		endif
	endfor
	InsertPoints V_n, 1, W_LCD
	W_LCD[V_n-1][0]=V_WaveLength
	return V_n-1
end


Function LCD_Control_makeLine(Amp1,Amp2, Amp3)
	Variable Amp1		//change delay
	Variable Amp2		//change polarizetion
	Variable Amp3		//QWP
	Make/O/n=24 LCD_amp_ch={Amp1, Amp1, Amp1, Amp1, Amp1, Amp1, Amp1, Amp1, Amp2, Amp2, Amp2, Amp2, Amp2, Amp2, Amp2, Amp2,Amp3,Amp3,Amp3,Amp3,Amp3,Amp3,Amp3,Amp3}
	SetScale/P x 8,1,"", LCD_amp_ch
end



Function /S Gen_WavelengthList(S_RefWave, S_ListWL)//popup menue generator
	//In this proceasure, 
	//S_RefWave="M_LCD_Driving_Param"
	//S_ListWL="S_ListWL"
	String S_RefWave, S_ListWL
	Svar L_ListWL=$S_ListWL
	wave W_RefWave=$S_RefWave
	//print dimsize(W_RefWave, 0)
	Variable i
	for(i=0, L_ListWL=""; i<dimsize(W_RefWave, 0); i+=1)
		L_ListWL+=";"+num2str(W_RefWave[i][0])
	endfor
	return L_ListWL
end


Function GenVolSet(ctrlName, V_Wavelength)
	String ctrlName
	Variable V_Wavelength
	Variable i
	wave M_LCD_Driving_Param
	FindValue /V=(V_Wavelength) M_LCD_Driving_Param
	//wave W_config=$"Cfg_PMC"
	wave W_freq=$"Cfg_PMC_Frq"
	string S_cfg="Cfg_PMC"
	wave Cfg_Cell2Ch=$"Cfg_Cell2Ch"
	variable I_config_PM=0//PolarizationMode
	variable I_config_LPdeg=1//LinearPolarization_angle
	variable I_config_QWP=4//F_QWP

	switch(GetCFG(S_cfg, I_config_PM))	
		case 1://RadiallyPolarizationMode
//			LCD_amp_ch[str2num(StringFromList(p, S_ListCell2Ch))]=M_LCD_Driving_Param[V_value][p+3]
			for(i=0; i<=15; i+=1)
				W_freq[Cfg_Cell2ch[i]]=M_LCD_Driving_Param[V_value][i+3]
//				print Cfg_LCD_ch_Frq[i]-8,M_LCD_Driving_Param[V_value][i+3]
			endfor
			break
		case 2:// X-PolarizationMode(onMicroscope)
			for(i=0; i<=7; i+=1)
			//	LCD_Control_makeLine(M_LCD_Driving_Param[V_value][1], M_LCD_Driving_Param[V_value][1], 0)
				W_freq[Cfg_Cell2ch[i]]=M_LCD_Driving_Param[V_value][1]
			endfor
			
			for(i=8; i<=15; i+=1)
			//	LCD_Control_makeLine(M_LCD_Driving_Param[V_value][1], M_LCD_Driving_Param[V_value][1], 0)
				W_freq[Cfg_Cell2ch[i]]=M_LCD_Driving_Param[V_value][1]
			endfor
			OverWriteCFG(S_cfg, I_config_LPdeg, 0)

			break
		case 3:// Y-PolarizationMode(onMicroscope)
			for(i=0; i<=7; i+=1)
			//	LCD_Control_makeLine(M_LCD_Driving_Param[V_value][1], M_LCD_Driving_Param[V_value][1], 0)
				W_freq[Cfg_Cell2ch[i]]=M_LCD_Driving_Param[V_value][1]
			endfor
			
			for(i=8; i<=15; i+=1)
			//	LCD_Control_makeLine(M_LCD_Driving_Param[V_value][1], M_LCD_Driving_Param[V_value][1], 0)
				W_freq[Cfg_Cell2ch[i]]=M_LCD_Driving_Param[V_value][2]
			endfor
			
//			LCD_Control_makeLine(M_LCD_Driving_Param[V_value][1], M_LCD_Driving_Param[V_value][2], 0)
			OverWriteCFG(S_cfg, I_config_LPdeg, 90)
			break
		case 4://Azimuth
			for(i=0; i<=15; i+=1)
				W_freq[Cfg_Cell2ch[i]]=M_LCD_Driving_Param[V_value][i+19]
			endfor
			break
		case 5:// LGmode
			for(i=0; i<=7; i+=1)
				W_freq[Cfg_Cell2ch[i]]=M_LCD_Driving_Param[V_value][i+35]
			endfor
			break
		default:
			print "invalied flag"
			abort 
	endswitch
	
	variable V_VoltageQWP=M_LCD_Driving_Param[V_value][44-GetCFG(S_cfg, I_config_QWP)]
	for(i=16; i<=23; i+=1)
		W_freq[Cfg_Cell2ch[i]]=V_VoltageQWP
	endfor
//	print V_VoltageQWP
	return GetCFG(S_cfg, I_config_PM)
	
end


Function BP_LCSLM_GenChVset(CtrlName): ButtonControl
	string CtrlName
	Variable i
	Svar S_CompCurve_Bname
	//wave W_LCDSettings//W_LCDVoltages={V_WaveLength, V_x, V_y, V_Cell1, V_Cell2, V_Cell3, V_Cell4, V_Cell5, V_Cell6, V_Cell7, V_Cell8, V_Cell9, V_Cell10, V_Cell11, V_Cell12, V_Cell13, V_Cell14, V_Cell15, V_Cell16}
	variable V_ColumnNo
	//wave W_config=$"Cfg_PMC"
	variable I_config_WL=3//Wavelength
	V_ColumnNo=AddLCDSettings(PMC_GetConfig(I_config_WL))
//	FindValue /V=(V_Wavelength) /Z W_LCDSettings

//	GenLinVset("GenChVset")
	GenRadialVset("GenChVset")
//	GenAzimthVset("GenChVset")
//	GenLGVset("GenChVset")
//	GenQWPVset("GenChVset")
end

function yaxismake()
wave wave20
variable i
	for(i=0;i<6;i+=1)
		wave20[i]=0.5*pi*i
	endfor

end


//	string CtrlName
//	Variable i
//	//Svar S_CompCurve_Bname
//	wave M_LCD_Driving_Param//W_LCDFreq={V_WaveLength, V_x, V_y, V_Cell1, V_Cell2, V_Cell3, V_Cell4, V_Cell5, V_Cell6, V_Cell7, V_Cell8, V_Cell9, V_Cell10, V_Cell11, V_Cell12, V_Cell13, V_Cell14, V_Cell15, V_Cell16}
//	variable I_config_WL=3//Wavelength
//	variable I_config_PhInv=2//PhaseInversion
//	variable V_WL_nm=GetCFG("Cfg_PMC", I_config_WL)
//	variable F_inv=GetCFG("Cfg_PMC", I_config_PhInv)
//	variable V_ColumnNo=AddLCDSettings(V_WL_nm)
////	FindValue /V=(V_Wavelength) /Z M_LCD_Driving_Param
////print itemsinlist(GenRadialFset("GenChVset",V_WL_nm, F_inv))
////	print V_ColumnNo
//	wave W_LCDFreq=$"M_LCD_Driving_Param"
//	string L_LCDFreq=""
//	L_LCDFreq+=GenLinFset("GenChVset", V_WL_nm)//+";"
//	L_LCDFreq+=GenRadialFset("GenChVset",V_WL_nm, F_inv)//+";"
//	L_LCDFreq+=GenAzimthFset("GenChVset",V_WL_nm, F_inv)//+";"
//	L_LCDFreq+=GenLGFset("GenChVset",V_WL_nm, F_inv)//+";"
//	L_LCDFreq+=GenQWPFset("GenChVset",V_WL_nm)
////print L_LCDFreq
//	variable n=itemsinlist(L_LCDFreq)
	
//	for(i=1; i<=n; i+=1)
//		W_LCDFreq[V_ColumnNo][i]=str2num(StringFromList(i-1, L_LCDFreq))
////		print i
//	endfor
//end



Function GenQWPVset(ctrlname)
	string ctrlname
	variable V_ColumnNo
	Svar S_CompCurve_Bname
	Nvar V_PolCorrection
	wave W_LCDVoltages=$"W_LCDSettings"
	//wave W_config=$"Cfg_PMC"
	variable I_config_WL=3//Wavelength
	V_ColumnNo=AddLCDSettings(PMC_GetConfig(I_config_WL))
	//W_LCDVoltages[V_ColumnNo][43]=Retardation2Voltage(S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", (45+V_PolCorrection)/90*pi)//QWP on
	findvalue /T=(pi/1000) /V=((45+V_PolCorrection)/90*pi) $S_CompCurve_Bname+"_"+num2str(PMC_GetConfig(I_config_WL))+"nm_PolDir_SS"
	W_LCDVoltages[V_ColumnNo][43]=pnt2x($S_CompCurve_Bname+"_"+num2str(PMC_GetConfig(I_config_WL))+"nm_PolDir_SS", V_value)//QWP on
	findvalue /T=(pi/1000) /V=((V_PolCorrection)/90*pi) $S_CompCurve_Bname+"_"+num2str(PMC_GetConfig(I_config_WL))+"nm_PolDir_SS"
	W_LCDVoltages[V_ColumnNo][44]=pnt2x($S_CompCurve_Bname+"_"+num2str(PMC_GetConfig(I_config_WL))+"nm_PolDir_SS", V_value)//QWP off
	//W_LCDVoltages[V_ColumnNo][44]=Retardation2Voltage(S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", (V_PolCorrection)/90*pi)//QWP off
end

Function GenLinVset(ctrlname)
	string ctrlname
	variable V_ColumnNo
	Svar S_CompCurve_Bname
	Nvar V_PolCorrection
	wave W_LCDVoltages=$"W_LCDSettings"
	wave W_config=$"Cfg_PMC"
	variable I_config_WL=3//Wavelength
	V_ColumnNo=AddLCDSettings(W_config[I_config_WL])
	W_LCDVoltages[V_ColumnNo][1]=Retardation2Voltage(S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", V_PolCorrection/90*pi)
	W_LCDVoltages[V_ColumnNo][2]=Retardation2Voltage(S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", (90+V_PolCorrection)/90*pi)
end

Function GenRadialVset(ctrlname)
	string ctrlname
	variable V_ColumnNo
	Svar S_CompCurve_Bname
	//wave W_LCDVoltages=$"W_LCDSettings"
	variable i
	wave  LCD_amp_ch=$"LCD_amp_ch"
	//wave fit_wave13=$"fit_wave13"
	wave W_config=$"Cfg_PMC"
	variable I_config_WL=3//Wavelength
	variable I_config_PhInv=2//PhaseInversion
	//V_ColumnNo=AddLCDSettings(W_config[I_config_WL])
	for(i=0; i<4; i+=1)//Phase control
		//LCD_amp_ch[i]=pnt2x(fit_wave13, pi/8+(pi/4)*i)
		findvalue /T=(pi/20) /V=((22.5+45*(i+1))*pi/180) $S_CompCurve_Bname//+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS"
		print (22.5+45*(i+1))*pi/180
		print V_value
		//if(W_config[I_config_PhInv])
			LCD_amp_ch[7-i]=pnt2x($S_CompCurve_Bname, V_value)
			LCD_amp_ch[3-i]=pnt2x($S_CompCurve_Bname, V_value)
			//W_LCDVoltages[V_ColumnNo][10-i]=pnt2x($S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", V_value)
		//lse
			//W_LCDVoltages[V_ColumnNo][i+3]=pnt2x($S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", V_value)
		//endif
	endfor
	//for(i=0; i<4; i+=1)
		//findvalue /T=(pi/20) /V=((22.5+45*(i+1))*pi/180) $S_CompCurve_Bname
		//print (22.5+45*(i+1))*pi/180
		//print V_value
		//LCD_amp_ch[i+4]=pnt2x($S_CompCurve_Bname, V_value)
	//endfor
	
	
	for(i=0; i<4; i+=1)//polarization control
		//LCD_amp_ch[i]=pnt2x(fit_wave13, pi/4+(pi/2)*i)
		findvalue /T=(pi/20) /V=(2*(22.5+45*(i+1))*pi/180) $S_CompCurve_Bname//+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS"
		print 2*(22.5+45*(i+1))*pi/180
		print V_value
		LCD_amp_ch[i+10]=pnt2x($S_CompCurve_Bname, V_value)
		//W_LCDVoltages[V_ColumnNo][i+11]=pnt2x($S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", V_value)
		//W_LCDVoltages[V_ColumnNo][i+15]=pnt2x($S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", V_value)
	endfor
	for(i=2; i<4; i+=1)
		findvalue /T=(pi/20) /V=(2*(22.5+45*(i+1))*pi/180) $S_CompCurve_Bname
		print (2*(22.5+45*(i+1))*pi/180)
		print V_value
		LCD_amp_ch[i+6]=pnt2x($S_CompCurve_Bname, V_value)
	endfor
	for(i=0; i<2; i+=1)
		findvalue /T=(pi/20) /V=(2*(22.5+45*(i+1))*pi/180) $S_CompCurve_Bname
		print (2*(22.5+45*(i+1))*pi/180)
		print V_value
		LCD_amp_ch[i+14]=pnt2x($S_CompCurve_Bname, V_value)
	endfor
	
	
	for(i=16; i<24; i+=1)//polarization control
		findvalue /T=(pi/20) /V=(pi/2) $S_CompCurve_Bname
		//LCD_amp_ch[i]=pnt2x(fit_wave13, V_value)
		LCD_amp_ch[i]=2.2

	endfor
end

Function GenRadialVset_old(ctrlname)
	string ctrlname
	variable V_ColumnNo
	Svar S_CompCurve_Bname
	//wave W_LCDVoltages=$"W_LCDSettings"
	variable i
	wave  LCD_amp_ch=$"LCD_amp_ch"
	//wave fit_wave13=$"fit_wave13"
	wave W_config=$"Cfg_PMC"
	variable I_config_WL=3//Wavelength
	variable I_config_PhInv=2//PhaseInversion
	//V_ColumnNo=AddLCDSettings(W_config[I_config_WL])
	for(i=0; i<8; i+=1)//Phase control
		//LCD_amp_ch[i]=pnt2x(fit_wave13, pi/8+(pi/4)*i)
		findvalue /T=(pi/2.7) /V=((22.5+45*(i+1))*pi/180) $S_CompCurve_Bname//+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS"
		print (22.5+45*(i+1))*pi/180
		print V_value
		//if(W_config[I_config_PhInv])
			LCD_amp_ch[i]=pnt2x($S_CompCurve_Bname, V_value)
			//W_LCDVoltages[V_ColumnNo][10-i]=pnt2x($S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", V_value)
		//lse
			//W_LCDVoltages[V_ColumnNo][i+3]=pnt2x($S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", V_value)
		//endif
	endfor

	for(i=0; i<8; i+=1)//polarization control
		//LCD_amp_ch[i]=pnt2x(fit_wave13, pi/4+(pi/2)*i)
		findvalue /T=(pi/2.7) /V=(2*(22.5+45*(i+1))*pi/180) $S_CompCurve_Bname//+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS"
		print 2*(22.5+45*(i+1))*pi/180
		print V_value
		LCD_amp_ch[i+8]=pnt2x($S_CompCurve_Bname, V_value)
		//W_LCDVoltages[V_ColumnNo][i+11]=pnt2x($S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", V_value)
		//W_LCDVoltages[V_ColumnNo][i+15]=pnt2x($S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", V_value)
	endfor

	for(i=16; i<24; i+=1)//polarization control
		findvalue /T=(pi/2.7) /V=(pi/2) $S_CompCurve_Bname
		LCD_amp_ch[i]=pnt2x(fit_wave13, V_value)

	endfor
end


Function GenAzimthVset(ctrlname)
	string ctrlname
	variable V_ColumnNo
	Svar S_CompCurve_Bname
	wave W_LCDVoltages=$"W_LCDSettings"
	wave W_config=$"Cfg_PMC"
	variable I_config_WL=3//Wavelength
	variable I_config_PhInv=2//PhaseInversion
	V_ColumnNo=AddLCDSettings(W_config[I_config_WL])
	Variable i
	for(i=0; i<8; i+=1)//Phase control
//	print "Phase ", i
		if(W_config[I_config_PhInv])
			W_LCDVoltages[V_ColumnNo][26-i]=Retardation2Voltage(S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", (22.5+45*i)*pi/180)
		else
			W_LCDVoltages[V_ColumnNo][i+19]=Retardation2Voltage(S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", (22.5+45*i)*pi/180)
		endif
	endfor
	for(i=0; i<4; i+=1)//polarization control
//		print "polarization ", i, i+4
		W_LCDVoltages[V_ColumnNo][i+27]=Retardation2Voltage(S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", 2*(22.5+45*i)*pi/180)
		W_LCDVoltages[V_ColumnNo][i+31]=Retardation2Voltage(S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", 2*(22.5+45*i)*pi/180)
	endfor
end

Function GenLGVset(ctrlName)
	string ctrlName
	variable V_ColumnNo
	Svar S_CompCurve_Bname
	wave W_LCDVoltages=$"W_LCDSettings"
	Variable i
	wave W_config=$"Cfg_PMC"
	variable I_config_WL=3//Wavelength
	variable I_config_PhInv=2//PhaseInversion
	V_ColumnNo=AddLCDSettings(W_config[I_config_WL])
//	print "Phase ", i
	for(i=0; i<8; i+=1)//Phase control
		if(W_config[I_config_PhInv])
			W_LCDVoltages[V_ColumnNo][42-i]=Retardation2Voltage(S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", (22.5+45*i)*pi/180)
		else
			W_LCDVoltages[V_ColumnNo][i+35]=Retardation2Voltage(S_CompCurve_Bname+"_"+num2str(W_config[I_config_WL])+"nm_PolDir_SS", (22.5+45*i)*pi/180)
		endif
	endfor
end


Function Retardation2Voltage(S_Wname, V_Ret_rad)
	string S_Wname
	variable V_Ret_rad
	variable i
	wave W_Vol2Ret=$S_Wname
	for(i=0; i<numpnts(W_Vol2Ret)-1; i+=1)
		if((W_Vol2Ret[i]-V_Ret_rad)*(W_Vol2Ret[i+1]-V_Ret_rad)<0)
			return pnt2x(W_Vol2Ret, i)+(pnt2x(W_Vol2Ret, i+1)-pnt2x(W_Vol2Ret, i))*(V_Ret_rad-W_Vol2Ret[i])/(W_Vol2Ret[i+1]-W_Vol2Ret[i])
		elseif((W_Vol2Ret[i]-V_Ret_rad-2*pi)*(W_Vol2Ret[i+1]-V_Ret_rad-2*pi)<0)
			return pnt2x(W_Vol2Ret, i)+(pnt2x(W_Vol2Ret, i+1)-pnt2x(W_Vol2Ret, i))*(V_Ret_rad+2*pi-W_Vol2Ret[i])/(W_Vol2Ret[i+1]-W_Vol2Ret[i])
		elseif((W_Vol2Ret[i]-V_Ret_rad+2*pi)*(W_Vol2Ret[i+1]-V_Ret_rad+2*pi)<0)
			return pnt2x(W_Vol2Ret, i)+(pnt2x(W_Vol2Ret, i+1)-pnt2x(W_Vol2Ret, i))*(V_Ret_rad-2*pi-W_Vol2Ret[i])/(W_Vol2Ret[i+1]-W_Vol2Ret[i])
		endif
	endfor
	for(i=0; i<numpnts(W_Vol2Ret)-1; i+=1)
		if(abs(W_Vol2Ret[i]) < abs(V_Ret_rad) && abs(W_Vol2Ret[i+1]) > abs(V_Ret_rad))
			return pnt2x(W_Vol2Ret, i)+(pnt2x(W_Vol2Ret, i+1)-pnt2x(W_Vol2Ret, i))*(V_Ret_rad-W_Vol2Ret[i])/(W_Vol2Ret[i+1]-W_Vol2Ret[i])
		elseif(abs(W_Vol2Ret[i]) < abs(V_Ret_rad+2*pi) && abs(W_Vol2Ret[i+1]) > abs(V_Ret_rad+2*pi))
			return pnt2x(W_Vol2Ret, i)+(pnt2x(W_Vol2Ret, i+1)-pnt2x(W_Vol2Ret, i))*(V_Ret_rad+2*pi-W_Vol2Ret[i])/(W_Vol2Ret[i+1]-W_Vol2Ret[i])
		endif
	endfor
	print "Error"
//findvalue
end





Function /S GenQWPFset(ctrlname,V_WL_nm)
	string ctrlname
	variable V_WL_nm
//	Svar S_CompCurve_Bname
//	Nvar V_PolCorrection
//	wave W_LCDFreq=$"M_LCD_Driving_Param"
	wave W_Phs_Frq=Extract_Phs_Frq(V_WL_nm)
	wave W_config=$"Cfg_PMC"
	string L_LinFset=""
	//W_LCDFreq[V_ColumnNo][43]=Rtd2Frq(S_CompCurve_Bname+"_PolDir_SS", (45+V_PolCorrection)/90*pi)//QWP on
	findvalue /T=(pi/1000) /V=(45/90*pi) W_Phs_Frq
	L_LinFset+=num2strD(pnt2x(W_Phs_Frq, V_value))+";"//QWP on
//	print V_value
	//W_LCDFreq[V_ColumnNo][43]=pnt2x($S_CompCurve_Bname+"_PolDir_SS", V_value)//QWP on
	findvalue /T=(pi/1000) /V=0 W_Phs_Frq
	L_LinFset+=num2strD(pnt2x(W_Phs_Frq, V_value))+";"//QWP off
//	print V_value
	//W_LCDFreq[V_ColumnNo][44]=pnt2x($S_CompCurve_Bname+"_PolDir_SS", V_value)//QWP off
	//W_LCDFreq[V_ColumnNo][44]=Rtd2Frq(S_CompCurve_Bname+"_PolDir_SS", (V_PolCorrection)/90*pi)//QWP off
	return L_LinFset
end

function /WAVE Extract_Phs_Frq(V_WL_nm)
	variable V_WL_nm
	wave M_Phase_Frq_WL
	variable P_wl=x2pntMD(M_Phase_Frq_WL,1,V_WL_nm*1e-9)
//	print P_wl
	ImageTransform /G=(P_wl) getCol M_Phase_Frq_WL
	CopyScales /I M_Phase_Frq_WL, W_ExtractedCol
	Duplicate /D /O W_ExtractedCol, W_PolDir
	return W_PolDir
end

Function /S GenLinFset(ctrlname, V_WL_nm)
	string ctrlname
	variable V_WL_nm
	variable I_PCorr=6; 
	variable V_PolCorrection=GetCFG("Cfg_PMC", I_PCorr)
	string L_LinFset=""
	wave W_Phs_Frq=Extract_Phs_Frq(V_WL_nm)
	findvalue /T=(pi/1000) /V=(2*(90+V_PolCorrection)/180*pi) W_Phs_Frq
	L_LinFset+=num2strD(pnt2x(W_Phs_Frq, V_value))+";"

	//L_LinFset+=num2strD(Rtd2Frq("W_ExtractedCol", 2*(90+V_PolCorrection)/180*pi, V_WL_nm))+";"
	findvalue /T=(pi/1000) /V=( 2*V_PolCorrection/180*pi) W_Phs_Frq

	L_LinFset+=num2strD(pnt2x(W_Phs_Frq, V_value))+";"
	//L_LinFset+=num2strD(Rtd2Frq("W_ExtractedCol", 2*V_PolCorrection/180*pi, V_WL_nm))
	
	//wave W_LCDFreq=$"M_LCD_Driving_Param"
	//W_LCDFreq[V_ColumnNo][1]=
	//W_LCDFreq[V_ColumnNo][2]=

	return L_LinFset
end

Function /S GenRadialFset(ctrlname,V_WL_nm, F_inv)
	string ctrlname
	variable V_WL_nm, F_inv
	//wave W_LCDFreq=$"M_LCD_Driving_Param"
	Variable i,j
	string L_LinFset=""
	//wave W_config=$"Cfg_PMC"
	//variable I_config_WL=3//Wavelength
	wave W_Phs_Frq=Extract_Phs_Frq(V_WL_nm)
	for(i=0; i<8; i+=1)//Phase control
		findvalue /T=(pi/1000) /V=((22.5+45*i)*pi/180) W_Phs_Frq
		if(F_inv)
			L_LinFset=num2strD(pnt2x(W_Phs_Frq, V_value))+";"+L_LinFset
		else
			L_LinFset+=num2strD(pnt2x(W_Phs_Frq, V_value))+";"
		endif
	endfor
	for(j=0; j<2; j+=1)
		for(i=0; i<4; i+=1)//polarization control
			findvalue /T=(pi/1000) /V=((22.5+45*i)*pi/180) W_Phs_Frq
			//W_LCDFreq[V_ColumnNo][i+11]=pnt2x($"M_Phase_Frq_WL", V_value)
			//W_LCDFreq[V_ColumnNo][i+15]=pnt2x($"M_Phase_Frq_WL", V_value)
			L_LinFset+=num2strD(pnt2x(W_Phs_Frq, V_value))+";"
		endfor
	endfor
	return L_LinFset
end

Function /S GenAzimthFset(ctrlname,V_WL_nm, F_inv)
	string ctrlname
	variable V_WL_nm, F_inv
//	Svar S_CompCurve_Bname
//	wave W_LCDFreq=$"M_LCD_Driving_Param"
//	variable I_config_PhInv=2//PhaseInversion
	wave W_Phs_Frq=Extract_Phs_Frq(V_WL_nm)
	Variable i,j
	string L_LinFset=""
	for(i=0; i<8; i+=1)//Phase control
//	print "Phase ", i
		findvalue /T=(pi/1000) /V=((22.5+45*i)*pi/180) W_Phs_Frq
		if(F_inv)
//--			W_LCDFreq[V_ColumnNo][26-i]=Rtd2Frq(S_CompCurve_Bname+"_PolDir_SS", (22.5+45*i)*pi/180)
			L_LinFset=num2strD(pnt2x(W_Phs_Frq, V_value))+";"+L_LinFset
		else
//--			W_LCDFreq[V_ColumnNo][i+19]=Rtd2Frq(S_CompCurve_Bname+"_PolDir_SS", (22.5+45*i)*pi/180)
			L_LinFset+=num2strD(pnt2x(W_Phs_Frq, V_value))+";"
		endif
	endfor
	for(j=0; j<2; j+=1)
		for(i=0; i<4; i+=1)//polarization control
//			print "polarization ", i, i+4 
			findvalue /T=(pi/1000) /V=(2*(22.5+45*i)*pi/180) W_Phs_Frq
			L_LinFset+=num2strD(pnt2x(W_Phs_Frq, V_value))+";"
//--		W_LCDFreq[V_ColumnNo][i+27]=Rtd2Frq(S_CompCurve_Bname+"_PolDir_SS", 2*(22.5+45*i)*pi/180)
//--		W_LCDFreq[V_ColumnNo][i+31]=Rtd2Frq(S_CompCurve_Bname+"_PolDir_SS", 2*(22.5+45*i)*pi/180)
		endfor
	endfor
	return L_LinFset
end

Function /S GenLGFset(ctrlName, V_WL_nm, F_inv)
	string ctrlName
	variable V_WL_nm, F_inv
//	Svar S_CompCurve_Bname
//	wave W_LCDFreq=$"M_LCD_Driving_Param"
	wave W_Phs_Frq=Extract_Phs_Frq(V_WL_nm)
	Variable i,j
	string L_LinFset=""
//	variable I_config_PhInv=2//PhaseInversion
//	print "Phase ", i
	for(i=0; i<8; i+=1)//Phase control
		findvalue /T=(pi/1000) /V=((22.5+45*i)*pi/180) W_Phs_Frq
		if(F_inv)
			L_LinFset=num2strD(pnt2x(W_Phs_Frq, V_value))+";"+L_LinFset
//			W_LCDFreq[V_ColumnNo][42-i]=Rtd2Frq(S_CompCurve_Bname+"_PolDir_SS", (22.5+45*i)*pi/180)
		else
			L_LinFset+=num2strD(pnt2x(W_Phs_Frq, V_value))+";"
//			W_LCDFreq[V_ColumnNo][i+35]=Rtd2Frq(S_CompCurve_Bname+"_PolDir_SS", (22.5+45*i)*pi/180)
		endif
	endfor
	return L_LinFset
end

//Function /S GenCorrTable(S_ListCh)
	//S_ListCh:	Channel Number connected by i th Cell
	//A String S_ListCh is required
//	String S_ListCh
//	String S_Output
//	Variable i
//	if(ItemsInList(S_ListCh)!=16)
//		print "Input Lists is invalid..."
//		return ""
//	endif
//	for(i=0; i<ItemsInList(S_ListCh); i+=1, S_Output+=";")
//		S_Output+=StringFromList(i, S_ListCh)
//	endfor
//	return S_Output
//end


function LCDwaveformGenerator_old(ctrlName)          
	string ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_config_Freq=5//DrivingFrequency
	variable V_Freq=W_config[I_config_Freq]
	variable ch, i
	wave LCD_amp_ch
	Svar L_LCDWavelist
	Svar S_PwrCtrlWave
	Nvar V_PwrCtrlCh
	Nvar F_LCDWaveform, V_LCD_WDuty
	L_LCDWavelist=""
	variable npnts=20000//200
	variable xstep=5e-6
	variable V_pulsewidth=V_LCD_WDuty/100/V_Freq
	variable V_cycle=1/V_Freq
	//F_WF 1: Sin, 2: Square, 3: triangle
	for(ch=8; ch <24; ch +=1)
		make/O/N=(npnts)  $"LCD_Ctrl_Wave"+num2str(ch)
		SetScale/P x 0, (xstep), "s" $"LCD_Ctrl_Wave"+num2str(ch)
		wave w=$"LCD_Ctrl_Wave"+num2str(ch)
		switch(F_LCDWaveform)
			case 1:
				w= LCD_amp_ch[ch-8]*sin(2*Pi*x*V_Freq)
				break
			case 2:
				w=LCD_amp_ch[ch-8]*(-2*(mod(x, 1/V_Freq)>(V_pulsewidth))+1)
				break
			case 3:
				w=-LCD_amp_ch[ch-8]*((2*mod(x, V_cycle)/V_pulsewidth-1)*(mod(x, V_cycle)<=V_pulsewidth)+(mod(x, V_cycle)>V_pulsewidth)*(-2*(mod(x, V_cycle)-V_pulsewidth)/((1-V_LCD_WDuty/100)*V_cycle)+1))
				break
			default:
		endswitch
		L_LCDWavelist = L_LCDWavelist + "LCD_Ctrl_Wave"+num2str(ch)+","+num2str(ch) +";"
	endfor
	L_LCDWavelist+=S_PwrCtrlWave+","+num2str(V_PwrCtrlCh)+";"
end

function LCDwaveformGenerator(ctrlName)
	string ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_config_Freq=5//DrivingFrequency
	variable I_config_PwrCtrl=9//F_PwrCtrl
	variable V_Freq=W_config[I_config_Freq]
	variable i
	wave Cfg_LCD_ch_Frq
	Svar L_LCDWavelist
	Svar S_PwrCtrlWave
	Nvar V_PwrCtrlCh
	Nvar F_LCDWaveform, V_LCD_WDuty
	L_LCDWavelist=""
	variable npnts=20000//200
	variable xstep=5e-6
	variable V_pulsewidth=V_LCD_WDuty/100/V_Freq
	variable V_cycle=1/V_Freq
	//F_WF 1: Sin, 2: Square, 3: triangle
	for(i=0; i <24; i +=1)
		make/O/N=(npnts)  $"LCD_Ctrl_Wave"+num2str( pnt2x(Cfg_LCD_ch_Frq, i) )
		SetScale/P x 0, (xstep), "s" $"LCD_Ctrl_Wave"+num2str(pnt2x( Cfg_LCD_ch_Frq, i) )
		wave w=$"LCD_Ctrl_Wave"+num2str( pnt2x(Cfg_LCD_ch_Frq, i) )
		switch(F_LCDWaveform)
			case 1:
				w= Cfg_LCD_ch_Frq[i]*sin(2*Pi*x*V_Freq)
				break
			case 2:
				w=Cfg_LCD_ch_Frq[i]*(-2*(mod(x, 1/V_Freq)>(V_pulsewidth))+1)
				break
			case 3:
				w=-Cfg_LCD_ch_Frq[i]*((2*mod(x, V_cycle)/V_pulsewidth-1)*(mod(x, V_cycle)<=V_pulsewidth)+(mod(x, V_cycle)>V_pulsewidth)*(-2*(mod(x, V_cycle)-V_pulsewidth)/((1-V_LCD_WDuty/100)*V_cycle)+1))
				break
			default:
		endswitch
		L_LCDWavelist = L_LCDWavelist + "LCD_Ctrl_Wave"+num2str(pnt2x(Cfg_LCD_ch_Frq, i))+","+num2str(pnt2x(Cfg_LCD_ch_Frq, i)) +";"
	endfor
	if(W_config[I_config_PwrCtrl])
		L_LCDWavelist+=S_PwrCtrlWave+","+num2str(V_PwrCtrlCh)+";"
	endif
end

Function LCD_Control_pol(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
//	Svar S_ListCell2Ch
	variable I_config_PM=0//PolarizationMode
	variable I_config_WLnm=3//Wavelength
	variable V_WLnm=GetCFG("Cfg_PMC", I_config_WLnm)
	//Cfg_PMC[0]=	1: Rarially polarization
	//				2: X polarization
	//				3: Y polarization
	//				4: Azimuthal polarization
	//				5: Laguerre-Gauss beam
	OverWriteCFG("Cfg_PMC", I_config_PM, popNum)
	GenVolSet("LCD_Control_pol", V_WLnm)
	RS232_StrWrite(genStrPMC_sglCHs("SVP_PMC_SetFreq"))
	//print W_config[I_config_WL]
	//LCDwaveformGenerator("LCD_Control_pol")
	
end



Function C_PhaseInv(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	wave W_config=$"Cfg_PMC"
	variable I_config=0//PolarizationMode
	variable I_config_PhInv=2//PhaseInversion
	W_config[I_config_PhInv]=checked
	BP_LCSLM_GenChVset("C_PhaseInv")
	LCD_Control_pol("C_PhaseInv", W_config[I_config], "")
	// Basename is unchangable in GenChVset(V_Wavelength)
	LCDwaveformGenerator("C_PhaseInv")
End


Function SV_LCDDutyCTRL(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	LCDwaveformGenerator3("SV_LCDDutyCTRL")
End

Function PM_LCDWaveform(ctrlName,popNum,popStr) : PopupMenuControl             //20151111改造
	String ctrlName
	Variable popNum
	String popStr
	Nvar F_LCDWaveform
	F_LCDWaveform=popNum
	LCDwaveformGenerator3("PM_LCDWaveform")      //LCDwaveformGenerator("PM_LCDWaveform")      
End





Function LCD_Ctrl_ButtonProc2(ctrlName) : ButtonControl
	String	ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_config_ON=4//LCD_ON
	variable I_config_DNo=6//DevNo
	string S_deviceName="Dev"+num2str(W_config[I_config_DNo])
	String	Mess

	if(W_config[I_config_ON] == 0)
		Button LCD_Ctrl,proc=LCD_Ctrl_ButtonProc,title="Stop", fColor=(65280,48896,48896),win=LCD_Control
		LCDwaveformGenerator("")
		W_config[I_config_ON]=1
	else
		Button LCD_Ctrl,proc=LCD_Ctrl_ButtonProc,title="Ctrl",fColor=(0,0,0), win=LCD_Control
		LCDwaveformGenerator0("")
		W_config[I_config_ON]=0
	endif

	Svar		L_LCDWavelist
	Svar		L_LCDWavelist2
	Mess = L_LCDWavelist + L_LCDWavelist2
	//fDAQmx_WaveformStop(S_deviceName) 
	//DAQmx_WaveformGen/DEV=S_deviceName Mess
End


function LCDwaveformGenerator0(ctrlName)
	string	ctrlName
	variable	ch, i
	variable	npnts=20000//200
	variable	xstep=5e-6
	Svar		L_LCDWavelist

	L_LCDWavelist=""
	for(ch=8; ch <24; ch +=1)
		make/O/N=(npnts)  $"LCD_Ctrl_Wave"+num2str(ch)
		SetScale/P x 0, (xstep), "s" $"LCD_Ctrl_Wave"+num2str(ch)
		wave w=$"LCD_Ctrl_Wave"+num2str(ch)
		w= 0
		L_LCDWavelist = L_LCDWavelist + "LCD_Ctrl_Wave"+num2str(ch)+","+num2str(ch) +";"
	endfor
end


//	This function changes incident beam power
//	F_WF 1: Sin, 2: Square, 3: triangle
function LCDwaveformGenerator2(ctrlName)
	String	ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_config_Freq=5//DrivingFrequency
	variable V_Freq=W_config[I_config_Freq]
	variable	ch = 24
	Svar		L_LCDWavelist2
	Nvar		F_LCDWaveform, V_LCD_WDuty
	variable	LCD_Amp=2
	variable	npnts=20000//200
	variable	xstep=5e-6
	variable	V_pulsewidth=V_LCD_WDuty/100/V_Freq
	variable	V_cycle=1/V_Freq

	make/O/N=(npnts)  $"LCD_Ctrl_Wave"+num2str(ch)
	SetScale/P x 0, (xstep), "s" $"LCD_Ctrl_Wave"+num2str(ch)
	wave w=$"LCD_Ctrl_Wave"+num2str(ch)
	switch(F_LCDWaveform)
		case 1:
			w= LCD_Amp*sin(2*Pi*x*V_Freq)
			break
		case 2:
			w=LCD_Amp*(-2*(mod(x, 1/V_Freq)>(V_pulsewidth))+1)
			break
		case 3:
			w=-LCD_Amp*((2*mod(x, V_cycle)/V_pulsewidth-1)*(mod(x, V_cycle)<=V_pulsewidth)+(mod(x, V_cycle)>V_pulsewidth)*(-2*(mod(x, V_cycle)-V_pulsewidth)/((1-V_LCD_WDuty/100)*V_cycle)+1))
			break
		default:
	endswitch
	L_LCDWavelist2 = "LCD_Ctrl_Wave"+num2str(ch)+","+num2str(ch) +";"
end

Function SV_LCDFreqCTRL(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	LCDwaveformGenerator3("SV_LCDFreqCTRL")
End



Function Pop_ChangeWL(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	//wave W_config=$"Cfg_PMC"
	variable I_config_WL=3//Wavelength
	OverWriteCFG("Cfg_PMC", I_config_WL, str2num(popStr))

//	W_config[I_config_WL]=str2num(popStr)
	//if(str2num(popStr)<925&&str2num(popStr)>715)
	//	Chameleon_WAVELENGTHControl("Pop_ChangeWL",W_config[I_config_WL],popStr,"V_Chameleon_WAVELENGTH")
	//endif
End


Gen_WavelengthList

function LCDPolVol(V_num)
	variable V_num
	wave Cfg_LCD_ch_Frq
	Cfg_LCD_ch_Frq=0
	Cfg_LCD_ch_Frq[0]=V_num
	Cfg_LCD_ch_Frq[1]=V_num
	Cfg_LCD_ch_Frq[2]=V_num
	Cfg_LCD_ch_Frq[3]=V_num
	Cfg_LCD_ch_Frq[4]=V_num
	Cfg_LCD_ch_Frq[5]=V_num
	Cfg_LCD_ch_Frq[6]=V_num
	Cfg_LCD_ch_Frq[7]=V_num
	LCDwaveformGenerator3("LCDPolVol")
end



Function CB_PwrCtrl(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	wave W_config=$"Cfg_PMC"
	variable I_config_PwrCtrl=9//F_PwrCtrl
	W_config[I_config_PwrCtrl]=checked
End

Function SV_Angle(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	variable I_config_LPdeg=1//LinearPolarization_angle
	variable I_config_WL=3//Wavelength
	variable I_config_PolCor=7//PolarizationCorrection
	variable I_config_QWP=8//F_QWP
	//Svar S_CompCurve_Bname
	
	variable Amp1,Amp2, Amp3
	OverWriteCFG("Cfg_PMC", I_config_LPdeg, varNum)
	//W_config[I_config_LPdeg]=varNum
	variable V_wl_nm=GetCFG("Cfg_PMC", I_config_WL)
	variable V_LPdeg=GetCFG("Cfg_PMC", I_config_LPdeg)
	variable V_PolCor=GetCFG("Cfg_PMC", I_config_PolCor)
	variable F_QWP=GetCFG("Cfg_PMC", I_config_QWP)
	wave W_PolDir=Extract_Phs_Frq(V_wl_nm)
	findvalue /T=(pi/1000) /V=0 W_PolDir
	//Amp1=Rtd2Frq(S_CompCurve_Bname+"_PolDir_SS", 0, V_wl)
	Amp1=V_value
	//Amp2=Rtd2Frq(S_CompCurve_Bname+"_PolDir_SS", (V_LPdeg+90+V_PolCor)/90*pi)
	findvalue /T=(pi/1000) /V=((V_LPdeg+V_PolCor)/180*pi) W_PolDir
	Amp2=V_value
	
	//Rtd2Frq(S_CompCurve_Bname+"_PolDir_SS", (V_LPdeg+V_PolCor)/180*pi)
	if(F_QWP)
		findvalue /T=(pi/1000) /V=(pi/2) W_PolDir
		Amp3=V_value
		//Amp3=Rtd2Frq(S_CompCurve_Bname+"_PolDir_SS", pi/2, V_wl)
	else
		findvalue /T=(pi/1000) /V=0 W_PolDir
		Amp3=V_value
		//Amp3=Rtd2Frq(S_CompCurve_Bname+"_PolDir_SS", 0, V_wl)
	endif
	LCD_Control_makeLine(Amp1, Amp2, Amp3)
	LCDwaveformGenerator("LCD_Control_pol")
End


Function CB_QWP(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	wave W_config=$"Cfg_PMC"
	variable I_config_QWP=7//F_QWP
	W_config[I_config_QWP]=checked
	Svar S_ListCell2Ch
	variable I_config_WL=3//Wavelength
	GenVolSet(S_ListCell2Ch, W_config[I_config_WL])
	LCDwaveformGenerator("LCD_Control_pol")
End


Function refleshPMC(ctrlName)
	String ctrlName
	wave Cfg_PMC_amp=Cfg_PMC_amp
	wave Cfg_PMC_Frq=Cfg_PMC_Frq
	variable i
	String S_res
	for(i=0;i<24;i+=1)
		S_res=DS_Read("refleshPMC", "/"+num2str(i)+","+num2str(Cfg_PMC_Frq[i])+","+num2str(Cfg_PMC_Amp[i]), "\r")
			if(stringmatch(S_res, "OK"))
	//	print i,"OK"
	elseif(stringmatch(S_res, "NG"))
		print i,"NG"
	else
		print i,"error"
	endif
	endfor

	return 0
End

Function SVP_PMC_SetSignal_Ch_strct(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva
	// printWMSetVariableAction(sva)
	string ctrlName=sva.ctrlName
	variable V_CNo=str2num(ReplaceString("CH", ctrlName, ""))
	//print V_CNo
	wave Cfg_PMC_amp=Cfg_PMC_amp
	wave Cfg_PMC_Frq=Cfg_PMC_Frq
	//print nameofwave(svwave)
			Variable dval = sva.dval
			String sval = sva.sval
	switch( sva.eventCode )
		case 1: // mouse up
			print DS_Read("SVP_PMC_SetSignal_Ch", "/"+num2str(V_CNo)+","+num2str(Cfg_PMC_Frq[V_CNo])+","+num2str(Cfg_PMC_Amp[V_CNo]), "\r")
		break
		case 2: // Enter key
			print DS_Read("SVP_PMC_SetSignal_Ch", "/"+num2str(V_CNo)+","+num2str(Cfg_PMC_Frq[V_CNo])+","+num2str(Cfg_PMC_Amp[V_CNo]), "\r")

//			print DS_Read("SVP_PMC_SetSignal_Ch", "/8,1800,8", "\r")
		break
		case 3: // Live update
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function SVP_PMC_SetFreq(sva) : SetVariableControl                 //"%3.3W0PHz"パネルの表記
	STRUCT WMSetVariableAction &sva
	// printWMSetVariableAction(sva)
	string ctrlName=sva.ctrlName
	variable V_CNo=str2num(ReplaceString("CH", ctrlName, ""))
	wave svWave=sva.svWave
	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			//RS232_StrWrite(genStrPMC_sglCHs("SVP_PMC_SetFreq"))
			RS232_StrWrite(genStrPMC_sglCH("SVP_PMC_SetFreq", V_CNo, dval))
			
			string S_Err=RS232_StrRead("SVP_PMC_SetFreq")
			if(stringmatch(S_Err, num2char(0x06)))
			//	print S_Err, " is ", "0x06"
			elseif(stringmatch(S_Err, num2char(0x15)+num2char(0x15)))
				print S_Err, " is ", "0x15"
			else
				print "error", S_Err, char2num(S_Err)
			endif
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function BP_PMC_refresh_24ch(ctrlName) : ButtonControl
	String ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_LCD_ON=4//LCD_ON
	variable I_config_USB=8//F_USB_enable
	wave Cfg_PMC_amp, Cfg_PMC_frq
	Variable V_ch
		if(W_config[I_LCD_ON] != 0)
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch8,0.0;LCD_amp_ch9,0.1;LCD_amp_ch10,0.2;LCD_amp_ch11,0.3;LCD_amp_ch12,0.4;LCD_amp_ch13,0.5;LCD_amp_ch14,0.6;LCD_amp_ch15,0.7;LCD_amp_ch16,0.8;LCD_amp_ch17,0.9;LCD_amp_ch18,1.0;LCD_amp_ch19,1.1;LCD_amp_ch20,1.2;"
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch21,1.3;LCD_amp_ch22,1.4;LCD_amp_ch23,1.5;LCD_amp_ch24,1.6;LCD_amp_ch25,1.7;LCD_amp_ch26,1.8;LCD_amp_ch27,1.9;LCD_amp_ch28,2.0;LCD_amp_ch29,2.1;LCD_amp_ch30,2.2;LCD_amp_ch31,2.3;"//L_LCDWavelist
		if(W_config[I_config_USB])
			String S_res				
			for(V_ch=0; V_ch<24 ;V_ch+=1)
				//print V_ch+1, "/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch])
					//RS232_StrWrite("/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch]))
					//RS232_StrRead(CtrlName)
					S_res=DS_Read("BP_PMC_refresh", "/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_Frq[V_ch])+","+num2str(Cfg_PMC_Amp[V_ch]), "\r")
					//print S_res
			//print  "/"+num2str(V_ch)+","+num2str(Cfg_PMC_Frq[V_ch])+","+num2str(Cfg_PMC_Amp[V_ch])		
					
					if(stringmatch(S_res, "NG"))
					print "NG"
					elseif(stringmatch(S_res, "OK"))
					else
					print "no response"
					endif
					
				endfor
			else
				//	DAQmx_WaveformGen/DEV=S_deviceName L_LCDWavelist
			endif
		endif
end

Function BP_PMC_refresh_LC1_24ch(ctrlName) : ButtonControl
	String ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_LCD_ON=4//LCD_ON
	variable I_config_USB=8//F_USB_enable
	wave Cfg_PMC_amp, Cfg_PMC_frq
	Variable V_ch
		if(W_config[I_LCD_ON] != 0)
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch8,0.0;LCD_amp_ch9,0.1;LCD_amp_ch10,0.2;LCD_amp_ch11,0.3;LCD_amp_ch12,0.4;LCD_amp_ch13,0.5;LCD_amp_ch14,0.6;LCD_amp_ch15,0.7;LCD_amp_ch16,0.8;LCD_amp_ch17,0.9;LCD_amp_ch18,1.0;LCD_amp_ch19,1.1;LCD_amp_ch20,1.2;"
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch21,1.3;LCD_amp_ch22,1.4;LCD_amp_ch23,1.5;LCD_amp_ch24,1.6;LCD_amp_ch25,1.7;LCD_amp_ch26,1.8;LCD_amp_ch27,1.9;LCD_amp_ch28,2.0;LCD_amp_ch29,2.1;LCD_amp_ch30,2.2;LCD_amp_ch31,2.3;"//L_LCDWavelist
		if(W_config[I_config_USB])
			String S_res				
			for(V_ch=0; V_ch<8 ;V_ch+=1)
				//print V_ch+1, "/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch])
					//RS232_StrWrite("/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch]))
					//RS232_StrRead(CtrlName)
					S_res=DS_Read("BP_PMC_refresh", "/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_Frq[V_ch])+","+num2str(Cfg_PMC_Amp[V_ch]), "\r")
					//print S_res
			//print  "/"+num2str(V_ch)+","+num2str(Cfg_PMC_Frq[V_ch])+","+num2str(Cfg_PMC_Amp[V_ch])		
					
					if(stringmatch(S_res, "NG"))
					print "NG"
					elseif(stringmatch(S_res, "OK"))
					else
					print "no response"
					endif
					
				endfor
			else
				//	DAQmx_WaveformGen/DEV=S_deviceName L_LCDWavelist
			endif
		endif
end

Function BP_PMC_refresh_48ch(ctrlName) : ButtonControl
	String ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_LCD_ON=4//LCD_ON
	variable I_config_USB=8//F_USB_enable
	wave Cfg_PMC_amp, Cfg_PMC_frq
	Variable V_ch
		if(W_config[I_LCD_ON] != 0)
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch8,0.0;LCD_amp_ch9,0.1;LCD_amp_ch10,0.2;LCD_amp_ch11,0.3;LCD_amp_ch12,0.4;LCD_amp_ch13,0.5;LCD_amp_ch14,0.6;LCD_amp_ch15,0.7;LCD_amp_ch16,0.8;LCD_amp_ch17,0.9;LCD_amp_ch18,1.0;LCD_amp_ch19,1.1;LCD_amp_ch20,1.2;"
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch21,1.3;LCD_amp_ch22,1.4;LCD_amp_ch23,1.5;LCD_amp_ch24,1.6;LCD_amp_ch25,1.7;LCD_amp_ch26,1.8;LCD_amp_ch27,1.9;LCD_amp_ch28,2.0;LCD_amp_ch29,2.1;LCD_amp_ch30,2.2;LCD_amp_ch31,2.3;"//L_LCDWavelist
		if(W_config[I_config_USB])
			String S_res				
			for(V_ch=0; V_ch<24 ;V_ch+=1)
				//print V_ch, "/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch])
					//RS232_StrWrite("/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch]))
					//RS232_StrRead(CtrlName)
					S_res=DS_Read("BP_PMC_refresh", "/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_Frq[V_ch])+","+num2str(Cfg_PMC_Amp[V_ch]), "\r")
					//print S_res
					if(stringmatch(S_res, "NG"))
					print "NG"
					elseif(stringmatch(S_res, "OK"))
					else
					print "no response"
					endif
					
				endfor
			else
				//	DAQmx_WaveformGen/DEV=S_deviceName L_LCDWavelist
			endif
		endif
end



Function BP_PMC_refresh_8ch(ctrlName) : ButtonControl
	String ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_LCD_ON=4//LCD_ON
	variable I_config_USB=8//F_USB_enable
	wave Cfg_PMC_amp, Cfg_PMC_frq
	Variable V_ch
		if(W_config[I_LCD_ON] != 0)
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch8,0.0;LCD_amp_ch9,0.1;LCD_amp_ch10,0.2;LCD_amp_ch11,0.3;LCD_amp_ch12,0.4;LCD_amp_ch13,0.5;LCD_amp_ch14,0.6;LCD_amp_ch15,0.7;LCD_amp_ch16,0.8;LCD_amp_ch17,0.9;LCD_amp_ch18,1.0;LCD_amp_ch19,1.1;LCD_amp_ch20,1.2;"
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch21,1.3;LCD_amp_ch22,1.4;LCD_amp_ch23,1.5;LCD_amp_ch24,1.6;LCD_amp_ch25,1.7;LCD_amp_ch26,1.8;LCD_amp_ch27,1.9;LCD_amp_ch28,2.0;LCD_amp_ch29,2.1;LCD_amp_ch30,2.2;LCD_amp_ch31,2.3;"//L_LCDWavelist
		if(W_config[I_config_USB])
			String S_res				
			for(V_ch=0; V_ch<8 ;V_ch+=1)//(V_ch=0; V_ch<24 ;V_ch+=1)
				//print V_ch, "/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch])
					//RS232_StrWrite("/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch]))
					//RS232_StrRead(CtrlName)
					S_res=DS_Read("BP_PMC_refresh", "/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_Frq[V_ch])+","+num2str(Cfg_PMC_Amp[V_ch]), "\r")
					//print S_res
					if(stringmatch(S_res, "NG"))
					print "NG"
					elseif(stringmatch(S_res, "OK"))
					else
					print "no response"
					endif
					
				endfor
			else
				//	DAQmx_WaveformGen/DEV=S_deviceName L_LCDWavelist
			endif
		endif
end

Function BP_PMC_refresh_1ch(ctrlName) : ButtonControl
	String ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_LCD_ON=4//LCD_ON
	variable I_config_USB=8//F_USB_enable
	wave Cfg_PMC_amp, Cfg_PMC_frq
	Variable V_ch
		if(W_config[I_LCD_ON] != 0)
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch8,0.0;LCD_amp_ch9,0.1;LCD_amp_ch10,0.2;LCD_amp_ch11,0.3;LCD_amp_ch12,0.4;LCD_amp_ch13,0.5;LCD_amp_ch14,0.6;LCD_amp_ch15,0.7;LCD_amp_ch16,0.8;LCD_amp_ch17,0.9;LCD_amp_ch18,1.0;LCD_amp_ch19,1.1;LCD_amp_ch20,1.2;"
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch21,1.3;LCD_amp_ch22,1.4;LCD_amp_ch23,1.5;LCD_amp_ch24,1.6;LCD_amp_ch25,1.7;LCD_amp_ch26,1.8;LCD_amp_ch27,1.9;LCD_amp_ch28,2.0;LCD_amp_ch29,2.1;LCD_amp_ch30,2.2;LCD_amp_ch31,2.3;"//L_LCDWavelist
		if(W_config[I_config_USB])
			String S_res				
			//for(V_ch=0; V_ch<5 ;V_ch+=4)//(V_ch=0; V_ch<24 ;V_ch+=1)
				//print V_ch, "/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch])
					//RS232_StrWrite("/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch]))
					//RS232_StrRead(CtrlName)
					S_res=SetPMC("BP_PMC_refresh_1ch", 0, Cfg_PMC_Frq[1], Cfg_PMC_Amp[1])//S_res=SetPMC("BP_PMC_refresh_1ch", 1, Cfg_PMC_Frq[1], Cfg_PMC_Amp[1])
					//S_res=SetPMC("BP_PMC_refresh_1ch", 2, Cfg_PMC_Frq[1], Cfg_PMC_Amp[1])
					//S_res=SetPMC("BP_PMC_refresh_1ch", 3, Cfg_PMC_Frq[2], Cfg_PMC_Amp[2])
					//print S_res
					//DS_Read("BP_PMC_refresh", "/"+num2str(1)+","+num2str(Cfg_PMC_Frq[V_ch])+","+num2str(Cfg_PMC_Amp[V_ch]), "\r")
					print S_res
					if(stringmatch(S_res, "NG"))
					print "NG"
					elseif(stringmatch(S_res, "OK"))
					else
					print "no response"
					endif
					
			//endfor
			else
				//	DAQmx_WaveformGen/DEV=S_deviceName L_LCDWavelist
			endif
		endif
end


Function BP_PMC_refresh_2ch(ctrlName) : ButtonControl
	String ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_LCD_ON=4//LCD_ON
	variable I_config_USB=8//F_USB_enable
	wave Cfg_PMC_amp, Cfg_PMC_frq
	Variable V_ch
		if(W_config[I_LCD_ON] != 0)
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch8,0.0;LCD_amp_ch9,0.1;LCD_amp_ch10,0.2;LCD_amp_ch11,0.3;LCD_amp_ch12,0.4;LCD_amp_ch13,0.5;LCD_amp_ch14,0.6;LCD_amp_ch15,0.7;LCD_amp_ch16,0.8;LCD_amp_ch17,0.9;LCD_amp_ch18,1.0;LCD_amp_ch19,1.1;LCD_amp_ch20,1.2;"
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch21,1.3;LCD_amp_ch22,1.4;LCD_amp_ch23,1.5;LCD_amp_ch24,1.6;LCD_amp_ch25,1.7;LCD_amp_ch26,1.8;LCD_amp_ch27,1.9;LCD_amp_ch28,2.0;LCD_amp_ch29,2.1;LCD_amp_ch30,2.2;LCD_amp_ch31,2.3;"//L_LCDWavelist
		if(W_config[I_config_USB])
			String S_res				
			for(V_ch=0; V_ch<4 ;V_ch+=3)//(V_ch=0; V_ch<24 ;V_ch+=1)
				print V_ch, "/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch])
					//RS232_StrWrite("/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch]))
					//RS232_StrRead(CtrlName)
					S_res=DS_Read("BP_PMC_refresh", "/"+num2str(V_ch)+","+num2str(Cfg_PMC_Frq[V_ch])+","+num2str(Cfg_PMC_Amp[V_ch]), "\r")
					//print S_res
					if(stringmatch(S_res, "NG"))
					print "NG"
					elseif(stringmatch(S_res, "OK"))
					else
					print "no response"
					endif
					
				endfor
			else
				//	DAQmx_WaveformGen/DEV=S_deviceName L_LCDWavelist
			endif
		endif
end

Function BP_PMC_refresh_48(ctrlName) : ButtonControl
	String ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_LCD_ON=4//LCD_ON
	variable I_config_USB=8//F_USB_enable
	wave Cfg_PMC_Amp, Cfg_PMC_Frq
	Variable V_ch
		if(W_config[I_LCD_ON] != 0)
			String S_res
			for(V_ch=48; V_ch>=1 ;V_ch-=1)//(V_ch=0; V_ch<24 ;V_ch+=1)
				//print V_ch, Cfg_PMC_Frq[V_ch],Cfg_PMC_Amp[V_ch]
				 //"/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch])
					//RS232_StrWrite("/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch]))
					//RS232_StrRead(CtrlName)
					S_res=SetPMC("BP_PMC_refresh_48", V_ch, Cfg_PMC_Frq[V_ch-1],Cfg_PMC_Amp[V_ch-1])
					//print S_res
					if(stringmatch(S_res, "NG"))
					print "NG"
					elseif(stringmatch(S_res, "OK"))
					else
					print "no response"
					endif
					
				endfor
				SyncPMC("BP_PMC_refresh_48")
			else
				//	DAQmx_WaveformGen/DEV=S_deviceName L_LCDWavelist
			endif
end

Function BP_PMC_refresh_24(ctrlName) : ButtonControl
	String ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_LCD_ON=4//LCD_ON
	variable I_config_USB=8//F_USB_enable
	wave Cfg_PMC_Amp, Cfg_PMC_Frq
	Variable V_ch
		if(W_config[I_LCD_ON] != 0)
			String S_res
			for(V_ch=24; V_ch>=1 ;V_ch-=1)//(V_ch=0; V_ch<24 ;V_ch+=1)
				//print V_ch, Cfg_PMC_Frq[V_ch-1],Cfg_PMC_Amp[V_ch-1]
				 //"/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch])
					//RS232_StrWrite("/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch]))
					//RS232_StrRead(CtrlName)
					S_res=SetPMC("BP_PMC_refresh_24", V_ch, Cfg_PMC_Frq[V_ch-1],Cfg_PMC_Amp[V_ch-1])
					//print S_res
					if(stringmatch(S_res, "NG"))
					print "NG"
					elseif(stringmatch(S_res, "OK"))
					else
					print "no response"
					endif
					
				endfor
				SyncPMC("BP_PMC_refresh_48")
			else
				//	DAQmx_WaveformGen/DEV=S_deviceName L_LCDWavelist
			endif
end

Function BP_PMC_OFF(ctrlName) : ButtonControl
	String ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_LCD_ON=4//LCD_ON
	variable I_config_USB=8//F_USB_enable
	wave Cfg_PMC_amp, Cfg_PMC_frq
	Variable V_ch
		if(W_config[I_LCD_ON] != 0)
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch8,0.0;LCD_amp_ch9,0.1;LCD_amp_ch10,0.2;LCD_amp_ch11,0.3;LCD_amp_ch12,0.4;LCD_amp_ch13,0.5;LCD_amp_ch14,0.6;LCD_amp_ch15,0.7;LCD_amp_ch16,0.8;LCD_amp_ch17,0.9;LCD_amp_ch18,1.0;LCD_amp_ch19,1.1;LCD_amp_ch20,1.2;"
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch21,1.3;LCD_amp_ch22,1.4;LCD_amp_ch23,1.5;LCD_amp_ch24,1.6;LCD_amp_ch25,1.7;LCD_amp_ch26,1.8;LCD_amp_ch27,1.9;LCD_amp_ch28,2.0;LCD_amp_ch29,2.1;LCD_amp_ch30,2.2;LCD_amp_ch31,2.3;"//L_LCDWavelist
		if(W_config[I_config_USB])
			String S_res				
			for(V_ch=0; V_ch<24 ;V_ch+=1)
				//print V_ch, "/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch])
					//RS232_StrWrite("/"+num2str(V_ch+1)+","+num2str(Cfg_PMC_frq[V_ch])+","+num2str(Cfg_PMC_amp[V_ch]))
					//RS232_StrRead(CtrlName)
					S_res=DS_Read("BP_PMC_OFF", "/"+num2str(V_ch)+",100,0", "\r")
					//print S_res//, "BP_PMC_OFF", "/"+num2str(V_ch)+",100,0"
				endfor
			else
				//	DAQmx_WaveformGen/DEV=S_deviceName L_LCDWavelist
			endif
		endif
end



Function BP_LCD_Stat_Stop_24(ctrlName) : ButtonControl
	String ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_LCD_ON=4//LCD_ON
	variable I_config_USB=8//F_USB_enable
	wave Cfg_PMC_amp, Cfg_PMC_frq
	Variable V_ch
	//String Mess = ""

	wave  LCD_amp_ch=$"Cfg_LCD_amp_ch"
//	wave  LCD_Ctrl_Wave8=$"LCD_Ctrl_Wave8"

//	if(!W_config[I_config_USB])
//		variable I_config_DNo=6//DevNoもともと6
//		string S_deviceName="Dev"+num2str(W_config[I_config_DNo])
//		LCDwaveformGenerator4("LCD_Ctrl_ButtonProc")	
//		Svar L_LCDWavelist
//	else
//		
//	endif

	
	//LCD_ch_Ctrl2()

	if(!W_config[I_LCD_ON])
		W_config[I_LCD_ON]=1
		BP_PMC_refresh_24ch("BP_LCD_Stat_Stop")
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_Ctrl_Wave22,22;"
		Button LCD_Ctrl,title="Stop", fColor=(65280,48896,48896), win=LCD_Control_FreqAmpMode24
		//print "Running"		
		OnPMC("BP_LCD_Stat_Stop_24")
	else
		//fDAQmx_WaveformStop(S_deviceName)
		Button LCD_Ctrl,title="Ctrl",fColor=(0,0,0), win=LCD_Control_FreqAmpMode24
	//	BP_PMC_OFF("BP_LCD_Stat_Stop")//全て０Vにする方式
		OffPMC("BP_LCD_Stat_Stop_24")
		W_config[I_LCD_ON]=0
		//for(V_ch=8; V_ch <24; V_ch+=1)
		//	fDAQmx_WriteChan(S_deviceName, V_ch, 0, -10, 10)
		//endfor
		//print "Stop"
		W_config[I_LCD_ON]=0
	endif
End



Function LCD_Ctrl_ButtonProc(ctrlName) : ButtonControl
	String ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_config_Freq=5//DrivingFrequency
	variable I_config_ON=4//LCD_ON
	variable I_config_DNo=6//DevNoもともと6
	Variable ch
	//String Mess = ""
	variable Freq=W_config[I_config_Freq]
	string S_deviceName="Dev"+num2str(W_config[I_config_DNo])
	wave  LCD_amp_ch=$"LCD_amp_ch"
	wave  LCD_Ctrl_Wave8=$"LCD_Ctrl_Wave8"

	Svar L_LCDWavelist
	LCDwaveformGenerator3("LCD_Ctrl_ButtonProc")			//3に変更
	
	//LCD_ch_Ctrl2()
	
	if(W_config[I_config_ON] == 0)
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch8,0.0;LCD_amp_ch9,0.1;LCD_amp_ch10,0.2;LCD_amp_ch11,0.3;LCD_amp_ch12,0.4;LCD_amp_ch13,0.5;LCD_amp_ch14,0.6;LCD_amp_ch15,0.7;LCD_amp_ch16,0.8;LCD_amp_ch17,0.9;LCD_amp_ch18,1.0;LCD_amp_ch19,1.1;LCD_amp_ch20,1.2;"
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_amp_ch21,1.3;LCD_amp_ch22,1.4;LCD_amp_ch23,1.5;LCD_amp_ch24,1.6;LCD_amp_ch25,1.7;LCD_amp_ch26,1.8;LCD_amp_ch27,1.9;LCD_amp_ch28,2.0;LCD_amp_ch29,2.1;LCD_amp_ch30,2.2;LCD_amp_ch31,2.3;"//L_LCDWavelist
		//DAQmx_WaveformGen/DEV=S_deviceName L_LCDWavelist
		//DAQmx_WaveformGen/DEV=S_deviceName "LCD_Ctrl_Wave22,22;"
		Button LCD_Ctrl,proc=LCD_Ctrl_ButtonProc,title="Stop", fColor=(65280,48896,48896),win=LCD_Control
//		print "Running"
		W_config[I_config_ON]=1
	else
		//fDAQmx_WaveformStop(S_deviceName)
		Button LCD_Ctrl,proc=LCD_Ctrl_ButtonProc,title="Ctrl",fColor=(0,0,0), win=LCD_Control
		for(ch=8; ch <24; ch+=1)
			//fDAQmx_WriteChan(S_deviceName, ch, 0, -10, 10)
		endfor
//		print "Stop"
		W_config[I_config_ON]=0
	endif
End

function LCDwaveformGenerator3(ctrlName)          
	string ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_config_Freq=5//DrivingFrequency
	variable V_Freq=W_config[I_config_Freq]
	variable ch, i
	wave LCD_amp_ch
	Svar L_LCDWavelist
	Svar S_PwrCtrlWave
	Nvar V_PwrCtrlCh
	Nvar F_LCDWaveform, V_LCD_WDuty
	L_LCDWavelist=""
	variable npnts=20000//200
	variable xstep=5e-6
	variable V_pulsewidth=V_LCD_WDuty/100/V_Freq
	variable V_cycle=1/V_Freq
	//F_WF 1: Sin, 2: Square, 3: triangle
	for(ch=8; ch <32; ch +=1)
		make/O/N=(npnts)  $"LCD_Ctrl_Wave"+num2str(ch)
		SetScale/P x 0, (xstep), "s" $"LCD_Ctrl_Wave"+num2str(ch)
		wave w=$"LCD_Ctrl_Wave"+num2str(ch)
		switch(F_LCDWaveform)
			case 1:
				w= LCD_amp_ch[ch-8]*sin(2*Pi*x*V_Freq)
				break
			case 2:
				w=LCD_amp_ch[ch-8]*(-2*(mod(x, 1/V_Freq)>(V_pulsewidth))+1)
				break
			case 3:
				w=-LCD_amp_ch[ch-8]*((2*mod(x, V_cycle)/V_pulsewidth-1)*(mod(x, V_cycle)<=V_pulsewidth)+(mod(x, V_cycle)>V_pulsewidth)*(-2*(mod(x, V_cycle)-V_pulsewidth)/((1-V_LCD_WDuty/100)*V_cycle)+1))
				break
			default:
		endswitch
		L_LCDWavelist = L_LCDWavelist +"LCD_Ctrl_Wave"+num2str(ch)+","+num2str(ch) +";"
	endfor
	//L_LCDWavelist+=S_PwrCtrlWave+","+num2str(V_PwrCtrlCh)+";"
end

function LCDwaveformGenerator4(ctrlName)          
	string ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_config_Freq=5//DrivingFrequency
	//variable V_Freq=W_config[I_config_Freq]
	variable ch, i
	wave Cfg_PMC_amp, Cfg_PMC_Frq
	Svar L_LCDWavelist
	Svar S_PwrCtrlWave
	Nvar V_PwrCtrlCh
	Nvar F_LCDWaveform//, V_LCD_WDuty
	L_LCDWavelist=""
	variable npnts=20000//200
	variable xstep=5e-6
	//variable V_pulsewidth=V_LCD_WDuty/100/V_Freq
	//variable V_cycle=1/V_Freq
	//F_WF 1: Sin, 2: Square, 3: triangle
	for(ch=8; ch <32; ch +=1)
		make/O/N=(npnts)  $"LCD_Ctrl_Wave"+num2str(ch)
		SetScale/P x 0, (xstep), "s" $"LCD_Ctrl_Wave"+num2str(ch)
		wave w=$"LCD_Ctrl_Wave"+num2str(ch)
		switch(F_LCDWaveform)
			case 1:
				w= Cfg_PMC_amp[ch-8]*sin(2*Pi*x*Cfg_PMC_Frq[ch-8])
				break
			case 2:
				w=Cfg_PMC_amp[ch-8]*(-2*(mod(x, 1/Cfg_PMC_Frq[ch-8])>(0.5/Cfg_PMC_Frq[ch-8]))+1)
				break
			case 3:
				w=-Cfg_PMC_amp[ch-8]*((2*mod(x, 1/Cfg_PMC_Frq[ch-8])/0.5/Cfg_PMC_Frq[ch-8]-1)*(mod(x, 1/Cfg_PMC_Frq[ch-8])<=0.5/Cfg_PMC_Frq[ch-8])+(mod(x, 1/Cfg_PMC_Frq[ch-8])>0.5/Cfg_PMC_Frq[ch-8])*(-2*(mod(x, 1/Cfg_PMC_Frq[ch-8])-0.5/Cfg_PMC_Frq[ch-8])/((1-0.5/Cfg_PMC_Frq[ch-8]/100)*1/Cfg_PMC_Frq[ch-8])+1))
				break
			default:
		endswitch
		L_LCDWavelist = L_LCDWavelist +"LCD_Ctrl_Wave"+num2str(ch)+","+num2str(ch) +";"
	endfor
	//L_LCDWavelist+=S_PwrCtrlWave+","+num2str(V_PwrCtrlCh)+";"
end



Function LCD_ch_Ctrl2()
	wave  LCD_amp_ch=$"LCD_amp_ch"
	
	wave  LCD_amp_ch8=$"LCD_amp_ch8"
	wave  LCD_amp_ch9=$"LCD_amp_ch9"
	wave  LCD_amp_ch10=$"LCD_amp_ch10"
	wave  LCD_amp_ch11=$"LCD_amp_ch11"
	wave  LCD_amp_ch12=$"LCD_amp_ch12"
	wave  LCD_amp_ch13=$"LCD_amp_ch13"
	wave  LCD_amp_ch14=$"LCD_amp_ch14"
	wave  LCD_amp_ch15=$"LCD_amp_ch15"
	wave  LCD_amp_ch16=$"LCD_amp_ch16"
	wave  LCD_amp_ch17=$"LCD_amp_ch17"
	wave  LCD_amp_ch18=$"LCD_amp_ch18"
	wave  LCD_amp_ch19=$"LCD_amp_ch19"
	wave  LCD_amp_ch20=$"LCD_amp_ch20"
	wave  LCD_amp_ch21=$"LCD_amp_ch21"
	wave  LCD_amp_ch22=$"LCD_amp_ch22"
	wave  LCD_amp_ch23=$"LCD_amp_ch23"
	wave  LCD_amp_ch24=$"LCD_amp_ch24"
	wave  LCD_amp_ch25=$"LCD_amp_ch25"
	wave  LCD_amp_ch26=$"LCD_amp_ch26"
	wave  LCD_amp_ch27=$"LCD_amp_ch27"
	wave  LCD_amp_ch28=$"LCD_amp_ch28"
	wave  LCD_amp_ch29=$"LCD_amp_ch29"
	wave  LCD_amp_ch30=$"LCD_amp_ch30"
	wave  LCD_amp_ch31=$"LCD_amp_ch31"

	
	
	
	LCD_amp_ch8[0]=LCD_amp_ch[0]
	LCD_amp_ch8[1]=LCD_amp_ch[0]
	LCD_amp_ch9[0]=LCD_amp_ch[1]
	LCD_amp_ch9[1]=LCD_amp_ch[1]
	LCD_amp_ch10[0]=LCD_amp_ch[2]
	LCD_amp_ch10[1]=LCD_amp_ch[2]
	LCD_amp_ch11[0]=LCD_amp_ch[3]
	LCD_amp_ch11[1]=LCD_amp_ch[3]
	LCD_amp_ch12[0]=LCD_amp_ch[4]
	LCD_amp_ch12[1]=LCD_amp_ch[4]
	LCD_amp_ch13[0]=LCD_amp_ch[5]
	LCD_amp_ch13[1]=LCD_amp_ch[5]
	LCD_amp_ch14[0]=LCD_amp_ch[6]
	LCD_amp_ch14[1]=LCD_amp_ch[6]
	LCD_amp_ch15[0]=LCD_amp_ch[7]
	LCD_amp_ch15[1]=LCD_amp_ch[7]
	LCD_amp_ch16[0]=LCD_amp_ch[8]
	LCD_amp_ch16[1]=LCD_amp_ch[8]
	LCD_amp_ch17[0]=LCD_amp_ch[9]
	LCD_amp_ch17[1]=LCD_amp_ch[9]
	LCD_amp_ch18[0]=LCD_amp_ch[10]
	LCD_amp_ch18[1]=LCD_amp_ch[10]
	LCD_amp_ch19[0]=LCD_amp_ch[11]
	LCD_amp_ch19[1]=LCD_amp_ch[11]
	LCD_amp_ch20[0]=LCD_amp_ch[12]
	LCD_amp_ch20[1]=LCD_amp_ch[12]
	LCD_amp_ch21[0]=LCD_amp_ch[13]
	LCD_amp_ch21[1]=LCD_amp_ch[13]
	LCD_amp_ch22[0]=LCD_amp_ch[14]
	LCD_amp_ch22[1]=LCD_amp_ch[14]
	LCD_amp_ch23[0]=LCD_amp_ch[15]
	LCD_amp_ch23[1]=LCD_amp_ch[15]
	LCD_amp_ch24[0]=LCD_amp_ch[16]
	LCD_amp_ch24[1]=LCD_amp_ch[16]
	LCD_amp_ch25[0]=LCD_amp_ch[17]
	LCD_amp_ch25[1]=LCD_amp_ch[17]
	LCD_amp_ch26[0]=LCD_amp_ch[18]
	LCD_amp_ch26[1]=LCD_amp_ch[18]
	LCD_amp_ch27[0]=LCD_amp_ch[19]
	LCD_amp_ch27[1]=LCD_amp_ch[19]
	LCD_amp_ch28[0]=LCD_amp_ch[20]
	LCD_amp_ch28[1]=LCD_amp_ch[20]
	LCD_amp_ch29[0]=LCD_amp_ch[21]
	LCD_amp_ch29[1]=LCD_amp_ch[21]
	LCD_amp_ch30[0]=LCD_amp_ch[22]
	LCD_amp_ch30[1]=LCD_amp_ch[22]
	LCD_amp_ch31[0]=LCD_amp_ch[23]
	LCD_amp_ch31[1]=LCD_amp_ch[23]



End

Function CB_USB_enalbe(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	wave W_config=$"Cfg_PMC"
	wave Cfg_RS232C
	variable I_config_USB=8//F_USB_enable
	variable I_config_COM=5//F_USB_enable
	W_config[I_config_USB]=checked
	variable V_pop=WhichListItem("COM"+num2str(W_config[I_config_COM]),BP_refreash("CB_USB_enalbe"))+1
	PopupMenu COM win=RS232CPanel, mode=V_pop
	Cfg_RS232C={V_pop,115200,16384,8,1,0,1,0,0,0,1,0,1}
	if(checked)
		PopupMenu Waveform win=LCD_Control_FreqAmpMode, disable=2
		//print "COM"+num2str(W_config[I_config_COM]),BP_refreash("CB_USB_enalbe")
		//print Cfg_RS232C[0]
		BP_RS232C_portOpen("CB_USB_enalbe")
	else
		PopupMenu Waveform win=LCD_Control_FreqAmpMode, disable=0
		BP_RS232C_portClose("CB_USB_enalbe")
	endif
End





Function BP_PMC_Connect(ctrlName) : ButtonControl
	String ctrlName
	wave Cfg_RS232C
	wave Cfg_PMC
	variable V_nCOM=Cfg_PMC[9]
	variable V_pop=WhichListItem("COM"+num2str(V_nCOM),BP_refreash("BP_PMC_Connect"))+1
	PopupMenu COM win=RS232CPanel, mode=V_pop
	//	VDT2 /P=COM1 baud=38400, buffer=4096, databits=8, echo=0, in=1, killio, out=1, parity=0, rts=1, stopbits=1, terminalEOL=2
	Cfg_RS232C={V_pop,38400,4096,8,0,1,1,0,0,0,1,0,1}
	BP_RS232C_portOpen("BP_PMC_Connect")
End

Function SVP_PMC_SetSignal_Ch(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum // value of variable as number
	String varStr // value of variable as string
	String varName // name of variable
	//print ctrlName,varNum,varStr,varName
	wave W_config=$"Cfg_PMC"
	variable I_LCD_ON=4//LCD_ON
	//variable I_config_USB=8//F_USB_enable
	variable V_CNo=str2num(ReplaceString("Frq", ReplaceString("Amp", ReplaceString("CH", ctrlName, ""), ""), ""))

	//V_CNo+=1
	wave Cfg_PMC_amp=Cfg_PMC_amp
	wave Cfg_PMC_Frq=Cfg_PMC_Frq
	//print W_config[I_LCD_ON], W_config[I_config_USB]
	//if(W_config[I_config_USB])
		if(W_config[I_LCD_ON])
//			String S_res=DS_Read("SVP_PMC_SetSignal_Ch", "/"+num2str(V_CNo)+","+num2str(Cfg_PMC_Frq[V_CNo])+","+num2str(Cfg_PMC_Amp[V_CNo]), "\r")
					String S_res=DS_Read("SVP_PMC_SetSignal_Ch", "/"+num2str(V_CNo+1)+","+num2str(Cfg_PMC_Frq[V_CNo])+","+num2str(Cfg_PMC_Amp[V_CNo]), "\r")
			//print "SVP_PMC_SetSignal_Ch", "/"+num2str(V_CNo+1)+","+num2str(Cfg_PMC_Frq[V_CNo])+","+num2str(Cfg_PMC_Amp[V_CNo]), "\r"
			if(stringmatch(S_res, "OK"))
				//print "OK"
			elseif(stringmatch(S_res, "NG"))
				print "NG"
			else
				print "error"
			endif
			return 1
		//endif
	endif
	
End
