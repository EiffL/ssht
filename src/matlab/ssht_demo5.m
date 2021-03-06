% ssht_demo5 - Run demo5
%
% Simulate a Gaussian cosmic microwave background (CMB) from the 7-year
% power spectrum fitted by NASA's Wilkinson Microwave Anisotropy Probe
% (WMAP) satellite.
%
% Default usage is given by
%
%   ssht_demo5
%
% Author: Jason McEwen (www.jasonmcewen.org)

% SSHT package to perform spin spherical harmonic transforms
% Copyright (C) 2011  Jason McEwen
% See LICENSE.txt for license details

clear all;

% Define parameters.
L = 256
methods = {'MW', 'MWSS', 'GL', 'DH'};
method = char(methods(1))
close_plot = true;
plot_samples = false;

% Load power spectrum.
%load('data/wmap_lcdm_pl_model_yr1_v1.mat')
%load('data/wmap_tt_spectrum_7yr_v4p1.mat')
load('data/wmap_lcdm_pl_model_wmap7baoh0.mat');

% Simulate CMB in harmonic space.
cmb_lm = zeros(L^2,1);
for el = 2:L-1      
   cl(el-1) = cl(el-1) * 2*pi / (el*(el+1));
   for m = -el:el
     ind = ssht_elm2ind(el, m);
     if m == 0
       cmb_lm(ind) = sqrt(cl(el-1)) .* randn;
     else
        cmb_lm(ind) = ...
           sqrt(cl(el-1)./2) .* randn ...
           + sqrt(-1) * sqrt(cl(el-1)./2) .* randn;
     end
   end
end

% Compute real space version of CMB.
cmb = ssht_inverse(cmb_lm, L, 'Method', method, 'Reality', true);

% Plot function on sphere.
figure;
ssht_plot_sphere(cmb, L, 'Method', method, 'Close', close_plot, ...
                 'PlotSamples', plot_samples, 'Lighting', true);
figure;
ssht_plot_mollweide(cmb, L, 'Method', method);
