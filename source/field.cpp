#include "field.h"
#include <QDebug>
#include <fstream>
#include <deque>
#include <queue>
#include <QFile>
#include <QTextStream>
#include <QDateTime>
#include <cmath>
#include <QString>

Field::Field(QObject *parent) : QObject(parent)
{
    for(int i = 0; i < 100; ++i){
        for(int j = 0; j < 100; ++j){
            a[i][j] = 0;
        }
    }
    reachable = false;
}

Field::Field(Field* f){
    for(int i = 0; i < 100; ++i){
        for(int j = 0; j < 100; ++j){
            a[i][j] = f->a[i][j];
        }
    }
}

int Field::get(int i, int j){
    return a[i][j];
}

void Field::set(int i, int j, int val){
    a[i][j] = val;
    //qDebug() << "a[" << i << "][" << j << "] = " << val;
}

void Field::clr(){
    for(int i = 0; i < 100; ++i){
        for(int j = 0; j < 100; ++j){
            a[i][j] = 0;
        }
    }
}

void Field::setField(Field *f){
    for(int i = 0; i < 100; ++i){
        for(int j = 0; j < 100; ++j){
            a[i][j] = f->a[i][j];
        }
    }
}

void Field::print(){
    std::ofstream out("output.txt");
    for(int i = 0; i < 30; ++i){
        for(int j = 0; j < 30; ++j){
            out << a[i][j];
        }
        out << std::endl;
    }
}

void Field::changeHeight(int a){
    h = a;
}

void Field::setCoord(int fi, int fj, int ui, int uj, int height, int n1){
    si = fi;
    sj = fj;
    ti = ui;
    tj = uj;
    h = height;
    n = n1;
    calculate();
}
void Field::operate(std::queue<std::pair<int, int>>& q, int i, int j){
    q.push({i, j});
}
void Field::calculate(){
    std::queue<std::pair<int, int>> q;
    int s[100][100];
    for(int i = 0; i < 100; ++i){
        for(int j = 0; j < 100; ++j){
            s[i][j] = INF;
        }
    }
    if(a[si][sj] > h){
        reachable = false;
        return;
    }
    s[si][sj] = 0;
    q.push({si, sj});
    while(!q.empty()){
        int i = q.front().first, j = q.front().second;
        q.pop();
        //out << i << ' ' << j << ": " << s[i + 1][j] << ' ' << s[j][i] + 1 << std::endl;
        if(i + 1 < n && s[i + 1][j] > s[i][j] + 1
                && a[i + 1][j] <= h){
            q.push({i + 1, j});
            s[i + 1][j] = s[i][j] + 1;
        }
        if(j + 1 < n && s[i][j + 1] > s[i][j] + 1
                && a[i][j + 1] <= h){
            q.push({i, j + 1});
            s[i][j + 1] = s[i][j] + 1;
        }
        if(i >= 1 && s[i - 1][j] > s[i][j] + 1
                && a[i - 1][j] <= h){
            q.push({i - 1, j});
            s[i - 1][j] = s[i][j] + 1;
        }
        if(j >= 1 && s[i][j - 1] > s[i][j] + 1
                && a[i][j - 1] <= h){
            q.push({i, j - 1});
            s[i][j - 1] = s[i][j] + 1;
        }
    }
    int val = s[ti][tj];
    if(val == INF){
        reachable = false;
        return;
    }
    reachable = true;
    int i = ti, j = tj;
    while(val != 0){
        if(i + 1 < n && s[i + 1][j] == val - 1){
            path.push_front({i + 1, j});
            --val;
            ++i;
            continue;
        }
        if(j + 1 < n && s[i][j + 1] == val - 1){
            path.push_front({i, j + 1});
            --val;
            ++j;
            continue;
        }
        if(i > 0 && s[i - 1][j] == val - 1){
            path.push_front({i - 1, j});
            --val;
            --i;
            continue;
        }
        if(j > 0 && s[i][j - 1] == val - 1){
            path.push_front({i, j - 1});
            --val;
            --j;
            continue;
        }
    }
    path.push_back({ti, tj});
    /*for(int t = 0; t < (int)path.size(); ++t){
        out << path[t].first << ' ' << path[t].second << std::endl;
    }
    for(int j = 0; j < n; ++j){
        for(int i = 0; i < n; ++i){
            out << s[i][j] << ' ';
        }
        out << std::endl;
    }*/
    countReachable = 0;
    for(int j = 0; j < n; ++j)
        for(int i = 0; i < n; ++i)
            if(s[i][j] != INF)
                ++countReachable;
    qDebug() << countReachable;

}

