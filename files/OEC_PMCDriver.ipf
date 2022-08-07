#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.
<従来設定コマンド>
/CC,FFFF,VV<CR> 出力設定(周波数電圧ﾊﾟﾗﾒｰﾀ指定型)
　CC　　　　　　Ch　　0=ALL or 1～48　 (0x指定可)
　FFFF　　　　　Freq　100～100000(Hz)　(10進整数指定)
　VV　　　　　　Volt　0～23.2(Vp-p)　　(10進小数指定)
/SYNC<CR>　　　 出力同期(Sync)　新規追加
/OFF<CR>　　　　全出力OFF(0V)　新規追加
/ON<CR>　　　　 全出力ON　新規追加
/CAL<CR>　　　　全ﾁｬﾝﾈﾙ　10000Hz, 5V出力　新規追加
<ダイレクト設定コマンド>
$CC,FFFF,VV<CR> 出力設定(ﾀﾞｲﾚｸﾄﾊﾟﾗﾒｰﾀ指定型)
　CC　　　　　　Ch　　0=ALL or 1～48　(0x指定可)
　FFFF　　　　　Freq　1～65535　(NCO増加値 16bit)
　VV　　　　　　Volt　0～255　　　(デジタルポテンショメータ値 8bit)

function /S SetPMC(ctrlName, V_C, V_F, V_V)
	String ctrlName
	variable V_C,V_F,V_V
	string res
	//print "/"+num2str(V_C)+","+num2str(V_F)+","+num2str(V_V)
	res= DS_Read("SetPMC", "/"+num2str(V_C)+","+num2str(V_F)+","+num2str(V_V), "\r")
	SyncPMC("SetPMC")
	return res

end

function /S SyncPMC(ctrlName)
	String ctrlName
	return DS_Read("SyncPMC", "/SYNC", "\r")
end

function /S OnPMC(ctrlName)//PMC内部の駆動状態は変えずにON
	String ctrlName
	return DS_Read("OnPMC", "/ON", "\r")
end

function /S OffPMC(ctrlName)//PMC内部の駆動状態は変えずにOFF
	String ctrlName
	return DS_Read("OffPMC", "/OFF", "\r")
end

function /S CalPMC(ctrlName)
	String ctrlName
	return DS_Read("CalPMC", "/CAL", "\r")
end

function /S SetxPMC(ctrlName, V_xC, V_xF, V_xV)
	String ctrlName
	variable V_xC,V_xF,V_xV
	return DS_Read("SetPMC", "$"+num2str(V_xC)+","+num2str(V_xF)+","+num2str(V_xV), "\r")
end

function PMCAmp_x2d(V_x)
	variable V_x
	variable V_max=PMC_GetConfig(10)
	variable res=V_max/256*V_x
	if(res<=V_max&&res>=0)
		return res
	else
		return nan
	endif
end

function PMCAmp_d2x(V_d)
	variable V_d
	variable V_maxVpp=PMC_GetConfig(10)
	variable res=round(V_d/(V_maxVpp/256))
	if(res<256&&res>=0)
		return res
	else
		return nan
	endif
end

function PMCFrq_x2d(V_x)//
	variable V_x//>1
	variable V_Seq=1/PMC_GetConfig(12)//;print 2^PMC_GetConfig(11)
	return 1/(2^PMC_GetConfig(11)/V_x*V_Seq*2)
end

function PMCFrq_d2x(V_d)
	variable V_d//Hz
	variable V_Period=1/V_d/2//sec
	V_Period/=1/PMC_GetConfig(12)//times
	return round(2^PMC_GetConfig(11)/V_Period)
end


Function BP_ImportPanelPreset(ctrlName) : ButtonControl
	String ctrlName
	variable V_maxAmp=PMC_GetConfig(10)/2
	variable V_n=PMC_GetConfig(13)
	variable i
	for(i=1;i<=V_n;i+=1)
		if(i<10)
			SetVariable $"CH0"+num2str(i)+"Amp" limits={0,V_maxAmp,0.01}
		else
			SetVariable $"CH"+num2str(i)+"Amp" limits={0,V_maxAmp,0.01}
		endif
	endfor
