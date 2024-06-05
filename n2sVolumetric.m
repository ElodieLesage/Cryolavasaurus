%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Takes a property on normal nodes and returns the volumetric average on
% staggered elements
function [prop_s] = n2sVolumetric(M,prop)

prop_s = M.Vf1 .* prop(M.refInd) + M.Vf2 .* prop(M.refInd+1);

end