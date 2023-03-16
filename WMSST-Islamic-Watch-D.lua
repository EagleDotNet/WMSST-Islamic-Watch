------------ Output  ------------

--[==[

var_hijri_day        = number of hijri day
var_hijri_month  = number of hijri month
var_hijri_year      = number of hijri year
var_hijri_date     = full date

var_ia_monthnames[var_hijri_month]  = Arabic name of hijri month
var_ie_monthnames[var_hijri_month]  = English name of hijri month

var_ar_monthnames[{dn}]  = Arabic name of English month
var_en_monthnames[{dn}]  = English name of English month

var_ar_daynames[{ddw0}+1]  = Arabic name of week day
var_en_daynames[{ddw0}+1]  = English name of week day

var_title                                       = opinion type name
var_totime(var_s_shroq)       = Shroq Time
var_totime(var_s_fajr)            = Fajr Time
var_totime(var_s_noon )        = Zuhr Time
var_totime(var_s_asr)             = Asr Time
var_totime(var_s_maghrib)   = Maghreb Time
var_totime(var_s_isha)           = Isha Time
var_totime(var_s_wait)           = Waiting Time

]==]

------------ Intput  ------------

-- Choose opinion to follow.  To specify details yourself, select none of them
-- and adjust numbers a little further down.

-- opinion="ISNA"	     -- Islamic Society of N. America
-- opinion="MWL"     -- Muslim World League
 opinion="EGAOS"   -- Egyptian General Authority of Survey
-- opinion="UmmAlQura"	-- Umm al-Qura University (Makka)
-- opinion="UIS"	-- University of Islamic Sciences, Karachi
-- opinion="GeoPhys"	-- Institute of Geophysics, University of Tehran
-- opinion="IthnaAshari"   -- Shia Ithna Ashari, Leva Research Inst., Qum.

fajr_angle=19.5
isha_angle=17.5
maghrib_angle=0.833	-- maghrib at sunset; Shiites might set this to 4.
asr_constant= 1 -- Set to 2 for Hanafi 1 for shafee opinion.

fajr_edit            = 1 -- per minute 0 is default
shroq_edit       = 3 -- per minute 0 is default
zuhr_edit          = 3 -- per minute 0 is default
asr_edit            = 2 -- per minute 0 is default
maghreb_edit = 2 -- per minute 0 is default
isha_edit          = 2 -- per minute 0 is default

------------ Names ------------

var_ie_monthnames = {"Muharram", "Safar", "First Rabi", "Second Rabi", "First Jumada", "Second Jumada", "Rajab", "Sha'ban", "Ramadan", "Shawwal", "Zu al-Qada", "Zu al-Hijjah"}

