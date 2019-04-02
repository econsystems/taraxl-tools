#include "imageprovider.h"

ImageProvider* ImageProvider::instance = NULL;

ImageProvider::ImageProvider()
: QQuickImageProvider(QQuickImageProvider::Image) {

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

QImage ImageProvider::requestImage(const QString& id, QSize* size, const QSize& requestedSize) {


  QImage qimg;

  if (id.toStdString() == "left") {
    qimg = img_left;
  }
  else if (id.toStdString() == "right") {
    qimg = img_right;
  }
  else if (id.toStdString() == "disp0") {
    qimg = img_disp0;
  }
  else if (id.toStdString() == "disp1") {
    qimg = img_disp1;
  }


  return qimg;

}
