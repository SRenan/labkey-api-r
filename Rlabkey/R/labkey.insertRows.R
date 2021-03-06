##
#  Copyright (c) 2009-2015 LabKey Corporation
# 
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
##

labkey.insertRows <- function(baseUrl, folderPath, schemaName, queryName, toInsert)
{  
## Default showAllRows=TRUE
showAllRows=TRUE

## Error if any of baseUrl, folderPath, schemName or toInsert are missing
if(exists("baseUrl")==FALSE || exists("folderPath")==FALSE || exists("schemaName")==FALSE || exists("toInsert")==FALSE)
stop (paste("A value must be specified for each of baseUrl, folderPath, schemaName and toInsert."))

## Formatting
baseUrl <- gsub("[\\]", "/", baseUrl)
folderPath <- gsub("[\\]", "/", folderPath)
if(substr(baseUrl, nchar(baseUrl), nchar(baseUrl))!="/"){baseUrl <- paste(baseUrl,"/",sep="")}
if(substr(folderPath, nchar(folderPath), nchar(folderPath))!="/"){folderPath <- paste(folderPath,"/",sep="")}
if(substr(folderPath, 1, 1)!="/"){folderPath <- paste("/",folderPath,sep="")}

## URL encode folder path, JSON encode post body (if not already encoded)
toInsert <- convertFactorsToStrings(toInsert);
if(folderPath==URLdecode(folderPath)) {folderPath <- URLencode(folderPath)}
nrows <- nrow(toInsert)
ncols <- ncol(toInsert)
p1 <- toJSON(list(schemaName=schemaName, queryName=queryName, apiVersion=8.3))
cnames <- colnames(toInsert)
p3 <- NULL
for(j in 1:nrows)
{
    cvalues <- as.list(toInsert[j,])
	names(cvalues) <- cnames
	cvalues[is.na(cvalues)] = NULL
    p2 <- toJSON(cvalues)
    p3 <- c(p3, p2)
}
p3 <- paste(p3, collapse=",")
pbody <- paste(substr(p1, 1, nchar(p1)-1), ', \"rows\":[' ,p3, "] }", sep="")

myurl <- paste(baseUrl, "query", folderPath, "insertRows.api", sep="")

## Execute via our standard POST function
mydata <- labkey.post(myurl, pbody)
newdata <- fromJSON(mydata)

return(newdata)
}
                                                              