var_en_monthnames = {"Jan", "Feb ", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"}

var_en_daynames = {"Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"}  

var_ia_monthnames = {"محرّم", "صفر", "ربيع الأوّل", "ربيع الثاني", "جمادى الأولى", "جمادى الثانية", "رجب", "شعبان", "رمضان", "شوّال", "ذو القعدة", "ذو الحجّة" }

var_ar_monthnames = {"يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو", "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر"}

var_ar_daynames = {"الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"}

------------ Start Prayer Time Code ------------

var_title=""
if opinion=="ISNA" then
   fajr_angle=15
   isha_angle=15
   var_title="ISNA Calculation"
elseif opinion=="MWL" then
   fajr_angle=18
   isha_angle=17
   var_title="MWL Calculation"
elseif opinion=="EGAOS" then
   fajr_angle=19.5 --38.7
   isha_angle=17.5 --36.3
   var_title="Egypt. Gen. Survey"
elseif opinion=="UmmAlQura" then
   fajr_angle=18.5
   isha_override=function (jd, alat, alon)
      return maghrib(jd, alat, alon) + (var_s_date.month==9 and 1/12 or 1.5/24)
   end
   var_title="Umm al-Qura Univ."
elseif opinion=="UIS" then
   fajr_angle=18
   isha_angle=18
   var_title="Univ. Isl. Studies"
elseif opinion=="GeoPhys" then
   fajr_angle=17.7
   isha_angle=14
   var_title="Univ. Tehran"
elseif opinion=="IthnaAshari" then
   fajr_angle=16
   isha_angle=13
   maghrib_angle=4	-- ?
   var_title="Shia Ithna Ashari"
end

IslEpoch=227015

function isl_ly(y)
    local yy=y%30
    return yy==2 or yy==5 or yy==7 or yy==10 or yy==13 or yy==16 or yy==18 or yy==21 or yy==24 or yy==26 or yy==29
end

function isl_last_day(m, y)
    if m==1 or m==3 or m==5 or m==7 or m==9 or m==11
	then return 30
    elseif m==2 or m==4 or m==6 or m==8 or m==10
	then return 29
    elseif isl_ly(y)
	then return 30
    else
	return 29
    end
end

function isl_day_number(m, d, y)
   return 30 * math.modf(m/2) + 29 * math.modf((m-1)/2) + d
end


function isl_to_fixed(month, day, year)
   local y=year%30
   local ly_in_cycle

   if y<3 then ly_in_cycle=0
   elseif y<6 then ly_in_cycle=1
   elseif y<8 then ly_in_cycle=2
   elseif y<11 then ly_in_cycle=3
   elseif y<14 then ly_in_cycle=4
   elseif y<17 then ly_in_cycle=5
   elseif y<19 then ly_in_cycle=6
   elseif y<22 then ly_in_cycle=7
   elseif y<25 then ly_in_cycle=8
   elseif y<27 then ly_in_cycle=9
   else ly_in_cycle=10
   end

   return (isl_day_number(month, day, year) + (year-1)*354 +
	      math.modf(year/30)*11 + ly_in_cycle + (IslEpoch-1))
end

function isl_from_fixed(d)
    local approx=math.modf((d-IslEpoch)/355)
    local year=approx
    local month
    local day
    local y
    local m

    if d < IslEpoch then return nil end

    y=approx
    while d >= isl_to_fixed(1, 1, y+1)
    do
       year=year+1
       y=y+1
    end
    month=1
    m=1
    while d > isl_to_fixed(m, isl_last_day(m, year), year)
    do
       month=month+1
       m=m+1
    end
    day=d-(isl_to_fixed(month, 1, year)-1)
    return ({year=year, month=month, day=day})
end

function greg_jd_to_fixed(y, jd)
    local rv
    rv = (y-1) * 365
    rv = rv + math.modf((y-1)/4)
    rv = rv - math.modf((y-1)/100)
    rv = rv + math.modf((y-1)/400)
    rv = rv + jd
    return rv
end



function var_dx(r,t) return  r*math.sin(math.rad(t)) end

function var_dy(r,t) return  -r*math.cos(math.rad(t)) end

var_ardig="٠١٢٣٤٥٦٧٨٩"

-- doing bad Unicode things
function var_arabicnum(n)
   local rv=""
   local j
   if n==0 then return var_ardig:sub(1,2) end
   while n>0 do
      j=n%10
      rv=var_ardig:sub(2*j+1,2*j+2) .. rv
      n=math.floor(n/10)
   end
   return rv
end
function ddy2jd(y,ddy,dtp)
    dtp=dtp or 0.   -- dtp should be corrected for TZ before passing in.
    return 1721424.5 + (y-1)*365 + math.modf((y-1)/4) - math.modf((y-1)/100) + math.modf((y-1)/400) + ddy + dtp
end

--[==[  from http://praytimes.org/calculation/ ...

 d = jd - 2451545.0;  // jd is the given Julian date 

   g = 357.529 + 0.98560028* d;
   q = 280.459 + 0.98564736* d;
   L = q + 1.915* sin(g) + 0.020* sin(2*g);

   R = 1.00014 - 0.01671* cos(g) - 0.00014* cos(2*g);
   e = 23.439 - 0.00000036* d;
   RA = arctan2(cos(e)* sin(L), cos(L))/ 15;

   D = arcsin(sin(e)* sin(L));  // declination of the Sun
   EqT = q/15 - RA;  // equation of time

   (( argh, nice going, use L for two different things! ))
]==]

function sind(x) return math.sin(math.rad(x)) end
function cosd(x) return math.cos(math.rad(x)) end
function tand(x) return math.tan(math.rad(x)) end
var_s_decl=0

function var_angleT(jd, alat, alon, alpha)
   local d, g, q, L, Ll, R, e, RA, D, EqT

   d = jd - 2451545.0
   g = 357.529 + 0.98560028* d
   q = 280.459 + 0.98564736* d
   Ll = q + 1.915* sind(g) + 0.020* sind(2*g)

   R = 1.00014 - 0.01671* cosd(g) - 0.00014* cosd(2*g)
   e = 23.439 - 0.00000036* d
   RA = math.deg(math.atan2(cosd(e)* sind(Ll), cosd(Ll)))/15

   D = math.deg(math.asin(sind(e)* sind(Ll)))
   L = alat
   EqT = q/15 - RA

   var_s_decl=D			-- This function is run early on.

   return 1/15 * math.deg(math.acos((-sind(alpha)-sind(L)*sind(D))/(cosd(L)*cosd(D))))
end

-- dtp with higher precision
function dtpp(dh23,dm,ds,dss)
   if not dh23 then
      dh23, dm, ds, dss = {dh23}, {dm}, {ds}, {dss}
   end
   dm = dm or 0
   ds = ds or 0
   dss = dss or 0
   return (dh23 + dm/60 + ds/3600 + dss/3600000)/24
end
-- Sometimes need it updated
var_s_dtpp=dtpp

function var_now()
   return ddy2jd({dyy},{ddy},{dtp}) -- Do we need to work with dtp? Care about zone?
end

fajr=function (jd, alat, alon)
   return var_s_noon - var_angleT(jd, alat, alon, fajr_angle)/24
end

isha=function (jd, alat, alon)
   return var_s_noon + var_angleT(jd, alat, alon, isha_angle)/24
end

maghrib=function (jd, alat, alon)
   return var_s_noon + var_angleT(jd, alat, alon, maghrib_angle)/24
end

asr=function (jd, alat, alon)
   return var_s_noon + isna_asr(jd, alat, alon, asr_constant)
end

function isna_asr (jd, alat, alon, t)
   local A
   t = t or 1
   A=1/15 * math.deg(math.acos((math.sin(math.atan(1/(t+tand(alat-var_s_decl)))) - sind(alat) * sind(var_s_decl))/(cosd(alat)*cosd(var_s_decl))))
   return A/24
end

function var_between(a,b,c)
  return a<b and b<c
end

function var_toentime(d)
   return ("%d:%02d"):format(d*24, (d*24)%1*60)
end

function var_toartime(d)
   local m
   m=math.floor((d*24)%1*60)
   return ("%s:%s%s"):format(var_arabicnum(math.floor(d*24)), (m<10 and '٠' or ''), var_arabicnum(m))
end

var_totime=var_toentime

function toggle_ar()
   var_arabic=not var_arabic
   if var_arabic then
     var_totime=var_toartime
   else
      var_totime=var_toentime
    end
end

-- Kaaba:
klat=21.4225
klon=39.826181
DEGREES=math.pi/180

function var_qibla(lat, lon)
   return math.atan2(math.sin((klon-lon)*DEGREES)*math.cos(klat*DEGREES), math.cos(lat*DEGREES)*math.sin(klat*DEGREES)-math.sin(lat*DEGREES)*math.cos(klat*DEGREES)*math.cos((klon-lon)*DEGREES))/DEGREES
end

om = 0.0006944444
zuhr_edit = zuhr_edit * om
fajr_edit = (fajr_edit * om) - zuhr_edit
shroq_edit = shroq_edit * om
asr_edit = (asr_edit * om) - zuhr_edit
maghreb_edit = (maghreb_edit * om) - zuhr_edit
isha_edit = (isha_edit * om) - zuhr_edit

var_rad=215
var_s_now=0
var_s_noon=0
var_alat={alat} 
var_alon={alon} 
var_lastvibe=0
function on_millisecond (dt)
   local times
   local i
   var_s_shroq = {wsrp} + shroq_edit
   var_s_date=isl_from_fixed(greg_jd_to_fixed({dyy},{ddy}))
   var_s_noon=(({wsrp}+{wssp})/2) + zuhr_edit
   var_s_now=var_now()
   var_s_fajr=fajr(var_s_now, var_alat, var_alon) + fajr_edit 
   var_s_asr=asr(var_s_now, var_alat, var_alon) + asr_edit
   var_s_maghrib=maghrib(var_s_now, var_alat, var_alon) + maghreb_edit
   var_s_isha=(isha_override or isha)(var_s_now, var_alat, var_alon) + isha_edit

-- 0.02
var_s_wait =
(((var_s_fajr - {dtp})) > 0
and var_s_fajr - {dtp}
or ((var_s_noon - {dtp})) > 0
and var_s_noon - {dtp}
or ((var_s_asr - {dtp})) > 0
and var_s_asr - {dtp}
or ((var_s_maghrib - {dtp})) > 0
and var_s_maghrib - {dtp}
or ((var_s_isha - {dtp})) > 0
and var_s_isha - {dtp}
or 1-{dtp}) 

   times={var_s_fajr, var_s_noon, var_s_asr, var_s_maghrib, var_s_isha}
   if var_s_vibrate then
      for i=1,#times,1 do
	 if var_between(times[i], dtpp(), times[i]+2/24/60) then
	    if var_lastvibe and dtpp()-var_lastvibe >= 5/24/60 then
	       var_lastvibe={dtp}
	       wm_vibrate(600,4)
	    end
	    break
	 end
      end
   end
end

hm = 0.0001736111
--hm = 0.0003472222
--hm = 0.0006944444
function on_minute (m)
if
var_s_wait >= hm * 119 and  var_s_wait <= hm * 121
or 
var_s_wait >= hm * 59 and  var_s_wait <= hm * 61
then
--wm_sfx('beep478')
--wm_sfx('beep147')
--wm_sfx('cool426')
wm_sfx('casio955') 
wm_vibrate(600,6)
end
end

function on_display_bright()
   var_alat=(tonumber({alat}) or 0)
   var_alon=(tonumber({alon}) or 0)
end

function on_display_not_bright()
   var_qibl=false
end

--on_display_bright ()
--on_display_not_bright()
on_millisecond (1)
on_minute (1)



------------ End Prayer Time Code ------------

------------ Start Hijri Date Code ------------

function on_hour (h)
-- Day of hijri date --
var_hijri_day=({dn}<(3)and(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-math.floor(math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631)-8.01/60.)/(10631./30.))*(10631./30.)+8.01/60.)-math.floor((math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5))*29.5001-29))or(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631)-math.floor(math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631)-8.01/60.)/(10631./30.))*(10631./30.)+8.01/60.)-math.floor((math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5))*29.5001-29))) 

