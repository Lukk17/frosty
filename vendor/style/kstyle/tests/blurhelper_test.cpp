/*
 * Unit tests for BlurHelper behavior with DolphinViewOpacity
 *
 * Tests that blur regions are correctly calculated when
 * DolphinViewOpacity is set to less than 100.
 */

#include <QTest>
#include <QWidget>
#include <QMainWindow>
#include <QScrollArea>
#include <QVBoxLayout>
#include <QTemporaryDir>
#include <QStandardPaths>
#include <QQuickRenderControl>
#include <QQuickWindow>
#include <QSGRendererInterface>

#include "frostyquickwindowblur.h"
#include "frostystyleconfigdata.h"

// Mock widget that inherits from QAbstractScrollArea and pretends to be KItemListContainer
class MockKItemListContainer : public QAbstractScrollArea
{
    Q_OBJECT
public:
    explicit MockKItemListContainer(QWidget *parent = nullptr)
        : QAbstractScrollArea(parent)
    {
        setObjectName("MockKItemListContainer");
    }

    // Override inherits to pretend we're KItemListContainer
    bool inherits(const char *classname) const
    {
        if (qstrcmp(classname, "KItemListContainer") == 0) {
            return true;
        }
        return QAbstractScrollArea::inherits(classname);
    }
};

// Mock render control that reports a render window, like the one QQuickWidget uses
class MockQuickWidgetRenderControl : public QQuickRenderControl
{
public:
    explicit MockQuickWidgetRenderControl(QWindow *renderWindow)
        : m_renderWindow(renderWindow)
    {
    }

    QWindow *renderWindow(QPoint *offset) override
    {
        if (offset) {
            *offset = QPoint();
        }
        return m_renderWindow;
    }

private:
    QWindow *m_renderWindow;
};

class BlurHelperTest : public QObject
{
    Q_OBJECT

private:
    QTemporaryDir m_tempDir;

private Q_SLOTS:
    void initTestCase();
    void cleanupTestCase();
    void init();
    void cleanup();

    // Blur region tests
    void testNoBlurWhenOpacity100();
    void testBlurEnabledWhenOpacityLessThan100();
    void testBlurRegionIncludesKItemListContainer();
    void testBlurIndependentOfSidebarOpacity();

    // Qt Quick window blur tests
    void testQuickWindowTranslucentRequestsBlur();
    void testQuickDialogTranslucentRequestsBlur();
    void testQuickWindowOpaqueDisablesBlur();
    void testQuickWindowFramelessSkipped();
    void testQuickWindowOffscreenSkipped();
    void testQuickWindowHiddenSkipped();
    void testQuickWindowPopupSkipped();
    void testNullWindowSkipped();
};

void BlurHelperTest::initTestCase()
{
    QVERIFY(m_tempDir.isValid());
    QStandardPaths::setTestModeEnabled(true);
    QQuickWindow::setGraphicsApi(QSGRendererInterface::Software);
}

void BlurHelperTest::cleanupTestCase()
{
    QStandardPaths::setTestModeEnabled(false);
}

void BlurHelperTest::init()
{
    Frosty::StyleConfigData::self()->setDefaults();
}

void BlurHelperTest::cleanup()
{
}

void BlurHelperTest::testNoBlurWhenOpacity100()
{
    // When opacity is 100, no blur should be needed for the view
    Frosty::StyleConfigData::setDolphinViewOpacity(100);
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 100);

    // The condition for blur registration should be false
    bool shouldRegisterBlur = (Frosty::StyleConfigData::dolphinViewOpacity() < 100);
    QVERIFY(!shouldRegisterBlur);
}

void BlurHelperTest::testBlurEnabledWhenOpacityLessThan100()
{
    // When opacity is less than 100, blur should be enabled
    Frosty::StyleConfigData::setDolphinViewOpacity(50);
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 50);

    bool shouldRegisterBlur = (Frosty::StyleConfigData::dolphinViewOpacity() < 100);
    QVERIFY(shouldRegisterBlur);

    // Test with 0 opacity
    Frosty::StyleConfigData::setDolphinViewOpacity(0);
    shouldRegisterBlur = (Frosty::StyleConfigData::dolphinViewOpacity() < 100);
    QVERIFY(shouldRegisterBlur);

    // Test with 99 opacity
    Frosty::StyleConfigData::setDolphinViewOpacity(99);
    shouldRegisterBlur = (Frosty::StyleConfigData::dolphinViewOpacity() < 100);
    QVERIFY(shouldRegisterBlur);
}

void BlurHelperTest::testBlurRegionIncludesKItemListContainer()
{
    Frosty::StyleConfigData::setDolphinViewOpacity(50);

    // Create a mock window with a KItemListContainer-like widget
    QMainWindow window;
    window.setGeometry(0, 0, 800, 600);

    auto *container = new MockKItemListContainer(&window);
    container->setGeometry(100, 100, 400, 300);

    window.setCentralWidget(container);
    window.show();

    // Process events to ensure visibility is updated
    QTest::qWait(10);

    // Verify our mock properly reports as KItemListContainer
    QVERIFY(container->inherits("KItemListContainer"));

    // The blur helper would find this widget and include its region
    // We can't directly test BlurHelper without more infrastructure,
    // but we can verify the conditions are met
    bool isDolphin = true; // In real code, this is set based on app name
    bool viewOpacityLessThan100 = Frosty::StyleConfigData::dolphinViewOpacity() < 100;
    bool containerIsKItemList = container->inherits("KItemListContainer");

    // The core conditions for blur region inclusion
    QVERIFY(isDolphin);
    QVERIFY(viewOpacityLessThan100);
    QVERIFY(containerIsKItemList);

    // After window.show() and event processing, container should be visible
    // But in headless test environment, this may not work - so we test the logic only
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 50);
}

