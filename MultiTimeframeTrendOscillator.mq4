//+------------------------------------------------------------------+
//|                              MultiTimeFrame Trend Oscillator.mq4 |
//|          Copyright, Seif Rached - https://github.com/seifrached/ |
//|                                   https://github.com/seifrached/ |
//+------------------------------------------------------------------+
#property copyright "Copyright, Seif Rached - https://github.com/seifrached/"
#property link      "https://github.com/seifrached/"
#property version   "1.00"
#property description "MultiTimeFrame Trend Oscillator"
#property strict
#property indicator_separate_window
#property indicator_buffers 20  // 5 timeframes x 4 trend conditions = 20 buffers
#property indicator_minimum 0
#property indicator_maximum 6


input int      FastEMA = 4;      // Fast EMA Period
input int      SlowEMA = 14;     // Slow EMA Period
input int      VerySlowEMA = 72; // Very Slow EMA Period
extern ENUM_MA_METHOD MAMethod = MODE_EMA; // Method
extern ENUM_APPLIED_PRICE AppliedPrice = PRICE_CLOSE; // Applied Price

// Input parameters
extern double Row_Height = 1.0;       // Height spacing between rows
extern int Bar_Length = 3;           // Length of horizontal bars
extern color UpTrendColor = clrTeal;          // Color for uptrend
extern color DownTrendColor = clrRed;      // Color for downtrend
extern color UpCorrectionColor = clrLightGreen;     // Color for correction in uptrend
extern color DownCorrectionColor = clrPink;   // Color for correction in downtrend

// Buffers for each timeframe and trend condition
// H4 buffers
double H4_UpBuffer[];
double H4_DownBuffer[];
double H4_UpCorrectionBuffer[];
double H4_DownCorrectionBuffer[];
// H1 buffers
double H1_UpBuffer[];
double H1_DownBuffer[];
double H1_UpCorrectionBuffer[];
double H1_DownCorrectionBuffer[];
// M30 buffers
double M30_UpBuffer[];
double M30_DownBuffer[];
double M30_UpCorrectionBuffer[];
double M30_DownCorrectionBuffer[];
// M15 buffers
double M15_UpBuffer[];
double M15_DownBuffer[];
double M15_UpCorrectionBuffer[];
double M15_DownCorrectionBuffer[];
// M5 buffers
double M5_UpBuffer[];
double M5_DownBuffer[];
double M5_UpCorrectionBuffer[];
double M5_DownCorrectionBuffer[];

// Timeframe positions (vertical offset)
double H4Position = 5.0;
double H1Position = 4.0;
double M30Position = 3.0;
double M15Position = 2.0;
double M5Position = 1.0;

