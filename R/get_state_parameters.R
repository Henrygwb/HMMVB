library('pryr')
library('MASS')
setGeneric('get_state_parameters',
           function(object, block_id, state_id){
             standardGeneric('get_state_parameters')
           }
)

setMethod('get_state_parameters', 'HMMVB',
          function(object, block_id, state_id){
            pp = sprintf ('Get parameters of block %d state %d', block_id, state_id)
            print (pp)
            if (block_id == 1){
              transition_prob_a00 = read.table('model.out', skip = 18, nrow=1)
              transition_prob_a = read.table('model.out', skip = 20, nrow=1)
              State_start_line_id = 11+object@nseq+12+(5+2*(1+object@ndim_seq[1])+1)*(state_id-1)
              mean = read.table('model.out', skip = State_start_line_id+2, nrow = 1)
              cov = read.table('model.out', skip = State_start_line_id+5, nrow = object@ndim_seq[1])
              #inv_cov = read.table('model.out', skip = State_start_line_id+5+object@ndim_seq[1]+1, nrow = object@ndim_seq[1])
              inv_cov = solve(cov)
            }
            else if (block_id == 2){
              block_start_line_id = (11+object@nseq+12+object@ncom_seq[1]*(6+2*(1+object@ndim_seq[1])))
              transition_prob_a00 = read.table('model.out', skip = block_start_line_id+5, nrow=1)
              transition_prob_a = read.table('model.out', skip = block_start_line_id+5+2, nrow=object@ncom_seq[2])
              State_start_line_id = (block_start_line_id+7+object@ncom_seq[2]+4)+(5+2*(1+object@ndim_seq[2])+1)*(state_id-1)
              mean = read.table('model.out', skip = State_start_line_id+2, nrow = 1)
              cov = read.table('model.out', skip = State_start_line_id+5, nrow = object@ndim_seq[2])
              inv_cov = read.table('model.out', skip = State_start_line_id+5+object@ndim_seq[2]+1, nrow = object@ndim_seq[2])
            }
            else{
              block_start_line_id = (11+object@nseq+12+object@ncom_seq[1]*(6+2*(1+object@ndim_seq[1])))
              for (i in 3:block_id){
                block_start_line_id = block_start_line_id + (4+3+object@ncom_seq[i-1]+3+object@ncom_seq[i-1]*(6+2*(1+object@ndim_seq[i-1])))+1
                #start_line_id = start_line_id + 310 +1
              }
              #print (block_start_line_id)
              transition_prob_a00 = read.table('model.out', skip = block_start_line_id+5, nrow=1)
              transition_prob_a = read.table('model.out', skip = block_start_line_id+5+2, nrow=object@ncom_seq[block_id])

              State_start_line_id = (block_start_line_id+7+object@ncom_seq[block_id]+4)+(5+2*(1+object@ndim_seq[block_id])+1)*(state_id-1)
              #print (State_start_line_id)
              mean = read.table('model.out', skip = State_start_line_id+2, nrow = 1)
              cov = read.table('model.out', skip = State_start_line_id+5, nrow = object@ndim_seq[block_id])
              inv_cov = read.table('model.out', skip = State_start_line_id+5+object@ndim_seq[block_id]+1, nrow = object@ndim_seq[block_id])
            }

            Gaussian_para = list(block_id = block_id, state_id = state_id, transition_prob_a = as.matrix(transition_prob_a),
                                 transition_prob_a00 = as.matrix(transition_prob_a00), mean = unlist(mean, use.names = FALSE), cov = as.matrix(cov), inv_cov = as.matrix(inv_cov))
            return (Gaussian_para)
          }
)
