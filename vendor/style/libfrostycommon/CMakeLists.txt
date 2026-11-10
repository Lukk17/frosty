add_library(frostycommon${QT_MAJOR_VERSION} OBJECT frostyboxshadowrenderer.cpp)

set_target_properties(frostycommon${QT_MAJOR_VERSION} PROPERTIES POSITION_INDEPENDENT_CODE TRUE)

target_link_libraries(frostycommon${QT_MAJOR_VERSION}
    PUBLIC
        Qt${QT_MAJOR_VERSION}::Core
        Qt${QT_MAJOR_VERSION}::Gui)
