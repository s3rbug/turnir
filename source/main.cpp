#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include "field.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setOrganizationName("Любомльська гімназія");
    app.setOrganizationDomain("http://gymnasia-luboml.ucoz.ua/");
    app.setApplicationName("Control Panel");
    app.setWindowIcon(QIcon("qrc:/img/image/icon2.ico"));

    qmlRegisterType<Field>("field", 1, 0, "Field");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
