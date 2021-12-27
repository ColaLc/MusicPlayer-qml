#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "mediaplayer.h"
#include <QQmlContext>
#include <QQuickView>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

//    //注册c++
    qmlRegisterType<MediaPlayer>("MyMusicPlayClass",1,0,"MyMusicPlayObj");
    engine.addImageProvider("myImage", MediaPlayer::m_pImgProvider);

//    //对象设置上下文
//     MediaPlayer musicPlayer;
//     engine.rootContext()->setContextProperty("musicPlayer",&musicPlayer);
//     engine.addImageProvider("myImage",musicPlayer.m_pImgProvider);


    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
