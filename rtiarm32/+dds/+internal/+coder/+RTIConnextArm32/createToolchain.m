function registeredObjects = createToolchain(varargin)
% This function was generated using target data export.

    builddependencies = target.create("BuildDependencies");

    cmakebuildtype = target.create("CMakeBuildType");
    cmakebuildtype.GeneratesDebugSymbols = true;
    cmakebuildtype.Name = "RelWithDebInfo";

    cmakebuildtype2 = target.create("CMakeBuildType");
    cmakebuildtype2.DebugBuildType = "RelWithDebInfo";
    cmakebuildtype2.Name = "Release";

    cmakebuildtype3 = target.create("CMakeBuildType");
    cmakebuildtype3.GeneratesDebugSymbols = true;
    cmakebuildtype3.Name = "Debug";

    cmakebuilder = target.create("CMakeBuilder");
    cmakebuilder.Generator = "Unix Makefiles";
    cmakebuilder.SupportedBuildTypes(1) = cmakebuildtype;
    cmakebuilder.SupportedBuildTypes(2) = cmakebuildtype2;
    cmakebuilder.SupportedBuildTypes(3) = cmakebuildtype3;
    cmakebuilder.ToolchainFile = fullfile(fileparts(mfilename('fullpath')),'rti_connext_armv7.cmake');

    hostoperatingsystemsupport = target.create("HostOperatingSystemSupport");

    environmentconfiguration = target.create("EnvironmentConfiguration");
    environmentconfiguration.HostOperatingSystemSupport = hostoperatingsystemsupport;

    hostoperatingsystemsupport2 = target.create("HostOperatingSystemSupport");
    hostoperatingsystemsupport2.Linux = true;
    hostoperatingsystemsupport2.Windows = true;
    hostoperatingsystemsupport2.Mac = true;

    % Create target.Toolchain "RTI Connext 6.x for Arm 32 bits Project"
    toolchain = target.create("Toolchain");
    toolchain.BuildRequirements = builddependencies;
    toolchain.Builder = cmakebuilder;
    toolchain.EnvironmentConfiguration(1) = environmentconfiguration;
    toolchain.HostOperatingSystemSupport = hostoperatingsystemsupport2;
    toolchain.Name = "RTI Connext 6.x for Arm 32 bits Project";

    % Add the target objects to MATLAB memory
    registeredObjects = target.add(toolchain, varargin{:});
end
