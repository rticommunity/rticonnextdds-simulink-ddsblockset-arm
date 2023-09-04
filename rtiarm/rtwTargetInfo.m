function rtwTargetInfo(tr)
%RTWTARGETINFO Register toolchain for RTI Connext 6.x for Arm

% Copyright 2020-2021 The MathWorks, Inc.

    tr.registerTargetInfo(@loc_createToolchain);
end

% --------------------------------------------------------------------------
function config = loc_createToolchain

    config = coder.make.ToolchainInfoRegistry; % initialize
    config(end)                     = coder.make.ToolchainInfoRegistry;
    config(end).Name                = 'RTI Connext 6.x for Arm Project';
    config(end).Alias               = 'rtiConnext6_xForArm';
    config(end).FileName            = fullfile(fileparts(mfilename('fullpath')),'registry',['rtiarmconnext_6_x_rtiproject_', computer('arch'), '_v1.0.mat']);
    config(end).TargetHWDeviceType  = {'*'};
    config(end).Platform            = {'maca64', 'maci64', 'win64', 'glnxa64'};
end
