//+------------------------------------------------------------------+
//|                                                      CalcLib.mqh |
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

#include <CustomObjects.mqh>

class Logic{
private:

   string logic_name;   
   string label_name;
   string label_name2;
   string HighExHours[];
   string LowExHours[];   
   bool pre_alert;
   bool IsEntryEnable_WinRate;
   bool IsEntryEnable_Number;
   

   int fb;//FirstBuffer
   
   int bwin[24],blose[24],swin[24],slose[24];
   int sum_win,sum_lose;
   double winper;   
   int con_win;
   int h;//timehour
   int hist[10];//勝ち負け履歴　勝ち：１　負け：－１
   
   void WriteWinRate(string writen_label_name,int win,int lose){
      double calc_winper = 0;
      if(win+lose!=0)calc_winper = (double)win/(double)(win+lose)*100;
      ObjectSetString(NULL,writen_label_name,OBJPROP_TEXT,
                     StringFormat("%3.2f / %3d",calc_winper,win+lose));
      if(calc_winper>=exp_winper) ObjectSetInteger(NULL,writen_label_name,OBJPROP_COLOR,clrLemonChiffon);    // 色設定
      else ObjectSetInteger(NULL,writen_label_name,OBJPROP_COLOR,clrWhite);    
   }
   
   bool CheckHour(int shift,string &Hours[], bool UseJPYtime=false){
      int hour=0;
      if(UseJPYtime) hour = TimeHour(MT4toJPYtime(Time[shift])); 
      else hour = TimeHour(Time[shift]);
      
      for (int i=0; i < ArraySize(Hours); i++) {
         if (hour == (int)StringToInteger(Hours[i])) return false;
      }
      return true;
   }
   
   void AddHistory(int value){
      for(int hist_number=ArraySize(hist)-1;hist_number>=0;hist_number--){
         if(hist_number == 0)hist[hist_number]=value;
         else hist[hist_number] = hist[hist_number-1];
      }
   }
   
      
public:
   //外部使用あり
   double sell[], buy[], sell_win[], sell_lose[], buy_win[], buy_lose[];
   string button_name;
   //ユーザー指定--------
   color up_color;   
   color down_color;
   color judge_color;
   color button_color;
   color click_button_color;
   int inp_timeout;//タイムアウト
   double arrow_dis;//矢印位置
   double non_judge;//抑止本数
   int jt;//判定本数
   int sp;//スプレッド
   double exp_winper;//期待する勝率
   int amp;//購入金額
   bool detail_winrate;//詳細勝率
   int display_state;//0 HighLow 4なし
   
     
   //コンストラクタ
   Logic(){
      ArrayInitialize(bwin,0);
      ArrayInitialize(blose,0);
      ArrayInitialize(swin,0);
      ArrayInitialize(slose,0);
      
      ArrayInitialize(hist,0);
      
      pre_alert = false;
      IsEntryEnable_WinRate = false; 
      IsEntryEnable_Number = false;
      display_state = 0;
      //ユーザー指定--------
      up_color = clrRed;   
      down_color = clrBlue;
      judge_color = clrWhite;
      button_color = clrDarkOrange;
      click_button_color = clrNavy;
      inp_timeout = 6;//タイムアウト
      arrow_dis = 5;//矢印位置
      non_judge = 0;//抑止本数
      jt = 1;//判定本数
      sp = 0;//スプレッド
      exp_winper = 0;//期待する勝率
      amp = 1;//購入金額   
      detail_winrate = false;//詳細勝率 
      
      sum_win=0;
      sum_lose=0;
      con_win = 0;//連勝 

   }
   
