library('pryr')
library('MASS')
setGeneric('cluster',
           function(object, test_data, model_name = 'model_binary', result_name = 'refcls', input_ref_file = NULL, output_info_file = NULL, min_cluster_size = 1, L1_flag = FALSE, diagonal_flag = FALSE){
             standardGeneric('cluster')
           }
)

setMethod('cluster', 'HMMVB',
          function(object, test_data, model_name = 'model_binary', result_name = 'refcls', input_ref_file = NULL, output_info_file = NULL, min_cluster_size = 1, L1_flag = FALSE, diagonal_flag = FALSE){
            model_binary_file = paste(model_name, 'dat', sep = '.')
            output_result_file = paste(result_name, 'dat', sep = '.')
            test_data_file = WriteData(object, test_data, 'Test_data.txt')
            test_cmd = paste(object@c_path, '/testsync -i', sep='')
            test_cmd = paste(test_cmd, test_data_file)
            test_cmd = paste(test_cmd, '-m', model_binary_file)
            test_cmd = paste(test_cmd, '-o', output_result_file)
            #print (test_cmd)
            if (is.null(input_ref_file) == FALSE){
              test_cmd = paste(test_cmd, '-r', input_ref_file)
            }
            if (is.null(output_info_file) == FALSE){
              test_cmd = paste(test_cmd, '-a', output_info_file)
            }
            if (min_cluster_size != 1){
              test_cmd = paste(test_cmd, '-l', as.character(min_cluster_size))
            }
            if (L1_flag == TRUE){
              test_cmd = paste(test_cmd, '-u')
            }
            if (diagonal_flag == TRUE){
              test_cmd = paste(test_cmd, '-v')
            }
            #print (test_cmd)
            test_cmd_all = paste(test_cmd, '> cluster_result.out')
            print (test_cmd_all)
            system(test_cmd_all)
            result = read.table(output_result_file, skip = 1)
            result = result + 1
            return (unlist(result, use.names = FALSE))
          }
)
