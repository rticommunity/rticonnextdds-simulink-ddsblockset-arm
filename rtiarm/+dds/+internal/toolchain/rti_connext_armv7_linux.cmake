#
# This toolchain file can be used to cross-compile a Simulink
# DDS application for Raspberry Pi.

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ARM)
set(CMAKE_SYSTEM_VERSION 1)

set(CMAKE_C_COMPILER   arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Since the toolchain file restricts CMake's find() functions,
# We must add the following Connext paths to CMake's search path
# to help FindRTIConnextDDS.cmake
list(APPEND CMAKE_FIND_ROOT_PATH
    ${CONNEXTDDS_DIR}
    ${CONNEXTDDS_DIR}/bin
    ${CONNEXTDDS_DIR}/lib/${CONNEXTDDS_ARCH}
    ${CONNEXTDDS_DIR}/include/ndds)

