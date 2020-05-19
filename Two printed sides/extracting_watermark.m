% This code corresponds with the experiment introduced in section "5.2 Two 
% inked sides" of the work:
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

% Reading images
load('./data/T_RGB.mat');
load('./data/F_RGB.mat');
load('./data/B_RGB.mat');

% Changing from RGB to grayscale and taking logarithm
T = log(mean(double(T_RGB),3));
F = log(mean(double(F_RGB),3));
B = log(mean(double(B_RGB),3));

% Blurring B to take into account scattering
s = 21; % -> size of the gaussian filter
sig = 1.45; % -> standard deviation of the gaussian filter
h = fspecial('gaussian',[s,s],sig);
Bh = imfilter(B,h,'conv');

% Cropping the Region of interest
T = T(1:2000,1:3500);
F = F(1:2000,1:3500);
B = B(1:2000,1:3500);
Bh = Bh(1:2000,1:3500);

% Initializing the algorithm
TF = T-F;
W = zeros(1800,3300);

% Loop in the patches
for j = 1:33
     for i = 1:18
         
         % Selecting a patch 
         pos = [i*100+1,(i+1)*100;j*100+1,(j+1)*100];
         fixed = TF(pos(1,1)-100:pos(1,2)+100,pos(2,1)-100:pos(2,2)+100);
         moving = B(pos(1,1)-100:pos(1,2)+100,pos(2,1)-100:pos(2,2)+100);
         moving_blurred = Bh(pos(1,1)-100:pos(1,2)+100,pos(2,1)-100:pos(2,2)+100);
         
         % Registration
         tform = imregcorr(moving,fixed);
         reg = imwarp(moving_blurred, tform, 'OutputView', imref2d(size(moving_blurred)));
         % Substracting the registered patch
         S = fixed - reg;
         
         % Placing the obtained patch in the full watermark 
         W(pos(1,1)-100:pos(1,2)-100,pos(2,1)-100:pos(2,2)-100) = S(101:200,101:200);
                  
         imshow(fliplr(W'),[]);
         pause(0.001);        
     end
end

%% Cropping the watermark and adjusting the contrast
W = fliplr(W');
W = W(12:3287,175:1626);

W(W>-5.5) = -5.5;
W(W<-11.4) = -11.4;
W = (W - min(W(:))) / (max(W(:)) - min(W(:)));
imshow(W)

