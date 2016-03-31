# ==============================================================================
# Medical Image Registration ToolKit (MIRTK)
#
# Copyright 2016 Imperial College London
# Copyright 2016 Andreas Schuh
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

if (COMMAND mirtk_generate_bash_completions)
  return()
endif ()

# ------------------------------------------------------------------------------
## @brief Write Bash completion scripts for "mirtk" commands
function (mirtk_generate_bash_completions)
  message(STATUS "Writing Bash completions script...")
  get_property(COMMANDS GLOBAL PROPERTY MIRTK_COMMANDS)
  basis_list_to_delimited_string(COMMANDS " " ${COMMANDS})
  file(WRITE "${PROJECT_BINARY_DIR}/share/completion/bash/mirtk"
"
# Auto-generated by MIRTK root CMakeLists.txt during CMake configure.
#
# To enable Bash completion of \"mirtk\" subcommands, add the following to your
# ~/.bashrc (Linux) or ~/.bash_profile (OS X) file:
#
#   [ ! -f \"\$MIRTK_ROOT/share/completion/bash/mirtk\" ] ||
#   source \"\$MIRTK_ROOT/share/completion/bash/mirtk\"
#   [ ! -f \"\$MIRTK_ROOT/share/mirtk/completion/bash/mirtk\" ] ||
#   source \"\$MIRTK_ROOT/share/mirtk/completion/bash/mirtk\"
#
# Alternatively, copy this file to:
# - /etc/bash_completion.d/ (Linux)
# - \$(brew --prefix)/etc/bash_completion.d/ (OS X, Homebrew)
#
_mirtk_complete()
{
  local commands='${COMMANDS}'
  local noreply='true'
  if [ \$COMP_CWORD -eq 2 ]; then
    if [ \${COMP_WORDS[1]} = help ] || [ \${COMP_WORDS[1]} = help-rst ]; then
      COMPREPLY=( `compgen -W \"\$commands\" -- \${COMP_WORDS[COMP_CWORD]}` )
      noreply='false'
    fi
  elif [ \$COMP_CWORD -eq 1 ]; then
    COMPREPLY=( `compgen -W \"help help-rst \$commands\" -- \${COMP_WORDS[COMP_CWORD]}` )
    noreply='false'
  fi
  if [ \$noreply = true ]; then
    local IFS=$'\n'
    COMPREPLY=(`compgen -o plusdirs -f -- \"\${COMP_WORDS[COMP_CWORD]}\"`)
    compopt -o filenames +o nospace 2>/dev/null || compgen -f /non-existing-dir/ > /dev/null
  fi
}
complete -F _mirtk_complete mirtk
"
  )
  file(WRITE "${PROJECT_BINARY_DIR}/share/completion/bash/docker-mirtk"
"
# Auto-generated by MIRTK root CMakeLists.txt during CMake configure.
#
# To enable Bash completion for \"docker run [options] <user>/mirtk\" subcommands:
#
# - On Linux:
#   - Copy this file to /etc/bash_completion.d/:
#
# - On OS X with Homebrew:
#   - brew install bash-completion
#   - curl -L https://raw.githubusercontent.com/docker/docker/master/contrib/completion/bash/docker > \$(brew --prefix)/etc/bash_completion.d/docker
#   - Copy this file to \$(brew --prefix)/etc/bash_completion.d/:
#
_docker_mirtk()
{
  local commands='${COMMANDS}'
  local noreply='true'
  local nodocker='false'
  if [ \$COMP_CWORD -gt 2 ] && [ \${COMP_WORDS[1]} = run ]; then
    local i
    let i=\$COMP_CWORD-1
    if [ \${COMP_WORDS[i]/*\\//} = mirtk ]; then
      COMPREPLY=( `compgen -W \"help help-rst \$commands\" -- \${COMP_WORDS[COMP_CWORD]}` )
      nodocker='true'
      noreply='false'
    elif [ \${COMP_WORDS[i]} = help ]; then
      let i=\$i-1
      if [ \${COMP_WORDS[i]/*\\//} = mirtk ]; then
        COMPREPLY=( `compgen -W \"\$commands\" -- \${COMP_WORDS[COMP_CWORD]}` )
        nodocker='true'
        noreply='false'
      fi
    else
      local word
      for word in \${COMP_WORDS[@]}; do
        if [ \${word/*\\//} = mirtk ]; then
          nodocker='true'
          noreply='true'
        fi
      done
    fi
  fi
  if [ \$nodocker = false ]; then
    # call docker completion function instead
    # https://raw.githubusercontent.com/docker/docker/master/contrib/completion/bash/docker
    declare -f _docker > /dev/null
    if [ \$? -eq 0 ]; then
      _docker
      noreply='false'
    fi
  fi
  if [ \$noreply = true ]; then
    local IFS=$'\n'
    COMPREPLY=(`compgen -o plusdirs -f -- \"\${COMP_WORDS[COMP_CWORD]}\"`)
    compopt -o filenames +o nospace 2>/dev/null || compgen -f /non-existing-dir/ > /dev/null
  fi
}
complete -F _docker_mirtk docker
"
  )
  install(
    FILES
      "${PROJECT_BINARY_DIR}/share/completion/bash/mirtk"
      "${PROJECT_BINARY_DIR}/share/completion/bash/docker-mirtk"
    DESTINATION
      "${INSTALL_SHARE_DIR}/completion/bash"
  )
  message(STATUS "Writing Bash completions script... done")
endfunction ()