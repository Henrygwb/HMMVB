library('pryr')
library('MASS')
setGeneric('Print_model_information',
           function(object){
             standardGeneric('Print_model_information')
           }
)

setMethod('Print_model_information', 'HMMVB',
          function(object){
            system('cat model.out')
          }
)