void Field::clearPath(){
    path.clear();
}

bool Field::isReachable(){
    return reachable;
}

int Field::getSize(){
    return path.size();
}

void Field::setInfo(int mxs, int mxh, int focus, int bat, int ph, int hr, int cn){
    maxSpeed = mxs;
    maxHeight = mxh;
    focusLength = focus;
    batteryCharge = bat;
    chargePerPhoto = ph;
    chargePerMinute = hr;
    countPhotoes = cn;
}

void Field::setPhotoAll(bool b){
    photoAll = b;
}

/*
    maxSpeed = mxs;
    maxHeight = mxh;
    focusLength = focus;
    batteryCharge = bat;
    chargePerPhoto = ph;
    chargePerMinute = hr;
    countPhotoes
    n
*/
void Field::log(QString s){
    s.replace("file:///", "");
    QString outputDir = s;
    QString time = QTime::currentTime().toString("hh.mm.ss");
    qDebug() << time;
        QString fileName = QString( "%1%2" ).arg("log" + time).arg( ".txt" );
        QString fileOut = outputDir + "/" + fileName;
        QFile file(fileOut);

             if (!file.open((QFile::Append | QFile::Text))) {
                 qDebug() << "Could not create Project File";
             }
             else{
                 QTextStream stream(&file);
                 //stream.setCodec("Windows-1258");
                 int time = 0, cnt, l = path.size() - 1;
                 bool bad = false;
                 double dTime = (double)l / maxSpeed;
                 if(photoAll){
                     cnt = (l + 1) * countPhotoes;
                 }
                 else{
                     cnt = countPhotoes;
                 }
                 if(maxSpeed != 0)
                     time = std::round((double)l / maxSpeed);
                 int charge = cnt * chargePerPhoto + 2 * time * chargePerMinute;
                 //qDebug() << batteryCharge << charge << endl;
                 if(batteryCharge < charge || batteryCharge == 0){
                     stream << "***Not enough charge***" << endl;
                     bad = true;
                 }
                 else{
                     stream << "Drone has enough charge" << endl;
                 }
                 if(reachable){
                     stream << "Terrain is suitable for this drone" << endl;
                 }
                 else{
                     stream << "***Terrain is too high***" << endl;
                     bad = true;
                 }
                 stream << endl;
                 if(bad){
                     stream << "------------------------------------" << endl << "Drone will not be able to reach desination point";
                 }
                 else{
                     stream << fixed << "Max speed: " + QString::number(maxSpeed) + "m/s" << endl
                                     << "Max height: " + QString::number(maxHeight) + "m" << endl
                                     << "Focus length: " + QString::number(focusLength) + "m" << endl
                                     << "Battery charge: " + QString::number(batteryCharge) + "mA/h" << endl
                                     << "Charge per photo: " + QString::number(chargePerPhoto) + "mA/h" << endl
                                     << "Charge per minute: " + QString::number(chargePerMinute) + "mA/h" << endl << endl;
                     double t = a[ti][tj];
                     double qual = t / focusLength;
                     //qDebug() << qual << a[ti][tj] << focusLength << endl;
                     if(qual > 1){
                         qual = 1 / qual;
                     }
                     qual *= 100;
                     stream << fixed << "Minimal time of flight: " + QString::number(dTime) + "min" << endl
                                     << "Battery charge needed: " + QString::number(charge) + "mA/h" << endl
                                     << "Battery charge left: " + QString::number(batteryCharge - charge) + "mA/h" << endl
                                     << "Photoes taken: " + QString::number(cnt) << endl
                                     << "Photoes quality: " + QString::number(qual) + "%" << endl
                                     << "Places visited: " + QString::number(l + 1) << endl
                                     << "Reachable points: " + QString::number(countReachable) << endl;

                 }
             }
             file.close();
}


int Field::getPath(int i, bool fir){
    return fir ? path[i].first : path[i].second;
}
