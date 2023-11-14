function regEnt = registerRTIConnext6XForArm64Bits
% This function is for internal use only. It may be removed in the future.


% registerRTIConnext6XForArm64Bits return a struct with required fields
regEnt = struct();
regEnt.Key = 'rtiarm64';
regEnt.DisplayName = 'RTI Connext 6.x for Arm 64 bits';
regEnt.DefaultToolchain = 'RTI Connext 6.x for Arm 64 bits Project';
regEnt.AnnotationKey = 'rti_connext';

regEnt.SetupModel = @dds.internal.coder.RTIConnextArm64.setupModel;
regEnt.ImportXML = @dds.internal.coder.RTIConnextArm64.importXML;
regEnt.ImportXMLAndIDL = @dds.internal.coder.RTIConnextArm64.importXMLAndIDL;
regEnt.VendorPostCompileValidation =@dds.internal.coder.RTI.VendorPostCompileValidation.RTIPostCompileValidation;

regEnt.ExportToXML = @dds.internal.coder.RTIConnextArm64.exportToXML;
regEnt.GenerateIDLAndXMLFiles = @dds.internal.coder.RTIConnextArm64.generateIDLAndXMLFiles;
regEnt.GenerateServices = @dds.internal.coder.RTIConnextArm64.generateServices;
regEnt.GetIsTraditionalCppSafeEnum = @dds.internal.coder.RTI.DataTypeCustomization.getIsTraditionalCppSafeEnum;
regEnt.GetIsStructUsingAccessFcn = @dds.internal.coder.RTI.DataTypeCustomization.getIsStructUsingAccessFcn;
regEnt.CMakePreEmitHook = @dds.internal.coder.RTIConnextArm64.CMakePreEmitHook;
regEnt.ServicePlugin = @dds.internal.coder.RTIConnextArm64.InterfaceAndImplementationPlugin;

end