   //initialize   
   void LogicInit(string LogicName, string high_exhours, string low_exhours){
      //ロジック名
      logic_name = LogicName;
      //除外時間の挿入
      StringSplit(high_exhours, StringGetCharacter(",", 0), HighExHours);
      StringSplit(low_exhours, StringGetCharacter(",", 0), LowExHours);
   }
   void SetBuffer(int FirstBuffer){
      fb = FirstBuffer;
      SetIndexBuffer(fb, sell);
      SetIndexEmptyValue(fb, EMPTY_VALUE);
   	SetIndexDrawBegin(fb, 0);
   	SetIndexArrow(fb, 234);
   	SetIndexStyle(fb, DRAW_ARROW ,0, 2 , down_color);
   	
   	SetIndexBuffer(fb+1, buy);
   	SetIndexEmptyValue(fb+1, EMPTY_VALUE);
   	SetIndexDrawBegin(fb+1, 0);
   	SetIndexArrow(fb+1, 233);
   	SetIndexStyle(fb+1, DRAW_ARROW ,0, 2, up_color);
   
   	SetIndexBuffer(fb+2, sell_win);
   	SetIndexEmptyValue(fb+2, EMPTY_VALUE);
   	SetIndexDrawBegin(fb+2, 0);
   	SetIndexArrow(fb+2, 161);
   	SetIndexStyle(fb+2, DRAW_ARROW ,0, 2 , judge_color);
   	
   	SetIndexBuffer(fb+3, buy_win);
   	SetIndexEmptyValue(fb+3, EMPTY_VALUE);
   	SetIndexDrawBegin(fb+3, 0);
   	SetIndexArrow(fb+3, 161);
   	SetIndexStyle(fb+3, DRAW_ARROW ,0, 2 , judge_color);
   	
   	SetIndexBuffer(fb+4, sell_lose);
   	SetIndexEmptyValue(fb+4, EMPTY_VALUE);
   	SetIndexDrawBegin(fb+4, 0);
   	SetIndexArrow(fb+4, 251);
   	SetIndexStyle(fb+4, DRAW_ARROW ,0, 2 , judge_color);
   
   	SetIndexBuffer(fb+5, buy_lose);
   	SetIndexEmptyValue(fb+5, EMPTY_VALUE);
   	SetIndexDrawBegin(fb+5, 0);
   	SetIndexArrow(fb+5, 251);
   	SetIndexStyle(fb+5, DRAW_ARROW ,0, 2 , judge_color);
   }
   //ロジックの名前の表示(勝率とは別)
   void LogicLabel_Name(string title,int LabelX,int LabelY){
      label_name = logic_name+"label";
      label(label_name,title,LabelX,LabelY,clrWhite,CORNER_LEFT_UPPER,10);
   }
   //ロジックの勝率表示
   void LogicLabel_WinRate(int LabelX,int LabelY,int corner = CORNER_RIGHT_UPPER){
      if(detail_winrate){
         label(logic_name+"DetailLabelH","High",LabelX+100,5,clrWhite, corner);
         label(logic_name+"DetailLabelL","Low",LabelX,5,clrWhite, corner);
         for(int hour=0;hour<24;hour++){
            label(logic_name+"DetailHour"+IntegerToString(hour),IntegerToString(hour)+"時",LabelX+150,20+15*hour,clrWhite, corner);
            label(logic_name+"DetailHigh"+IntegerToString(hour),"計算中",LabelX+100,20+15*hour,clrWhite, corner);
            label(logic_name+"DetailLow"+IntegerToString(hour),"計算中",LabelX,20+15*hour,clrWhite, corner);
         }
         label(logic_name+"DetailHour24","合計",LabelX+150,25+15*24,clrMagenta, corner);
         label(logic_name+"DetailHigh24","計算中",LabelX+100,25+15*24,clrWhite, corner);
         label(logic_name+"DetailLow24","計算中",LabelX,25+15*24,clrWhite, corner);       
      }
      else {
         label_name2 = logic_name+"label2";
         label(label_name2,"計算中",LabelX,LabelY,clrWhite, corner,10);      
      }
   }
   void LogicButton(int ButtonX,int ButtonY,int SizeX,int SizeY){
      button_name = logic_name+"button";
      button(button_name,"ON",ButtonX,ButtonY,SizeX,SizeY,button_color,CORNER_LEFT_UPPER,6);
   }
   //リセット
   void Reset(){
      ArrayInitialize(bwin,0);
      ArrayInitialize(blose,0);
      ArrayInitialize(swin,0);
      ArrayInitialize(slose,0);
      ArrayInitialize(sell,EMPTY_VALUE);
      ArrayInitialize(buy,EMPTY_VALUE);
      ArrayInitialize(sell_win,EMPTY_VALUE);
      ArrayInitialize(buy_win,EMPTY_VALUE);
      ArrayInitialize(sell_lose,EMPTY_VALUE);
      ArrayInitialize(buy_lose,EMPTY_VALUE);  
      ArrayInitialize(hist,0);
   }

