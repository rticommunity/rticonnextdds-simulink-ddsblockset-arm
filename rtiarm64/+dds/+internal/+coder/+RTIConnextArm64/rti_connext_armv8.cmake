#
# This toolchain file can be used to cross-compile a Simulink
# DDS application for Raspberry Pi.

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ARM)
set(CMAKE_SYSTEM_VERSION 1)

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
    set(CMAKE_C_COMPILER   aarch64-linux-gnu-gcc)
    set(CMAKE_CXX_COMPILER aarch64-linux-gnu-g++)
    set(CMAKE_LINKER aarch64-linux-gnu-g++)
    set(CMAKE_AR aarch64-linux-gnu-ar)
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
    message(FATAL_ERROR "Unsupported OS. Please, contact simulink@rti.com "
        "if you need support for this host OS.")
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    set(CMAKE_C_COMPILER   aarch64-none-linux-gnu-gcc)
    set(CMAKE_CXX_COMPILER aarch64-none-linux-gnu-g++)
    set(CMAKE_LINKER aarch64-none-linux-gnu-g++)
    set(CMAKE_AR aarch64-none-linux-gnu-ar)
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
