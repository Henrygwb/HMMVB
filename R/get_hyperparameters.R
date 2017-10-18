library('pryr')
library('MASS')
setGeneric('get_hyperparameters',
           function(object){
             standardGeneric('get_hyperparameters')
           }
)

setMethod('get_hyperparameters', 'HMMVB',
          function(object){
            hyper_param = list(ndim = object@ndim, nseq = object@nseq, ndim_seq = object@ndim_seq,
                               ncom_seq = object@ncom_seq, dim_order = object@dim_order)
            return (hyper_param)
          }
)
