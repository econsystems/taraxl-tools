#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QIcon>

#include "imageprovider.h"
#include "camera.h"

int main(int argc, char *argv[]) {

    QGuiApplication app(argc, argv);

    qmlRegisterType<camera>("cam", 1, 0, "Camera");

    QQmlApplicationEngine engine;
    ImageProvider *img = ImageProvider::getInstance();

    engine.addImageProvider(QLatin1String("imageprovider"), img);

    QIcon icon(":/images/taraXLStudio.ico");
    app.setWindowIcon(icon);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