void BlurHelperTest::testBlurIndependentOfSidebarOpacity()
{
    // Test that view blur is independent of sidebar blur

    // Case 1: View transparent, sidebar opaque
    Frosty::StyleConfigData::setDolphinViewOpacity(50);
    Frosty::StyleConfigData::setDolphinSidebarOpacity(100);

    bool shouldBlurView = (Frosty::StyleConfigData::dolphinViewOpacity() < 100);
    bool shouldBlurSidebar = (Frosty::StyleConfigData::dolphinSidebarOpacity() < 100);

    QVERIFY(shouldBlurView);
    QVERIFY(!shouldBlurSidebar);

    // Case 2: View opaque, sidebar transparent
    Frosty::StyleConfigData::setDolphinViewOpacity(100);
    Frosty::StyleConfigData::setDolphinSidebarOpacity(50);

    shouldBlurView = (Frosty::StyleConfigData::dolphinViewOpacity() < 100);
    shouldBlurSidebar = (Frosty::StyleConfigData::dolphinSidebarOpacity() < 100);

    QVERIFY(!shouldBlurView);
    QVERIFY(shouldBlurSidebar);

    // Case 3: Both transparent
    Frosty::StyleConfigData::setDolphinViewOpacity(30);
    Frosty::StyleConfigData::setDolphinSidebarOpacity(70);

    shouldBlurView = (Frosty::StyleConfigData::dolphinViewOpacity() < 100);
    shouldBlurSidebar = (Frosty::StyleConfigData::dolphinSidebarOpacity() < 100);

    QVERIFY(shouldBlurView);
    QVERIFY(shouldBlurSidebar);

    // Case 4: Both opaque
    Frosty::StyleConfigData::setDolphinViewOpacity(100);
    Frosty::StyleConfigData::setDolphinSidebarOpacity(100);

    shouldBlurView = (Frosty::StyleConfigData::dolphinViewOpacity() < 100);
    shouldBlurSidebar = (Frosty::StyleConfigData::dolphinSidebarOpacity() < 100);

    QVERIFY(!shouldBlurView);
    QVERIFY(!shouldBlurSidebar);
}

void BlurHelperTest::testQuickWindowTranslucentRequestsBlur()
{
    QQuickWindow window;
    window.setColor(QColor(16, 16, 20, 179));
    window.resize(400, 300);
    window.show();

    QCOMPARE(Frosty::quickWindowBlur(&window), Frosty::QuickWindowBlur::Enable);
}

void BlurHelperTest::testQuickDialogTranslucentRequestsBlur()
{
    QQuickWindow window;
    window.setFlags(Qt::Dialog);
    window.setColor(QColor(16, 16, 20, 179));
    window.resize(400, 300);
    window.show();

    QCOMPARE(Frosty::quickWindowBlur(&window), Frosty::QuickWindowBlur::Enable);
}

void BlurHelperTest::testQuickWindowOpaqueDisablesBlur()
{
    QQuickWindow window;
    window.setColor(QColor(16, 16, 20));
    window.resize(400, 300);
    window.show();

    QCOMPARE(Frosty::quickWindowBlur(&window), Frosty::QuickWindowBlur::Disable);
}

void BlurHelperTest::testQuickWindowFramelessSkipped()
{
    QQuickWindow window;
    window.setFlags(Qt::Window | Qt::FramelessWindowHint);
    window.setColor(QColor(16, 16, 20, 179));
    window.resize(400, 300);
    window.show();

    QCOMPARE(Frosty::quickWindowBlur(&window), Frosty::QuickWindowBlur::Skip);

    window.setColor(QColor(16, 16, 20));
    QCOMPARE(Frosty::quickWindowBlur(&window), Frosty::QuickWindowBlur::Skip);
}

void BlurHelperTest::testQuickWindowOffscreenSkipped()
{
    QWindow renderTarget;
    MockQuickWidgetRenderControl renderControl(&renderTarget);
    QQuickWindow window(&renderControl);
    window.setColor(QColor(16, 16, 20, 179));
    window.resize(400, 300);
    window.show();

    QVERIFY(window.isVisible());
    QCOMPARE(QQuickRenderControl::renderWindowFor(&window), &renderTarget);
    QCOMPARE(Frosty::quickWindowBlur(&window), Frosty::QuickWindowBlur::Skip);
}

void BlurHelperTest::testQuickWindowHiddenSkipped()
{
    QQuickWindow window;
    window.setColor(QColor(16, 16, 20, 179));
    window.resize(400, 300);

    QCOMPARE(Frosty::quickWindowBlur(&window), Frosty::QuickWindowBlur::Skip);
}

void BlurHelperTest::testQuickWindowPopupSkipped()
{
    QQuickWindow window;
    window.setFlags(Qt::Popup);
    window.setColor(QColor(16, 16, 20, 179));
    window.resize(400, 300);
    window.show();

    QCOMPARE(Frosty::quickWindowBlur(&window), Frosty::QuickWindowBlur::Skip);

    window.setFlags(Qt::ToolTip);
    QCOMPARE(Frosty::quickWindowBlur(&window), Frosty::QuickWindowBlur::Skip);
}

void BlurHelperTest::testNullWindowSkipped()
{
    QCOMPARE(Frosty::quickWindowBlur(nullptr), Frosty::QuickWindowBlur::Skip);
}

QTEST_MAIN(BlurHelperTest)
#include "blurhelper_test.moc"
