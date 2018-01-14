#include "customprint.h"
#include <QFileDialog>
#include <QPainter>
#include <QImage>
#include <QtPrintSupport/QPrinter>
#include <QtPrintSupport/QPrintDialog>
#include <QPdfWriter>
#include <QVariant>
#include <QDebug>

CustomPrint::CustomPrint(QObject *parent) : QObject(parent)
{

}

void CustomPrint::print(QVariant data)
{
    QString fileName = QFileDialog::getSaveFileName(0, tr("Save File"),
                                 "untitled.png",
                                 tr("Images (*.png *.xpm *.jpg)"));
    QImage img = qvariant_cast<QImage>(data);
    if(img.isNull())
    {
        qDebug() << "In valid image" << endl;
    }
    img.save(fileName);
    emit saveComplete();
}
