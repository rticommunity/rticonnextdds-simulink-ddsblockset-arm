classdef CMakePreEmitHook < dds.internal.coder.CMakePreEmitHook
    % CMakePreEmitHook
    %
    %   Pre-emit hook to customize CMakeLists.txt file for RTI Connext.
    %

    %   Copyright 2023 The MathWorks, Inc.
    properties (Constant)
        ENV_VAR_NDDSHOME_NAME = 'NDDSHOME';
    end

    methods
        function apply(obj, cmakeProject, buildInfo)
            % Cache the architecture
            obj.setMWArchVariable(cmakeProject);

            % Disable noisy MSVC warnings.
            obj.addCommonMSVCOptions(cmakeProject);

            % Validate that NDDSHOME has been set
            rtiInstallDir = getenv(obj.ENV_VAR_NDDSHOME_NAME);
            if isempty(rtiInstallDir)
                error(message('dds:cgen:ErrorCreatingPackage', ['Env variable "', obj.ENV_VAR_NDDSHOME_NAME,...
                    '" not defined, set it to the RTI installation directory, for more info please refer to https://community.rti.com/documentation.']));
            end

            % Have CMakeLists file validate NDDSHOME too.
            buffer = coder.make.internal.CMakeListsBuffer;
            buffer.appendCommand('if', 'NOT DEFINED ENV{NDDSHOME}');
            buffer.appendCommand('   message', 'FATAL_ERROR', '"Env variable NDDSHOME not defined.  Set it to the RTI installation directory."')
            buffer.appendCommand('endif');

            % Set CONNEXTDDS_ARCH variable and the toolchain
            buffer.appendCommand('set','CONNEXTDDS_ARCH armv8Linux4gcc7.3.0');
            buffer.appendCommand('set','CONNEXTDDS_DIR $ENV{NDDSHOME}');

            cmakeProject.addCommonSettingsInlinedText(buffer.Buffer);

            % Add paths for third party libraries
            cmakeProject.addCMakeModulePath('$ENV{NDDSHOME}/resource/cmake');

            % Add additional package requirements
            cmakeProject.addFindPackage('RTIConnextDDS', {'6.1.1', 'REQUIRED', 'COMPONENTS', 'core'});

            % Add dependency on RTIConnextDDS::cpp2_api to each target.
            obj.addLinkLibraryDependenciesToTargets(cmakeProject, {'RTIConnextDDS::cpp2_api'});

            % Add dependency on winmm.dll on Windows for executable
            % targets.
            obj.addWinmmDependency(cmakeProject);

            [~, xmlFiles] = obj.getDDSFiles(buildInfo);

            % Move XML files to same location as final product
            obj.generateXMLFileInstallRules(cmakeProject, xmlFiles);
        end
    end
end