// Define timeframes
int timeframes[5] = {PERIOD_H4, PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5};
string timeframeNames[5] = {"H4", "H1", "M30", "M15", "M5"};

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   // Set indicator buffers
   // H4 buffers
   SetIndexBuffer(0, H4_UpBuffer);
   SetIndexBuffer(1, H4_DownBuffer);
   SetIndexBuffer(2, H4_UpCorrectionBuffer);
   SetIndexBuffer(3, H4_DownCorrectionBuffer);
   // H1 buffers
   SetIndexBuffer(4, H1_UpBuffer);
   SetIndexBuffer(5, H1_DownBuffer);
   SetIndexBuffer(6, H1_UpCorrectionBuffer);
   SetIndexBuffer(7, H1_DownCorrectionBuffer);
   // M30 buffers
   SetIndexBuffer(8, M30_UpBuffer);
   SetIndexBuffer(9, M30_DownBuffer);
   SetIndexBuffer(10, M30_UpCorrectionBuffer);
   SetIndexBuffer(11, M30_DownCorrectionBuffer);
   // M15 buffers
   SetIndexBuffer(12, M15_UpBuffer);
   SetIndexBuffer(13, M15_DownBuffer);
   SetIndexBuffer(14, M15_UpCorrectionBuffer);
   SetIndexBuffer(15, M15_DownCorrectionBuffer);
   // M5 buffers
   SetIndexBuffer(16, M5_UpBuffer);
   SetIndexBuffer(17, M5_DownBuffer);
   SetIndexBuffer(18, M5_UpCorrectionBuffer);
   SetIndexBuffer(19, M5_DownCorrectionBuffer);
   
   // Set up drawing styles
   for(int i = 0; i < 20; i++)
   {
      SetIndexStyle(i, DRAW_HISTOGRAM);
      SetIndexLabel(i, "");
   }
   
   // Set colors for each buffer
   // H4 colors
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, UpTrendColor);
   SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, DownTrendColor);
   SetIndexStyle(2, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, UpCorrectionColor);
   SetIndexStyle(3, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, DownCorrectionColor);
   // H1 colors
   SetIndexStyle(4, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, UpTrendColor);
   SetIndexStyle(5, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, DownTrendColor);
   SetIndexStyle(6, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, UpCorrectionColor);
   SetIndexStyle(7, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, DownCorrectionColor);
   // M30 colors
   SetIndexStyle(8, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, UpTrendColor);
   SetIndexStyle(9, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, DownTrendColor);
   SetIndexStyle(10, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, UpCorrectionColor);
   SetIndexStyle(11, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, DownCorrectionColor);
   // M15 colors
   SetIndexStyle(12, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, UpTrendColor);
   SetIndexStyle(13, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, DownTrendColor);
   SetIndexStyle(14, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, UpCorrectionColor);
   SetIndexStyle(15, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, DownCorrectionColor);
   // M5 colors
   SetIndexStyle(16, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, UpTrendColor);
   SetIndexStyle(17, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, DownTrendColor);
   SetIndexStyle(18, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, UpCorrectionColor);
   SetIndexStyle(19, DRAW_HISTOGRAM, STYLE_SOLID, Bar_Length, DownCorrectionColor);
   

   for(int i = 1; i <= 5; i++)
   {
      SetLevelValue(i-1, i * Row_Height);
      SetLevelStyle(STYLE_DOT, 1, clrDimGray);
   }
   
   IndicatorShortName("Multi-Timeframe Trend Oscillator");
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   int start;
   if(prev_calculated == 0)
      start = 1; 
   else
      start = prev_calculated - 1;
      

   if(start == 1)
   {
      for(int i = 0; i < rates_total; i++)
      {
         // H4 buffers
         H4_UpBuffer[i] = EMPTY_VALUE;
         H4_DownBuffer[i] = EMPTY_VALUE;
         H4_UpCorrectionBuffer[i] = EMPTY_VALUE;
         H4_DownCorrectionBuffer[i] = EMPTY_VALUE;
         // H1 buffers
         H1_UpBuffer[i] = EMPTY_VALUE;
         H1_DownBuffer[i] = EMPTY_VALUE;
         H1_UpCorrectionBuffer[i] = EMPTY_VALUE;
         H1_DownCorrectionBuffer[i] = EMPTY_VALUE;
         // M30 buffers
         M30_UpBuffer[i] = EMPTY_VALUE;
         M30_DownBuffer[i] = EMPTY_VALUE;
         M30_UpCorrectionBuffer[i] = EMPTY_VALUE;
         M30_DownCorrectionBuffer[i] = EMPTY_VALUE;
         // M15 buffers
         M15_UpBuffer[i] = EMPTY_VALUE;
         M15_DownBuffer[i] = EMPTY_VALUE;
         M15_UpCorrectionBuffer[i] = EMPTY_VALUE;
         M15_DownCorrectionBuffer[i] = EMPTY_VALUE;
         // M5 buffers
         M5_UpBuffer[i] = EMPTY_VALUE;
         M5_DownBuffer[i] = EMPTY_VALUE;
         M5_UpCorrectionBuffer[i] = EMPTY_VALUE;
         M5_DownCorrectionBuffer[i] = EMPTY_VALUE;
      }
   }
   

   for(int i = start; i < rates_total; i++)
   {

      CalculateTimeframe(Symbol(), timeframes[0], time[i], i, H4Position);
      CalculateTimeframe(Symbol(), timeframes[1], time[i], i, H1Position);
      CalculateTimeframe(Symbol(), timeframes[2], time[i], i, M30Position);
      CalculateTimeframe(Symbol(), timeframes[3], time[i], i, M15Position);
      CalculateTimeframe(Symbol(), timeframes[4], time[i], i, M5Position);
   }
   

   DrawLabels();
   
   return(rates_total);
}

