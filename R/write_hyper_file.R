
setGeneric('write_hyper_file',
           function(object){
             standardGeneric('write_hyper_file')
           }
)

setMethod('write_hyper_file', 'HMMVB',
          function(object){
            line_1 = paste(as.character(object@ndim), as.character(object@nseq))
            ndim_seq_str = as.character(object@ndim_seq)
            line_2 = ndim_seq_str[1]
            for (i in 2:length(ndim_seq_str)){
              line_2 = paste(line_2, ndim_seq_str[i])
            }

            ncom_seq_str = as.character(object@ncom_seq)
            line_3 = ncom_seq_str[1]
            for (i in 2:length(ncom_seq_str)){
              line_3 = paste(line_3, ncom_seq_str[i])
            }

            dim_order_str = as.character((object@dim_order-1))
            line_4 = dim_order_str[1]
            for (i in 2:length(dim_order_str)){
              line_4 = paste(line_4, dim_order_str[i])
            }

            para = file('hyperparam_HMMVB.dat')
            writeLines(c(line_1, line_2, line_3, line_4), para)
            close(para)
          }
)
