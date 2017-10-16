setGeneric('BIC',
           function(object, data, ncom){
             standardGeneric('HMMVB_BIC')
           }
)

setMethod('BIC', 'HMMVB',
          function(object, data, ncom){
            stopifnot(ncol(ncom) == object@nseq)
            write.table(data, "train_data_bic.txt", sep = " ", row.names = FALSE, col.names = FALSE)
            BIC <- rep(0L, nrow(ncom))
            pb <- txtProgressBar(min = 0, max = nrow(ncom), style = 3)
            for (i in 1:nrow(ncom)){
              com_tmp <- ncom[i,]
              object@ncom_seq <- com_tmp
              HMMVB_train(object, train_file = "train_data_bic.txt",  model_binary_file = 'model_binary_bic.dat')
              BIC[i] <- GetBIC(object)
              setTxtProgressBar(pb, i)
            }
            close(pb)
            Best_BIC <- min(BIC)
            Best_com <- ncom[which.min(BIC),]
            return (list(all_BIC = BIC, all_hyper = ncom, Best_BIC = Best_BIC, Best_hyper = Best_com))
          }
)
