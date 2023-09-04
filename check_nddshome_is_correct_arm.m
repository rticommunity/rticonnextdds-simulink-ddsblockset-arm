%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  (c) 2023 Copyright, Real-Time Innovations, Inc. (RTI) All rights reserved. %
%                                                                             %
%  RTI grants Licensee a license to use, modify, compile, and create          %
%  derivative works of the software solely for use with RTI Connext DDS.      %
%  Licensee may redistribute copies of the software provided that all such    %
%  copies are subject to this license.                                        %
%  The software is provided "as is", with no warranty of any type, including  %
%  any warranty for fitness for any purpose. RTI is under no obligation to    %
%  maintain or support the software.  RTI shall not be liable for any         %
%  incidental or consequential damages arising out of the use or inability to %
%  use the software.                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ok = check_nddshome_is_correct_arm()
    % CHECK_NDDSHOME_IS_CORRECT_ARM check whether the NDDSHOME environment
    % variable is set to a supported version for the current version of the
    % installed RTI Connext for DDS Blockset toolbox.
    %   check_nddshome_is_correct_arm() returns
    %   true if NDDSHOME is correctly set to a supported version.

    supportedVersions = ["6.1.2"];
    nddshome = getenv('NDDSHOME');
    ok = false;

    % Check NDDSHOME is set
    if isempty(nddshome)
        error(['Error: NDDSHOME environment variable is not set.' ...
                'Please, install RTI Connext DDS or "RTI Connext for DDS ' ...
                'Blockset" toolbox from the following link: %s'], ...
            "https://www.mathworks.com/matlabcentral/fileexchange/" + ...
            "94665-rti-connext-dds-connectivity-framework-for-dds-blockset");
    end

    % Check NDDSHOME is pointing to a existing folder
    if ~exist(nddshome, "dir")
        error(['Error: NDDSHOME environment variable is not pointing ' ...
            'to an existing folder: %s'], ...
            nddshome);
    else
        % If NDDSHOME is pointing to a folder, check it is a supported
        % version. In this case this is a warning because unsupported
        % versions may work as well, so this doesn't prevent to use a
        % different Connext version.
        if is_rti_connext_dds_version_supported_arm(nddshome,...
                supportedVersions) == false
            warning(['The installed Connext version pointed by NDDSHOME '...
                    '<%s> is not supported.' ...
                    'Supported Connext versions for MATLAB %s:' newline ...
                    '%s'],...
                nddshome,...
                matlabRelease.Release,...
                supportedVersions);
        end
    end
    ok = true;
end

function ok = is_rti_connext_dds_version_supported_arm(nddshome, supportedVersions)
    % IS_RTI_CONNEXT_DDS_VERSION_SUPPORTED check whether the current
    % nddshome is pointing to a supported version
    %   is_rti_connext_dds_version_supported() return true if that nddshome
    %   is supported

    ok = false;
    for i = 1:length(supportedVersions)
        if contains(nddshome, strcat('rti_connext_dds-', supportedVersions{i}))
            ok = true;
        end
    end
end
