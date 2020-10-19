#!/bin/sh
######################
# makePacket.sh - Create the audio output file for an APRS position report
#
# HISTORICAL INFORMATION -
#
#  2018-02-12  msipin  (Circa) - Created.
#  2018-02-20  msipin  Ensured leading zeros in lat and lon. Added ability to convert some
#                      GPS's "non-NMEA" (aka decimal) LAT/LON values into NMEA-compatible
#                      format.
#  2018-02-22  msipin  Trimmed output, tried specifying Keller (Keller Peak) repeater in path
#  2018-06-04  msipin/epowell  Adapted for St. Louis testing, and for using AGW/AGPE (spelling?)
#  2018-11-01  msipin/epowell  Adjusted for using Baofeng 888 as transmitter, rather than BCM built-in oscillator
#  2018-11-04  msipin/epowell  Bumped up to "Warpig-IV" - otherwise same as prior (NOTE: THIS MEANS that this
#                              version will work with *both* Baofeng 888 + VOX and the BCM internal oscillator
#                              to generate APRS position reports.)
#  2019-01-16  msipin          Replaced my call with "N0CALL". Allowed multiple temperatures to be transmitted.
#  2019-03-05  msipin  Added instructions for sending the newly-created packet out both via the BCM built-in
#                      oscillator and via PCM0/a USB audio dongle.
#  2019-04-28  msipin  Added trailing space after all data to separate valid data from last digit "weird" decode
#  2019-05-02  msipin  Adapted to using getDirewolfData, rather than just sending temperature data
#  2019-11-02  msipin  Changed APRS PATH between WIDE2-1 and WIDE1-1 based upon altitude. (WIDE2-1 only used
#                      at "lower altitudes".) <<<--- NOTE: THIS STATEMENT IS WRONG - see the next line!
#  2019-11-05  msipin  FIXED the altitude-based APRS PATH manipulation (I had it reversed!) WIDE2-1 is used at
#                      *HIGHER* altitudes, and WIDE1-1 is digi-fill-in, used only at LOWER altitudes.
######################

# All last-known-good data will be written to files in the following directory -
LAST_KNOWN_GOOD_DIR=/usr/local/bin

# If need to convert GPS output to "NMEA-compatible" format, set the following
# variable to "1". IF NOT, set it to "0" -
GPS_TO_NMEA=1	# NOTE: "ORIG GPS's" = 0, "Microcenter GPS" =1

AUDIO_FILE="packet.Loc.wav"

VERBOSE="1"

