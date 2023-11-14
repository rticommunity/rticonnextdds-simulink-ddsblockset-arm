function regEnt = registerRTIConnext6XForArm32Bits
% This function is for internal use only. It may be removed in the future.


% registerRTIConnext6XForArm32Bits return a struct with required fields
regEnt = struct();
regEnt.Key = 'rtiarm32';
regEnt.DisplayName = 'RTI Connext 6.x for Arm 32 bits';
regEnt.DefaultToolchain = 'RTI Connext 6.x for Arm 32 bits Project';
regEnt.AnnotationKey = 'rti_connext';

regEnt.SetupModel = @dds.internal.coder.RTIConnextArm32.setupModel;
regEnt.ImportXML = @dds.internal.coder.RTIConnextArm32.importXML;
regEnt.ImportXMLAndIDL = @dds.internal.coder.RTIConnextArm32.importXMLAndIDL;
regEnt.VendorPostCompileValidation =@dds.internal.coder.RTI.VendorPostCompileValidation.RTIPostCompileValidation;

regEnt.ExportToXML = @dds.internal.coder.RTIConnextArm32.exportToXML;
regEnt.GenerateIDLAndXMLFiles = @dds.internal.coder.RTIConnextArm32.generateIDLAndXMLFiles;
regEnt.GenerateServices = @dds.internal.coder.RTIConnextArm32.generateServices;
regEnt.GetIsTraditionalCppSafeEnum = @dds.internal.coder.RTI.DataTypeCustomization.getIsTraditionalCppSafeEnum;
regEnt.GetIsStructUsingAccessFcn = @dds.internal.coder.RTI.DataTypeCustomization.getIsStructUsingAccessFcn;
regEnt.CMakePreEmitHook = @dds.internal.coder.RTIConnextArm32.CMakePreEmitHook;
regEnt.ServicePlugin = @dds.internal.coder.RTIConnextArm32.InterfaceAndImplementationPlugin;

end