end
	
End

Function BP_SyncPMCchannels(ctrlName) : ButtonControl
	String ctrlName
	SyncPMC("BP_SyncPMCchannels")
End

Function BP_CalPMC(ctrlName) : ButtonControl
	String ctrlName
	CalPMC("BP_SyncPMCchannels")
End

Function BP_LCD_Stat_Stop_48(ctrlName) : ButtonControl
	String ctrlName
	wave W_config=$"Cfg_PMC"
	variable I_LCD_ON=4//LCD_ON
	wave Cfg_PMC_amp, Cfg_PMC_frq
	Variable V_ch
	wave  LCD_amp_ch=$"Cfg_LCD_amp_ch"
	if(!W_config[I_LCD_ON])
		W_config[I_LCD_ON]=1
		Button LCD_Ctrl,title="Stop", fColor=(65280,48896,48896), win=LCD_Control_FreqAmpMode48
		BP_PMC_refresh_48("BP_LCD_Stat_Stop")
		//SyncPMC("BP_SyncPMCchannels")//
		OnPMC("BP_LCD_Stat_Stop_48")
		//print "Running"
	else
		//BP_PMC_OFF("BP_LCD_Stat_Stop")
		OffPMC("BP_LCD_Stat_Stop_48")
		Button LCD_Ctrl,title="Ctrl",fColor=(0,0,0), win=LCD_Control_FreqAmpMode48
		W_config[I_LCD_ON]=0
		//print "Stop"
	endif
End