   //勝率書き込み
   void WriteLabel(){
      if(detail_winrate){
         for(int hour=0;hour<25;hour++){
            string label_nameH = logic_name+"DetailHigh"+IntegerToString(hour);
            string label_nameL = logic_name+"DetailLow"+IntegerToString(hour);
            
            if(hour==24){
               int sum_bwin=0,sum_blose=0,sum_swin=0,sum_slose=0;
               for(int _hour = 0;_hour<24;_hour++){
                  sum_bwin += bwin[_hour]; 
                  sum_blose += blose[_hour]; 
                  sum_swin += swin[_hour]; 
                  sum_slose += slose[_hour];
               }    
               sum_win = sum_bwin + sum_swin;
               sum_lose = sum_blose + sum_slose;
               WriteWinRate(label_nameH,sum_bwin,sum_blose);
               WriteWinRate(label_nameL,sum_swin,sum_slose);                       
            }
            else{
               ObjectSetInteger(NULL,logic_name+"DetailHour"+IntegerToString(hour),OBJPROP_COLOR,clrWhite);
               WriteWinRate(label_nameH,bwin[hour],blose[hour]);
               WriteWinRate(label_nameL,swin[hour],slose[hour]);            
            }     
            if(TimeHour(TimeLocal())==hour)ObjectSetInteger(NULL,logic_name+"DetailHour"+IntegerToString(hour),OBJPROP_COLOR,clrCyan);
         }
      }
      else {
         int sum_bwin=0,sum_blose=0,sum_swin=0,sum_slose=0;
         for(int hour = 0;hour<24;hour++){
            sum_bwin += bwin[hour]; 
            sum_blose += blose[hour]; 
            sum_swin += swin[hour]; 
            sum_slose += slose[hour];
         }
         sum_win = sum_bwin + sum_swin;
         sum_lose = sum_blose + sum_slose;
         if(sum_swin+sum_bwin+sum_slose+sum_blose==0)winper=0;
         else winper = (double)(sum_swin+sum_bwin)/(double)(sum_swin+sum_bwin+sum_slose+sum_blose)*100;
         if(label_name!=""){
            string text=StringFormat("勝率　%3.2f％  勝ち%4d　負け%4d",winper,sum_swin+sum_bwin,sum_slose+sum_blose);
            ObjectSetString(NULL,label_name2,OBJPROP_TEXT,text);    
         }
         if(winper>=exp_winper){
            if(label_name!="")ObjectSetInteger(NULL,label_name2,OBJPROP_COLOR,clrLemonChiffon);    // 色設定
            IsEntryEnable_WinRate =true;
         }
         else {
            if(label_name!="")ObjectSetInteger(NULL,label_name2,OBJPROP_COLOR,clrWhite);
            IsEntryEnable_WinRate = false;
         }
      }
   }
   //矢印セット
   void SetArrow( int shift,int ram,int rom){
      int flag=0;   
      if(non_judge>0){
         for(int j=1;j<non_judge+1;j++){
            if(buy[shift+j]!=EMPTY_VALUE || sell[shift+j]!=EMPTY_VALUE )flag++; 
         }         
      }
      //休止期間でないとき
      if(flag==0){
         if(ram==rom){
            if(CheckHour(shift,LowExHours,true)){
               sell[shift]=High[shift]+arrow_dis*Point();
               buy[shift]=EMPTY_VALUE;            
            }
            else{
               sell[shift]=EMPTY_VALUE;
               buy[shift]=EMPTY_VALUE;               
            }
         }
         else if(ram==-rom){
            if(CheckHour(shift,HighExHours,true)){
               buy[shift]=Low[shift]-arrow_dis*Point();
               sell[shift]=EMPTY_VALUE;            
            }
            else {
               sell[shift]=EMPTY_VALUE;
               buy[shift]=EMPTY_VALUE;
            }
         }
         else {
            sell[shift]=EMPTY_VALUE;
            buy[shift]=EMPTY_VALUE;
         }         
      }
      else {
         sell[shift]=EMPTY_VALUE;
         buy[shift]=EMPTY_VALUE;
      } 

      
      if(shift>0){
         if(sell[shift+jt]!=EMPTY_VALUE){
            h = TimeHour(MT4toJPYtime(Time[shift+jt]));
            if(Open[shift+jt-1]-Close[shift]>Point()*sp){//Lowエントリー
               sell_win[shift]=Low[shift]-arrow_dis*Point();
               swin[h]++;
               con_win++;
               AddHistory(1);
            }
            else {
               sell_lose[shift]=Low[shift]-arrow_dis*Point();     
               slose[h]++;
               con_win = 0;
               AddHistory(-1);
            }
         }
         else if(buy[shift+jt]!=EMPTY_VALUE){//Highエントリー
            h = TimeHour(MT4toJPYtime(Time[shift+jt]));
            if(Close[shift]-Open[shift+jt-1]>Point()*sp){
               buy_win[shift]=High[shift]+arrow_dis*Point();
               bwin[h]++;
               con_win++;
               AddHistory(1);
            }
            else {
               buy_lose[shift]=High[shift]+arrow_dis*Point();
               blose[h]++;
               con_win = 0;
               AddHistory(-1);
            }
         }       
      } 
   }
   
