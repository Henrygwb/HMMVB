library('pryr')
library('MASS')
setGeneric('print_model_information',
           function(object){
             standardGeneric('print_model_information')
           }
)

setMethod('print_model_information', 'HMMVB',
          function(object){
            system('cat model.out')
          }
)
