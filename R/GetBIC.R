setGeneric('GetBIC',
           function(object){
             standardGeneric('GetBIC')
           }
)

setMethod('GetBIC', 'HMMVB',
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
