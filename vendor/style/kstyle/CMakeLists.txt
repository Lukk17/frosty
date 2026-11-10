################# includes #################
include_directories(
    animations
    debug
    ${CMAKE_SOURCE_DIR}/libfrostycommon
    ${CMAKE_BINARY_DIR}/libfrostycommon
)

################# configuration #################
configure_file(config-frosty.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config-frosty.h)

########### next target ###############
set(frosty_PART_SRCS
    animations/frostyanimation.cpp
    animations/frostyanimations.cpp
    animations/frostyanimationdata.cpp
    animations/frostybaseengine.cpp
    animations/frostybusyindicatordata.cpp
    animations/frostybusyindicatorengine.cpp
    animations/frostydialdata.cpp
    animations/frostydialengine.cpp
    animations/frostyenabledata.cpp
    animations/frostygenericdata.cpp
    animations/frostyheaderviewdata.cpp
    animations/frostyheaderviewengine.cpp
    animations/frostyscrollbardata.cpp
    animations/frostyscrollbarengine.cpp
    animations/frostyspinboxengine.cpp
    animations/frostyspinboxdata.cpp
    animations/frostystackedwidgetdata.cpp
    animations/frostystackedwidgetengine.cpp
    animations/frostytabbarengine.cpp
    animations/frostytabbardata.cpp
    animations/frostytoolboxengine.cpp
    animations/frostytransitiondata.cpp
    animations/frostytransitionwidget.cpp
    animations/frostywidgetstateengine.cpp
    animations/frostywidgetstatedata.cpp
    debug/frostywidgetexplorer.cpp
    frostyaddeventfilter.cpp
    frostyblurhelper.cpp
    frostyframeshadow.cpp
    frostyhelper.cpp
    frostymdiwindowshadow.cpp
    frostymnemonics.cpp
    frostypropertynames.cpp
    frostyshadowhelper.cpp
    frostysplitterproxy.cpp
    frostystyle.cpp
    frostystyleplugin.cpp
    frostytileset.cpp
    frostywindowmanager.cpp
    frostytoolsareamanager.cpp
)

kconfig_add_kcfg_files(frosty_PART_SRCS ../kdecoration/frostysettings.kcfgc)
kconfig_add_kcfg_files(frosty_PART_SRCS frostystyleconfigdata.kcfgc)

add_library(frosty${QT_MAJOR_VERSION} MODULE ${frosty_PART_SRCS})

################# find Qt modules #################
if(QT_MAJOR_VERSION EQUAL 6)
    find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets Quick QuickWidgets)
else()
    find_package(Qt5 REQUIRED COMPONENTS Core Gui Widgets Quick QuickWidgets)
endif()

################# link Qt libraries #################
target_link_libraries(frosty${QT_MAJOR_VERSION}
    PRIVATE
    Qt${QT_MAJOR_VERSION}::Core
    Qt${QT_MAJOR_VERSION}::Gui
    Qt${QT_MAJOR_VERSION}::Widgets
    Qt${QT_MAJOR_VERSION}::DBus
    Qt${QT_MAJOR_VERSION}::Quick
)

if( FROSTY_HAVE_QTQUICK )
    target_link_libraries(frosty${QT_MAJOR_VERSION}
        PRIVATE
            Qt${QT_MAJOR_VERSION}::QuickWidgets
            KF${QT_MAJOR_VERSION}::CoreAddons
    )
endif()

################# link KDE Frameworks #################
target_link_libraries(frosty${QT_MAJOR_VERSION}
    PRIVATE
    KF${QT_MAJOR_VERSION}::CoreAddons
    KF${QT_MAJOR_VERSION}::ConfigCore
    KF${QT_MAJOR_VERSION}::ConfigGui
    KF${QT_MAJOR_VERSION}::GuiAddons
    KF${QT_MAJOR_VERSION}::IconThemes
    KF${QT_MAJOR_VERSION}::WindowSystem
)

if(QT_MAJOR_VERSION STREQUAL "5")
    target_link_libraries(frosty${QT_MAJOR_VERSION} PRIVATE KF5::ConfigWidgets)
    if(FROSTY_HAVE_QTQUICK)
        target_link_libraries(frosty${QT_MAJOR_VERSION} PRIVATE KF5::Kirigami2)
    endif()
else()
    target_link_libraries(frosty${QT_MAJOR_VERSION} PRIVATE KF6::ColorScheme)
    if(FROSTY_HAVE_QTQUICK)
        target_link_libraries(frosty${QT_MAJOR_VERSION} PRIVATE KF6::KirigamiPlatform)
    endif()
endif()

################# link internal library #################
target_link_libraries(frosty${QT_MAJOR_VERSION} PRIVATE frostycommon${QT_MAJOR_VERSION})

################# KDE style integration #################
if(KF${QT_MAJOR_VERSION}FrameworkIntegration_FOUND)
    target_link_libraries(frosty${QT_MAJOR_VERSION} PRIVATE KF${QT_MAJOR_VERSION}::Style)
endif()

if (WIN32)
    # As stated in https://docs.microsoft.com/en-us/cpp/c-runtime-library/math-constants M_PI only gets defined
    # when if _USE_MATH_DEFINES is defined
    target_compile_definitions(frosty${QT_MAJOR_VERSION} PRIVATE _USE_MATH_DEFINES _BSD_SOURCE)
endif()


########### install files ###############
if (FOR_FLATPAK)
    set(LIB_TARGET ${QT_PLUGINS_DIR}/styles/)
else()
    set(LIB_TARGET ${KDE_INSTALL_QTPLUGINDIR}/styles/)
endif()
install(TARGETS frosty${QT_MAJOR_VERSION} DESTINATION ${LIB_TARGET})

if (NOT FOR_FLATPAK)
    install(FILES frosty.themerc  DESTINATION  ${KDE_INSTALL_DATADIR}/kstyle/themes)
endif()

########### subdirectories ###############

if (QT_MAJOR_VERSION EQUAL "6" AND TARGET "KF6::KCMUtils" AND NOT FOR_FLATPAK)
    add_subdirectory(config)
endif()

########### tests ###############
include(CTest)
if(BUILD_TESTING)
    add_subdirectory(tests)
endif()
