This code was all written by [Xi-Nian Zuo](http://lfcd.psych.ac.cn/) , Ph.D. for the analysis of the [1000 Functional Connectome Project](http://fcon_1000.projects.nitrc.org/) data, while in the lab of [Michael Milham](http://www.childmind.org/en/directory/staff/mmilham), M.D., Ph.D.  The code relies on some parcellations developed by others, including [the Neuro Bureau](http://neurobureau.org).  Note that the raw data is available for download from the 1000FCP NITRIC [downloads page](http://www.nitrc.org/frs/?group_id=296), and the processed data is available for [download](http://db.tt/c8DUupG) as well.

Mission
======

The purpose of this code is to take NIFTI files of whole brains and estimate functional connectivity. The main functions are called 'IPN_doSingleSubject_regionCENT_X.m' where X indicates which of four possible parcellation schemes were used: (i) aal, (ii) cameron, (iii) dosenbach2010, or (iv) hoa25. Each of the main functions behaves as follows:


Input: 
-----
*  filename: name of NIFTI file to be processed
*  maskname: name of mask to use to exclude non-brain
*  template: which of the 4 templates will be used
*  outfprefix: name of the output files
*  threshold: threshold for binarizing each correlation matrix

Output: 
------
no array's are output to the workspace, but several data derivatives are saved, including:
*  ts:  N-by-T matrix containing the time-series of each region
*  rsfc: N-by-N matrix of correlations across regions, as well some transformed versions
*  cent: the thresholds for binarizing the adjacency matrices computed in a variety of possible ways
  

