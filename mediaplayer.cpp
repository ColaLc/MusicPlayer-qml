#include "mediaplayer.h"
#include <QMediaMetaData>
#include <QDebug>
#include <QThread>

MediaPlayer::MediaPlayer(QObject *parent)
    : QObject{parent}
{

    player = new QMediaPlayer;
    playList=new QMediaPlaylist;
    player->setPlaylist(playList);
    initPlayer();

    connect(player, &QMediaPlayer::positionChanged, [=](int value){
        double temp=QString::number((value*100.0/player->duration()),'f',2).toDouble();
        emit musicDurationChanged(temp);
        m_currPostion= QDateTime::fromMSecsSinceEpoch(value).toString("mm:ss");
        emit currPostionChanged(m_currPostion);

    });
    connect(player,&QMediaPlayer::durationChanged,this,[=](){

        if(player->mediaStatus()==QMediaPlayer::BufferedMedia)
        {
            QString title;
            title=player->metaData(QMediaMetaData::Title).toString();
            int value=player->metaData(QMediaMetaData::Duration ).toInt();
            m_currMusicToalTime=QDateTime::fromMSecsSinceEpoch(value).toString("mm:ss");
            emit currMusicToalTimeChanged(m_currMusicToalTime);
            //qDebug()<<"title11:"<<title<<m_currMusicToalTime;

        }
    });
    connect(playList,&QMediaPlaylist::currentIndexChanged,[=](int index){
        //qDebug()<<"currentindex:"<<index;
        emit currentListIndex_Signal(index);
    }
    );

    connect(player, &QMediaPlayer::mediaStatusChanged ,[=]()mutable{
        if(player->mediaStatus()==QMediaPlayer::BufferedMedia )
        {

            m_currMusicTitle=player->metaData(QMediaMetaData::Title ).toString();
            m_currMusicAuthor=player->metaData(QMediaMetaData::Author ).toString();
            setImage();
        }
    });

}

ColorImageProvider *MediaPlayer::m_pImgProvider=new ColorImageProvider;

ColorImageProvider::ColorImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Pixmap)
{

}

/******************************************************
 *@name: requestPixmap
 *@function: 重载requestPixmap函数
 *@parameter: //
 *@return: QPixmap
*********************************************************/
QPixmap ColorImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    int width = 100;
    int height = 50;

    if (size)
        *size = QSize(width, height);
    QPixmap pixmap(requestedSize.width() > 0 ? requestedSize.width() : width,
                   requestedSize.height() > 0 ? requestedSize.height() : height);
    //pixmap.fill(QColor(id).rgba());

    if(this->img.isNull() )
        this->img=QImage(":/pic/music.png");

    return QPixmap::fromImage(this->img);
}


void MediaPlayer::initPlayer()
{
    player->setVolume(50);
}

void MediaPlayer::setVolum(int value)
{
    player->setVolume(value);
}

void MediaPlayer::startPlay()
{
    player->play();
}

void MediaPlayer::stopPlay()
{
    player->pause();
}

void MediaPlayer::setCurrentDuration(qreal value)
{

    double temp=(double)value/100;
    qint64 pos=temp*player->duration();
    player->setPosition(pos);
}

void MediaPlayer::setMusicList(QList<QUrl> list)
{
    for (int i = 0; i < list.size(); ++i)
    {
        getMusicInfo(list.at(i));
    }

}

void MediaPlayer::setCurrentMusicIndex(int index)
{
    playList->setCurrentIndex(index);
}

void MediaPlayer::setNextMusic()
{
    if(playList->currentIndex()==playList->mediaCount()-1)
        playList->setCurrentIndex(0);
    else
        playList->next();
}

void MediaPlayer::setPreviousMusic()
{
    if(playList->currentIndex()==0)
        playList->setCurrentIndex(playList->mediaCount()-1);
    else
        playList->previous();
}

QImage MediaPlayer::getImage()
{
    QImage image=player->metaData(QMediaMetaData::ThumbnailImage).value<QImage>() ;
    return  image;
}


/******************************************************
 *@name: getMusicInfo
 *@function: 解析歌曲信息
 *@parameter: Qurl
 *@return: null
*********************************************************/
void MediaPlayer::getMusicInfo(QUrl url)
{
    QMediaPlayer  *play=new QMediaPlayer;
    play->setMedia(QUrl(url));
    connect(play, QOverload<>::of(&QMediaObject::metaDataChanged),
            [=]()mutable{
        //qDebug()<<play->metaData(QMediaMetaData::Title )<<play->metaData(QMediaMetaData::Author );
        playList->addMedia(url);
        int time=play->metaData(QMediaMetaData::Duration).toInt();
        QString toaltime= QDateTime::fromMSecsSinceEpoch(time).toString("mm:ss");
        emit addMusicInfo(play->metaData(QMediaMetaData::Title ).toString(),play->metaData(QMediaMetaData::Author).toString(),toaltime);

        play->deleteLater();
        play=NULL;
    });

}


QString MediaPlayer::getCurrPostion()
{
    return m_currPostion;
}

QString MediaPlayer::getCurrMusicTitle()
{
    return m_currMusicTitle;
}

QString MediaPlayer::getCurrMusicAuthor()
{
    return m_currMusicAuthor;
}

QString MediaPlayer::getCurrMusicToalTime(){
    return m_currMusicToalTime;
}

void MediaPlayer::setImage()
{
    QImage img2(player->metaData(QMediaMetaData::ThumbnailImage).value<QImage>());
    m_pImgProvider->img = img2;
    emit callQmlRefeshImg();
}

void MediaPlayer::setPlayMode(int value)
{
    playList->setPlaybackMode(QMediaPlaylist::PlaybackMode(value));
}

void MediaPlayer::setPImgProvider(ColorImageProvider *newPImgProvider)
{
    m_pImgProvider = newPImgProvider;
}


