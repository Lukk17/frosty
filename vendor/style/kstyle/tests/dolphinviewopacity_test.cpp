/*
 * Unit tests for DolphinViewOpacity configuration
 *
 * Tests the new DolphinViewOpacity setting that controls
 * transparency of Dolphin's main file view area.
 */

#include <QTest>
#include <QTemporaryDir>
#include <QStandardPaths>

#include "frostystyleconfigdata.h"

class DolphinViewOpacityTest : public QObject
{
    Q_OBJECT

private:
    QTemporaryDir m_tempDir;

private Q_SLOTS:
    void initTestCase();
    void cleanupTestCase();
    void init();
    void cleanup();

    // Configuration tests
    void testDefaultValue();
    void testSetAndGetValue();
    void testBoundaryValues();
    void testPersistence();
    void testIndependentFromSidebarOpacity();
};

void DolphinViewOpacityTest::initTestCase()
{
    // Use temporary directory for config files
    QVERIFY(m_tempDir.isValid());
    QStandardPaths::setTestModeEnabled(true);
}

void DolphinViewOpacityTest::cleanupTestCase()
{
    QStandardPaths::setTestModeEnabled(false);
}

void DolphinViewOpacityTest::init()
{
    // Reset to defaults before each test
    Frosty::StyleConfigData::self()->setDefaults();
}

void DolphinViewOpacityTest::cleanup()
{
    // Nothing to clean up
}

void DolphinViewOpacityTest::testDefaultValue()
{
    // The default value should be 100 (fully opaque)
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 80);
}

void DolphinViewOpacityTest::testSetAndGetValue()
{
    // Test setting various valid values
    Frosty::StyleConfigData::setDolphinViewOpacity(50);
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 50);

    Frosty::StyleConfigData::setDolphinViewOpacity(0);
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 0);

    Frosty::StyleConfigData::setDolphinViewOpacity(75);
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 75);

    Frosty::StyleConfigData::setDolphinViewOpacity(100);
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 100);
}

void DolphinViewOpacityTest::testBoundaryValues()
{
    // Test minimum value (0 = fully transparent)
    Frosty::StyleConfigData::setDolphinViewOpacity(0);
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 0);

    // Test maximum value (100 = fully opaque)
    Frosty::StyleConfigData::setDolphinViewOpacity(100);
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 100);

    // Test value at 1 (near minimum)
    Frosty::StyleConfigData::setDolphinViewOpacity(1);
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 1);

    // Test value at 99 (near maximum)
    Frosty::StyleConfigData::setDolphinViewOpacity(99);
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 99);
}

void DolphinViewOpacityTest::testPersistence()
{
    // Set a non-default value
    Frosty::StyleConfigData::setDolphinViewOpacity(42);
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 42);

    // Save configuration
    Frosty::StyleConfigData::self()->save();

    // Reset to defaults
    Frosty::StyleConfigData::self()->setDefaults();
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 80);

    // Reload configuration
    Frosty::StyleConfigData::self()->load();
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 42);
}

void DolphinViewOpacityTest::testIndependentFromSidebarOpacity()
{
    // Set different values for view and sidebar opacity
    Frosty::StyleConfigData::setDolphinViewOpacity(30);
    Frosty::StyleConfigData::setDolphinSidebarOpacity(70);

    // Verify they are independent
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 30);
    QCOMPARE(Frosty::StyleConfigData::dolphinSidebarOpacity(), 70);

    // Change one, verify the other is unaffected
    Frosty::StyleConfigData::setDolphinViewOpacity(50);
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 50);
    QCOMPARE(Frosty::StyleConfigData::dolphinSidebarOpacity(), 70);

    Frosty::StyleConfigData::setDolphinSidebarOpacity(25);
    QCOMPARE(Frosty::StyleConfigData::dolphinViewOpacity(), 50);
    QCOMPARE(Frosty::StyleConfigData::dolphinSidebarOpacity(), 25);
}

QTEST_MAIN(DolphinViewOpacityTest)
#include "dolphinviewopacity_test.moc"
