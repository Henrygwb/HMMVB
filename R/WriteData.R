setGeneric('WriteData',
           function(object){
             standardGeneric('WriteData')
           }
)

setGeneric('WriteData',
           function(object, data, file = 'Train_data.txt'){
             stopifnot(is.matrix(X))
             write.table(X, file, sep = "\t", quote=FALSE, row.names = FALSE, col.names = FALSE)
             return (file)
           }
)

