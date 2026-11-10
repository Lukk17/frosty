add_definitions(-DTRANSLATION_DOMAIN="frosty_kwin_deco")

################# configuration #################
configure_file(config-frosty.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config-frosty.h )

################# includes #################
include_directories(${CMAKE_SOURCE_DIR}/libfrostycommon)
include_directories(${CMAKE_BINARY_DIR}/libfrostycommon)

################# newt target #################
### plugin classes
set(frostydecoration_SRCS
    frostybutton.cpp
    frostydecoration.cpp
    frostyexceptionlist.cpp
    frostysettingsprovider.cpp
)
### build library
kconfig_add_kcfg_files(frostydecoration_SRCS frostysettings.kcfgc)
add_library(frostydecoration MODULE
    ${frostydecoration_SRCS}
    ${frostydecoration_config_SRCS}
    ${frostydecoration_config_PART_FORMS_HEADERS})

set_target_properties(frostydecoration PROPERTIES
    OUTPUT_NAME com.github.lukk17.frosty
)

target_link_libraries(frostydecoration
     PRIVATE
        frostycommon6
        KF6::CoreAddons
        KF6::ConfigWidgets
        KF6::GuiAddons
        KF6::I18n
        KF6::IconThemes
        KF6::WindowSystem
        KF6::KCMUtils
        Qt6::DBus
        KDecoration3::KDecoration
)
install(TARGETS frostydecoration DESTINATION ${KDE_INSTALL_PLUGINDIR}/${KDECORATION_PLUGIN_DIR})
install(FILES config/frostydecorationconfig.desktop DESTINATION  ${KDE_INSTALL_DATADIR}/kservices6)
add_subdirectory(config)
