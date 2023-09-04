function regEnt = registerRTIConnext6XForArm
% This function is for internal use only. It may be removed in the future.

% Copyright 2020-2021 The MathWorks, Inc.

% registerRTIConnext6XForArm return a struct with required fields
regEnt = struct();
regEnt.Key = 'rtiConnext6_xForArm';
regEnt.DisplayName = 'RTI Connext 6.x for Arm';
regEnt.DefaultToolchain = 'RTI Connext 6.x for Arm Project';
regEnt.AnnotationKey = 'rti_connext';

regEnt.SetupModel = @dds.internal.coder.RTIConnextArm.setupModel;
regEnt.ImportXML = @dds.internal.coder.RTIConnextArm.importXML;
regEnt.ImportXMLAndIDL = @dds.internal.coder.RTIConnextArm.importXMLAndIDL;
regEnt.VendorPostCompileValidation =@dds.internal.coder.RTI.VendorPostCompileValidation.RTIPostCompileValidation;

regEnt.ExportToXML = @dds.internal.coder.RTIConnextArm.exportToXML;
regEnt.GenerateIDLAndXMLFiles = @dds.internal.coder.RTIConnextArm.generateIDLAndXMLFiles;
regEnt.GenerateServices = @dds.internal.coder.RTIConnextArm.generateServices;
regEnt.GetIsTraditionalCppSafeEnum = @dds.internal.coder.RTI.DataTypeCustomization.getIsTraditionalCppSafeEnum;
regEnt.GetIsStructUsingAccessFcn = @dds.internal.coder.RTI.DataTypeCustomization.getIsStructUsingAccessFcn;

end
