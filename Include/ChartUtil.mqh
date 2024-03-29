//+------------------------------------------------------------------+
//|                                                    ChartUtil.mqh |
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

int ChartsTotal(){
   int  counter = 1;  // チャートの数
   long nextChart = ChartNext(ChartFirst());
   while(nextChart != -1){
     counter++;
     nextChart = ChartNext(nextChart);
   }
   return counter;
}

int ChartNumber(){
   int num =0;
   long chartId = ChartFirst();
   while(chartId != -1){
      if(chartId==ChartID()){
         return num;
      } 
      num++;
      chartId = ChartNext(chartId);
   }
   return num;
}