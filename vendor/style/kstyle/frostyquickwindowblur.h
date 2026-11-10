#ifndef frostyquickwindowblur_h
#define frostyquickwindowblur_h

#include <QQuickRenderControl>
#include <QQuickWindow>

namespace Frosty
{
enum class QuickWindowBlur {
    Skip,
    Disable,
    Enable,
};

//! what to ask KWin for a Qt Quick top level window
inline QuickWindowBlur quickWindowBlur(QQuickWindow *window)
{
    if (!window || !window->isVisible() || QQuickRenderControl::renderWindowFor(window)) {
        return QuickWindowBlur::Skip;
    }

    const Qt::WindowType type = window->type();
    if ((type != Qt::Window && type != Qt::Dialog) || window->flags().testFlag(Qt::FramelessWindowHint)) {
        return QuickWindowBlur::Skip;
    }

    return window->color().alpha() == 255 ? QuickWindowBlur::Disable : QuickWindowBlur::Enable;
}
}

#endif