//+------------------------------------------------------------------+
//| Calculate trend for a specific timeframe and update buffers      |
//+------------------------------------------------------------------+
void CalculateTimeframe(string symbol, int timeframe, datetime bar_time, int index, double position)
{

   int shift = iBarShift(symbol, timeframe, bar_time, false);
   if(shift < 0) return; 
   

   double ema4 = iMA(symbol, timeframe, FastEMA, 0, MAMethod, AppliedPrice, shift);
   double ema14 = iMA(symbol, timeframe, SlowEMA, 0, MAMethod, AppliedPrice, shift);
   double ema72 = iMA(symbol, timeframe, VerySlowEMA, 0, MAMethod, AppliedPrice, shift);
   

   ResetBuffersForTimeframe(timeframe, index);

   if(timeframe == PERIOD_H4)
   {
      if((ema4 > ema14) && (ema14 > ema72))           
         H4_UpBuffer[index] = position;
      else if((ema4 < ema14) && (ema14 < ema72))       
         H4_DownBuffer[index] = position;
      else if((ema4 < ema14) && (ema14 > ema72))         
         H4_UpCorrectionBuffer[index] = position;
      else if((ema4 > ema14) && (ema14 < ema72))         
         H4_DownCorrectionBuffer[index] = position;
   }
   else if(timeframe == PERIOD_H1)
   {
      if((ema4 > ema14) && (ema14 > ema72))
         H1_UpBuffer[index] = position;
      else if((ema4 < ema14) && (ema14 < ema72))
         H1_DownBuffer[index] = position;
      else if((ema4 < ema14) && (ema14 > ema72))
         H1_UpCorrectionBuffer[index] = position;
      else if((ema4 > ema14) && (ema14 < ema72))
         H1_DownCorrectionBuffer[index] = position;
   }
   else if(timeframe == PERIOD_M30)
   {
      if((ema4 > ema14) && (ema14 > ema72))
         M30_UpBuffer[index] = position;
      else if((ema4 < ema14) && (ema14 < ema72))
         M30_DownBuffer[index] = position;
      else if((ema4 < ema14) && (ema14 > ema72))
         M30_UpCorrectionBuffer[index] = position;
      else if((ema4 > ema14) && (ema14 < ema72))
         M30_DownCorrectionBuffer[index] = position;
   }
   else if(timeframe == PERIOD_M15)
   {
      if((ema4 > ema14) && (ema14 > ema72))
         M15_UpBuffer[index] = position;
      else if((ema4 < ema14) && (ema14 < ema72))
         M15_DownBuffer[index] = position;
      else if((ema4 < ema14) && (ema14 > ema72))
         M15_UpCorrectionBuffer[index] = position;
      else if((ema4 > ema14) && (ema14 < ema72))
         M15_DownCorrectionBuffer[index] = position;
   }
   else if(timeframe == PERIOD_M5)
   {
      if((ema4 > ema14) && (ema14 > ema72))
         M5_UpBuffer[index] = position;
      else if((ema4 < ema14) && (ema14 < ema72))
         M5_DownBuffer[index] = position;
      else if((ema4 < ema14) && (ema14 > ema72))
         M5_UpCorrectionBuffer[index] = position;
      else if((ema4 > ema14) && (ema14 < ema72))
         M5_DownCorrectionBuffer[index] = position;
   }
}

//+------------------------------------------------------------------+
//| Reset buffers for specific timeframe at index                    |
//+------------------------------------------------------------------+
void ResetBuffersForTimeframe(int timeframe, int index)
{
   if(timeframe == PERIOD_H4)
   {
      H4_UpBuffer[index] = EMPTY_VALUE;
      H4_DownBuffer[index] = EMPTY_VALUE;
      H4_UpCorrectionBuffer[index] = EMPTY_VALUE;
      H4_DownCorrectionBuffer[index] = EMPTY_VALUE;
   }
   else if(timeframe == PERIOD_H1)
   {
      H1_UpBuffer[index] = EMPTY_VALUE;
      H1_DownBuffer[index] = EMPTY_VALUE;
      H1_UpCorrectionBuffer[index] = EMPTY_VALUE;
      H1_DownCorrectionBuffer[index] = EMPTY_VALUE;
   }
   else if(timeframe == PERIOD_M30)
   {
      M30_UpBuffer[index] = EMPTY_VALUE;
      M30_DownBuffer[index] = EMPTY_VALUE;
      M30_UpCorrectionBuffer[index] = EMPTY_VALUE;
      M30_DownCorrectionBuffer[index] = EMPTY_VALUE;
   }
   else if(timeframe == PERIOD_M15)
   {
      M15_UpBuffer[index] = EMPTY_VALUE;
      M15_DownBuffer[index] = EMPTY_VALUE;
      M15_UpCorrectionBuffer[index] = EMPTY_VALUE;
      M15_DownCorrectionBuffer[index] = EMPTY_VALUE;
   }
   else if(timeframe == PERIOD_M5)
   {
      M5_UpBuffer[index] = EMPTY_VALUE;
      M5_DownBuffer[index] = EMPTY_VALUE;
      M5_UpCorrectionBuffer[index] = EMPTY_VALUE;
      M5_DownCorrectionBuffer[index] = EMPTY_VALUE;
   }
}

