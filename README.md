This code was all written by Xi-Nian Zuo, Ph.D. for the analysis of the 1000 Functional Connectome Project data.  

Mission
-------

The purpose of this code is to take NIFTI files of whole brains and estimate functional connectivity. The main functions are called 'IPN_doSingleSubject_regionCENT_X.m' where X indicates which of four possible parcellation schemes were used: (i) aal, (ii) cameron, (iii) dosenbach2010, or (iv) hoa25. 

Steps - each of the main functions behaves as follows:
-----

* Input: 
**  filename: name of NIFTI file to be processed
**  maskname: name of mask to use to exclude non-brain
**  template: which of the 4 templates will be used
**  outfprefix: name of the output files
**  threshold: threshold for binarizing each correlation matrix

* Output: no array's are output to the workspace, but several data derivatives are saved, including:
**  ts:  N-by-T matrix containing the time-series of each region
**  rsfc: N-by-N matrix of correlations across regions, as well some transformed versions
**  cent: the thresholds for binarizing the adjacency matrices computed in a variety of possible ways
  

