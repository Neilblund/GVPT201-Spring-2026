library(googlesheets4)
library(labelled)
# old URL


sheet_urls<-c(
  'Spring 2025' = 'https://docs.google.com/spreadsheets/d/1ThOq7SQjnOQxvdbzUawE5jo5UwOyoSSDxDcPMec5C8Q/edit?usp=sharing',
  'Spring 2026' = 'https://docs.google.com/spreadsheets/d/1P8hH3lV3pt3-jAY9_8wX0r5Ek23zgeaxIfcDy3NXM7Q/edit?usp=sharing'
  )

all_responses<-data.frame()

for(i in 1:length(sheet_urls)){
  responses<-read_sheet(sheet_urls[i])
  codes<-read_sheet(sheet_urls[i], sheet ='labels')
  colnames(responses) <- codes$colname
  
  for(col in codes$colname){
    if(!is.na(labels<-codes$labels[which(codes$colname == col)])){
      responses[[col]]<-factor(responses[[col]], eval(parse(text=labels)))
      
    }
    var_label(responses[[col]]) <-codes$label[which(codes$colname == col)]
  }
  
  responses$semester<-names(sheet_urls)[i]
  
  if(!"best_song2026" %in% colnames(responses)){
    responses$best_song2026 <- NA
  }


  all_responses<-rbind(responses, all_responses)
  
}



response_file<-here::here("Data/inclass_responses_combined.rds")

saveRDS(all_responses, file= response_file)

system(glue::glue("git add Data/inclass_responses_combined.rds"))

system(glue::glue('git commit -m "Adding responses for {Sys.Date()}"'))

system("git push origin master")
