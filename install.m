function success = install()
%INSTALLCADET Installs the program
%
% The PATH is adjusted to include necessary directories for the program.
%
% Returns true if the program is installed correctly, otherwise false.
%
% Copyright: © 2019 Qiao-Le He
% See the license note at the end of the file.

    % Get the path of this file
    localPath = fileparts(mfilename('fullpath'));

    % Add to Matlab's PATH
    fprintf('Adding %s to MATLAB PATH\n', localPath);
    path(localPath, path);
    fprintf('Adding %s to MATLAB PATH\n', [localPath filesep 'thirdParty']);
    path([localPath filesep 'thirdParty'], path);

end
% =============================================================================
%  All rights reserved. This program and the accompanying materials
%  are made available under the terms of the GNU Public License v3.0 (or, at
%  your option, any later version) which accompanies this distribution, and
%  is available at http://www.gnu.org/licenses/gpl.html
% =============================================================================
