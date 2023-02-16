//+------------------------------------------------------------------+
//|                                                      Include.mqh |
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

class Scheduler{
private:
   datetime arr[][2];
   string comment[];
   
public:
   Scheduler(void){};
   ~Scheduler(void){};
   
   void Add(datetime time_start, datetime time_stop, string text){
      ArrayResize(arr, ArrayRange(arr,0)+1);
      ArrayResize(comment, ArraySize(comment)+1);
      arr[ArrayRange(arr,0)-1][0] = time_start;
      arr[ArrayRange(arr,0)-1][1] = time_stop;
      comment[ArraySize(comment)-1] = text;
   }
   
   string ToString(){
      string builder = "";
      for(int i=0;i<ArraySize(comment);i++){
         builder = builder + TimeToStr(arr[i][0]) + " - " + TimeToStr(arr[i][1]);
         builder = builder + "   " + comment[i] + "\n";
      }
      return builder;
   }
   
   bool Check(datetime dt){
      for(int i=0;i<ArrayRange(arr,0);i++){
         if(arr[i][0] <= dt && dt <= arr[i][1]){
            return true;
         }  
      }
      return false;
   }
};
