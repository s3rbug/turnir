#ifndef FIELD_H
#define FIELD_H

#include <QObject>
#include <deque>
#include <queue>

class Field : public QObject
{
    Q_OBJECT
public:
    explicit Field(QObject *parent = nullptr);
    explicit Field(Field*);
    int a[100][100];
    int h, n, countReachable;
    int si, sj, ti, tj;
    int maxSpeed, maxHeight, focusLength, batteryCharge, chargePerPhoto, chargePerMinute, countPhotoes;
    const int INF = 1000000000;
    std::deque<std::pair<int, int>> path;
    bool reachable;
    bool photoAll;
    Q_INVOKABLE void set(int, int, int);
    Q_INVOKABLE int get(int, int);
    Q_INVOKABLE void clr();
    Q_INVOKABLE void setField(Field*);
    Q_INVOKABLE void print();
    Q_INVOKABLE void changeHeight(int);
    Q_INVOKABLE void calculate();
    Q_INVOKABLE void setCoord(int, int, int, int, int, int);
    Q_INVOKABLE int getSize();
    Q_INVOKABLE int getPath(int, bool);
    Q_INVOKABLE void clearPath();
    Q_INVOKABLE bool isReachable();
    Q_INVOKABLE void setInfo(int, int, int, int, int, int, int);
    Q_INVOKABLE void log(QString);
    Q_INVOKABLE void setPhotoAll(bool);
    void operate(std::queue<std::pair<int, int>>&, int, int);

signals:

public slots:
};

#endif // FIELD_H
