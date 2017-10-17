# HMMVB
1. Depends: pypr, MASS 
2. Before install the package:  
   - Download **Hmmvb_package.tar.gz** and unzip it to somewhere on your computer;  
   - Open terminal and go into the folder: Hmmvb_package_v1.3.2 by the following commend:  
     ```cd [absolute path of that folder]```
   - Type the following command:  
     ```make```
3. Install the package:
   Open RStudio and type the following command:  
   ```library('devtools')```     
   ```install_github('Henrygwb/HMMVB')```
4. Use the package:
   Type the following command:  
```library('HMMVB')```  
```library('MASS')```  
```library('pryr')```
5. For the usage of the functions in the package, please refer to test_package/test_package.R