-- Month of hijri date --
var_hijri_month = (({dn}<(3)and(math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5))or(math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5)) == 1) and 01 or
({dn}<(3)and(math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5))or(math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5)) == 2) and 02 or 
({dn}<(3)and(math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5))or(math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5)) == 3) and 03 or 
({dn}<(3)and(math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5))or(math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5)) == 4) and 04 or 
({dn}<(3)and(math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5))or(math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5)) == 5) and 05 or  
({dn}<(3)and(math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5))or(math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5)) == 6) and 06 or 
({dn}<(3)and(math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5))or(math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5)) == 7) and 07 or   
({dn}<(3)and(math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5))or(math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5)) == 8) and 08 or   
({dn}<(3)and(math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5))or(math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5)) == 9) and 09 or  
({dn}<(3)and(math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5))or(math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5)) == 10) and 10 or 
({dn}<(3)and(math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*(({dyy}-1)+4716)))+(math.floor(30.6001*(({dn}+12)+1)))+{dd}+2-(math.floor(({dyy}-1)/100))+(math.floor((math.floor(({dyy}-1)/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5))or(math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-(math.floor((math.floor((((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)-10631*(math.floor(((math.floor(365.25*({dyy}+4716)))+(math.floor(30.6001*({dn}+1)))+{dd}+2-(math.floor({dyy}/100))+(math.floor((math.floor({dyy}/100))/4))-1524-1948084)/10631))-8.01/60)/(10631/30)))*(10631/30)+8.01/60))+28.5001)/29.5)) == 11) and 11 or 12) 

