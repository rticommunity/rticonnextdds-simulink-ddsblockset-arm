#
# This toolchain file can be used to cross-compile a Simulink
# DDS application for Raspberry Pi.

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ARM)
set(CMAKE_SYSTEM_VERSION 1)

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
    set(CMAKE_C_COMPILER   arm-linux-gnueabihf-gcc)
    set(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)
    set(CMAKE_LINKER arm-linux-gnueabihf-g++)
    set(CMAKE_AR arm-linux-gnueabihf-ar)
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
    message(FATAL_ERROR "Unsupported OS. Please, contact simulink@rti.com "
        "if you need support for this host OS.")
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    set(CMAKE_C_COMPILER   arm-none-linux-gnueabihf-gcc)
    set(CMAKE_CXX_COMPILER arm-none-linux-gnueabihf-g++)
    set(CMAKE_LINKER arm-none-linux-gnueabihf-g++)
    set(CMAKE_AR arm-none-linux-gnueabihf-ar)
else()
    message(FATAL_ERROR "Unsupported OS. Please, contact simulink@rti.com "
        "if you need support for this host OS.")
endif()

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CONNEXTDDS_DIR $ENV{NDDSHOME})
set(RTICODEGEN_DIR ${CONNEXTDDS_DIR}/bin)
set(CONNEXTDDS_BASE_INCLUDE_DIRS ${CONNEXTDDS_DIR}/include/ndds)

# Since the toolchain file restricts CMake's find() functions,
# We must add the following Connext paths to CMake's search path
# to help FindRTIConnextDDS.cmake
list(APPEND CMAKE_FIND_ROOT_PATH
    ${CONNEXTDDS_DIR}
    ${CONNEXTDDS_DIR}/bin
    ${CONNEXTDDS_DIR}/lib/${CONNEXTDDS_ARCH}
    ${CONNEXTDDS_DIR}/include/ndds)

