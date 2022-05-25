#pragma rtGlobals=1		// Use modern global access method.
function GConstDrvPls(ctrlName, SWN_distwv, V_PlsHz, V_xRange, V_step, V_unit_pls)
	string ctrlName, SWN_distwv
	variable V_PlsHz, V_xRange, V_step, V_unit_pls
	variable V_Smpling_Hz=1e6
	Make/O/n=(V_xRange/V_unit_pls/V_PlsHz*V_Smpling_Hz) $SWN_distwv
	wave W_wv=$SWN_distwv
	setscale /I x, 0, (V_xRange/V_unit_pls)/V_PlsHz, "s", W_wv	
//	W_P0CW=7*round(mod(x, 1/100)*100)
	div2Hz(W_wv, V_xRange, V_step, V_step)
end

GConstDrvPls("", "W_P0CW", 1e4, 360, 1, 0.02)

StpMotor_SoftRanding.ipf

function /D t2x(V_t, V_tPrd)
	variable /D V_t, V_tPrd
	if(V_t<V_tPrd/2)
		return 2/V_tPrd^2*V_t^2
	elseif(V_t<V_tPrd)
		return -2/V_tPrd^2*(V_t-V_tPrd)^2+1
	else
		return 1
	endif
end

function /D x2t(V_x, V_tPrd)
	variable /D V_x, V_tPrd
	if(V_x<0.5)
		return sqrt(V_x*V_tPrd^2/2)
	elseif(V_x<1)
		return  -sqrt(-(V_x-1)*V_tPrd^2/2)+V_tPrd
	else
		return nan
	endif
end

function /D div2Hz(W_src, V_xMax, V_dx, V_pls_x)
	wave W_src
	variable V_xMax, V_dx, V_pls_x
	variable V_dt, V_x, V_nPls, V_Hz, V_t
	variable V_tPrd=rightx(W_src)
	variable V_SplFrq_Hz =1/deltax(W_src)
	V_t=0
	for(V_x=0; V_x<V_xMax-V_dx; V_x+=V_dx)
		V_dt=x2t((V_x+V_dx)/V_xMax, V_tPrd)-x2t(V_x/V_xMax, V_tPrd)
		V_Hz=V_dx*V_pls_x/V_dt
		genPlses(W_src, V_t, V_t+V_dt, V_Hz)
		V_t+=V_dt
	endfor
	return  0
end

function genPlses(W_src, V_x1, V_x2, V_Hz)
	wave W_src
	variable V_x1, V_x2, V_Hz
	W_src[x2pnt(W_src, V_x1), x2pnt(W_src, V_x2)]=5*round(mod(x, 1/V_Hz)*V_Hz)
end