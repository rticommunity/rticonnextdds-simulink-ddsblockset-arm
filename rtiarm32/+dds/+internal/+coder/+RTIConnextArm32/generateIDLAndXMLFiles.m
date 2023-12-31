function files = generateIDLAndXMLFiles(modelName, buildInfo, varargin)
%   This function is for internal use only. It may be removed in the future.

%   Copyright 2020-2023 The MathWorks, Inc.

% Generate XML and IDL files, and put them into buildInfo
    files = dds.internal.coder.RTI.generateIDLAndXMLFiles(modelName, buildInfo, varargin{:});
end
