local f=string.byte;local i=string.char;local c=string.sub;local u=table.concat;local C=math.ldexp;local E=getfenv or function()return _ENV end;local H=setmetatable;local h=select;local t=unpack;local r=tonumber;local function s(t)local e,n,a="","",{}local d=256;local o={}for l=0,d-1 do o[l]=i(l)end;local l=1;local function f()local e=r(c(t,l,l),36)l=l+1;local n=r(c(t,l,l+e-1),36)l=l+e;return n end;e=i(f())a[1]=e;while l<#t do local l=f()if o[l]then n=o[l]else n=e..c(e,1,1)end;o[d]=e..c(n,1,1)a[#a+1],e,d=n,n,d+1 end;return table.concat(a)end;local d=s('23822T27522S22P27522T1214181022S22Q27921H19141S101N1M22S2322792151A16141927I27K27M27F27912101H1D1I1C1122S22R27921C1M27M2181122U27526D1526Q25K23X21027727921921E2181X22S21T27922L1X2101W1Z22K1X22D22022B22E22A1Z22022922F22B22922021029022E22022D22E1W2281Z22L22A22F2282121Z1X22V22S22S28H2751X101J2A022T24P22D1526O21022V22T2A51D25823T26Q28O22O2812831I1927P27921E1D1C1H10191C1M2AU28822X2791Y2832AR2AT2AV2AX1H22S22W2AQ2AS2AU2AW2AY10112131S22T22027922G23124524A25W23127522H22T21X22T25Q2792BV22D2BY27922K22T2BQ25S2C421X2BQ2662BX22T22L23H27526V2CG22T22922T2C226V2792292251522T26V2252752C22392CT27922D21126T2CT21127522922L2CN22L2D621H2D326V21H2CW2BW2CZ2CW22525X2CT2CV22T22122T2CY26Y27922121124L22T25P2D52CM22L2D526V2DA2DO2CM2DI2DO2252512DM2752DN2E722122L2DF2E327522121H2DW2DE2752CF2CY2CI27522A2DH25N28I22H2BT2CT2EY2BV2CH2792281L2BQ26E1L2752F42BQ26V2F82CK2312BX26V2EY22D2392EH2CY2DO2392F826V2FM22523925H2CT2FM28W2E227921X23H2EQ2CJ22J2C624A26H28I21X2CD26D2CD21T1T2F82641T27521T21H2DF2652DF22T21W2F524A2FC2GI26D2FP26D2752GP2FB2FD21X2FF2EZ2GI26L2FP26L2GI2FM2FQ2BU2EY2FH2752AC2752782762HH27A27C27E2332B228321I27M1J1C1627E23A27921J171T2101B27V1S1H2HT1M2HQ1N2HS2HU2AP2752B31H2122AW101B1H28F22T2EY22T2BO2BQ2682F02DH2CO2F923H2FB2CJ22H23H2FG2IY22T2FY2BU2H92FM2F12E72EX2CH2IN2792AK2762JE22T1L141C27N28928B28D1N28F28P27528R28T2802752822842862882A52A21J22T28W27522C2BP2BR2EY2DP2752FU2CW2392D525Y2FM22J2652BQ26H26522T26D23D22L2BX25Q2E423H2EY25H2EY23H2192KS21927523E2312D326S2BT26D2G42KL2EW2EY25T2EY2KQ2C22KT27523G2CA2BR2CD2KV2BX26C2LF2D222T26J2DZ2L42CY25R2L82G42752G72KO2LA2G628I22L2LD2LF2EG2BY2E42LW22T2LY2M32792M22L92252KL2CV26D22I2EY26G2LZ2MH28I22J2K826H2L822M2MP2MR2LB2KO2292M82DG2BX26Q27922J22524A2G62NA1Q2C22C22DS2KE2752672FM22D2G12CT2CJ22D2252FG2DN2FJ2CH2J72HC2JC275');local o=bit and bit.bxor or function(l,n)local e,o=1,0 while l>0 and n>0 do local c,a=l%2,n%2 if c~=a then o=o+e end l,n,e=(l-c)/2,(n-a)/2,e*2 end if l<n then l=n end while l>0 do local n=l%2 if n>0 then o=o+e end l,e=(l-n)/2,e*2 end return o end local function e(e,l,n)if n then local l=(e/2^(l-1))%2^((n-1)-(l-1)+1);return l-l%1;else local l=2^(l-1);return(e%(l+l)>=l)and 1 or 0;end;end;local l=1;local function n()local a,c,n,e=f(d,l,l+3);a=o(a,101)c=o(c,101)n=o(n,101)e=o(e,101)l=l+4;return(e*16777216)+(n*65536)+(c*256)+a;end;local function a()local e=o(f(d,l,l),101);l=l+1;return e;end;local function D()local o=n();local l=n();local c=1;local o=(e(l,1,20)*(2^32))+o;local n=e(l,21,31);local l=((-1)^e(l,32));if(n==0)then if(o==0)then return l*0;else n=1;c=0;end;elseif(n==2047)then return(o==0)and(l*(1/0))or(l*(0/0));end;return C(l,n-1023)*(c+(o/(2^52)));end;local r=n;local function s(e)local n;if(not e)then e=r();if(e==0)then return'';end;end;n=c(d,l,l+e-1);l=l+e;local e={}for l=1,#n do e[l]=i(o(f(c(n,l,l)),101))end return u(e);end;local l=n;local function i(...)return{...},h('#',...)end local function F()local t={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};local f={0,0};local l={};local d={t,nil,f,nil,l};local l=n()local c={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};for n=1,l do local e=a();local l;if(e==2)then l=(a()~=0);elseif(e==3)then l=D();elseif(e==1)then l=s();end;c[n]=l;end;d[2]=c d[4]=a();for a=1,n()do local c=o(n(),60);local n=o(n(),146);local o=e(c,1,2);local l=e(n,1,11);local l={l,e(c,3,11),nil,nil,n};if(o==0)then l[3]=e(c,12,20);l[5]=e(c,21,29);elseif(o==1)then l[3]=e(n,12,33);elseif(o==2)then l[3]=e(n,12,32)-1048575;elseif(o==3)then l[3]=e(n,12,32)-1048575;l[5]=e(c,21,29);end;t[a]=l;end;for l=1,n()do f[l-1]=F();end;return d;end;local function u(l,T,d)local e=l[1];local n=l[2];local o=l[3];local l=l[4];return function(...)local a=e;local c=n;local C=o;local o=l;local l=i local e=1;local r=-1;local s={};local i={...};local f=h('#',...)-1;local D={};local n={};for l=0,f do if(l>=o)then s[l-o]=i[l+1];else n[l]=i[l+1];end;end;local l=f-o+1 local l;local o;while true do l=a[e];o=l[1];if o<=30 then if o<=14 then if o<=6 then if o<=2 then if o<=0 then n[l[2]]=n[l[3]];elseif o>1 then n[l[2]]=(l[3]~=0);else do return end;end;elseif o<=4 then if o==3 then if(n[l[2]]==n[l[5]])then e=e+1;else e=e+l[3];end;else n[l[2]]={};end;elseif o==5 then local o=l[2];local a=l[5];local l=o+2;local c={n[o](n[o+1],n[l])};for e=1,a do n[l+e]=c[e];end;local o=n[o+3];if o then n[l]=o else e=e+1;end;else n[l[2]][c[l[3]]]=c[l[5]];end;elseif o<=10 then if o<=8 then if o==7 then local e=l[2];local c=e+l[3]-2;local o={};local l=0;for e=e,c do l=l+1;o[l]=n[e];end;do return t(o,1,l)end;else local o=l[2];local a=l[5];local l=o+2;local c={n[o](n[o+1],n[l])};for e=1,a do n[l+e]=c[e];end;local o=n[o+3];if o then n[l]=o else e=e+1;end;end;elseif o==9 then n[l[2]]={unpack({},1,l[3])};else n[l[2]]=c[l[3]];end;elseif o<=12 then if o==11 then n[l[2]]=T[l[3]];else local f=C[l[3]];local t;local o={};t=H({},{__index=function(e,l)local l=o[l];return l[1][l[2]];end,__newindex=function(n,l,e)local l=o[l]l[1][l[2]]=e;end;});for c=1,l[5]do e=e+1;local l=a[e];if l[1]==0 then o[c-1]={n,l[3]};else o[c-1]={T,l[3]};end;D[#D+1]=o;end;n[l[2]]=u(f,t,d);end;elseif o==13 then n[l[2]]={};else local o=n[l[3]];if not o then e=e+1;else n[l[2]]=o;e=e+a[e+1][3]+1;end;end;elseif o<=22 then if o<=18 then if o<=16 then if o==15 then n[l[2]]=n[l[3]][n[l[5]]];else n[l[2]]={unpack({},1,l[3])};end;elseif o>17 then n[l[2]]=n[l[3]];else local i;local t;local o;local h,f;local o;d[c[l[3]]]=n[l[2]];e=e+1;l=a[e];n[l[2]]=d[c[l[3]]];e=e+1;l=a[e];o=l[2];h,f={n[o]()};f=o+l[5]-2;t=0;for l=o,f do t=t+1;n[l]=h[t];end;r=f;e=e+1;l=a[e];n[l[2]]=n[l[3]][c[l[5]]];e=e+1;l=a[e];n[l[2]]=n[l[3]][c[l[5]]];e=e+1;l=a[e];n[l[2]]=n[l[3]][c[l[5]]];e=e+1;l=a[e];n[l[2]]={};e=e+1;l=a[e];i=n[l[3]];if not i then e=e+1;else n[l[2]]=i;e=e+a[e+1][3]+1;end;end;elseif o<=20 then if o==19 then local e=l[2];local c,o={n[e]()};local o=e+l[5]-2;local l=0;for e=e,o do l=l+1;n[e]=c[l];end;r=o;else local o=n[l[3]];if not o then e=e+1;else n[l[2]]=o;e=e+a[e+1][3]+1;end;end;elseif o>21 then local e=l[2];local o={};local l=e+l[3]-1;for l=e+1,l do o[#o+1]=n[l];end;do return n[e](t(o,1,l-e))end;else d[c[l[3]]]=n[l[2]];end;elseif o<=26 then if o<=24 then if o==23 then local u;local C;local i;local f;local h;local s;local o;n[l[2]]=d[c[l[3]]];e=e+1;l=a[e];o=l[2];s=n[l[3]];n[o+1]=s;n[o]=s[c[l[5]]];e=e+1;l=a[e];n[l[2]]=c[l[3]];e=e+1;l=a[e];o=l[2];h={};f=0;i=o+l[3]-1;for l=o+1,i do f=f+1;h[f]=n[l];end;C={n[o](t(h,1,i-o))};i=o+l[5]-2;f=0;for l=o,i do f=f+1;n[l]=C[f];end;r=i;e=e+1;l=a[e];o=l[2];s=n[l[3]];n[o+1]=s;n[o]=s[c[l[5]]];e=e+1;l=a[e];o=l[2];h={};i=o+l[3]-1;for l=o+1,i do h[#h+1]=n[l];end;do return n[o](t(h,1,i-o))end;e=e+1;l=a[e];o=l[2];i=r;u={};f=0;for l=o,i do f=f+1;u[f]=n[l];end;do return t(u,1,f)end;e=e+1;l=a[e];do return end;else n[l[2]]=c[l[3]];end;elseif o==25 then do return end;else d[c[l[3]]]=n[l[2]];end;elseif o<=28 then if o==27 then local e=l[2];local o={};local l=e+l[3]-1;for l=e+1,l do o[#o+1]=n[l];end;do return n[e](t(o,1,l-e))end;else n[l[2]]=n[l[3]][n[l[5]]];end;elseif o==29 then local o=l[2];local c=r;local e={};local l=0;for o=o,c do l=l+1;e[l]=n[o];end;do return t(e,1,l)end;else e=e+l[3];end;elseif o<=45 then if o<=37 then if o<=33 then if o<=31 then if n[l[2]]then e=e+1;else e=e+l[3];end;elseif o>32 then local o=l[2];local a={};local e=0;local c=o+l[3]-1;for l=o+1,c do e=e+1;a[e]=n[l];end;local c={n[o](t(a,1,c-o))};local l=o+l[5]-2;e=0;for l=o,l do e=e+1;n[l]=c[e];end;r=l;else if(n[l[2]]==n[l[5]])then e=e+1;else e=e+l[3];end;end;elseif o<=35 then if o>34 then n[l[2]]=d[c[l[3]]];else if not n[l[2]]then e=e+1;else e=e+l[3];end;end;elseif o>36 then n[l[2]]=d[c[l[3]]];else n[l[2]]=u(C[l[3]],nil,d);end;elseif o<=41 then if o<=39 then if o==38 then n[l[2]]=(l[3]~=0);else n[l[2]]=u(C[l[3]],nil,d);end;elseif o>40 then d[c[l[3]]]=n[l[2]];e=e+1;l=a[e];n[l[2]]={unpack({},1,l[3])};e=e+1;l=a[e];n[l[2]]={};e=e+1;l=a[e];n[l[2]][c[l[3]]]=c[l[5]];e=e+1;l=a[e];n[l[2]]={};e=e+1;l=a[e];n[l[2]][c[l[3]]]=c[l[5]];e=e+1;l=a[e];n[l[2]][c[l[3]]]=n[l[5]];e=e+1;l=a[e];n[l[2]][c[l[3]]]=c[l[5]];e=e+1;l=a[e];n[l[2]]={};e=e+1;l=a[e];n[l[2]][c[l[3]]]=c[l[5]];else local o;local f;local i;local d;n[l[2]][c[l[3]]]=n[l[5]];e=e+1;l=a[e];n[l[2]][c[l[3]]]=n[l[5]];e=e+1;l=a[e];n[l[2]][c[l[3]]]=n[l[5]];e=e+1;l=a[e];d=l[2];i=d+l[3]-2;f={};o=0;for l=d,i do o=o+1;f[o]=n[l];end;do return t(f,1,o)end;e=e+1;l=a[e];do return end;end;elseif o<=43 then if o==42 then local h;local o;local f;local s,i;local f;n[l[2]][c[l[3]]]=n[l[5]];e=e+1;l=a[e];n[l[2]]=d[c[l[3]]];e=e+1;l=a[e];n[l[2]][c[l[3]]]=n[l[5]];e=e+1;l=a[e];n[l[2]]=d[c[l[3]]];e=e+1;l=a[e];f=l[2];s,i={n[f]()};i=f+l[5]-2;o=0;for l=f,i do o=o+1;n[l]=s[o];end;r=i;e=e+1;l=a[e];n[l[2]][c[l[3]]]=n[l[5]];e=e+1;l=a[e];f=l[2];i=f+l[3]-2;h={};o=0;for l=f,i do o=o+1;h[o]=n[l];end;do return t(h,1,o)end;e=e+1;l=a[e];do return end;else n[l[2]][c[l[3]]]=n[l[5]];end;elseif o==44 then if n[l[2]]then e=e+1;else e=e+l[3];end;else n[l[2]][c[l[3]]]=n[l[5]];end;elseif o<=53 then if o<=49 then if o<=47 then if o==46 then local e=l[2];local o=n[l[3]];n[e+1]=o;n[e]=o[c[l[5]]];else local o=l[2];local c=o+l[3]-2;local e={};local l=0;for o=o,c do l=l+1;e[l]=n[o];end;do return t(e,1,l)end;end;elseif o==48 then e=e+l[3];else local c=l[2];local o=r;local e={};local l=0;for o=c,o do l=l+1;e[l]=n[o];end;do return t(e,1,l)end;end;elseif o<=51 then if o==50 then n[l[2]]=T[l[3]];else local e=l[2];local c,o={n[e]()};local o=e+l[5]-2;local l=0;for e=e,o do l=l+1;n[e]=c[l];end;r=o;end;elseif o==52 then local o=l[2];local e=n[l[3]];n[o+1]=e;n[o]=e[c[l[5]]];else local e=l[2];local o=n[e];local l=l[3];for l=1,l do o[l]=n[e+l]end;end;elseif o<=57 then if o<=55 then if o>54 then local o=l[2];local c={};local e=0;local a=o+l[3]-1;for l=o+1,a do e=e+1;c[e]=n[l];end;local c={n[o](t(c,1,a-o))};local l=o+l[5]-2;e=0;for l=o,l do e=e+1;n[l]=c[e];end;r=l;else local e=l[2];local o=n[e];local l=l[3];for l=1,l do o[l]=n[e+l]end;end;elseif o>56 then n[l[2]]=n[l[3]][c[l[5]]];else if not n[l[2]]then e=e+1;else e=e+l[3];end;end;elseif o<=59 then if o>58 then n[l[2]][c[l[3]]]=c[l[5]];else local d;local t;local o;n[l[2]][c[l[3]]]=c[l[5]];e=e+1;l=a[e];n[l[2]][c[l[3]]]=n[l[5]];e=e+1;l=a[e];n[l[2]]={};e=e+1;l=a[e];n[l[2]][c[l[3]]]=c[l[5]];e=e+1;l=a[e];n[l[2]]={};e=e+1;l=a[e];n[l[2]][c[l[3]]]=n[l[5]];e=e+1;l=a[e];n[l[2]][c[l[3]]]=c[l[5]];e=e+1;l=a[e];o=l[2];t=n[o];d=l[3];for l=1,d do t[l]=n[o+l]end;end;elseif o==60 then local t=C[l[3]];local c;local o={};c=H({},{__index=function(e,l)local l=o[l];return l[1][l[2]];end,__newindex=function(n,l,e)local l=o[l]l[1][l[2]]=e;end;});for c=1,l[5]do e=e+1;local l=a[e];if l[1]==0 then o[c-1]={n,l[3]};else o[c-1]={T,l[3]};end;D[#D+1]=o;end;n[l[2]]=u(t,c,d);else n[l[2]]=n[l[3]][c[l[5]]];end;e=e+1;end;end;end;return u(F(),{},E())();
