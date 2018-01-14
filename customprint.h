#ifndef CUSTOMPRINT_H
#define CUSTOMPRINT_H

#include <QObject>
#include <QVariant>

class CustomPrint : public QObject
{
    Q_OBJECT
public:
    explicit CustomPrint(QObject *parent = nullptr);

    Q_INVOKABLE void print(QVariant data);

signals:
    void saveComplete();

public slots:
};

#endif // CUSTOMPRINT_H
