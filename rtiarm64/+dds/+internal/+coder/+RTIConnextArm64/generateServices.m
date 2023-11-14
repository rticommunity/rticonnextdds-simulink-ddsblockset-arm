function filesPathsGenOrAdded = emitSecondPass(data, varargin)
%This function is for internal use only. It may be removed in the future.

%   Copyright 2020-2023 The MathWorks, Inc.

    filesPathsGenOrAdded = dds.internal.coder.RTI.generateServices(data, varargin{:});
end
