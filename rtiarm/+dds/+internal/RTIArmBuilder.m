classdef RTIArmBuilder < dds.internal.RTIBuilder
    % This class is for internal use only. It may be removed in the future.
    % RTIBuilder that builds an RTI Connext Project
    % Copyright 2020-2022 The MathWorks, Inc.

    methods
        function h = RTIArmBuilder(varargin)
            h@dds.internal.RTIBuilder(varargin{:});
        end

        function pkgInfoStruct = createVendorArtifacts(h, pkgInfoStruct, pkgDir)

            hwdevice = get_param(bdroot,'ProdHWDeviceType');

            if hwdevice ~= "ARM Compatible->ARM 7" && hwdevice ~= "ARM Compatible->ARM 8"
                error(['Hardware configuration "%s" not supported. To fix ' ...
                    'this error, go to Settings/Hardware Implementation ' ...
                    'and select ARM Compatible and ARM 7 or 8.'], hwdevice);
            end

            cmakeTmpl = fullfile(matlabroot,...
                'toolbox/dds/vendor/rti/internal/template/RTICpp/CMakeLists.txt.tlc');

            CMakeResource = fullfile(h.InstallDir, 'resource', 'cmake');
            pkgInfoStruct.CMakeResource = strrep(CMakeResource,'\','/');
            IDLAndXMLFiles = [pkgInfoStruct.IDLFiles pkgInfoStruct.XMLFiles];
            if ~isempty(IDLAndXMLFiles)
                for i = 1:numel(IDLAndXMLFiles)
                        [status, result] = h.runcommand(['rtiddsgen -language C++11 -replace -d "'...
                            fullfile(pkgDir,'src') '" "' fullfile(pkgDir, 'src', IDLAndXMLFiles{i}) '"']);
                    if status ~= 0
                        error(message('dds:cgen:ErrorCreatingPackage', result));
                    end
                    [~,fileName,~] = fileparts(IDLAndXMLFiles{i});
                    % check if cxx files are generated
                    fileExtension = '.cxx';
                    typeFiles = {};
                    if isfile(fullfile(pkgDir,'src',[fileName 'Plugin' fileExtension]))...
                            && isfile(fullfile(pkgDir,'src',[fileName fileExtension]))
                        % should not add one fileName.c/cxx twice
                        if  ~any(strcmp(pkgInfoStruct.SourceFiles, ['src/',fileName,fileExtension]))
                            pkgInfoStruct.SourceFiles{end+1} = ['src/',fileName,fileExtension];
                            pkgInfoStruct.SourceFiles{end+1} = ['src/',fileName,'Plugin',fileExtension];
                        end
                    end
                    typeFiles{end+1} = [fileName,'.hpp']; %#ok<AGROW>
                end
                dds.internal.coder.RTI.customizeIDLGeneratedFiles(fullfile(pkgDir, 'src'), typeFiles);
            end
            h.createFileFromTemplate(pkgInfoStruct, cmakeTmpl, 'genCMakeList', fullfile(pkgDir,'CMakeLists.txt'));
        end

        function [result, outDir] = buildGivenPackage(h, pkgName)
            pkgFolder = h.getPackageFolder(pkgName);
            pkgDir = fullfile(h.RootDir, pkgFolder);
            buildDir = fullfile(pkgDir,'build');

            % Remove the build directory if one exists and recreate it
            if isfolder(buildDir)
                [status, msg, msgid] = rmdir(buildDir,'s');
                if status ~= 0
                    error(msgid, strrep(msg,'\','/'));
                end
            end
            [status, msg, msgid] = mkdir(buildDir);
            if status ~= 0
                error(msgid, strrep(msg,'\','/'));
            end

            curDir = cd (buildDir);
            clnUp = onCleanup(@()cd(curDir));

            cmdToCreateBuild = [h.CMakePath ' .. -DCMAKE_BUILD_TYPE=' h.BuildType];
            hwdevice = get_param(bdroot,'ProdHWDeviceType');

            if hwdevice == "ARM Compatible->ARM 7"
                extraFlags = ' -DCONNEXTDDS_ARCH=armv7Linux4gcc7.5.0 ';
                toolchainFile = fullfile(fileparts(mfilename('fullpath')),...
                    'toolchain', 'rti_connext_armv7');

            elseif hwdevice == "ARM Compatible->ARM 8"
                extraFlags = ' -DCONNEXTDDS_ARCH=armv8Linux4gcc7.3.0 ';
                toolchainFile = fullfile(fileparts(mfilename('fullpath')),...
                    'toolchain', 'rti_connext_armv8');
            else
                error(['Hardware configuration "%s" not supported. To fix ' ...
                    'this error, go to Settings/Hardware Implementation ' ...
                    'and select ARM Compatible and ARM 7 or 8.'], hwdevice);
            end

            if ismac
                toolchainFile = [toolchainFile '_mac.cmake'];
            elseif isunix
                toolchainFile = [toolchainFile '_linux.cmake'];
            elseif ispc
                toolchainFile = [toolchainFile '_win.cmake'];
            else
                error("Unsupported OS.");
            end

            cmdToCreateBuild = [cmdToCreateBuild ' -DCMAKE_TOOLCHAIN_FILE="' toolchainFile '"'];
            cmdToCreateBuild = [cmdToCreateBuild extraFlags];

            if (check_nddshome_is_correct_arm())
                cmdToCreateBuild = [cmdToCreateBuild '-DCONNEXTDDS_DIR="' getenv('NDDSHOME') '"'];
            else
                error('Incorrect version of NDDSHOME.');
            end

            [status, result] = h.runcommand(cmdToCreateBuild);
            if status ~= 0
                % throw error if the arch is not selected or not supported
                % (eg ARM 10)
                % NDDSHOME is set here, we can check the library is
                % installed
                error(message('dds:util:ErrorBuildingPackage', result));
            end

            cmdToBuild = [h.CMakePath ' --build "' buildDir '" --config ' h.BuildType];
            [status, result] = h.runcommand(cmdToBuild);
            if status ~= 0
                error(message('dds:util:ErrorBuildingPackage', result));
            end

            if isfolder(h.BuildType) %some tools put under the BuildType
                outDir = fullfile(buildDir, h.BuildType);
            else
                outDir = buildDir;
            end
        end
    end
end
