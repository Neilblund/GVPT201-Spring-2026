library(googlesheets4)
library(labelled)
# old URL
# sheet_url<-'https://docs.google.com/spreadsheets/d/1ThOq7SQjnOQxvdbzUawE5jo5UwOyoSSDxDcPMec5C8Q/edit?usp=sharing'
sheet_url<-'https://docs.google.com/spreadsheets/d/1P8hH3lV3pt3-jAY9_8wX0r5Ek23zgeaxIfcDy3NXM7Q/edit?usp=sharing'
responses<-read_sheet(sheet_url)

codes<-read_sheet(sheet_url, sheet ='labels')
colnames(responses) <- codes$colname

for(col in codes$colname){
  if(!is.na(labels<-codes$labels[which(codes$colname == col)])){
    responses[[col]]<-factor(responses[[col]], eval(parse(text=labels)))
    
  }
  var_label(responses[[col]]) <-codes$label[which(codes$colname == col)]
}

response_file<-here::here("Data/inclass_responses.rds")

saveRDS(responses, file= response_file)

system(glue::glue("git add Data/inclass_responses.rds"))

system(glue::glue('git commit -m "Adding responses for {Sys.Date()}"'))

system("git push origin master")
