#R script for generating a simple webpage for playing mp3 files
#Mark Reuter
#mark.reuter@googlemail.com
#August 2024

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

htmlPlayerTag <- vector()

for (i in 1:length(wavs)){
  htmlPlayerTag[i] <- paste0("<h4>",
                             substr(wavs[i],1,(nchar(wavs[i])-4)),
                             "</h4><br>",
                             mp3tag,
                             wavs[i],
                             mp3tagclose,
                             "<hr><br>")
}
htmlPlayerTag

page <- c(
  header,
  title,
  toollink,
  htmlPlayerTag,
  contact,
  footer
)
write(page,"index.html")

##
style <- "body {
    background-color: rgb(10, 10, 10);
    color: rgb(245,255,255);
    }"

write(style,"style.css")
