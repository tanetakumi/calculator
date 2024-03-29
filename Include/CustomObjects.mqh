//+------------------------------------------------------------------+
//|                                                CustomObjects.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
void button(string name,string text, int x ,int y,int x_size,int y_size ,color c=clrDarkBlue,int corner=CORNER_LEFT_UPPER,int font_size=8){
   ObjectCreate(NULL,name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(NULL,name,OBJPROP_COLOR,clrWhite);    // text色設定
   //ObjectSetInteger(NULL,name,OBJPROP_BACK,true);            // オブジェクトの背景表示設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTABLE,false);     // オブジェクトの選択可否設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTED,false);      // オブジェクトの選択状態
   //ObjectSetInteger(NULL,name,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
   ObjectSetInteger(NULL,name,OBJPROP_ZORDER,0);            // オブジェクトのチャートクリックイベント優先順位
   ObjectSetString(NULL,name,OBJPROP_TEXT,text);            // 表示するテキスト
   ObjectSetString(NULL,name,OBJPROP_FONT,"ＭＳ　ゴシック");          // フォント
   ObjectSetInteger(NULL,name,OBJPROP_FONTSIZE,font_size);                   // フォントサイズ
   ObjectSetInteger(NULL,name,OBJPROP_CORNER,corner);  // コーナーアンカー設定
   ObjectSetInteger(NULL,name,OBJPROP_XDISTANCE,x);                // X座標
   ObjectSetInteger(NULL,name,OBJPROP_YDISTANCE,y);                 // Y座標
   ObjectSetInteger(NULL,name,OBJPROP_XSIZE,x_size);                    // ボタンサイズ幅
   ObjectSetInteger(NULL,name,OBJPROP_YSIZE,y_size);                     // ボタンサイズ高さ
   ObjectSetInteger(NULL,name,OBJPROP_BGCOLOR,c);              // ボタン色
   ObjectSetInteger(NULL,name,OBJPROP_BORDER_COLOR,clrWhite);       // ボタン枠色
   ObjectSetInteger(NULL,name,OBJPROP_STATE,false);                  // ボタン押下状態
}

void label(string name,string text, int x, int y,color c=clrWhite,int corner=CORNER_RIGHT_UPPER,int font_size=8){
   ObjectCreate(NULL,name,OBJ_LABEL,0,0,0); 
   ObjectSetInteger(NULL,name,OBJPROP_COLOR,c);    // 色設定
   ObjectSetInteger(NULL,name,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTABLE,false);     // オブジェクトの選択可否設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTED,false);      // オブジェクトの選択状態
   ObjectSetInteger(NULL,name,OBJPROP_HIDDEN,false);         // オブジェクトリスト表示設定
   ObjectSetInteger(NULL,name,OBJPROP_ZORDER,0);            // オブジェクトのチャートクリックイベント優先順位
   ObjectSetString(NULL,name,OBJPROP_TEXT,text);    // 表示するテキスト
   ObjectSetString(NULL,name,OBJPROP_FONT,"ＭＳ　ゴシック");  // フォント
   ObjectSetInteger(NULL,name,OBJPROP_FONTSIZE,font_size);                   // フォントサイズ
   ObjectSetInteger(NULL,name,OBJPROP_CORNER,corner);  // コーナーアンカー設定
   ObjectSetInteger(NULL,name,OBJPROP_XDISTANCE,x);                // X座標
   ObjectSetInteger(NULL,name,OBJPROP_YDISTANCE,y);                 // Y座標
}

void arrow(string name,int arrow_code, datetime time, double price,color c=clrWhite){
   ObjectCreate(NULL,name,OBJ_ARROW_DOWN,0,time,price);
   ObjectSetInteger(NULL,name,OBJPROP_COLOR,c);    // 色設定
   ObjectSetInteger(NULL,name,OBJPROP_WIDTH,1);             // 幅設定
   ObjectSetInteger(NULL,name,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTED,false);      // オブジェクトの選択状態
   ObjectSetInteger(NULL,name,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
   ObjectSetInteger(NULL,name,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
   ObjectSetInteger(NULL,name,OBJPROP_ANCHOR,ANCHOR_BOTTOM);   // アンカータイプ
   ObjectSetInteger(NULL,name,OBJPROP_ARROWCODE,arrow_code);      // アローコード
}

void hline(string name,double value,color c){
    ObjectCreate(NULL,name,OBJ_HLINE,0,0,value);
    ObjectSetInteger(NULL,name,OBJPROP_COLOR,c);    // ラインの色設定
    ObjectSetInteger(NULL,name,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
    ObjectSetInteger(NULL,name,OBJPROP_WIDTH,1);              // ラインの幅設定
    ObjectSetInteger(NULL,name,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
    ObjectSetInteger(NULL,name,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
    ObjectSetInteger(NULL,name,OBJPROP_SELECTED,false);      // オブジェクトの選択状態
    ObjectSetInteger(NULL,name,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
    ObjectSetInteger(NULL,name,OBJPROP_ZORDER,0);      // オブジェクトのチャートクリックイベント優先順位
}

void image(string name,int x ,int y,string path,int corner=CORNER_RIGHT_UPPER){
   ObjectCreate(NULL,name,OBJ_BITMAP_LABEL,0,0,0);           // OBJ_BITMAP_LABELオブジェクト作成
   ObjectSetInteger(NULL,name,OBJPROP_CORNER,corner); // アンカー設定：チャート右上
   ObjectSetInteger(NULL,name,OBJPROP_XDISTANCE,x);              // アンカーからのX軸距離：100pixel
   ObjectSetInteger(NULL,name,OBJPROP_YDISTANCE,y);  
   ObjectSetInteger(NULL,name,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTABLE,false);     // オブジェクトの選択可否設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTED,false);      // オブジェクトの選択状態
   ObjectSetInteger(NULL,name,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
   bool res = ObjectSetString(NULL,name,OBJPROP_BMPFILE,0,path); 
   if( res == false ) {                                                 // 画像ファイル設定失敗
      PrintFormat("%s の画像ファイルを設定出来ませんでした。 エラーコード： %d",path ,GetLastError());
   }
}

//まだ作りかけ
void trend(string name, datetime time1, double price1, datetime time2, double price2, color c=clrWhite){
   ObjectCreate(NULL,name,OBJ_TREND,0,time1,price1,time2,price2);
   ObjectSetInteger(NULL,name,OBJPROP_COLOR,c);    // ラインの色設定
   ObjectSetInteger(NULL,name,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
   ObjectSetInteger(NULL,name,OBJPROP_WIDTH,1);              // ラインの幅設定
   ObjectSetInteger(NULL,name,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTED,true);       // オブジェクトの選択状態
   ObjectSetInteger(NULL,name,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
   ObjectSetInteger(NULL,name,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
   ObjectSetInteger(NULL,name,OBJPROP_RAY_RIGHT,true);      // ラインの延長線(右)
}

void Button(const long              chart_ID=0,               // chart's ID
            const string            name="Button",            // button name
            const int               sub_window=0,             // subwindow index
            const int               x=0,                      // X coordinate
            const int               y=0,                      // Y coordinate
            const int               width=50,                 // button width
            const int               height=18,                // button height
            const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
            const string            text="Button",            // text
            const string            font="Arial",             // font
            const int               font_size=10,             // font size
            const color             clr=clrBlack,             // text color
            const color             back_clr=C'236,233,216',  // background color
            const color             border_clr=clrNONE,       // border color
            const bool              state=false,              // pressed/released
            const bool              back=false,               // in the background
            const bool              selection=false,          // highlight to move
            const bool              hidden=true,              // hidden in the object list
            const long              z_order=0                // priority for mouse click
            ){
//--- set button coordinates
   ObjectSetInteger(NULL,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(NULL,name,OBJPROP_YDISTANCE,y);
//--- set button size
   ObjectSetInteger(NULL,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(NULL,name,OBJPROP_YSIZE,height);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(NULL,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(NULL,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(NULL,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(NULL,name,OBJPROP_FONTSIZE,font_size);
//--- set text color
   ObjectSetInteger(NULL,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(NULL,name,OBJPROP_BGCOLOR,back_clr);
//--- set border color
   ObjectSetInteger(NULL,name,OBJPROP_BORDER_COLOR,border_clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(NULL,name,OBJPROP_BACK,back);
//--- set button state
   ObjectSetInteger(NULL,name,OBJPROP_STATE,state);
//--- enable (true) or disable (false) the mode of moving the button by mouse
   ObjectSetInteger(NULL,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(NULL,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(NULL,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(NULL,name,OBJPROP_ZORDER,z_order);
//--- successful execution
}