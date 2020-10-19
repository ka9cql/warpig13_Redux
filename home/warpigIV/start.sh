#!/bin/sh
##################
#
#  NOTE NOTE NOTE NOTE: WATCH OUT FOR AUTO-REBOOT AT BOTTOM OF THIS SCRIPT!!!
#  NOTE NOTE NOTE NOTE: WATCH OUT FOR AUTO-REBOOT AT BOTTOM OF THIS SCRIPT!!!
#  NOTE NOTE NOTE NOTE: WATCH OUT FOR AUTO-REBOOT AT BOTTOM OF THIS SCRIPT!!!
#  NOTE NOTE NOTE NOTE: WATCH OUT FOR AUTO-REBOOT AT BOTTOM OF THIS SCRIPT!!!
#
# start.sh - Script that gets called by /etc/rc.local to startup all the
#            direwolf/APRS/packet BBS/etc. stuff.
#
# HISTORICAL INFORMATION -
#
#  2019-05-17  msipin  Created
#  2019-11-03  msipin  Making a "floater" that won't have a B-888 because we're
#                      using the BCM chip to do APRS, ONLY. So we can disable all
#                      the Direwolf, kissutil and linbpq stuff in here.
#################

MYCALL="N0CALL-13"

# START DIREWOLF -
##cd /home/direwolf
##(/usr/bin/nohup /home/direwolf/direwolf -t 0 -qh -qd 2>&1 >> /dev/null)&

# Direwolf opens ports 8000 and 8001

# TO-DO: loop until BOTH tcp port 8000 and tcp port 8001 are in the LISTEN state

##/bin/sleep 10

# kissutil REQUIRES Direwolf
# START KISSUTIL -
##cd /home/direwolf
## We don't need to write to kiss.log anymore (2019-10-12, if not before))
##(/usr/bin/nohup /home/direwolf/kissutil -f /home/direwolf/outbox/ 2>&1 >> /home/direwolf/kiss.log)&
##(/usr/bin/nohup /home/direwolf/kissutil -f /home/direwolf/outbox/ 2>&1 >> /dev/null)&

##/bin/sleep 10

# Then start sendAPRS -
cd /home/pifm
(/usr/bin/nohup /home/pifm/sendAPRS 2>&1 >> /dev/null)&

/bin/sleep 5

# /home/kiss/examples/test.py REQUIRES Direwolf *and* Kissutil
# Then start our APRS message-parser/responder
##cd /home/pifm
##(/usr/bin/nohup /usr/bin/python3 /usr/local/bin/msgparser.py ${MYCALL} 2>&1 >> /usr/local/bin/APRSdata.log)&

##/bin/sleep 5

# linbpq REQUIRES Direwolf
# Although Linbpq does not require Kissutil, I would like to start Linbpq after Kissutil, not before
# Then start the LinBPQ Packet BBS system -
##cd /home/linbpq
##(/usr/bin/nohup /home/linbpq/linbpq 2>&1 >> /dev/null)&

# Linbpq opens ports 8008 and 8010 and 8011



# SPECIAL WARPIG-13 AUTO-REBOOT SEQUENCE - Pause 20 minutes and reboot (just in case the BCM transmitter
# gets "stuck", and we are jamming the APRS frequency with a constant FM signal)
##(/usr/bin/nohup /usr/local/bin/do_reboot)&



# NOTE: MUST exit with success so /etc/rc.local will not get mad!
exit 0

