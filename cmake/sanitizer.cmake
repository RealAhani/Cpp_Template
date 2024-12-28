macro(setting_enable_sanitizer target_link)
  if(HAS_SAN)
    if(UNIX OR LINUX OR APPLE) # this is for unix/linux
      if(${P_CXX_COMPILER} STREQUAL "clang++")
        message(
          "--------------------------------------------- SANITIZER IS ON IN (UNIX-LIKE) ${target_link} WITH: ${SAN_FLAGS}"
        )
        set(CMAKE_CXX_FLAGS_DEBUG
            "${CMAKE_CXX_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=${SAN_FLAGS}")
        set(CMAKE_LINKER_FLAGS_DEBUG
            "${CMAKE_LINKER_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=${SAN_FLAGS}"
        )
      endif()
    endif()
  endif()
endmacro()
