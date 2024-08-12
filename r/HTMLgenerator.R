#R script for generating a simple webpage for playing mp3 files
#Mark Reuter
#mark.reuter@googlemail.com
#August 2024

library(tuneR)

###variables

header = '<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>AI sounds - volume 1</title>
    <link rel="stylesheet" href="style.css">
  </head>
  <body>'
footer = '</body>
</html>'

title <- '<h1>AI Sound generation</h1>'
toollink <- '<a href="https://huggingface.co/spaces/haoheliu/audioldm-text-to-audio-generation">Text to Audio at Hugging Face</a>'
contact <- '<footer>
  <p>Made wth love by Mark</p>
  <p><a href="mailto:mark.reuter@googlemail.com?subject=AIsounds">contact</a></p>
</footer>'

wavs <- list.files(paste0(getwd(),"/edit"),pattern = ".wav")
wavs

mp3tag <- '<audio controls style="vertical-align: middle;"><source src="edit/'
mp3tagclose <- '" type="audio/mpeg">Your browser does not support the audio element. </audio>'

##generate wv plots png files

for (i in 1:length(wavs)){
  waveObject <- tuneR::readWave(paste0(getwd(),"/edit/",wavs[i]))
  fname <- unlist(strsplit(wavs[i],"\\."))[1]
  print(fname)
  png(file = paste0(getwd(),"/waveplots/",fname,".png"),
      width=400, height=300)
  #par(bg=NA) ##transparent background
  par(bg="grey31")
  tuneR::plot(waveObject,
              xunit = "time",
              col = sample(colours(),1),
              main = fname)
  dev.off()
}

#create a vector for HTML link to png files
htmlPNGtag <- vector()

for (i in 1:length(wavs)){
  fname <- unlist(strsplit(wavs[i],"\\."))[1]
  htmlPNGtag[i] <- paste0('<img class="wavplot" src="waveplots/',fname,'.png" alt="',fname,'">')
}
htmlPNGtag

htmlPlayerTag <- vector()

for (i in 1:length(wavs)){
  htmlPlayerTag[i] <- paste0("<h4>",
                             substr(wavs[i],1,(nchar(wavs[i])-4)),
                             "</h4><br>",
                             htmlPNGtag[i],
                             "<br>",
                             mp3tag,
                             wavs[i],
                             mp3tagclose,
                             "<br><hr>")
}
htmlPlayerTag

googleColabLink <- '<a href="https://colab.research.google.com/drive/1H5LY_m4FBGn0WeQ3eHl1pknbF-TeiY-B?usp=sharing" target="_blank"><h3>Google Colab Notebook</h3></a>'

page <- c(
  header,
  title,
  toollink,
  htmlPlayerTag,
  googleColabLink,
  contact,
  footer
)
write(page,"index.html")

##
style <- "body {
    background-color: rgb(10, 10, 10);
    color: rgb(245,255,255);
}
    .wavplot {
  border-radius: 25px};
"

write(style,"style.css")

## tuneR prototyping
# waveObject <- tuneR::readWave(paste0(getwd(),"/edit/",wavs[1]))
# plot(waveObject)
# tuneR::plot(waveObject,xunit = "samples")
# tuneR::plot(waveObject,
#             xunit = "time",
#             col = sample(colours(),1),
#             main = unlist(strsplit(wavs[1],"\\."))[1])
# 
# png(file = paste0(getwd(),"/waveplots/",unlist(strsplit(wavs[1],"\\."))[1],".png"),
#     width=400, height=300)
# #par(bg=NA) ##transparent background
# par(bg="grey31")
# tuneR::plot(waveObject,
#             xunit = "time",
#             col = sample(colours(),1),
#             main = unlist(strsplit(wavs[1],"\\."))[1]
#             )
# dev.off()



# plot(x, info = FALSE, xunit = c("time", "samples"),
#      ylim = NULL, main = NULL, sub = NULL, xlab = NULL, ylab = NULL,
#      simplify = TRUE, nr = 2500, axes = TRUE, yaxt = par("yaxt"), las = 1,
#      center = TRUE, ...)