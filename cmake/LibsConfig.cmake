include_guard()
include(FetchContent)

function(fetch_repositories target)
# define external lib as static or dynamic
if(${P_EXTERNAL_LIBS_TYPE} STREQUAL "STATIC")
# its Static
set(libbuildtemp OFF)
# its Shared
 else()
 set(libbuildtemp ON)
endif(${P_EXTERNAL_LIBS_TYPE} STREQUAL "STATIC")
  set_property(GLOBAL PROPERTY USE_FOLDERS ON)
  set(INDEX 0)
  if(URLS)
    list(LENGTH URLS repo_count)
    if(repo_count GREATER 0)
      foreach(repo_url IN LISTS URLS)
        string(REGEX REPLACE ".*/(.*)\\.git" "\\1" repo_name ${repo_url})
        set(SOURCE_DESTINATION "${CMAKE_SOURCE_DIR}/thirdParty/${repo_name}")
        set(FETCHCONTENT_BASE_DIR "${SOURCE_DESTINATION}")
        list(GET TAGS ${INDEX} repo_branch)
#check for folder of requested lib
        if(NOT EXISTS "${SOURCE_DESTINATION}")
        file(MAKE_DIRECTORY "${SOURCE_DESTINATION}")
        message(STATUS "Fetching ${repo_name}...")
        FetchContent_Declare(
          ${repo_name}
          GIT_REPOSITORY ${repo_url}
          GIT_TAG ${repo_branch}
          GIT_SHALLOW TRUE
          GIT_PROGRESS TRUE
          SOURCE_DIR "${SOURCE_DESTINATION}"
        )
        # this external lib build as a STATIC-LIB (OFF) / SHARED-LIB (ON)
        set(BUILD_SHARED_LIBS ${libbuildtemp})
        FetchContent_MakeAvailable(${repo_name})
        math(EXPR INDEX "${INDEX} + 1")
        include_directories(${${repo_name}_SOURCE_DIR}/include)
        message(
          "******************************************************* ${repo_name} GIT_REPOSITORY ${repo_url} GIT_TAG ${repo_branch} "
        )
        target_include_directories(${target} PRIVATE (${${repo_name}_SOURCE_DIR}/include))
        else()
        #### fetch update and overal of repositry if the directory is exist DISCONNECT and Dont Updat ===> thirdParty/raylib
        set(FETCHCONTENT_FULLY_DISCONNECTED ON)
        set(FETCHCONTENT_UPDATES_DISCONNECTED ON)
        #### fetch update and overal of repositry if the directory is exist DISCONNECT and Dont Updat ===> thirdParty/raylib
        message(STATUS "Fetched ${repo_name}...")
        FetchContent_Declare(
          ${repo_name}
          GIT_REPOSITORY ${repo_url}
          GIT_TAG ${repo_branch}
          GIT_SHALLOW TRUE
          GIT_PROGRESS TRUE
          SOURCE_DIR "${SOURCE_DESTINATION}"
        )
        # this external lib build as a STATIC-LIB (OFF) / SHARED-LIB (ON)
        set(BUILD_SHARED_LIBS ${libbuildtemp})
        FetchContent_MakeAvailable(${repo_name}) 
        math(EXPR INDEX "${INDEX} + 1")
        include_directories(${${repo_name}_SOURCE_DIR}/include)
        message(
          "******************************************************* ${repo_name} GIT_REPOSITORY ${repo_url} GIT_TAG ${repo_branch} "
        )
        target_include_directories(${target} PRIVATE (${${repo_name}_SOURCE_DIR}/include)) 
        endif(NOT EXISTS "${SOURCE_DESTINATION}")
      endforeach()
    endif()
  endif()
        message(
          "ALL External fetched libs build as a BUILD_SHARED_LIBS: ${libbuildtemp}"
        )
endfunction()

# target_link_libraries(MyApp PRIVATE sfml-graphics sfml-window sfml-system)
# target_include_directories(MyApp PRIVATE ${SFML_SOURCE_DIR}/include)
