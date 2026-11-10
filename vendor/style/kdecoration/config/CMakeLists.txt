#####  config classes ææææææ

set(frostydecoration_config_SRCS
  ../frostyexceptionlist.cpp
    frostyconfigwidget.cpp
    frostydetectwidget.cpp
    frostyexceptiondialog.cpp
    frostyexceptionlistwidget.cpp
    frostyexceptionmodel.cpp
    frostyitemmodel.cpp
)
ki18n_wrap_ui(frostydecoration_config_SRCS
    ui/frostyconfigurationui.ui
    ui/frostydetectwidget.ui
    ui/frostyexceptiondialog.ui
    ui/frostyexceptionlistwidget.ui
)

kcoreaddons_add_plugin(kcm_frostydecoration SOURCES kcm_frostydecoration.cpp ${frostydecoration_config_SRCS} INSTALL_NAMESPACE "${KDECORATION_KCM_PLUGIN_DIR}")
kconfig_add_kcfg_files(kcm_frostydecoration ../frostysettings.kcfgc)
target_include_directories(kcm_frostydecoration PRIVATE ${CMAKE_SOURCE_DIR}/kdecoration ${CMAKE_BINARY_DIR}/kdecoration/)
target_link_libraries(kcm_frostydecoration
     PUBLIC
        Qt6::Core
        Qt6::Gui
        Qt6::DBus
        KDecoration3::KDecoration
     PRIVATE
        KF6::CoreAddons
        KF6::ConfigWidgets
        KF6::GuiAddons
        KF6::I18n
        KF6::IconThemes
        KF6::WindowSystem
        KF6::KCMUtils
)
kcmutils_generate_desktop_file(kcm_frostydecoration)
