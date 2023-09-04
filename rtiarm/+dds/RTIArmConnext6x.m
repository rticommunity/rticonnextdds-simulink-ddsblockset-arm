classdef RTIArmConnext6x < dds.internal.coder.ProjectToolCore
%

%   Copyright 2020 The MathWorks, Inc.

    methods

        function h = RTIArmConnext6x(~)
            h@dds.internal.coder.ProjectToolCore('RTIArmConnext6x');
        end

        function fileName = getDDSProjectInfoFile(~)
            fileName = 'rticonnect6xprojectinfo.mat';
        end

        function builder = getDDSProjectBuilder(~, varargin)
            builder = dds.internal.RTIArmBuilder(varargin{:});
        end
    end

end
