#!/usr/bin/python


#   PiFmAdv - Advanced featured FM transmitter for the Raspberry Pi
#   Copyright (C) 2017 Miegl
#
#   See https://github.com/Miegl/PiFmAdv


#   This program generates the waveform of a single biphase symbol
#
#   This program uses Pydemod, see https://github.com/ChristopheJacquet/Pydemod

import pydemod.app.rds as rds
import numpy
import scipy.io.wavfile as wavfile
import io
import matplotlib.pyplot as plt

sample_rate = 228000

outc = io.open("waveforms.c", mode="w", encoding="utf8")
outh = io.open("waveforms.h", mode="w", encoding="utf8")

header = u"""
/* This file was automatically generated by "generate_waveforms.py".
   (C) 2014 Christophe Jacquet.
   Released under the GNU GPL v3 license.
*/

"""

outc.write(header)
outh.write(header)

def generate_bit(name):
    offset = 240
    l = 96
    count = 2


    sample = numpy.zeros(3*l)
    sample[l] = 1
    sample[2*l] = -1

    # Apply the data-shaping filter
    sf = rds.pulse_shaping_filter(96*8, 228000)
    shapedSamples = numpy.convolve(sample, sf)


    out = shapedSamples[528-288:528+288] #[offset:offset+l*count]
    #plt.plot(sf)
    #plt.plot(out)
    #plt.show()

    iout = (out * 20000./max(abs(out)) ).astype(numpy.dtype('>i2'))
    wavfile.write(u"waveform_{}.wav".format(name), sample_rate, iout)

    outc.write(u"float waveform_{name}[] = {{{values}}};\n\n".format(
        name = name,
        values = u", ".join(map(unicode, out/2.5))))
        # note: need to limit the amplitude so as not to saturate when the biphase
        # waveforms are summed

    outh.write(u"extern float waveform_{name}[{size}];\n".format(name=name, size=len(out)))


generate_bit("biphase")

outc.close()
outh.close()
