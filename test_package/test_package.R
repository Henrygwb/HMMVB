### Installing the package
library('devtools')
install_github('Henrygwb/HMMVB')

### Import the package and depend packages
library('HMMVB')
library('MASS')
library('pryr')

### Load data
data(simu1) #Simulation data set 1
#data(simu2) #Simulation data set 2

### Set up HMMVB model and specify hyper-parameters (prior knowledge)
HMM_1 = new("HMMVB", ndim = 8, nseq = 2, ndim_seq = c(5, 3), ncom_seq = c(20, 20),
            dim_order = c(1, 2, 3, 4, 5, 6, 7, 8),
            c_path = '/home/wzg13/Desktop/HMMVB_Rpackage')
# c_path is the absolute path of the folder:  Hmmvb_package_v1.3.2

### Plot the data set
plot(HMM_1, data = simu1$data, cluster_result = test_result, option='data')

# Estimating the density of given data set
estimate(HMM_1, data = simu1$data, model_name = 'model_binary', diagonal_flag = TRUE)

#Output model and hyperparameter information
get_hyperparameters(HMM_1)
print_model_information(HMM_1)
print_block_information(HMM_1, block_id=1)
Gaussian_para = get_state_parameters(HMM_1, block_id = 2, state_id = 1)

### Clustering the given data set with trained model
test_result = cluster(HMM_1, data  = simu1$data, model_name = 'model_binary', result_name = 'refcls', diagonal_flag = TRUE)
BIC <- getbic(HMM_1)
print (BIC)

### Ploting data and results
plot(HMM_1, data = simu1$data, cluster_result = test_result, option = 'cluster')
### Ploting data of one specific cluster
plot(HMM_1, data = simu1$data, cluster_result = test_result, option = 'one_cluster', cluster_id = 1)
### Ploting means of data in each cluster
plot(HMM_1, data = simu1$data, cluster_result = test_result, option = 'mean_cluster')
