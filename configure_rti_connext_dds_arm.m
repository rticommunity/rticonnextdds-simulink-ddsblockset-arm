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

function configure_rti_connext_dds_arm()

    connextVersion = "6.1.2";

    if isMATLABReleaseOlderThan('R2023a')
        error(['Connext DDS Support Package for Arm is only ' ...
            'supported in MATLAB 2023a+.']);
    end

    if check_nddshome_is_correct_arm() == false
        error('NDDSHOME is not correctly set.');
    end

    % Install rtipkg files
    install_rtipkg_arm(connextVersion, "armv7Linux4gcc7.5.0");
    install_rtipkg_arm(connextVersion, "armv8Linux4gcc7.3.0");

    % Register toolchain
    register_toolchain('RTI Connext 6.x for Arm 32 bits', 'RTIConnextArm32');
    register_toolchain('RTI Connext 6.x for Arm 64 bits', 'RTIConnextArm64');

    % Reset the TargetTegistry to load the new toolchain
    RTW.TargetRegistry.getInstance('reset');
end

function install_rtipkg_arm(version, rtipkgArch)
    % INSTALL_RTIPKG_ARM install the corresponding LM package for the
    % architecture specified in the corresponding NDDSHOME environment
    % variable.
    %   install_rtipkg_arm("6.1.2","armv7Linux4gcc7.5.0") installs the LM
    %   package for the architecture armv7Linux4gcc7.5.0

    % Check the architecture is not already installed
    nddshome = string(getenv('NDDSHOME'));
    if exist(nddshome + '/lib/' + rtipkgArch, "dir")
        warning('The architecture %s is already installed.', rtipkgArch);
    else
        matlabPackageName = append("RTI Connext DDS ", version);
        rtipkgName = sprintf("rti_connext_dds-%s-lm-target-%s.rtipkg", ...
            version, rtipkgArch);

        if contains(rtipkgArch, 'armv7')
            rtipkgPath = ...
                string(rticonnextdds_simulink_ddsblockset_arm.getInstallationLocation(...
                    matlabPackageName + ' - Armv7'));
        elseif contains(rtipkgArch, 'armv8')
            rtipkgPath = ...
                string(rticonnextdds_simulink_ddsblockset_arm.getInstallationLocation(...
                    matlabPackageName + ' - Armv8'));
        else
            error("Cannot install %s. Architecture not supported", ...
                rtipkgName);
        end

        command = fullfile('"' + nddshome + '"', 'bin/rtipkginstall') ...
            + " -u " + fullfile('"' + rtipkgPath + '"', rtipkgName);

        system(command);
    end
end

function register_toolchain(name, package)
    % REGISTER_TOOLCHAIN register the toolchain to be used in the 
    % Simulink DDS Blockset. The toolchain must be in the MATLAB path.
    %   register_toolchain('RTI Connext 6.x for Arm 32 bits','RTIConnextArm32')

    projectName = sprintf('%s Project', name);
    tc = target.get('Toolchain', projectName);
    if isempty(tc)
        dds.internal.coder.(package).createToolchain('UserInstall', true);
    else
        target.remove(tc);
        dds.internal.coder.(package).createToolchain('UserInstall', true);
    end
end