% This code corresponds with the experiment introduced in section "5.1 One 
% inked side" of the work:
%
% P. Ruiz, O. Dill, G. Raju, O. Cossairt, M. Walton and A. K. Katsaggelos,
% "Visible Transmission Imaging of Watermarks by Suppression of Occluding 
% Text or Drawings", Digital Applications in Archaeology and Cultural 
% Heritage, vol.15, e00121.
%
% Corresponding author: Pablo Ruiz. e-mail: mataran@northwestern.edu 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Disclaimer:
%
% The programs are granted free of charge for research and education 
% purposes only. Scientific results produced using the provided software 
% will acknowledge the use of the implementation provided by us. 
% If you plan to use it for non-scientific purposes, don't hesitate to 
% contact us.
% Because the programs are licensed free of charge, there is no warranty 
% for the program, to the extent permitted by applicable law, except when 
% otherwise stated in writing the copyright holders and/or other parties 
% provide the program "as is" without warranty of any kind, either 
% expressed or implied, including, but not limited to, the implied 
% warranties of merchantability and fitness for a particular purpose. The 
% entire risk as to the quality and performance of the program is with you. 
% should the program prove defective, you assume the cost of all necessary 
% servicing, repair or correction.
% In no event unless required by applicable law or agreed to in writing 
% will any copyright holder, or any other party who may modify and/or 
% redistribute the program, be liable to you for damages, including any 
% general, special, incidental or consequential damages arising out of the 
% use or inability to use the program (including but not limited to loss of 
% data or data being rendered inaccurate or losses sustained by you or 
% third parties or a failure of the program to operate with any other 
% programs), even if such holder or other party has been advised of the 
% possibility of such damages. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear all

% Loading data
load('./data/F_RGBraw_crop.mat')
load('./data/T_RGBraw_crop.mat')

% Changing from RGB to grayscale and taking logarithm
F = log(mean(double(F_RGBraw_crop),3)); 
T = log(mean(double(T_RGBraw_crop),3)); 

% Watermark extraction
W  = T - F;

% % Adjusting the contrast
W(W<-0.5) = -0.5;
W(W>0.3) = 0.3;
W = (W - min(W(:))) / (max(W(:)) - min(W(:)));
imshow(W)
