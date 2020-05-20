keywords<-list()
while (TRUE){
        newkey<-readline(prompt="Please enter a keyword: ")
        if (newkey!="done"){
                append(keywords,newkey)
                print(keywords)
        } else {
                break
        }
keywords
}
print(keywords)