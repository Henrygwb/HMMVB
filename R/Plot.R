setGeneric('Plot',
           function(object, BIC = NULL, hyper = NULL, data = NULL, cluster_result = NULL, No.cluster = NULL, option = NULL){
             standardGeneric('Plot')
           }
)

setMethod('Plot', 'HMMVB',
          function(object, BIC = NULL, hyper = NULL, data = NULL, cluster_result = NULL, No.cluster = NULL, option = NULL){
            if (option == "BIC"){
              r = nrow(BIC$all_hyper)
              c = ncol(BIC$all_hyper)
              label <- list()
              for (i in 1:r){
                label(lenght(label)+1) <- paste('(', as.character(BIC$all_hyper[i,1], '...', as.character(BIC$all_hyper[i,c], ')', sep = '')))
              }
              plot(BIC$all_BIC, xlab = 'Number of component', ylab = 'BIC', type = 'b', col = 'blue', pch = 16, xaxt = 'n')
              axis(1, at= seq(1,3,1), labels = label)
            }
            if (option == 'data'){
              dim = object@dim_order;
              data = data.frame(data);
              colnames(data) = c(as.character(dim))
              parcoord(data, var.label=TRUE)
            }
            if (option == 'cluster'){
              dim = object@dim_order
              data = data.frame(data)
              colnames(data) = c(as.character(dim))
              parcoord(data, col = cluster_result, var.label=TRUE)
            }
            if (option == 'one_cluster'){
              dim = object@dim_order
              idx = which(cluster_result == No.cluster)
              data = data.frame(data[idx,])
              colnames(data) = c(as.character(dim))
              parcoord(data, var.label=TRUE, labels = as.character(No.cluster))
            }
            if (option == 'mean_cluster'){
              dim = object@dim_order
              data_mean = matrix(0, max(unique(cluster_result)), ncol(data))
              for (i in 1:max(unique(cluster_result))){
                idx = which(cluster_result == i)
                data_one = data[idx,]
                data_mean[i,] = colMeans(data_one)
              }
              data = data.frame(data_mean)
              colnames(data) = c(as.character(dim))
              parcoord(data, col = c(1:max(unique(cluster_result))), var.label=TRUE)
            }
            if (option == 'density'){

            }
          }
)