Function SVP_PMC_SetSignal_Ch_OEC(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum // value of variable as number
	String varStr // value of variable as string
	String varName // name of variable
	//print ctrlName,varNum,varStr,varName
	wave Cfg_PMC_Amp=Cfg_PMC_Amp
	wave Cfg_PMC_Frq=Cfg_PMC_Frq
	wave Cfg_PMC_xAmp=Cfg_PMC_xAmp
	wave Cfg_PMC_xFrq=Cfg_PMC_xFrq
	
	wave W_config=$"Cfg_PMC"
	variable I_LCD_ON=4//LCD_ON
	//variable I_config_USB=8//F_USB_enable
	variable F_Amp=StringMatch(ctrlName, "*Amp")
	variable V_CNo=str2num(ReplaceString("Frq", ReplaceString("Amp", ReplaceString("CH", ctrlName, ""), ""), ""))
	if(F_Amp)
		Cfg_PMC_Amp[V_CNo-1]=varNum
		Cfg_PMC_xAmp[V_CNo-1]=PMCAmp_d2x(varNum)
	else
		Cfg_PMC_Frq[V_CNo-1]=varNum
		Cfg_PMC_xFrq[V_CNo-1]=PMCFrq_d2x(varNum)
	endif
	
	//print W_config[I_LCD_ON], W_config[I_config_USB]
	//if(W_config[I_config_USB])
		if(W_config[I_LCD_ON])
//			String S_res=DS_Read("SVP_PMC_SetSignal_Ch", "/"+num2str(V_CNo)+","+num2str(Cfg_PMC_Frq[V_CNo])+","+num2str(Cfg_PMC_Amp[V_CNo]), "\r")
			String S_res=SetPMC("SVP_PMC_SetSignal_Ch_OEC", V_CNo, Cfg_PMC_Frq[V_CNo-1], Cfg_PMC_Amp[V_CNo-1])
			//DS_Read("SVP_PMC_SetSignal_Ch", "/"+num2str(V_CNo)+","+num2str(Cfg_PMC_Frq[V_CNo])+","+num2str(Cfg_PMC_Amp[V_CNo]), "\r")
			//print "SVP_PMC_SetSignal_Ch",ctrlName, "/"+num2str(V_CNo)+","+num2str(Cfg_PMC_Frq[V_CNo-1])+","+num2str(Cfg_PMC_Amp[V_CNo-1]), "\r"
			if(stringmatch(S_res, "OK"))
				print "OK"
			elseif(stringmatch(S_res, "NG"))
				print "NG"
			else
				print "error"
			endif
			return 1
		endif
	//endif
End

Function PMC_xSetSignal_OEC(ctrlName,V_CNo, V_xFrq, V_xAmp) : SetVariableControl
	String ctrlName
	Variable V_CNo, V_xFrq, V_xAmp
	wave Cfg_PMC_Amp=Cfg_PMC_Amp
	wave Cfg_PMC_Frq=Cfg_PMC_Frq
	wave Cfg_PMC_xAmp=Cfg_PMC_xAmp
	wave Cfg_PMC_xFrq=Cfg_PMC_xFrq
	wave W_config=$"Cfg_PMC"
	variable I_LCD_ON=4//LCD_ON
	variable I_Nchannels=13
	//variable I_config_USB=8//F_USB_enable
	variable i
	if(V_CNo)
		Cfg_PMC_xAmp[V_CNo-1]=V_xAmp
		Cfg_PMC_Amp[V_CNo-1]=PMCAmp_x2d(V_xAmp)
		Cfg_PMC_xFrq[V_CNo-1]=V_xFrq
		Cfg_PMC_Frq[V_CNo-1]=PMCFrq_x2d(V_xFrq)
	elseif(V_CNo==0)
		variable V_Nchannels=W_config[I_Nchannels]
		for(i=1;i<=V_Nchannels;i+=1)
		//print i-1
			Cfg_PMC_xAmp[i-1]=V_xAmp
			Cfg_PMC_Amp[i-1]=PMCAmp_x2d(V_xAmp)
			Cfg_PMC_xFrq[i-1]=V_xFrq
			Cfg_PMC_Frq[i-1]=PMCFrq_x2d(V_xFrq)
		endfor
	endif
	
	//print W_config[I_LCD_ON], W_config[I_config_USB]
	//if(W_config[I_config_USB])
		if(W_config[I_LCD_ON])
//			String S_res=DS_Read("SVP_PMC_SetSignal_Ch", "/"+num2str(V_CNo)+","+num2str(Cfg_PMC_Frq[V_CNo])+","+num2str(Cfg_PMC_Amp[V_CNo]), "\r")
			String S_res=SetxPMC("PMC_xSetSignal_OEC", V_CNo, Cfg_PMC_xFrq[V_CNo-(V_CNo!=0)], Cfg_PMC_xAmp[V_CNo-(V_CNo!=0)])
			//DS_Read("SVP_PMC_SetSignal_Ch", "$"+num2str(V_CNo)+","+num2str(Cfg_PMC_Frq[V_CNo])+","+num2str(Cfg_PMC_Amp[V_CNo]), "\r")
			//print "SVP_PMC_SetSignal_Ch", "/"+num2str(V_CNo)+","+num2str(Cfg_PMC_Frq[V_CNo])+","+num2str(Cfg_PMC_Amp[V_CNo]), "\r"
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

Function Cycle()
	variable i=0
	do
		
		SetPMC("Cycle", 0, 1000, 10*(i))
		i+=0.05
	while(1)
end


function sweepLC1_24()
	wave Cfg_PMC_amp
	variable i=2
	do
	print i
		do
			Cfg_PMC_amp[0,7]=i
			BP_PMC_refresh_8ch("")
			i+=0.2
		while(i<5)
		do
			Cfg_PMC_amp[0,7]=i
			BP_PMC_refresh_8ch("")
			i-=0.2
		while(i>2)
	while(1)
end

function sweepLC1_48()
	wave Cfg_PMC_amp
	variable i=8
	do
		do
			Cfg_PMC_amp[0,15]=i
			//BP_PMC_refresh_2ch("GetRetardation_fv")
			i+=0.2
		while(i<9.9)
		do
			Cfg_PMC_amp[0,15]=i
			//BP_PMC_refresh_2ch("GetRetardation_fv")
			i-=0.2
		while(i>7)
	while(1)
end


function Cycle_LC1_24()//(V_start, V_end, V_step)
	variable V_start, V_end, V_step
	wave Cfg_PMC_amp
	//Cfg_PMC_amp=0
	variable i=V_start
	do
	 //OnPMC("Cycle_LC1_48")
	 BP_LCD_Stat_Stop_24("")
	sleep /S 0.2
	 //OffPMC("Cycle_LC1_48")
	 BP_LCD_Stat_Stop_24("")
	sleep /S 0.2
///		do
//			Cfg_PMC_amp[0,15]=i
//			BP_PMC_refresh_48("Cycle_LC1_48")
//			i+=V_step
//		while(i<V_end)
//		do
//			Cfg_PMC_amp[0,15]=i
//			BP_PMC_refresh_48("Cycle_LC1_48")
//			i-=V_step
//		while(i>V_start)
	while(1)
end

function Cycle_LC1_48()//(V_start, V_end, V_step)
	variable V_start, V_end, V_step
	wave Cfg_PMC_amp
	//Cfg_PMC_amp=0
	variable i=V_start
	do
	 OnPMC("Cycle_LC1_48")
	sleep /S 0.2
	 OffPMC("Cycle_LC1_48")
	sleep /S 0.2
///		do
//			Cfg_PMC_amp[0,15]=i
//			BP_PMC_refresh_48("Cycle_LC1_48")
//			i+=V_step
//		while(i<V_end)
//		do
//			Cfg_PMC_amp[0,15]=i
//			BP_PMC_refresh_48("Cycle_LC1_48")
//			i-=V_step
//		while(i>V_start)
	while(1)
end


function getPMCMAP()
	print DS_Read("", "/MAP", "\r")
	print DS_Read("", "", "")
	print DS_Read("", "", "")
	print DS_Read("", "", "")
	print DS_Read("", "", "")
end

function set8devPMC()
	print DS_Read("", "/MAP,1,3", "\r")
	print DS_Read("", "/MAP,2,1", "\r")
	print DS_Read("", "/MAP,3,2", "\r")
	print DS_Read("", "/MAP,4,7", "\r")
	print DS_Read("", "/MAP,5,8", "\r")
	print DS_Read("", "/MAP,6,6", "\r")
	print DS_Read("", "/MAP,7,4", "\r")
	print DS_Read("", "/MAP,8,5", "\r")
	print DS_Read("", "/MAP,9,10", "\r")
	print DS_Read("", "/MAP,10,11", "\r")
	print DS_Read("", "/MAP,11,9", "\r")
	print DS_Read("", "/MAP,12,14", "\r")
	print DS_Read("", "/MAP,13,16", "\r")
	print DS_Read("", "/MAP,14,15", "\r")
	print DS_Read("", "/MAP,15,13", "\r")
	print DS_Read("", "/MAP,16,12", "\r")
	print DS_Read("", "/MAP,17,19", "\r")
	print DS_Read("", "/MAP,18,17", "\r")
	print DS_Read("", "/MAP,19,18", "\r")
	print DS_Read("", "/MAP,20,23", "\r")
	print DS_Read("", "/MAP,21,24", "\r")
	print DS_Read("", "/MAP,22,22", "\r")
	print DS_Read("", "/MAP,23,20", "\r")
	print DS_Read("", "/MAP,24,21", "\r")
end
function reset8devPMC()
	print DS_Read("", "/MAP,1,1", "\r")
	print DS_Read("", "/MAP,2,2", "\r")
	print DS_Read("", "/MAP,3,3", "\r")
	print DS_Read("", "/MAP,4,4", "\r")
	print DS_Read("", "/MAP,5,5", "\r")
	print DS_Read("", "/MAP,6,6", "\r")
	print DS_Read("", "/MAP,7,7", "\r")
	print DS_Read("", "/MAP,8,8", "\r")
	print DS_Read("", "/MAP,9,9", "\r")
	print DS_Read("", "/MAP,10,10", "\r")
	print DS_Read("", "/MAP,11,11", "\r")
	print DS_Read("", "/MAP,12,12", "\r")
	print DS_Read("", "/MAP,13,13", "\r")
	print DS_Read("", "/MAP,14,14", "\r")
	print DS_Read("", "/MAP,15,15", "\r")
	print DS_Read("", "/MAP,16,16", "\r")
	print DS_Read("", "/MAP,17,17", "\r")
	print DS_Read("", "/MAP,18,18", "\r")
	print DS_Read("", "/MAP,19,19", "\r")
	print DS_Read("", "/MAP,20,20", "\r")
	print DS_Read("", "/MAP,21,21", "\r")
	print DS_Read("", "/MAP,22,22", "\r")
	print DS_Read("", "/MAP,23,23", "\r")
	print DS_Read("", "/MAP,24,24", "\r")
end

function set16devTMJPMC()
	print DS_Read("", "/MAP,1,5", "\r")
	print DS_Read("", "/MAP,2,1", "\r")
	print DS_Read("", "/MAP,3,14", "\r")
	print DS_Read("", "/MAP,4,15", "\r")
	print DS_Read("", "/MAP,5,12", "\r")
	print DS_Read("", "/MAP,6,11", "\r")
	print DS_Read("", "/MAP,7,7", "\r")
	print DS_Read("", "/MAP,8,6", "\r")
	print DS_Read("", "/MAP,9,3", "\r")
	print DS_Read("", "/MAP,10,2", "\r")
	print DS_Read("", "/MAP,11,16", "\r")
	print DS_Read("", "/MAP,12,13", "\r")
	print DS_Read("", "/MAP,13,10", "\r")
	print DS_Read("", "/MAP,14,9", "\r")
	print DS_Read("", "/MAP,15,8", "\r")
	print DS_Read("", "/MAP,16,4", "\r")
	
	print DS_Read("", "/MAP,17,21", "\r")
	print DS_Read("", "/MAP,18,17", "\r")
	print DS_Read("", "/MAP,19,30", "\r")
	print DS_Read("", "/MAP,20,31", "\r")
	print DS_Read("", "/MAP,21,28", "\r")
	print DS_Read("", "/MAP,22,27", "\r")
	print DS_Read("", "/MAP,23,23", "\r")
	print DS_Read("", "/MAP,24,22", "\r")
	print DS_Read("", "/MAP,25,19", "\r")
	print DS_Read("", "/MAP,26,18", "\r")
	print DS_Read("", "/MAP,27,32", "\r")
	print DS_Read("", "/MAP,28,29", "\r")
	print DS_Read("", "/MAP,29,26", "\r")
	print DS_Read("", "/MAP,30,25", "\r")
	print DS_Read("", "/MAP,31,24", "\r")
	print DS_Read("", "/MAP,32,20", "\r")
	
	print DS_Read("", "/MAP,33,37", "\r")
	print DS_Read("", "/MAP,34,33", "\r")
	print DS_Read("", "/MAP,35,46", "\r")
	print DS_Read("", "/MAP,36,47", "\r")
	print DS_Read("", "/MAP,37,44", "\r")
	print DS_Read("", "/MAP,38,43", "\r")
	print DS_Read("", "/MAP,39,39", "\r")
	print DS_Read("", "/MAP,40,38", "\r")
	print DS_Read("", "/MAP,41,35", "\r")
	print DS_Read("", "/MAP,42,34", "\r")
	print DS_Read("", "/MAP,43,48", "\r")
	print DS_Read("", "/MAP,44,45", "\r")
	print DS_Read("", "/MAP,45,42", "\r")
	print DS_Read("", "/MAP,46,41", "\r")
	print DS_Read("", "/MAP,47,40", "\r")
	print DS_Read("", "/MAP,48,36", "\r")
end

