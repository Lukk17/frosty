/*
 * Unit tests for the Dolphin status bar
 *
 * Tests that the Frosty style draws Dolphin's full width status bar
 * as glass at ToolBarOpacity, like the other Dolphin bars.
 */

#include <QApplication>
#include <QGridLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QMainWindow>
#include <QPainter>
#include <QPluginLoader>
#include <QScrollArea>
#include <QStandardPaths>
#include <QStyleOption>
#include <QStylePlugin>
#include <QTest>
#include <QVBoxLayout>

#include "frostystyleconfigdata.h"

// Mock widget with the class name, children and paint event of Dolphin's full width status bar
class DolphinStatusBar : public QWidget
{
    Q_OBJECT
public:
    explicit DolphinStatusBar(QWidget *parent = nullptr)
        : QWidget(parent)
    {
        auto *fillParentLayout = new QGridLayout(this);
        fillParentLayout->setContentsMargins(0, 0, 0, 0);

        auto *scrollArea = new QScrollArea(this);
        fillParentLayout->addWidget(scrollArea);
        scrollArea->setFrameShape(QFrame::NoFrame);
        scrollArea->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
        scrollArea->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
        scrollArea->setWidgetResizable(true);

        auto *contentsContainer = new QWidget;
        scrollArea->setWidget(contentsContainer);

        auto *topLayout = new QHBoxLayout(contentsContainer);
        topLayout->addWidget(new QLabel(QStringLiteral("10 folders, 2 files"), contentsContainer));
        topLayout->addStretch();

        setFixedHeight(32);
    }

protected:
    void paintEvent(QPaintEvent *) override
    {
        QPainter painter(this);
        QStyleOption option;
        option.initFrom(this);
        style()->drawPrimitive(QStyle::PE_PanelStatusBar, &option, &painter, this);
    }
};

class DolphinStatusBarTest : public QObject
{
    Q_OBJECT

private Q_SLOTS:
    void initTestCase();
    void cleanupTestCase();
    void init();

    void testStatusBarIsGlassAtToolBarOpacity();
};

void DolphinStatusBarTest::initTestCase()
{
    QStandardPaths::setTestModeEnabled(true);
    QCoreApplication::setApplicationName(QStringLiteral("dolphin"));

    QPluginLoader loader(QStringLiteral(FROSTY_STYLE_PLUGIN));
    auto *plugin = qobject_cast<QStylePlugin *>(loader.instance());
    QVERIFY2(plugin, qPrintable(loader.errorString()));

    QStyle *style = plugin->create(QStringLiteral("frosty"));
    QVERIFY(style);
    QApplication::setStyle(style);

    QPalette palette = QApplication::palette();
    palette.setColor(QPalette::Window, QColor(16, 16, 20, 166));
    QApplication::setPalette(palette);
}

void DolphinStatusBarTest::cleanupTestCase()
{
    QStandardPaths::setTestModeEnabled(false);
}

void DolphinStatusBarTest::init()
{
    Frosty::StyleConfigData::self()->load();
}

void DolphinStatusBarTest::testStatusBarIsGlassAtToolBarOpacity()
{
    QMainWindow window;
    auto *viewContainer = new QWidget(&window);
    auto *layout = new QVBoxLayout(viewContainer);
    layout->setContentsMargins(0, 0, 0, 0);
    layout->addStretch();
    auto *statusBar = new DolphinStatusBar(viewContainer);
    layout->addWidget(statusBar);
    window.setCentralWidget(viewContainer);
    window.resize(400, 300);
    window.show();
    QVERIFY(QTest::qWaitForWindowExposed(&window));
    QVERIFY(window.testAttribute(Qt::WA_TranslucentBackground));

    const QImage image = window.grab().toImage();
    const QPoint statusBarPoint = statusBar->mapTo(&window, QPoint(statusBar->width() - 10, statusBar->height() / 2));
    const int expectedAlpha = qRound(Frosty::StyleConfigData::toolBarOpacity() * 255 / 100.0);
    QCOMPARE(qAlpha(image.pixel(statusBarPoint)), expectedAlpha);
}

QTEST_MAIN(DolphinStatusBarTest)
#include "dolphinstatusbar_test.moc"