-- Year of hijri date --
var_hijri_year = ({dn}<(3)and(30*math.floor(((math.floor(365.25*(({dyy}-1)+4716))+math.floor(30.6001*(({dn}+12)+1))+({dd})+2-math.floor(({dyy}-1)/100)+math.floor(math.floor(({dyy}-1)/100)/4)-1524)-1948084)/10631)+math.floor(((math.floor(365.25*(({dyy}-1)+4716))+math.floor(30.6001*(({dn}+12)+1))+({dd})+2-math.floor(({dyy}-1)/100)+math.floor(math.floor(({dyy}-1)/100)/4)-1524)-1948084-10631*math.floor(((math.floor(365.25*(({dyy}-1)+4716))+math.floor(30.6001*(({dn}+12)+1))+({dd})+2-math.floor(({dyy}-1)/100)+math.floor(math.floor(({dyy}-1)/100)/4)-1524)-1948084)/10631)-(8.01/60))/(10631/30)))or(30*math.floor(((math.floor(365.25*({dyy}+4716))+math.floor(30.6001*({dn}+1))+({dd})+2-math.floor({dyy}/100)+math.floor(math.floor({dyy}/100)/4)-1524)-1948084)/10631)+math.floor(((math.floor(365.25*({dyy}+4716))+math.floor(30.6001*({dn}+1))+({dd})+2-math.floor({dyy}/100)+math.floor(math.floor({dyy}/100)/4)-1524)-1948084-10631*math.floor(((math.floor(365.25*({dyy}+4716))+math.floor(30.6001*({dn}+1))+({dd})+2-math.floor({dyy}/100)+math.floor(math.floor({dyy}/100)/4)-1524)-1948084)/10631)-(8.01/60))/(10631/30)))) 

-- full date --
var_hijri_date = var_hijri_day.." / ".. var_ie_monthnames[var_hijri_month].. " / ".. var_hijri_year

end
on_hour (1)
------------ End Hijri Date Code ------------
