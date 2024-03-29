//+------------------------------------------------------------------+
//|                                               TimeLimitation.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
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


class TimeRestriction{

private:
   string Hours[];
   
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
   
public:
   //コンストラクタ
   TimeRestriction(){}
   //コンストラクタ
   TimeRestriction(string inp_hours){
      StringSplit(inp_hours, StringGetCharacter(",", 0), Hours);
   }
 
   bool CheckHour(datetime time, bool UseJPYtime=false){
      int hour=0;
      
      if(UseJPYtime){
         hour = TimeHour(MT4toJPYtime(time)); 
      } else {
         hour = TimeHour(time);
      }
      for (int i=0; i < ArraySize(Hours); i++) {
         if (hour == (int)StringToInteger(Hours[i])) return false;
      }
      return true;
   }
};

