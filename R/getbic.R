library('pryr')
library('MASS')
setGeneric('getbic',
           function(object){
             standardGeneric('getbic')
           }
)

setMethod('getbic', 'HMMVB',
          function(object){
            if (length(object@nseq)==0){
              BIC <- readLines('model.out')[3]
            }
            else{
              BIC <- readLines('model.out')[1]
            }
            BIC <- as.numeric(gsub("BIC of the model: ", "", BIC))
            return (BIC)
          }
)
