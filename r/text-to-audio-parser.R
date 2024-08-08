setwd(getwd())
dictionary <- read.csv("dict.csv",header = FALSE)
head(dictionary)

temp.vec <- dictionary$V2
temp.vec

temp.vec2 <- vector()
for (i in 1:length(temp.vec)){
  temp.vec2[i] <- unlist(
    strsplit(
      unlist(strsplit(temp.vec[i],"'"))[4],
      "/"))[5]
}
temp.vec2

dictionary$file <- temp.vec2
head(dictionary)

dir.create(paste0(
  getwd(),'/renamed')
)

files <- list.files(getwd(),pattern = ".mp4")
print(files)
file.copy(from = paste0(getwd(),'/',files),
          to = paste0(getwd(),'/renamed/',files))
for (i in 1:nrow(dictionary)){
  print(dictionary[i,3])
  print(dictionary[i,1])
  file.rename(from = paste0(getwd(),'/renamed/',dictionary[i,3]),
              to = paste0(getwd(),'/renamed/',dictionary[i,1],".mp4")
              )
  
}
