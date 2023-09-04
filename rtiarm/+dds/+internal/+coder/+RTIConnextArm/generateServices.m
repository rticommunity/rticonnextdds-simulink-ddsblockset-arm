function filesPathsGenOrAdded = generateServices(data)
    %   %This function is for internal use only. It may be removed in the future.

    %   Copyright 2020-2022 The MathWorks, Inc.

    %% First add static files
    filesPathsGenOrAdded = {};
    if data.usingDataEvents
        filesPathsGenOrAdded{end+1} = fullfile((matlabroot), 'toolbox', 'dds',...
            'vendor', 'rti', 'src', 'RTICPP', 'RTIAdaptorDataEvents.hpp');  
        filesPathsGenOrAdded{end+1} = fullfile((matlabroot), 'toolbox', 'dds',...
            'vendor', 'rti', 'src', 'RTICPP', 'RTIAdaptorDataEvents.cpp');
        if matlab.internal.feature("DDSExecutorMain")
            tmplFile = fullfile(matlabroot,...
                'toolbox/dds/vendor/rti/internal/template/RTICpp/mainExecutorEvents.cpp.tlc');
        else
            tmplFile = fullfile(matlabroot,...
                'toolbox/dds/vendor/rti/internal/template/RTICpp/mainEvents.cpp.tlc');
        end
    else
        filesPathsGenOrAdded{end+1} = fullfile((matlabroot), 'toolbox', 'dds',...
            'vendor', 'rti', 'src', 'RTICPP', 'RTIAdaptor.hpp');  %#ok<*AGROW> 
        filesPathsGenOrAdded{end+1} = fullfile((matlabroot), 'toolbox', 'dds',...
            'vendor', 'rti', 'src', 'RTICPP', 'RTIAdaptor.cpp');
        if matlab.internal.feature("DDSExecutorMain")
            tmplFile = fullfile(matlabroot,...
                'toolbox/dds/vendor/rti/internal/template/RTICpp/mainExecutor.cpp.tlc');
        else
            tmplFile = fullfile(matlabroot,...
                'toolbox/dds/vendor/rti/internal/template/RTICpp/main.cpp.tlc');
        end
    end

    %% Generate main
    filePath = fullfile(data.buildDir,data.mainFileName);
    getStrAndWriteFile(tmplFile, filePath, 'genMain', data);
    filesPathsGenOrAdded{end+1} = filePath; 

    %% Generate Readers
    for inportInfo = data.inportInfos
        if ~data.usingDataEvents || slfeature('SimulinkDataEvents') == 0
            tmplFile = fullfile(matlabroot,...
                'toolbox/dds/vendor/rti/internal/template/RTICpp/DDSReader.hpp.tlc');
        else
            tmplFile = fullfile(matlabroot,...
                'toolbox/dds/vendor/rti/internal/template/RTICpp/DDSReaderDataEvents.hpp.tlc');
        end
        rwdata = struct;
        rwdata.className = strcat('DDSReader_', inportInfo.type);
        rwdata.headerfile = strcat(rwdata.className,'.h');
        rwdata.parentClassName = inportInfo.baseType;
        rwdata.type = inportInfo.type;
        rwdata.modelName = data.modelName;
        rwdata.platformTypes = data.platformTypes;
        filePath = fullfile(data.buildDir,rwdata.headerfile);
        getStrAndWriteFile(tmplFile,filePath, 'genReader', rwdata);
        filesPathsGenOrAdded{end+1} = filePath; 
    end

    %% Generate Writers
    for outportInfo = data.outportInfos
        if ~data.usingDataEvents || slfeature('SimulinkDataEvents') == 0 
            tmplFile = fullfile(matlabroot,...
                'toolbox/dds/vendor/rti/internal/template/RTICpp/DDSWriter.hpp.tlc');
        else
            tmplFile = fullfile(matlabroot,...
                'toolbox/dds/vendor/rti/internal/template/RTICpp/DDSWriterDataEvents.hpp.tlc');
        end
        rwdata = struct;
        rwdata.className = strcat('DDSWriter_', outportInfo.type);
        rwdata.headerfile = strcat(rwdata.className,'.h');
        rwdata.parentClassName = outportInfo.baseType;
        rwdata.type = outportInfo.type;
        rwdata.modelName = data.modelName;   
        rwdata.platformTypes = data.platformTypes; 
        filePath = fullfile(data.buildDir,rwdata.headerfile);
        getStrAndWriteFile(tmplFile,filePath, 'genWriter', rwdata);
        filesPathsGenOrAdded{end+1} = filePath; 
    end

    %% Generate types file
    tmplFile = fullfile(matlabroot,...
        'toolbox/dds/vendor/rti/internal/template/RTICpp/ddstypes.hpp.tlc');
    filePath = fullfile(data.buildDir,data.typesFileName);
    headerNames = {};
    for i = 1:length(data.xmlFiles)
        [~,name,~] = fileparts(data.xmlFiles{i});
        headerNames{end+1} = name; 
    end
    tdata = struct;
    tdata.fileNames = headerNames;
    tdata.modelName = data.modelName;
    tdata.typedefPairs = data.typedefPairs;
    getStrAndWriteFile(tmplFile,filePath, 'genTypes', tdata);
    filesPathsGenOrAdded{end+1} = filePath; 

end

function getStrAndWriteFile(tmplFile, filePath, tmplFunction, data)
    str = dds.internal.coder.evalTLCWithParam(tmplFile,tmplFunction,data);
    writeFile = true;
    if isfile(filePath)
        try
            tfp = fopen(filePath,'r');
            clnUp = onCleanup(@()fclose(tfp));
            curCont = fread(tfp,'*char')';
            %Note: If the file contains timestamps, the contents will
            %differ
            writeFile = ~isequal(str, curCont); 
        catch
            writeFile = true;
        end
    end
    if writeFile
        fp = fopen(filePath, 'wt');
        if fp<0
            error(message('MATLAB:save:cantWriteFile',filePath));
        else
            fwrite(fp, str);
            fclose(fp);
        end
    end
end
