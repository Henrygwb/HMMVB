library('pryr')
library('MASS')
setGeneric("Estimate",
           function(object, initial_scheme_flag = FALSE, kmeans_initial = TRUE, initial_scheme1 = 0, initial_scheme2 = 0, random_seed = 0, data,  model_name = 'model_binary', block_size_search = FALSE, max_block_size = 10, order_file = NULL, num_permu = 0, complex_file = NULL, relaxed_search = FALSE, diagonal_flag = TRUE, output_full_model = TRUE){
             standardGeneric("Estimate")
           }
)

setMethod("Estimate", "HMMVB",
          function(object, initial_scheme_flag = FALSE, kmeans_initial = TRUE, initial_scheme1 = 0, initial_scheme2 = 0, random_seed = 0, data, model_name = 'model_binary', block_size_search = FALSE, max_block_size = 10, order_file = NULL, num_permu = 0, complex_file = NULL, relaxed_search = FALSE, diagonal_flag = TRUE, output_full_model = TRUE){
            model_binary_file = paste(model_name, 'dat', sep = '.')
            train_file = WriteData(object, data, 'Train_data.txt')
            train_cmd = paste(object@c_path, '/trainmaster', sep='')
            #train_cmd = './Hmmvb_package_v1.3.2/trainmaster'
            #print (train_cmd)
            if (initial_scheme_flag == TRUE){
              if (kmeans_initial == FALSE){
                train_cmd = paste(train_cmd, '-0')
              }
              if (initial_scheme1 != 0){
                train_cmd = paste(train_cmd, '-1', as.character(initial_scheme1))
              }
              if (initial_scheme2 != 0){
                train_cmd = paste(train_cmd, '-2', as.character(initial_scheme2))
              }
              if (random_seed != 0){
                train_cmd = paste(train_cmd, '-r', as.character(random_seed))
              }
            }
            train_cmd = paste(train_cmd, '-i', train_file)
            train_cmd = paste(train_cmd, '-m', model_binary_file)
            #print (train_cmd)
            if (length(object@nseq) != 0){
              #print ("Train with variable blocks.")
              write_hyper_file(object)
              train_cmd =  paste(train_cmd, '-b hyperparam_HMMVB.dat')
            }
            else{
              #print ("Train without variable blocks.")
              if (block_size_search == TRUE){
                train_cmd = paste(train_cmd, '-y -x', as.character(max_block_size))
              }
              if (is.null(order_file) == FALSE){
                train_cmd = paste(train_cmd, '-o', order_file)
              }
              if (num_permu !=0 ){
                train_cmd = paste(train_cmd, '-n', as.character(num_permu))
              }
              if (is.null(complex_file) == FALSE){
                train_cmd = paste(train_cmd, '-p', complex_file)
              }
              if (relaxed_search == TRUE){
                train_cmd = paste(train_cmd, '-s')
              }
              train_cmd = paste(train_cmd, '-d', as.character(object@ndim))
            }
            #print (train_cmd)
            if (diagonal_flag==TRUE){
              train_cmd = paste(train_cmd, '-v')
            }
            if (output_full_model==TRUE){
              train_cmd= paste(train_cmd, '-t')
            }
            #print (train_cmd)
            train_cmd_all = paste(train_cmd, '> model.out')
            #print (train_cmd_all)
            system(train_cmd_all)
            #train_data = read.table(file(train_file))
            #return (as.matrix(train_data))
          }
)
