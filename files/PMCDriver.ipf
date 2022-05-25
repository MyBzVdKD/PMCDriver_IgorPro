#pragma rtGlobals=1		// Use modern global access method.
function /S genStrPMC_sglCH(ctrlName, V_ch, V_Hz)
	string ctrlName
	variable V_ch, V_Hz
	string S_cmd=num2char(0x02)//add STX
	S_cmd+=num2char(0x57)//add "W"
	if(V_ch>7)
		V_ch+=2
		if(V_ch>17)
			V_ch+=2
		endif
	endif
	S_cmd+=convHexStrs(V_ch)
	if(V_ch<16)
		S_cmd+="0"
	endif
	S_cmd+=convHexStrs(V_Hz)
	variable i
	for(i=1; i<=3; i+=1)
		if(V_Hz<16^i)
			S_cmd+="0"
		endif
	endfor
	S_cmd+=num2char(0x1F)//add US
	S_cmd+=num2char(0x03)//add ETX
	if(stringmatch(ctrlName, "SVP_PMC_SetFreq")==0)
	 OverWriteCFG("Cfg_LCSLM_Frq", V_ch, V_Hz)
	endif
	return S_cmd
end


function /S genStrPMC_sglCHs(ctrlName)
	string ctrlName
	string S_cmd=num2char(0x02)//add STX
	variable V_ch, V_Hz
	wave Cfg_LCSLM_Frq=$"Cfg_LCSLM_Frq"
	for(V_ch=0; V_ch<23; V_ch+=1,S_cmd+=",")
		V_Hz=round(Cfg_LCSLM_Frq[V_ch])//num2str(StringFromList(V_ch, L_Hz))
		S_cmd+=num2char(0x57)//add "W"
		if(V_ch>7)
			V_ch+=2
			if(V_ch>17)
				V_ch+=2
			endif
		endif
		S_cmd+=convHexStrs(V_ch)
		if(V_ch<16)
			S_cmd+="0"
		endif
		S_cmd+=convHexStrs(V_Hz)
		variable i
		for(i=1; i<=3; i+=1)
			if(V_Hz<16^i)
				S_cmd+="0"
			endif
		endfor
	endfor
	S_cmd=RemoveEnding(S_cmd)

	S_cmd+=num2char(0x1F)//add US
	S_cmd+=num2char(0x03)//add ETX
	if(stringmatch(ctrlName, "SVP_PMC_SetFreq")==0)
	 OverWriteCFG("Cfg_LCSLM_Frq", V_ch, V_Hz)
	endif
	return S_cmd
end

function /S convHexStrs(V_decs)
	variable V_decs
	string S_Hex=""
	variable i
	for(i=1; ; i+=1)
		//print V_decs, mod(V_decs, 16^i), i
		//print char2num(convHex(mod(V_decs, 16^i)/16^(i-1))), convHex(mod(V_decs, 16^i)/16^(i-1))
		S_Hex+=convHex(mod(V_decs, 16^i)/16^(i-1))
		V_decs-=mod(V_decs, 16^i)
		if(V_decs==0)
			break
		endif
	endfor
	return S_Hex
end

function /S convHex(V_dec)
	variable V_dec
	switch (V_dec)
		case 10:
			return "A"
		case 11:
			return "B"
		case 12:
			return "C"
		case 13:
			return "D"
		case 14:
			return "E"
		case 15:
			return "F"
		default:
			return num2str(V_dec)
	endswitch
end

