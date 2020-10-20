## Turning the Raspberry Pi Zero W Into an APRS Transmitter


### References

* http://www.icrobotics.co.uk/wiki/index.php/Turning_the_Raspberry_Pi_Into_an_FM_Transmitter

* http://blog.makezine.com/2012/12/10/raspberry-pi-as-an-fm-transmitter/?parent=Electronics

* http://www.youtube.com/v/ekcdAX53-S8#! 

* https://github.com/richardghirst/PiBits/pull/18



DEPENDENCY ALERT!
-----------------
This project has a dependency upon the direwolf project.

In particular, you will need the "gen_packets", "direwolf", "decode_aprs" and "atest" executables from that project for both testing and execution of this project. These executables are created by the appropriate Makefile from that direwolf project.  See that project for instructions on building those executables.


FINAL NOTES:
------------
Because this project depends upon other projects, I may have checked in some items from those other projects into THIS project, just for reference/completeness. IN EVERY CASE OF DISCREPANCY BETWEEN THE TWO you should ALWAYS defer to those dependencies. Conflicting files in this repository are only 'examples', and not "FINAL".


2019-05-04 UPDATE:  I started using Direwolf and a USB soundcard. I start Direwolf with "direwolf -t 0" using direwolf.conf copied to this repo. I then start the "kissutil" with "kissutil -T %H:%M:%S -f /home/direwolf/outbox/ | tee -a kiss.log" in the same directory (/home/direwolf).  Then all of the get* commands can be used to read through the kiss.log to try processing direct messages.  It's still experimental, so....

I also had to modify sendAPRS to adapt to this - Instead of sendAPRS playing out a file through the USB soundcard, which the Baofeng 888 transmitted via VOX, now we copy (only one line from) the "z.txt" file that sendAPRS creates, and send that to the kissutil's "outbox" (/home/direwolf/outbox/) directory, where kissutil picks it up and transmits it through Direwolf.

Again, it's all experimental...

To read and process direct APRS messages, run "getnewmsgs -r" (which both finds new messages and creates both ACKs and direct-message-responses back).  If you wanna ensure things get pushed out to the APRS network, wait 90 seconds, run "getunackmsgs" and send those results again (via a new file in "outbox/").  In the future, we might want to filter down the output of "getunackmsgs" using "getunheard" - because if the outbound messages were "heard" by someone digipeating them, we probably don't want to re-send them again (....probably!).

Did I mention this is all experimental!??! (GOOD!....because... it's all experimental!)


ALSO - FINAL, FINAL NOTE: This project has been superceeded by the PiFmAdv project!

I am leaving things here because I need to keep the history alive, not because it is necessarily of value nowadays.
