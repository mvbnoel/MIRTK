# ==============================================================================
# Medical Image Registration ToolKit (MIRTK)
#
# Copyright 2013-2015 Imperial College London
# Copyright 2013-2015 Andreas Schuh
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================

################################################################################
# @file  Settings.cmake
# @brief Non-default project settings.
#
# This file is included by basis_project_impl(), after it looked for the
# required and optional dependencies and the CMake variables related to the
# project directory structure were defined (see Directories.cmake file in
# @c BINARY_CONFIG_DIR). It is also included before the BasisSettings.cmake
# file.
#
# In particular build options should be added in this file using CMake's
# <a href="http://www.cmake.org/cmake/help/cmake-2-8-docs.html#command:option">
# option()</a> command. Further, any common settings related to using a found
# dependency can be set here if the basis_use_package() command was enable
# to import the required configuration of a particular external package.
#
# @ingroup BasisSettings
################################################################################

if (WITH_ARPACK AND NOT WITH_UMFPACK)
  message("${PROJECT_NAME} module WITH_ARPACK, setting also WITH_UMFPACK to ON")
  set(WITH_UMFPACK ON CACHE BOOL "Request build with UMFPACK library" FORCE)
elseif (NOT WITH_ARPACK AND WITH_UMFPACK)
  message("${PROJECT_NAME} module WITH_UMFPACK, setting also WITH_ARPACK to ON")
  set(WITH_ARPACK ON CACHE BOOL "Request build with ARPACK library" FORCE)
endif ()

set(BIG_ENDIAN_CONFIG 0)

basis_set_config_option(WITH_ARPACK_CONFIG  "${ARPACK_FOUND}")
basis_set_config_option(WITH_UMFPACK_CONFIG "${UMFPACK_FOUND}")
basis_set_config_option(WITH_MATLAB_CONFIG  "${MATLAB_FOUND}")
basis_set_config_option(WITH_VTK_CONFIG     "${VTK_FOUND}")
basis_set_config_option(WITH_LBFGS_CONFIG   "${LibLBFGS_FOUND}")

configure_file(
  "${PROJECT_CONFIG_DIR}/config.h.in"
  "${BINARY_INCLUDE_DIR}/mirtk/NumericsConfig.h"
  @ONLY
)