   void DelArrow(int shift){
      if(sell_win[shift]!=EMPTY_VALUE){
         h = TimeHour(MT4toJPYtime(Time[shift+jt]));
         swin[h]--;
         sell_win[shift]=EMPTY_VALUE;
         sell[shift+jt]=EMPTY_VALUE;
      }   
      else if(sell_lose[shift]!=EMPTY_VALUE){
         h = TimeHour(MT4toJPYtime(Time[shift+jt]));
         slose[h]--;
         sell_lose[shift]=EMPTY_VALUE;
         sell[shift+jt]=EMPTY_VALUE;
      } 
      else if(buy_win[shift]!=EMPTY_VALUE){
         h = TimeHour(MT4toJPYtime(Time[shift+jt]));
         bwin[h]--;
         buy_win[shift]=EMPTY_VALUE;
         buy[shift+jt]=EMPTY_VALUE;
      }  
      else if(buy_lose[shift]!=EMPTY_VALUE){
         h = TimeHour(MT4toJPYtime(Time[shift+jt]));
         blose[h]--;
         buy_lose[shift]=EMPTY_VALUE;
         buy[shift+jt]=EMPTY_VALUE;
      } 
   }
   
   void AlertArrowCurBar(){
      if(sell[0]!=EMPTY_VALUE){
         if(!pre_alert && (display_state==0 || display_state==2))Alert(Symbol()+" "+logic_name+" :Low");
         pre_alert=true;
      }
      else if(buy[0]!=EMPTY_VALUE){
         if(!pre_alert && (display_state==0 || display_state==1))Alert(Symbol()+" "+logic_name+" :High");
         pre_alert=true;
      }   
      else {
         pre_alert=false;
      }      
   }
   
   void AlertArrowPreBar(){
      if(sell[1]!=EMPTY_VALUE){
         if(display_state==0 || display_state==2)Alert(Symbol()+" "+logic_name+" :Low");
      }
      else if(buy[1]!=EMPTY_VALUE){
         if(display_state==0 || display_state==1)Alert(Symbol()+" "+logic_name+" :High");
      }        
   }
   
   void AutoModeOFF(){
         display_state=4;
         ObjectSetString(NULL,button_name,OBJPROP_TEXT,"OFF");
         ObjectSetInteger(NULL,button_name,OBJPROP_BGCOLOR,click_button_color);
         if(label_name!="")ObjectSetInteger(NULL,label_name2,OBJPROP_COLOR,clrLemonChiffon);
         SetIndexStyle(fb, DRAW_NONE);
      	SetIndexStyle(fb+1, DRAW_NONE);
      	SetIndexStyle(fb+2, DRAW_NONE);
      	SetIndexStyle(fb+3, DRAW_NONE);
      	SetIndexStyle(fb+4, DRAW_NONE);
      	SetIndexStyle(fb+5, DRAW_NONE);    
   }
   void AutoModeON(){
         display_state=0;
         ObjectSetString(NULL,button_name,OBJPROP_TEXT,"ON"); 
         ObjectSetInteger(NULL,button_name,OBJPROP_BGCOLOR,button_color);
         if(label_name!="")ObjectSetInteger(NULL,label_name2,OBJPROP_COLOR,clrYellow);
         SetIndexStyle(fb, DRAW_ARROW ,0, 2 , down_color);
      	SetIndexStyle(fb+1, DRAW_ARROW ,0, 2, up_color);
      	SetIndexStyle(fb+2, DRAW_ARROW ,0, 2 , judge_color);
      	SetIndexStyle(fb+3, DRAW_ARROW ,0, 2 , judge_color);
      	SetIndexStyle(fb+4, DRAW_ARROW ,0, 2 , judge_color);
      	SetIndexStyle(fb+5, DRAW_ARROW ,0, 2 , judge_color);       
   }
   
