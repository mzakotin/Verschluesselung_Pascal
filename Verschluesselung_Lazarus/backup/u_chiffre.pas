unit U_Chiffre;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Math;

type

  { Tfm_Chiffre }

  Tfm_Chiffre = class(TForm)
    bt_beenden: TButton;
    bt_einlesen: TButton;
    bt_speichern: TButton;
    bt_caesar: TButton;
    CB_Caesar: TComboBox;
    Memo_Gedicht: TMemo;
    Memo_Caesar: TMemo;
    OD_Chiffre: TOpenDialog;
    procedure bt_beendenClick(Sender: TObject);
    procedure bt_caesarClick(Sender: TObject);
    procedure bt_einlesenClick(Sender: TObject);
    procedure bt_speichernClick(Sender: TObject);
    procedure CB_CaesarKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  fm_Chiffre: Tfm_Chiffre;

implementation

{$R *.lfm}

{ Tfm_Chiffre }

procedure Tfm_Chiffre.bt_einlesenClick(Sender: TObject);
var Datei: Textfile;
    Zeile: string;
begin
 if not(OD_Chiffre.Execute=true) then showMessage('Ladefehler!')
 else
   begin
     assignfile(Datei,OD_Chiffre.FileName);
     reset(Datei);
     readln(Datei,Zeile);//Leere Zeile am Anfang weglassen
     repeat
       Memo_Gedicht.Lines.Add(Zeile);
       readln(Datei,Zeile);
     until EOF(Datei);
     Memo_Gedicht.Lines.Add(#13);//#13 = Zeilenumbruch (ASCII-Symbol)
     closefile(Datei);
     Memo_Caesar.Clear;
   end;
end;

procedure Tfm_Chiffre.bt_speichernClick(Sender: TObject);
var Datei:Textfile;
    Zeile:string;
begin
 if (Memo_Caesar.Lines.Text='') then showMessage('Keine Daten verfügbar!')
 else
   begin
     assignfile(Datei,'Gedicht_Caesar.txt');
     rewrite(Datei);
     Zeile:=Memo_Caesar.Lines.Text;
     writeln(Datei,Zeile);
     closefile(Datei);
   end;
end;

procedure Tfm_Chiffre.CB_CaesarKeyPress(Sender: TObject; var Key: char);
begin
  if not(key in[#8,'0'..'9']) or  //#8 = Lösch-/Rücktaste (ASCII-Symbol)
  ((length(CB_Caesar.Text)>1) and not(key in[#8])) or //max. 2 Stellen
  ((CB_Caesar.Text='0') and not(key in[#8])) or
  ((CB_Caesar.Text='2') and not(key in[#8,'0'..'5'])) or //20-25
  ((CB_Caesar.Text>'2') and not(key in[#8])) //erste Stelle > 2
  then key:=#0;
end;

procedure Tfm_Chiffre.FormCreate(Sender: TObject);
begin
  CB_Caesar.Text:='0';
  Memo_Gedicht.ReadOnly:=true;
  Memo_Caesar.ReadOnly:=true;
end;

procedure Tfm_Chiffre.bt_caesarClick(Sender: TObject);
var c, caesar: char;
    zwischen: integer;
begin
 if (Memo_Gedicht.Lines.Text='') then showMessage('Bitte Datei einlesen!')
 else
  begin
   for c in Memo_Gedicht.Lines.Text do
    begin
     if (CB_Caesar.Text<>'') then
      begin
       zwischen:=integer(c)+CB_Caesar.ItemIndex;

       if ((c >= 'A') and (c <= 'Z')) then
        begin
         if (char(zwischen)>'Z') then caesar:=char(zwischen-26)
         else caesar:=char(zwischen);
        end
        else
         begin
          if (char(zwischen)>'z') then caesar:=char(zwischen-26)
          else caesar:=char(zwischen);
         end;
         if (c=' ') or (c='.') then
         begin
          zwischen:=integer(c);
          caesar:=c;
         end
         else if (c=#13) then
          begin
           zwischen:=0;
           caesar:=char(0);
          end;
         Memo_Caesar.Lines.Text:=Memo_Caesar.Lines.Text+caesar;
      end;
    end;//for c
  end; //else
end;

procedure Tfm_Chiffre.bt_beendenClick(Sender: TObject);
begin
 fm_Chiffre.Close;
end;

end.

