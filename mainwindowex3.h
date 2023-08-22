#ifndef MAINWINDOWEX3_H
#define MAINWINDOWEX3_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindowEx3; }
QT_END_NAMESPACE

class MainWindowEx3 : public QMainWindow
{
    Q_OBJECT

public:
    MainWindowEx3(QWidget *parent = nullptr);
    ~MainWindowEx3();

    void setGroupe1(const char* Text);
    void setGroupe2(const char* Text);
    void setGroupe3(const char* Text);
    void setResultat1(int nb);
    void setResultat2(int nb);
    void setResultat3(int nb);
    bool recherche1Selectionnee();
    bool recherche2Selectionnee();
    bool recherche3Selectionnee();
    const char* getGroupe1();
    const char* getGroupe2();
    const char* getGroupe3();

private slots:
    void on_pushButtonLancerRecherche_clicked();
    void on_pushButtonVider_clicked();
    void on_pushButtonQuitter_clicked();

private:
    Ui::MainWindowEx3 *ui;

    char groupe1[80];
    char groupe2[80];
    char groupe3[80];
};
#endif // MAINWINDOWEX3_H
