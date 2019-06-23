
1. This code is for the paper: 

Runmin Cong, Jianjun Lei, Huazhu Fu, Fatih Porikli, Qingming Huang, and Chunping Hou, Video saliency detection via sparsity-based reconstruction and propagation, IEEE Transactions on Image Processing, 2019. DOI: 10.1109/TIP.2019.2910377.

It can only be used for non-comercial purpose. If you use this code, please cite our paper.

The related works include:

[1] Runmin Cong, Jianjun Lei, Huazhu Fu, Ming-Ming Cheng, Weisi Lin, and Qingming Huang, Review of visual saliency detection with comprehensive information, IEEE Transactions on Circuits and Systems for Video Technology, 2019. DOI: 10.1109/TCSVT.2018.2870832.


2. This matlab code is tested on Windows 10 64bit with MATLAB 2014a. 

3. Usage:

(1) put the test video sequences into file 'data\RGB'

(2) run demo_SRP.m
intra saliency maps with suffix '_intra.png' are generated and saved in the file 'results\SRP\**\intraSal';
intra saliency maps with suffix '_inter.png' are generated and saved in the file 'results\SRP\**\interSal';
and the final  video saliency maps with suffix '_SRP.png' are generated and saved in the file 'results\SRP\**\videoSal'

** represents file name, in our example, ** = parachute 


For any questions, please contact rmcong@126.com  runmincong@gmail.com.