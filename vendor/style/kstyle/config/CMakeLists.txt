### configuration plugin
add_definitions(-DTRANSLATION_DOMAIN=\"frosty_style_config\")
set(kstyle_frosty_config_PART_SRCS frostystyleconfig.cpp)

set(kstyle_frosty_config_PART_SRCS ${kstyle_frosty_config_PART_SRCS} frostystyleconfigmodule.cpp)

kconfig_add_kcfg_files(kstyle_frosty_config_PART_SRCS ../frostystyleconfigdata.kcfgc)
set(kstyle_frosty_config_PART_FORMS ui/frostystyleconfig.ui)
ki18n_wrap_ui(kstyle_frosty_config_PART_FORMS_HEADERS ${kstyle_frosty_config_PART_FORMS})

kcoreaddons_add_plugin(frostystyleconfig SOURCES
    ${kstyle_frosty_config_PART_SRCS}
    ${kstyle_frosty_config_PART_FORMS_HEADERS}
    INSTALL_NAMESPACE "kstyle_config"
)

target_link_libraries(frostystyleconfig Qt6::Core Qt6::Gui Qt6::Widgets Qt6::DBus)
target_link_libraries(frostystyleconfig KF6::CoreAddons KF6::ConfigCore KF6::ConfigWidgets KF6::I18n)
if(QT_MAJOR_VERSION STREQUAL "6")
    target_link_libraries(frostystyleconfig KF6::KCMUtils)
endif()
kcmutils_generate_desktop_file(frostystyleconfig)

set(frosty_settings_SOURCES main.cpp)
add_executable(frosty-settings ${frosty_settings_SOURCES} )
target_link_libraries(frosty-settings Qt6::Core Qt6::Gui Qt6::Widgets )
target_link_libraries(frosty-settings KF6::I18n KF6::KCMUtils KF6::CoreAddons)

set_target_properties(frosty-settings PROPERTIES OUTPUT_NAME frosty-settings${QT_MAJOR_VERSION})

install(TARGETS frosty-settings ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

# icon
ecm_install_icons(ICONS sc-apps-frosty-settings.svgz
    DESTINATION ${KDE_INSTALL_ICONDIR}
    THEME hicolor )