//+------------------------------------------------------------------+
//| Draw trend status labels for each timeframe                      |
//+------------------------------------------------------------------+
void DrawLabels()
{
   string prefix = "MTFTrend_";

   for(int i = ObjectsTotal() - 1; i >= 0; i--)
   {
      string objName = ObjectName(i);
      if(StringSubstr(objName, 0, StringLen(prefix)) == prefix)
         ObjectDelete(objName);
   }
   

   int x_pos = 100;
   

   int window = WindowFind("Multi-Timeframe Trend Oscillator");
   if(window < 0) window = 1;
   
   int height = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, window);
   if(height == 0) height = 300; 
   
   CreateTimeframeLabel(prefix+"H4", "H4", x_pos, height / 7 * 2-20);
   CreateTimeframeLabel(prefix+"H1", "H1", x_pos, height / 7 * 3-15);
   CreateTimeframeLabel(prefix+"M30", "M30", x_pos, height / 7 * 4-10);
   CreateTimeframeLabel(prefix+"M15", "M15", x_pos, height / 7 * 5);
   CreateTimeframeLabel(prefix+"M5", "M5", x_pos, height / 7 * 6);
   CreateTrendLabel(prefix+"H4_status", GetTrendText(Symbol(), timeframes[0], 0), x_pos + 30, height / 7 * 2-20, GetTrendColor(Symbol(), timeframes[0], 0));
   CreateTrendLabel(prefix+"H1_status", GetTrendText(Symbol(), timeframes[1], 0), x_pos + 30, height / 7 * 3-15, GetTrendColor(Symbol(), timeframes[1], 0));
   CreateTrendLabel(prefix+"M30_status", GetTrendText(Symbol(), timeframes[2], 0), x_pos + 30, height / 7 * 4-10, GetTrendColor(Symbol(), timeframes[2], 0));
   CreateTrendLabel(prefix+"M15_status", GetTrendText(Symbol(), timeframes[3], 0), x_pos + 30, height / 7 * 5, GetTrendColor(Symbol(), timeframes[3], 0));
   CreateTrendLabel(prefix+"M5_status", GetTrendText(Symbol(), timeframes[4], 0), x_pos + 30, height / 7 * 6, GetTrendColor(Symbol(), timeframes[4], 0));
}

//+------------------------------------------------------------------+
//| Create a timeframe label                                         |
//+------------------------------------------------------------------+
void CreateTimeframeLabel(string name, string text, int x, int y)
{
   int window = WindowFind("Multi-Timeframe Trend Oscillator");
   if(window < 0) window = 1;
   
   if(ObjectFind(name) < 0)
      ObjectCreate(name, OBJ_LABEL, window, 0, 0);
      
   ObjectSet(name, OBJPROP_XDISTANCE, x-30);
   ObjectSet(name, OBJPROP_YDISTANCE, y);
   ObjectSet(name, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
   ObjectSetText(name, text, 9, "Arial Bold", clrBlack);
}

//+------------------------------------------------------------------+
//| Create a trend status label                                      |
//+------------------------------------------------------------------+
void CreateTrendLabel(string name, string text, int x, int y, color clr)
{
   int window = WindowFind("Multi-Timeframe Trend Oscillator");
   if(window < 0) window = 1;
   
   if(ObjectFind(name) < 0)
      ObjectCreate(name, OBJ_LABEL, window, 0, 0);
      
   ObjectSet(name, OBJPROP_XDISTANCE, x);
   ObjectSet(name, OBJPROP_YDISTANCE, y);
   ObjectSet(name, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
   ObjectSetText(name, text, 9, "Arial Bold", clr);
}

//+------------------------------------------------------------------+
//| Get trend text description                                        |
//+------------------------------------------------------------------+
string GetTrendText(string symbol, int timeframe, int shift)
{
   
   double ema4 = iMA(symbol, timeframe, FastEMA, 0, MAMethod, AppliedPrice, shift);
   double ema14 = iMA(symbol, timeframe, SlowEMA, 0, MAMethod, AppliedPrice, shift);
   double ema72 = iMA(symbol, timeframe, VerySlowEMA, 0, MAMethod, AppliedPrice, shift);
   
   if((ema4 > ema14) && (ema14 > ema72))
      return "UP";
   else if((ema4 < ema14) && (ema14 < ema72))
      return "DOWN";
   else if((ema4 < ema14) && (ema14 > ema72))
      return "UP (Correction)";
   else if((ema4 > ema14) && (ema14 < ema72))
      return "DOWN (Correction)";
   else
      return "NEUTRAL";
}

//+------------------------------------------------------------------+
//| Get trend color                                                  |
//+------------------------------------------------------------------+
color GetTrendColor(string symbol, int timeframe, int shift)
{
   
   double ema4 = iMA(symbol, timeframe, FastEMA, 0, MAMethod, AppliedPrice, shift);
   double ema14 = iMA(symbol, timeframe, SlowEMA, 0, MAMethod, AppliedPrice, shift);
   double ema72 = iMA(symbol, timeframe, VerySlowEMA, 0, MAMethod, AppliedPrice, shift);
   
   if((ema4 > ema14) && (ema14 > ema72))
      return UpTrendColor;
   else if((ema4 < ema14) && (ema14 < ema72))
      return DownTrendColor;
   else if((ema4 < ema14) && (ema14 > ema72))
      return UpCorrectionColor;
   else if((ema4 > ema14) && (ema14 < ema72))
      return DownCorrectionColor;
   else
      return clrGray;
}

