/*
 * Unit tests for the window background
 *
 * Tests that the Frosty style paints the background of a translucent
 * window and the paint of a filtered widget once, so a plain window
 * area has the alpha of the Window colour.
 */

#include <QApplication>
#include <QDialogButtonBox>
#include <QPainter>
#include <QPluginLoader>
#include <QStandardPaths>
#include <QStylePlugin>
#include <QTest>

#include "frostypropertynames.h"
#include "frostystyleconfigdata.h"

namespace
{
const QColor windowColor(16, 16, 20, 166);
const QColor separatorColor(255, 255, 255, 16);
}

class WindowBackgroundTest : public QObject
{
    Q_OBJECT

private Q_SLOTS:
    void initTestCase();
    void cleanupTestCase();
    void init();

    void testPlainWindowAreaHasWindowAlpha();
    void testWidgetEventFilterPaintsOnce();
};

void WindowBackgroundTest::initTestCase()
{
    QStandardPaths::setTestModeEnabled(true);
    QCoreApplication::setApplicationName(QStringLiteral("windowbackground_test"));

    QPluginLoader loader(QStringLiteral(FROSTY_STYLE_PLUGIN));
    auto *plugin = qobject_cast<QStylePlugin *>(loader.instance());
    QVERIFY2(plugin, qPrintable(loader.errorString()));

    QStyle *style = plugin->create(QStringLiteral("frosty"));
    QVERIFY(style);
    QApplication::setStyle(style);

    QPalette palette = QApplication::palette();
    palette.setColor(QPalette::Window, windowColor);
    QApplication::setPalette(palette);
}

void WindowBackgroundTest::cleanupTestCase()
{
    QStandardPaths::setTestModeEnabled(false);
}

void WindowBackgroundTest::init()
{
    Frosty::StyleConfigData::self()->load();
}

void WindowBackgroundTest::testPlainWindowAreaHasWindowAlpha()
{
    QWidget window;
    window.resize(400, 300);
    window.show();
    QVERIFY(QTest::qWaitForWindowExposed(&window));
    QVERIFY(window.testAttribute(Qt::WA_TranslucentBackground));

    const QImage image = window.grab().toImage();
    QCOMPARE(qAlpha(image.pixel(window.width() / 2, window.height() / 2)), windowColor.alpha());
}

void WindowBackgroundTest::testWidgetEventFilterPaintsOnce()
{
    QWidget container;
    auto *buttonBox = new QDialogButtonBox(&container);
    buttonBox->setProperty(Frosty::PropertyNames::forceFrame, true);
    buttonBox->setGeometry(0, 0, 200, 40);

    const QImage image = buttonBox->grab().toImage();

    QImage expected(image.size(), image.format());
    expected.fill(Qt::transparent);
    QPainter painter(&expected);
    painter.setCompositionMode(QPainter::CompositionMode_Source);
    painter.fillRect(expected.rect(), windowColor);
    painter.setCompositionMode(QPainter::CompositionMode_SourceOver);
    painter.setPen(separatorColor);
    painter.drawLine(0, 0, expected.width() - 1, 0);
    painter.end();

    const QPoint separatorPoint(buttonBox->width() / 2, 0);
    QCOMPARE(QColor::fromRgba(image.pixel(separatorPoint)), QColor::fromRgba(expected.pixel(separatorPoint)));
}

QTEST_MAIN(WindowBackgroundTest)
#include "windowbackground_test.moc"
