library('pryr')
library('MASS')
setClass("HMMVB", slots = list(ndim = 'numeric', nseq = 'numeric', ndim_seq = 'vector',
                               ncom_seq = 'vector', dim_order = 'vector', c_path = 'character'))
#
# setGeneric('write_hyper_file',
#            function(object){
#              standardGeneric('write_hyper_file')
#            }
# )
#
# setMethod('write_hyper_file', 'HMMVB',
#           function(object){
#             line_1 = paste(as.character(object@ndim), as.character(object@nseq))
#             ndim_seq_str = as.character(object@ndim_seq)
#             line_2 = ndim_seq_str[1]
#             for (i in 2:length(ndim_seq_str)){
#               line_2 = paste(line_2, ndim_seq_str[i])
#             }
#
#             ncom_seq_str = as.character(object@ncom_seq)
#             line_3 = ncom_seq_str[1]
#             for (i in 2:length(ncom_seq_str)){
#               line_3 = paste(line_3, ncom_seq_str[i])
#             }
#
#             dim_order_str = as.character((object@dim_order-1))
#             line_4 = dim_order_str[1]
#             for (i in 2:length(dim_order_str)){
#               line_4 = paste(line_4, dim_order_str[i])
#             }
#
#             para = file('hyperparam_HMMVB.dat')
#             writeLines(c(line_1, line_2, line_3, line_4), para)
#             close(para)
#           }
# )
#
# setGeneric('WriteData',
#            function(object){
#              standardGeneric('WriteData')
#            }
# )
#
# setGeneric('WriteData',
#            function(object, data, file = 'Train_data.txt'){
#              stopifnot(is.matrix(X))
#              write.table(X, file, sep = "\t", quote=FALSE, row.names = FALSE, col.names = FALSE)
#              return (file)
#            }
# )
#
#
# setGeneric('GetBIC',
#            function(object){
#              standardGeneric('GetBIC')
#            }
# )
#
# setMethod('GetBIC', 'HMMVB',
#           function(object){
#             if (length(object@nseq)==0){
#               BIC <- readLines('model.out')[3]
#             }
#             else{
#               BIC <- readLines('model.out')[1]
#             }
#             BIC <- as.numeric(gsub("BIC of the model: ", "", BIC))
#             return (BIC)
#           }
# )
#
# setGeneric('Get_hyperparameters',
#            function(object){
#              standardGeneric('Get_hyperparameters')
#            }
# )
#
# setMethod('Get_hyperparameters', 'HMMVB',
#           function(object){
#             hyper_param = list(ndim = object@ndim, nseq = object@nseq, ndim_seq = object@ndim_seq,
#                                ncom_seq = object@ncom_seq, dim_order = object@dim_order)
#             return (hyper_param)
#           }
# )
#
# setGeneric('Print_model_information',
#            function(object){
#              standardGeneric('Print_model_information')
#            }
# )
#
# setMethod('Print_model_information', 'HMMVB',
#           function(object){
#             system('cat model.out')
#           }
# )
#
# setGeneric('Get_State_parameters',
#            function(object, block_id, state_id){
#              standardGeneric('Get_State_parameters')
#            }
# )
#
# setMethod('Get_State_parameters', 'HMMVB',
#           function(object, block_id, state_id){
#             pp = sprintf ('Get parameters of block %d state %d', block_id, state_id)
#             print (pp)
#             if (block_id == 1){
#               transition_prob_a00 = read.table('model.out', skip = 18, nrow=1)
#               transition_prob_a = read.table('model.out', skip = 20, nrow=1)
#               State_start_line_id = 11+object@nseq+12+(5+2*(1+object@ndim_seq[1])+1)*(state_id-1)
#               mean = read.table('model.out', skip = State_start_line_id+2, nrow = 1)
#               cov = read.table('model.out', skip = State_start_line_id+5, nrow = object@ndim_seq[1])
#               #inv_cov = read.table('model.out', skip = State_start_line_id+5+object@ndim_seq[1]+1, nrow = object@ndim_seq[1])
#               inv_cov = solve(cov)
#             }
#             else if (block_id == 2){
#               block_start_line_id = (11+object@nseq+12+object@ncom_seq[1]*(6+2*(1+object@ndim_seq[1])))
#               transition_prob_a00 = read.table('model.out', skip = block_start_line_id+5, nrow=1)
#               transition_prob_a = read.table('model.out', skip = block_start_line_id+5+2, nrow=object@ncom_seq[2])
#               State_start_line_id = (block_start_line_id+7+object@ncom_seq[2]+4)+(5+2*(1+object@ndim_seq[2])+1)*(state_id-1)
#               mean = read.table('model.out', skip = State_start_line_id+2, nrow = 1)
#               cov = read.table('model.out', skip = State_start_line_id+5, nrow = object@ndim_seq[2])
#               inv_cov = read.table('model.out', skip = State_start_line_id+5+object@ndim_seq[2]+1, nrow = object@ndim_seq[2])
#             }
#             else{
#               block_start_line_id = (11+object@nseq+12+object@ncom_seq[1]*(6+2*(1+object@ndim_seq[1])))
#               for (i in 3:block_id){
#                 block_start_line_id = block_start_line_id + (4+3+object@ncom_seq[i-1]+3+object@ncom_seq[i-1]*(6+2*(1+object@ndim_seq[i-1])))+1
#                 #start_line_id = start_line_id + 310 +1
#               }
#               #print (block_start_line_id)
#               transition_prob_a00 = read.table('model.out', skip = block_start_line_id+5, nrow=1)
#               transition_prob_a = read.table('model.out', skip = block_start_line_id+5+2, nrow=object@ncom_seq[block_id])
#
#               State_start_line_id = (block_start_line_id+7+object@ncom_seq[block_id]+4)+(5+2*(1+object@ndim_seq[block_id])+1)*(state_id-1)
#               #print (State_start_line_id)
#               mean = read.table('model.out', skip = State_start_line_id+2, nrow = 1)
#               cov = read.table('model.out', skip = State_start_line_id+5, nrow = object@ndim_seq[block_id])
#               inv_cov = read.table('model.out', skip = State_start_line_id+5+object@ndim_seq[block_id]+1, nrow = object@ndim_seq[block_id])
#             }
#
#             Gaussian_para = list(block_id = block_id, state_id = state_id, transition_prob_a = as.matrix(transition_prob_a),
#                                  transition_prob_a00 = as.matrix(transition_prob_a00), mean = unlist(mean, use.names = FALSE), cov = as.matrix(cov), inv_cov = as.matrix(inv_cov))
#             return (Gaussian_para)
#           }
# )
#
# setGeneric('HMMVB_BIC',
#            function(object, data, ncom){
#              standardGeneric('HMMVB_BIC')
#            }
# )
#
# setMethod('HMMVB_BIC', 'HMMVB',
#           function(object, data, ncom){
#             stopifnot(ncol(ncom) == object@nseq)
#             write.table(data, "train_data_bic.txt", sep = " ", row.names = FALSE, col.names = FALSE)
#             BIC <- rep(0L, nrow(ncom))
#             pb <- txtProgressBar(min = 0, max = nrow(ncom), style = 3)
#             for (i in 1:nrow(ncom)){
#               com_tmp <- ncom[i,]
#               object@ncom_seq <- com_tmp
#               HMMVB_train(object, train_file = "train_data_bic.txt",  model_binary_file = 'model_binary_bic.dat')
#               BIC[i] <- GetBIC(object)
#               setTxtProgressBar(pb, i)
#             }
#             close(pb)
#             Best_BIC <- min(BIC)
#             Best_com <- ncom[which.min(BIC),]
#             return (list(all_BIC = BIC, all_hyper = ncom, Best_BIC = Best_BIC, Best_hyper = Best_com))
#           }
# )
#
#
# setGeneric("Estimate",
#            function(object, initial_scheme_flag = FALSE, kmeans_initial = TRUE, initial_scheme1 = 0, initial_scheme2 = 0, random_seed = 0, data,  model_name = 'model_binary', block_size_search = FALSE, max_block_size = 10, order_file = NULL, num_permu = 0, complex_file = NULL, relaxed_search = FALSE, diagonal_flag = TRUE, output_full_model = TRUE){
#              standardGeneric("Estimate")
#            }
# )
#
# setMethod("Estimate", "HMMVB",
#           function(object, initial_scheme_flag = FALSE, kmeans_initial = TRUE, initial_scheme1 = 0, initial_scheme2 = 0, random_seed = 0, data, model_name = 'model_binary', block_size_search = FALSE, max_block_size = 10, order_file = NULL, num_permu = 0, complex_file = NULL, relaxed_search = FALSE, diagonal_flag = TRUE, output_full_model = TRUE){
#             model_binary_file = paste(model_name, 'dat', sep = '.')
#             train_file = WriteData(object, data, 'Train_data.txt')
#             train_cmd = paste(object@c_path, '/trainmaster', sep='')
#             #train_cmd = './Hmmvb_package_v1.3.2/trainmaster'
#             #print (train_cmd)
#             if (initial_scheme_flag == TRUE){
#               if (kmeans_initial == FALSE){
#                 train_cmd = paste(train_cmd, '-0')
#               }
#               if (initial_scheme1 != 0){
#                 train_cmd = paste(train_cmd, '-1', as.character(initial_scheme1))
#               }
#               if (initial_scheme2 != 0){
#                 train_cmd = paste(train_cmd, '-2', as.character(initial_scheme2))
#               }
#               if (random_seed != 0){
#                 train_cmd = paste(train_cmd, '-r', as.character(random_seed))
#               }
#             }
#             train_cmd = paste(train_cmd, '-i', train_file)
#             train_cmd = paste(train_cmd, '-m', model_binary_file)
#             #print (train_cmd)
#             if (length(object@nseq) != 0){
#               #print ("Train with variable blocks.")
#               write_hyper_file(object)
#               train_cmd =  paste(train_cmd, '-b hyperparam_HMMVB.dat')
#             }
#             else{
#               #print ("Train without variable blocks.")
#               if (block_size_search == TRUE){
#                 train_cmd = paste(train_cmd, '-y -x', as.character(max_block_size))
#               }
#               if (is.null(order_file) == FALSE){
#                 train_cmd = paste(train_cmd, '-o', order_file)
#               }
#               if (num_permu !=0 ){
#                 train_cmd = paste(train_cmd, '-n', as.character(num_permu))
#               }
#               if (is.null(complex_file) == FALSE){
#                 train_cmd = paste(train_cmd, '-p', complex_file)
#               }
#               if (relaxed_search == TRUE){
#                 train_cmd = paste(train_cmd, '-s')
#               }
#               train_cmd = paste(train_cmd, '-d', as.character(object@ndim))
#             }
#             #print (train_cmd)
#             if (diagonal_flag==TRUE){
#               train_cmd = paste(train_cmd, '-v')
#             }
#             if (output_full_model==TRUE){
#               train_cmd= paste(train_cmd, '-t')
#             }
#             #print (train_cmd)
#             train_cmd_all = paste(train_cmd, '> model.out')
#             #print (train_cmd_all)
#             system(train_cmd_all)
#             #train_data = read.table(file(train_file))
#             #return (as.matrix(train_data))
#           }
# )
#
# setGeneric('Cluster',
#            function(object, test_data, model_name = 'model_binary', result_name = 'refcls', input_ref_file = NULL, output_info_file = NULL, min_cluster_size = 1, L1_flag = FALSE, diagonal_flag = FALSE){
#              standardGeneric('Cluster')
#            }
# )
#
# setMethod('Cluster', 'HMMVB',
#           function(object, test_data, model_name = 'model_binary', result_name = 'refcls', input_ref_file = NULL, output_info_file = NULL, min_cluster_size = 1, L1_flag = FALSE, diagonal_flag = FALSE){
#             model_binary_file = paste(model_name, 'dat', sep = '.')
#             output_result_file = paste(result_name, 'dat', sep = '.')
#             test_data_file = WriteData(object, test_data, 'Test_data.txt')
#             test_cmd = paste(object@c_path, '/testsync -i', sep='')
#             test_cmd = paste(test_cmd, test_data_file)
#             test_cmd = paste(test_cmd, '-m', model_binary_file)
#             test_cmd = paste(test_cmd, '-o', output_result_file)
#             #print (test_cmd)
#             if (is.null(input_ref_file) == FALSE){
#               test_cmd = paste(test_cmd, '-r', input_ref_file)
#             }
#             if (is.null(output_info_file) == FALSE){
#               test_cmd = paste(test_cmd, '-a', output_info_file)
#             }
#             if (min_cluster_size != 1){
#               test_cmd = paste(test_cmd, '-l', as.character(min_cluster_size))
#             }
#             if (L1_flag == TRUE){
#               test_cmd = paste(test_cmd, '-u')
#             }
#             if (diagonal_flag == TRUE){
#               test_cmd = paste(test_cmd, '-v')
#             }
#             #print (test_cmd)
#             test_cmd_all = paste(test_cmd, '> cluster_result.out')
#             print (test_cmd_all)
#             system(test_cmd_all)
#             result = read.table(output_result_file, skip = 1)
#             result = result + 1
#             return (unlist(result, use.names = FALSE))
#           }
# )
#
# setGeneric('Plot',
#            function(object, BIC = NULL, hyper = NULL, data = NULL, cluster_result = NULL, No.cluster = NULL, option = NULL){
#              standardGeneric('Plot')
#            }
# )
#
# setMethod('Plot', 'HMMVB',
#           function(object, BIC = NULL, hyper = NULL, data = NULL, cluster_result = NULL, No.cluster = NULL, option = NULL){
#             if (option == "BIC"){
#               r = nrow(BIC$all_hyper)
#               c = ncol(BIC$all_hyper)
#               label <- list()
#               for (i in 1:r){
#                 label(lenght(label)+1) <- paste('(', as.character(BIC$all_hyper[i,1], '...', as.character(BIC$all_hyper[i,c], ')', sep = '')))
#               }
#               plot(BIC$all_BIC, xlab = 'Number of component', ylab = 'BIC', type = 'b', col = 'blue', pch = 16, xaxt = 'n')
#               axis(1, at= seq(1,3,1), labels = label)
#             }
#             if (option == 'data'){
#               dim = object@dim_order;
#               data = data.frame(data);
#               colnames(data) = c(as.character(dim))
#               parcoord(data, var.label=TRUE)
#             }
#             if (option == 'cluster'){
#               dim = object@dim_order
#               data = data.frame(data)
#               colnames(data) = c(as.character(dim))
#               parcoord(data, col = cluster_result, var.label=TRUE)
#             }
#             if (option == 'one_cluster'){
#               dim = object@dim_order
#               idx = which(cluster_result == No.cluster)
#               data = data.frame(data[idx,])
#               colnames(data) = c(as.character(dim))
#               parcoord(data, var.label=TRUE, labels = as.character(No.cluster))
#             }
#             if (option == 'mean_cluster'){
#               dim = object@dim_order
#               data_mean = matrix(0, max(unique(cluster_result)), ncol(data))
#               for (i in 1:max(unique(cluster_result))){
#                 idx = which(cluster_result == i)
#                 data_one = data[idx,]
#                 data_mean[i,] = colMeans(data_one)
#               }
#               data = data.frame(data_mean)
#               colnames(data) = c(as.character(dim))
#               parcoord(data, col = c(1:max(unique(cluster_result))), var.label=TRUE)
#             }
#             if (option == 'density'){
#
#             }
#           }
# )
#
