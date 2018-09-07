#include "imageprovider.h"

ImageProvider* ImageProvider::instance = NULL;

ImageProvider::ImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Pixmap) {

}

ImageProvider::ImageProvider(ImageType type)
    : QQuickImageProvider(type) {

}

ImageProvider::~ImageProvider() {

}

ImageProvider* ImageProvider::getInstance() {

    if (instance == NULL) {

        instance = new ImageProvider();
    }
    return instance;
}

QPixmap ImageProvider::requestPixmap(const QString& id,
                                     QSize* size,
                                     const QSize& requestedSize) {

    QImage qimg;

    if (id.toStdString() == "left") {

        qimg = QImage(m_left.data, m_left.cols, m_left.rows, QImage::Format_Indexed8);
    }
    else if (id.toStdString() == "right") {

        qimg = QImage(m_right.data, m_right.cols, m_right.rows, QImage::Format_Indexed8);
    }
    else if (id.toStdString() == "disp0") {

        qimg = QImage(m_disp0.data, m_disp0.cols, m_disp0.rows, QImage::Format_Indexed8);
    }
    else if (id.toStdString() == "disp1") {

        qimg = QImage(m_disp1.data, m_disp1.cols, m_disp1.rows, QImage::Format_RGB888);
        qimg = qimg.rgbSwapped();
    }
    return QPixmap::fromImage(qimg);
}
