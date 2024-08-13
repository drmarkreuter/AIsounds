##tuneR prototyping
##Mark Reuter
##August 2024
##contact mark.reuter@googlemail.com

## analysing a sine wave sweep
sineWaveSweep <- readWave("sine-wave-sweep.wav",
                          toWaveMC = FALSE)
par(mfrow = c(1,1))
plot(sineWaveSweep,
     main = "Sine wav sweep")
print(paste0("Sample rate: ",sineWaveSweep@samp.rate))
print(paste0("Bit depth: ",sineWaveSweep@bit))
print(paste0("Is stereo: ",sineWaveSweep@stereo))

#width is sample size window
#total samples
print(paste0("Total samples: ",length(sineWaveSweep)))
#calculate a window size to give approx 40 periodograms
#remind ourselves of power 2
for (i in 1:12){
  z <- 2^i
  print(z)
  print(paste0("Periodogram number: ",length(sineWaveSweep)/z))
}
#good starting window sizes are 2048, 4096, 8192
windowSize <- 4096
periodogramNumber <- length(sineWaveSweep)/windowSize
periodogramNumber

sineWaveSweepPeriodogram <- periodogram(sineWaveSweep,
                                        width = windowSize,
                                        units = "seconds")
#plot(sineWaveSweepPeriodogram) #not really useful
image(sineWaveSweepPeriodogram,
      log="z",
      main=paste0("Sine wave sweep spectrogram"))

#side-by-side plots of the sine wav sweep, the spectrogram is much more useful for 'analysis' of the sound compared to just plotting the samples over time.
par(mfrow = c(1,2))
plot(sineWaveSweep,
     main = "Sine wav sweep")
image(sineWaveSweepPeriodogram,
      log="z",
      main=paste0("Sine wave sweep spectrogram"))




wavs <- list.files(paste0(getwd(),"/edit"),pattern = ".wav")
wavs

waveObject <- tuneR::readWave(paste0(getwd(),"/edit/",wavs[1]),
                              toWaveMC = FALSE)
plot(waveObject,
     main = wavs[1])

##spectrogram left
waveObjectLeft <- tuneR::channel(waveObject,which="left")
plot(waveObjectLeft,
     cex.main = 0.7,
     main = paste0(wavs[1],' - left')
     )
WspecobjLeft <- periodogram(waveObjectLeft, width = 4096)
image(WspecobjLeft,
      log="z",
      cex.main = 0.7,
      main = paste0('Spectrogram left - ',wavs[1]))

waveObjectRight <- tuneR::channel(waveObject,which="right")
plot(waveObjectRight,
     cex.main = 0.7,
     main = paste0(wavs[1],' - right')
)
WspecobjRight <- periodogram(waveObjectRight, width = 4096)
image(WspecobjRight,
      log="z",
      cex.main = 0.7,
      main = paste0('Spectrogram left - ',wavs[1]))

#plot specrograms side by side
image(WspecobjLeft,
      log="z",
      cex.main = 0.7,
      main = paste0('Spectrogram left - ',wavs[1]))
image(WspecobjRight,
      log="z",
      cex.main = 0.7,
      main = paste0('Spectrogram left - ',wavs[1]))

#analysis of a real-world sample
#read lyre-A4-01-comp
RecordedWaveObject <- tuneR::readWave(paste0(getwd(),"/lyre-A4-01-comp.wav"),
                                      toWaveMC = FALSE)
#left channel
lyreLeft <- tuneR::channel(RecordedWaveObject,which="left")
lyreWspecobjLeft <- periodogram(lyreLeft, width = 4096)
plot(lyreWspecobjLeft)
#right channel
lyreRight <- tuneR::channel(RecordedWaveObject,which="right")
lyreWspecobjRight <- periodogram(lyreRight, width = 4096)
plot(lyreWspecobjRight)
#write left spectrogram to png file
png(file = paste0(getwd(),"/lyre-A4-01-comp-left.png"),
    width=400, height=300)
par(mfrow = c(1, 1))
par(bg="grey31")
image(lyreWspecobjLeft,
      ylim=c(0, 12000),
      log="z",
      cex.main = 0.7,
      main="lyre-A4-01-comp-left")
dev.off()

#save right channel
png(file = paste0(getwd(),"/lyre-A4-01-comp-right.png"),
    width=400, height=300)
par(bg="grey31")
image(lyreWspecobjRight,
      ylim=c(0, 12000),
      log="z",
      cex.main = 0.7,
      main=paste0("lyre-A4-01-comp-right"))
dev.off()

#compared side-by-side
png(file = paste0(getwd(),"/lyre-A4-01-comp.png"),
    width=700, height=300)
par(mfrow = c(1, 2))
par(bg="grey31")
image(lyreWspecobjLeft,
      ylim=c(0, 12000),
      log="z",
      cex.main = 0.7,
      main="lyre-A4-01-comp-left")
image(lyreWspecobjRight,
      ylim=c(0, 12000),
      log="z",
      cex.main = 0.7,
      main=paste0("lyre-A4-01-comp-right"))
dev.off()

recordedWaveDiff <- RecordedWaveObject@left - RecordedWaveObject@right
par(mfrow = c(1, 2))
plot(RecordedWaveObject,
     cex.main = 0.7,
     main = "plucked lyre string \n original stereo sample")
plot(recordedWaveDiff,
     cex.main = 0.7,
     main = "Delta \n (right channel subtracted from left channel)")


par(mfrow = c(1, 3))
plot(lyreLeft,
     ylim=c(-10000,10000),
     main = "Lyre-A4-Left")
plot(lyreRight,
     ylim=c(-10000,10000),
     main = "Lyre-A4-Right")
plot(recordedWaveDiff,
     ylim=c(-10000,10000),
     main = "Lyre-A4 \n Left minus Right")

#analyzing AI-generated wav files
#use the waveObject we already have in memory, or load new
# waveObject <- tuneR::readWave(paste0(getwd(),"/edit/",wavs[1]), toWaveMC = FALSE)
#since this is an S4 object, we can use the @ to access its elements

AIWaveDiff <- waveObject@left - waveObject@right
par(mfrow = c(1, 3))
plot(waveObject@left,
     ylim=c(-10000,10000),
     main = paste0(wavs[1]," - Left"))
plot(waveObject@right,
     ylim=c(-10000,10000),
     main = paste0(wavs[1]," - Right"))
plot(AIWaveDiff,
     ylim=c(-10000,10000),
     main = paste0(wavs[1]," \n Left minus Right"))
##convince ourselves that the delta is just zeros... 
summary(AIWaveDiff)
length(AIWaveDiff)
class(AIWaveDiff)