if [ $# -ge 1 -a ""$1"" = "-q" ]
then
	#echo
	#echo "DEBUG: QUIET MODE"
	VERBOSE="0"
fi



# Your callsign (MANDATORY!) - Use "dash-eleven" ("-11") to automatically mark as a balloon
MYCALL="N0CALL-13"

# Desired -
# ZULU_DDHHMM="110736"
ZULU_DDHHMM=`date "+%d%H%M"`

# Latitude, format: hhmm.ssN (or  hhmm.ssS)
# Desired -
# What is in the last-known-good file -
##echo "DEBUG: READ-LAT: `cat ${LAST_KNOWN_GOOD_DIR}/lat`"
# If need to convert GPS format to "NMEA format"...
if [ ""$GPS_TO_NMEA"" = "1" ]
then
    DEG=`cat ${LAST_KNOWN_GOOD_DIR}/lat | awk -F"," '{ printf "%d",int($1); }'`
    PRT=`cat ${LAST_KNOWN_GOOD_DIR}/lat | awk -F"," '{ printf "%.4f",($1-int($1)); }'`
    MIN=`echo ${PRT} | awk '{ printf "%2.4f",($1*60.0); }'`
    N_S=`cat ${LAST_KNOWN_GOOD_DIR}/lat | awk -F"," '{ print $2 }'`
    ##echo "DEBUG: DEG: ${DEG}"
    ##echo "DEBUG: PRT: ${PRT}"
    ##echo "DEBUG: MIN: ${MIN}"
    ##echo "DEBUG: N_S: ${N_S}"
    LAT=`echo ${DEG} ${MIN} ${N_S} | awk '{ printf "%04d.%02d%s",int($1*100+$2),int((($1*100+$2)-int($1*100+$2))*100),toupper($3); }'`
else
    LAT=`cat ${LAST_KNOWN_GOOD_DIR}/lat | awk -F"," '{ printf "%04d.%02d%s",int($1*100),int((($1*100)-int($1*100))*100),toupper($2); }'`
fi
##echo "DEBUG:      LAT: ${LAT}"

# Longitude, format: hhh.mmssssss.00W (or hhh.mmssssss.00E)
# Desired -
# What is in the last-known-good file -
##echo "DEBUG: READ-LON: `cat ${LAST_KNOWN_GOOD_DIR}/lon`"
# If need to convert GPS format to "NMEA format"...
if [ ""$GPS_TO_NMEA"" = "1" ]
then
    DEG=`cat ${LAST_KNOWN_GOOD_DIR}/lon | awk -F"," '{ printf "%d",int($1); }'`
    PRT=`cat ${LAST_KNOWN_GOOD_DIR}/lon | awk -F"," '{ printf "%.4f",($1-int($1)); }'`
    MIN=`echo ${PRT} | awk '{ printf "%2.4f",($1*60.0); }'`
    E_W=`cat ${LAST_KNOWN_GOOD_DIR}/lon | awk -F"," '{ print $2 }'`
    ##echo "DEBUG: DEG: ${DEG}"
    ##echo "DEBUG: PRT: ${PRT}"
    ##echo "DEBUG: MIN: ${MIN}"
    ##echo "DEBUG: E_W: ${E_W}"
    LON=`echo ${DEG} ${MIN} ${E_W} | awk '{ printf "%05d.%02d%s",int($1*100+$2),int((($1*100+$2)-int($1*100+$2))*100),toupper($3); }'`
else
    LON=`cat ${LAST_KNOWN_GOOD_DIR}/lon | awk -F"," '{ printf "%05d.%02d%s",int($1*100),int((($1*100)-int($1*100))*100),toupper($2); }'`
fi
##echo "DEBUG:      LON: ${LON}"


# Altitude in feet ASL, format: nnnnnn
# Desired -
# What is in the last-known-good file -
ALT=`cat ${LAST_KNOWN_GOOD_DIR}/alt | awk -F"," '{ printf "%06d",int($1*3.281); }'`

# Temperature (degrees F) - ONE SENSOR -
#DEGF=`cat ${LAST_KNOWN_GOOD_DIR}/temp | awk -F"," '{ printf "Temp. %d %s",$3,toupper($4); }'`
# Temperature (degrees F) - TWO SENSORS -
#DEGF=`cat ${LAST_KNOWN_GOOD_DIR}/temp | awk -F"," '{ printf "Temps %d/%d %s",$3,$7,toupper($4); }'`
DEGF=`getDirewolfData`

# Course (heading), in degrees format: ddd
HDG="090"

# Speed in MPH, format: sss
SPD="001"

# Message, freeform: "This is a message"
MSG="WP13 "
##MSG="BP9 "	# Shorten to avoid exceeding APRS comment length


rm -f $AUDIO_FILE
rm -f z.txt

## USING APRS (can't yet get or build it for Pi Zero...) -
## aprs -c ${MYCALL} -o AUDIO_FILE "/${ZULU_DDHHMM}z${LAT}/${LON}>${HDG}/${SPD}${MSG}/A=${ALT} ${DEGF}"


## Using direwolf -
########
##gen_packets -o packet.Loc.wav -r 44100 aprs.dat


# 2019-11-02 Adapt PATH based upon altitude
PATH="WIDE1-1,WIDE2-1"		# Default path of WIDE1-1,WIDE2-1 ("the current mobile standard")
if [ ""${ALT}"" -gt 12000 ]
then
	# "Higher" altitude, so use WIDE2-1 PATH (Bob Bruninga's suggested "best choice", if you can only pick one!)
	PATH="WIDE2-1"
fi
echo "${MYCALL}>BEACON,${PATH}:@${ZULU_DDHHMM}z${LAT}/${LON}O${MSG}/A=${ALT} ${DEGF}" >> z.txt
echo "${MYCALL}>BEACON,${PATH}:@${ZULU_DDHHMM}z${LAT}/${LON}O${MSG}/A=${ALT} ${DEGF}" >> z.txt


## FOR SOME REASON, the last packet does not seem to send properly when sent using BCM built-in oscillator, so put one or two
## more with "gibberish" to flush the others
###echo "${MYCALL}>APNXXX:#Next-to-last test packet" >> z.txt
echo "${MYCALL}>APNXXX:#Last test packet" >> z.txt

# NOTE: NEEDED THE FULL PATH TO gen_packets AT THE LAST MINUTE ON WARPIG-13-Redux. Dunno why!?!?!?
/usr/local/bin/gen_packets -o ${AUDIO_FILE} -r 44100 z.txt


if [ ""$VERBOSE"" = "1" ]
then
	# Test the result to see if it worked -
	echo
	echo "Testing encoding..."
	atest ${AUDIO_FILE}
	echo

	echo
	echo "To transmit the file you just built over the air as 2m APRS"
	echo "position reports via the BCM built-in oscillator, do this - "
	echo
	echo "    pifm ${AUDIO_FILE} 144.394157 44100 mono 4"
	echo
	echo "To send it out the audio port (PCM0 or USB audio dongle) to a"
	echo "2m radio in VOX mode, do this - "
	echo
	echo "    aplay ${AUDIO_FILE}"
	echo
fi


# Reset the screen (direwolf insists on changing its fg/bg colors!)
#tput reset

exit 0


