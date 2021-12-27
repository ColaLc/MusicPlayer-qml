#ifndef MEDIAPLAYER_H
#define MEDIAPLAYER_H

#include <QObject>
#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <QDateTime>
#include <QImage>
#include <QQuickImageProvider>


//************ColorImageProvider传输image from c++ to qml************
class ColorImageProvider : public QQuickImageProvider
{
public:
    ColorImageProvider();
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize) override;
    QImage img;
};


class MediaPlayer : public QObject
{
    Q_OBJECT
public:
    explicit MediaPlayer(QObject *parent = nullptr);

    Q_INVOKABLE void setVolum(int value);
    Q_INVOKABLE void startPlay();
    Q_INVOKABLE void stopPlay();
    Q_INVOKABLE void setCurrentDuration(qreal value);  //设置歌曲进度
    Q_INVOKABLE void setMusicList( QList<QUrl> list);  //设置歌曲列表信息
    Q_INVOKABLE void setCurrentMusicIndex(int index);  //设置index为当前播放
    Q_INVOKABLE void setNextMusic();                   //下一曲
    Q_INVOKABLE void setPreviousMusic();               //上一曲
    Q_INVOKABLE QImage getImage();                     //get歌曲image
    Q_INVOKABLE void setImage();                       //设置歌曲image
    Q_INVOKABLE void setPlayMode(int value);                    //设置播放模式

    Q_PROPERTY(QString currPostion READ getCurrPostion NOTIFY currPostionChanged);                 //歌曲进度位置
    Q_PROPERTY(QString currMusicToalTime READ getCurrMusicToalTime NOTIFY currMusicToalTimeChanged); //歌曲总时间
    Q_PROPERTY(QString currMusicTitle READ getCurrMusicTitle NOTIFY currMusicTitleChanged);          //歌曲标题
    Q_PROPERTY(QString currMusicAuthor READ getCurrMusicAuthor NOTIFY currMusicAuthorChanged);       //歌曲作者

    QMediaPlayer *player;
    QMediaPlaylist *playList;

    //**********静态变量 在main函数可以采用注册类   普通变量在main函数只能设置上下文
    static ColorImageProvider *m_pImgProvider;

    QString m_currPostion="00:00";
    QString m_currMusicToalTime="00:00";
    QString m_currMusicTitle;
    QString m_currMusicAuthor;

    QString getCurrPostion();
    QString getCurrMusicTitle();
    QString getCurrMusicAuthor();
    QString getCurrMusicToalTime();
    void getMusicInfo(QUrl url);
    void initPlayer();

    void setPImgProvider(ColorImageProvider *newPImgProvider);

private:
    //QString m_text="00:11";

signals:
    void musicDurationChanged(double value);
    void addMusicInfo(QString title,QString author,QString totalTime);
    void currentListIndex_Signal(int index);
    void currPostionChanged(QString v);
    void currMusicToalTimeChanged(QString v);
    void currMusicTitleChanged(QString v);
    void currMusicAuthorChanged(QString v);
    void callQmlRefeshImg();

};


#endif // MEDIAPLAYER_H
