##basing code on https://data.library.virginia.edu/reading-pdf-files-into-r-for-text-mining/

##install package for extracting text from PDF files
install.packages("pdftools")
library(pdftools)

##set working directory to folder with pdf files
#setwd("C:/Users/WilliamLetton/OneDrive - Crystallise Limited/boolean_search_within_pdfs/pdf_folder/")



##create a vector of pdf file names
files <- list.files(pattern = "pdf$")
#print(files)

## create an object of the text of each pdf file
pdf_texts <- lapply(files, pdf_text)

##create a master dataframe
t1<-data.frame(files)
rownames(t1)<-files
colnames(t1)<-c("filenames")

## define a function to ask the user for keywords
readKeywords <- function(){
        k<-c()
        for (i in 1:100){
                n<-readline(prompt="Please enter a keyword then press Enter. If all keywords have been entered then please type 'done'.")
                #print(n)
                if (n == "Done")
                        break
                if (n == "done")
                        break
                k<-append(k,n)
                #print(keywords)
        }
        #print(keywords)
        return(k)
}

## Run the readKeywords function, and assign the output to keywords variable.
keywords<-readKeywords()


## create a list of keywords using the script.
#keywords<-c("fibrillation","stroke","economic","patients","Patients","and")

##a loop to boolean search for each keyword
for (keyword in keywords){
        ##evaluate for keyword in each pdf in the vector of texts
        present<-grepl(keyword,pdf_texts,fixed=TRUE,ignore.case=TRUE)
        ##create a table of pdf names and true/false for keyword presence
        t2<-data.frame(files,present)
        rownames(t2)<-files
        colnames(t2)<-c("filenames",keyword)
        
        ##merge the result with the master table
        t1<-merge(t1,t2,by="filenames")
}

##evaluate whether all column values are TRUE for each row
numfiles<-length(files)
t1length<-length(t1)

all_true<-as.logical()
for (i in 1:numfiles){
        
        all_true<-append(all_true,(all((t1[i,c(2:t1length)])==TRUE)))
}
##create a data frame with these boolean values
t3<-data.frame(files,all_true)
colnames(t3)<-c("filenames","all_keywords")
##append this data frame to the master
t1<-merge(t1,t3,by="filenames")

##name the rows and remove first column
rownames(t1)<-files
t1<-t1[-1]
##save the boolean table as a csv
write.csv(t1,file="Boolean_results.csv")