   void EntryModeButtonClick(){
      if(display_state==0){
         display_state=1;
         ObjectSetString(NULL,button_name,OBJPROP_TEXT,"High");
      	SetIndexStyle(fb, DRAW_NONE);
      	SetIndexStyle(fb+2, DRAW_NONE);
      	SetIndexStyle(fb+4, DRAW_NONE);     
      }
      else if(display_state==1){
         display_state=2;
         ObjectSetString(NULL,button_name,OBJPROP_TEXT,"Low");
         SetIndexStyle(fb, DRAW_ARROW ,0, 2 , down_color);
      	SetIndexStyle(fb+2, DRAW_ARROW ,0, 2 , judge_color);
      	SetIndexStyle(fb+4, DRAW_ARROW ,0, 2 , judge_color);
      	SetIndexStyle(fb+1, DRAW_NONE);
      	SetIndexStyle(fb+3, DRAW_NONE);
      	SetIndexStyle(fb+5, DRAW_NONE); 
      }
      else if(display_state==2){
         display_state=3;
         ObjectSetString(NULL,button_name,OBJPROP_TEXT,"OFF");
         ObjectSetInteger(NULL,button_name,OBJPROP_BGCOLOR,click_button_color);
         SetIndexStyle(fb, DRAW_NONE);
      	SetIndexStyle(fb+1, DRAW_NONE);
      	SetIndexStyle(fb+2, DRAW_NONE);
      	SetIndexStyle(fb+3, DRAW_NONE);
      	SetIndexStyle(fb+4, DRAW_NONE);
      	SetIndexStyle(fb+5, DRAW_NONE);   
      }
      else {
         display_state=0;
         ObjectSetString(NULL,button_name,OBJPROP_TEXT,"High Low"); 
         ObjectSetInteger(NULL,button_name,OBJPROP_BGCOLOR,button_color);
         SetIndexStyle(fb, DRAW_ARROW ,0, 2 , down_color);
      	SetIndexStyle(fb+1, DRAW_ARROW ,0, 2, up_color);
      	SetIndexStyle(fb+2, DRAW_ARROW ,0, 2 , judge_color);
      	SetIndexStyle(fb+3, DRAW_ARROW ,0, 2 , judge_color);
      	SetIndexStyle(fb+4, DRAW_ARROW ,0, 2 , judge_color);
      	SetIndexStyle(fb+5, DRAW_ARROW ,0, 2 , judge_color);   
      }
   }
   
   void EarlyEntryReset(){
      IsEntryEnable_Number = true;
   }
   
   double GetWinper(){
      if(detail_winrate){
         return -1;
      }
      else return winper;
   }
   
   int GetSumWin(){
      return sum_win;
   }
   
   int GetSumLose(){
      return sum_lose;
   }
   
   void GetHistory(int &data[10]){
      for(int num=0;num<ArraySize(data);num++){
         data[num]=hist[num];
      }
   }
   //deinitialize    
   void LogicDeinit(){
      ObjectsDeleteAll(NULL,logic_name);
   }
};




datetime MT4toJPYtime(datetime time){
   //3月第2日曜日午前2時〜11月第1日曜日午前2時　夏時間
   
   int month = TimeMonth(time);
   if(month<3 || 11< month ){
      //冬時間
      return time+D'1970.01.01 7:00:00';
      
   }
   else if(month ==3){
      int day = TimeDay(time);
      int week = TimeDayOfWeek(time);
      if((day-week-1)/7>=1){
         //夏時間
         return time+D'1970.01.01 6:00:00';
      }
      else {
         //冬時間
         return time+D'1970.01.01 7:00:00';
      }
   }
   else if(month ==11){
      int day = TimeDay(time);
      int week = TimeDayOfWeek(time);
      if(1>day-week){
         //夏時間
         return time+D'1970.01.01 6:00:00';
      }
      else {
         //冬時間
         return time+D'1970.01.01 7:00:00';
      }
   }
   else {
      //夏時間
      return time+D'1970.01.01 6:00:00';
   }
}

string symbol_edit(string symbol){
   if(StringFind(Symbol(),"XAU")>-1 || StringFind(Symbol(),"GOLD")>-1){
      return "GOLD";
   }
   else{
      return StringSubstr(symbol,0,3)+"/"+StringSubstr(symbol,3,3);
   }
}