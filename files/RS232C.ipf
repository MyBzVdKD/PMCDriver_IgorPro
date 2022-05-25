A‚ª#pragma rtGlobals=1		// Use modern global access method.
Function RS232_StrWrite(S_command)
	String S_command
	VDTWrite2/O=1 S_command+"\r\n"
End

Function RS232_HexWrite(V_HexVal)
	variable V_HexVal
	VDTWriteHex2 /O=5 /Q  V_HexVal 
	
End

Function RS232__HexRead(CtrlName)
	String CtrlName
	variable V_RD_val
	//string ans, ans2
	VDTReadHex2 /O=1 /Q V_RD_val
	return V_RD_val
End

VDTReadBinary2 
VDTWriteBinary2 [ /B /O=n /Q /TYPE=type  ] argument  [,argument ]

Function /S RS232_StrRead(CtrlName)
	String CtrlName
	string S_RD_val
	//string ans, ans2
	VDTRead2 /O=1 /Q S_RD_val
	return S_RD_val
End

//function test(i, j)
//	variable V_Hz
	variable i, j//i: 0-23 j: 100-100000
	variable n=24
	make/O/T /n=(24, 100000-100) W_test
	SetScale/I y 100,100000,"Hz", W_test


	for(; i<n; i+=1)
	print i
	for(; j<100000; j+=1)
	//print j, x2pntMD(W_test, 1, j)
	//print genStrPMC_sglCH("", i, V_Hz)
	RS232_StrWrite(genStrPMC_sglCH("", i, j))
	W_test[i][x2pntMD(W_test, 1, j)]=RS232_StrRead("")
	endfor
	endfor
end




function RS232C_HexWaveW(ctrlName, W_Hex)
	string ctrlName
	wave W_Hex
	VDTWriteHexWave2 /O=5 W_Hex
	
end


Function /S DS_Read(ctrlName, S_command, S_endcode)
	String ctrlName, S_command, S_endcode
	string ans, ans2
	VDTWrite2/Q/O=10 S_command+S_endcode
	VDTRead2/N=1024/O=2/T=S_endcode ans
	return ans
End



Function DS_Read_old(command)
	String command
	String ans, ans2
	variable i
	VDTWrite2/O=2 command+"\r\n" 
	Sleep/B/C=2/S/Q 1
	VDTRead2/N=256/O=1/T="\n" ans
	//VDTRead2/N=256/O=1/T=",\r\t" ans2
	//VDTReadBinary2 /O=1 i
//	for(i=0;i<1e5;i+=1)
//	endfor
//	print ans
//	print ans2
	//return str2num(StringFromList(0,ans2,"\r\n"))
	return str2num(ans2)
End


Function DS_comm_init(ctrlName) : ButtonControl    // Initialization of RS-232C
	string ctrlName
	VDT2 /P=COM1 baud=38400, buffer=4096, databits=8, echo=0, in=0, killio, out=0, parity=0, rts=0, stopbits=1, terminalEOL=2, line=1
	//print DS_Read("DS_comm_init", "PROMPT=0", "\r\n");	print DS_Read("DS_comm_init", "ECHO=0", "\r\n")
End


//     Function DS_comm_init_old(ctrlName) : ButtonControl    // Initialization of RS-232C
//       	string ctrlName
//	      VDT2 /P=COM5 baud=19200, buffer=4096, databits=8, echo=0, in=0, killio, out=0, parity=0, rts=0, stopbits=1, terminalEOL=2, line=1
 //       DS_Write("SERIAL BAUDRATE=19200")
//            End

//Function BP_refreash(ba) : ButtonControl
//	STRUCT WMButtonAction &ba
//
//	switch( ba.eventCode )
//		case 2: // mouse up
//			VDTGetPortList2 
//			break
//		case -1: // control being killed
//			break
//	endswitch
//
//	return 0
//End


Function /S BP_refreash(ctrlName) : ButtonControl
	String ctrlName
	VDTGetPortList2 //scan
	return S_VDT
End

Function BP_RS232C_portInit2(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	wave Cfg_RS232C
	svar S_VDT
	switch( ba.eventCode )
		case 2: // mouse up
		print StringFromList(Cfg_RS232C[0]-1, S_VDT)
			VDT2 /P=$StringFromList(Cfg_RS232C[0]-1, S_VDT) baud=Cfg_RS232C[1], buffer=Cfg_RS232C[2], databits=Cfg_RS232C[3], echo=Cfg_RS232C[4], in=Cfg_RS232C[5], killio, out=Cfg_RS232C[7], parity=Cfg_RS232C[8], rts=Cfg_RS232C[9], stopbits=Cfg_RS232C[10], terminalEOL=Cfg_RS232C[11], line=Cfg_RS232C[12]
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function BP_RS232C_portOpen(ctrlName) : ButtonControl
	String ctrlName
	wave Cfg_RS232C
	svar S_VDT
	S_VDT=BP_refreash("")
	variable F_COM_PopupListNo=Cfg_RS232C[0]
	//print F_COM_PopupListNo-1, S_VDT
	//print 11,"COM11;COM1;COM2;COM3;COM4;COM5;COM6;COM7;COM8;COM9;COM10;COM13;"
	VDT2 /P=$StringFromList(F_COM_PopupListNo-1, S_VDT) baud=Cfg_RS232C[1], buffer=Cfg_RS232C[2], databits=Cfg_RS232C[3], echo=Cfg_RS232C[4], in=Cfg_RS232C[5], killio, out=Cfg_RS232C[7], parity=Cfg_RS232C[8], rts=Cfg_RS232C[9], stopbits=Cfg_RS232C[10], terminalEOL=Cfg_RS232C[11], line=Cfg_RS232C[12]
	VDTOpenPort2 $StringFromList(F_COM_PopupListNo-1, S_VDT)
	print StringFromList(F_COM_PopupListNo-1, S_VDT),"is Opened"
	VDTOperationsPort2 $StringFromList(F_COM_PopupListNo-1, S_VDT)
	//print S_VDT, "is Opend as designated port"
	return 0
End

Function BP_RS232C_resetPorts(ctrlName) : ButtonControl
	String ctrlName
	wave Cfg_RS232C
	svar S_VDT
	print "reset ALL ports"
	VDT2 resetPorts
	return 0
End

Function BP_RS232C_portClose(ctrlName) : ButtonControl
	String ctrlName
	wave Cfg_RS232C
	VDTClosePort2 $StringFromList(Cfg_RS232C[0]-1, BP_refreash(""))
	print StringFromList(Cfg_RS232C[0]-1, BP_refreash("")), "is Closed"
	return 0
End
 

Function PM_com(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa
wave Cfg_RS232C
	switch( pa.eventCode )
		case 2: // mouse up
			Variable popNum = pa.popNum
			Cfg_RS232C[0]=popNum
			String popStr = pa.popStr
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End
