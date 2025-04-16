Multi-Timeframe Trend Oscillator
Multi-Timeframe Trend Oscillator is an MQL4 custom indicator developed by Seif Rached. Designed for MetaTrader 4, this indicator provides a comprehensive view of market trend conditions by analyzing and comparing trends across five different timeframes: H4, H1, M30, M15, and M5. It does so by calculating and comparing three EMAs (Fast EMA, Slow EMA, and Very Slow EMA) and then classifying the trend conditions into four distinct states for each timeframe.

Key Features
Multi-Timeframe Analysis:
Evaluates market trends across five key timeframes (H4, H1, M30, M15, and M5) for an at-a-glance understanding of both the broader market context and short-term conditions.

Triple EMA Calculation:
Uses three exponential moving averages with customizable periods (default Fast = 4, Slow = 14, and Very Slow = 72) to derive trend signals.

Trend Classification:
Determines and displays four trend conditions based on EMA relationships:

Uptrend: Fast EMA > Slow EMA > Very Slow EMA

Downtrend: Fast EMA < Slow EMA < Very Slow EMA

Up Correction (Pullback): Fast EMA < Slow EMA but Slow EMA > Very Slow EMA

Down Correction (Pullback): Fast EMA > Slow EMA but Slow EMA < Very Slow EMA

Histogram Visualization:
Displays trend conditions using separate histogram buffers. The indicator creates a grid-like structure where each timeframe is allocated a row defined by a customizable row height and bar length.

Real-Time Trend Labels:
Dynamically draws labels on the chart indicating the timeframe (e.g., H4, H1, etc.) along with the corresponding trend status (e.g., "UP", "DOWN", "UP (Correction)", "DOWN (Correction)", "NEUTRAL"). Colors for trend states are fully customizable.

How It Works
Indicator Initialization (OnInit)
Buffer Setup:
Allocates 20 indicator buffers (4 per timeframe) to store data for the different trend conditions.

Index Style and Labeling:
Configures the drawing style (histogram) for each buffer and sets up fixed levels for visual separation (using row height).

Level Settings:
Configures dotted levels across the separate indicator window to delineate each timeframe visually.

Short Name:
Sets the indicator's short name as "Multi-Timeframe Trend Oscillator".

Main Calculation (OnCalculate)
Initialization Reset:
On the first run (or when previous calculations are absent), the indicator resets each buffer to EMPTY_VALUE to prevent visual artifacts.

Per-Bar Processing:
For every new data point, the indicator:

Determines the corresponding bar index for each timeframe using iBarShift.

Calculates the three EMAs (Fast, Slow, Very Slow) using the built-in iMA function.

Classifies the trend condition for each timeframe based on EMA relationships by populating the corresponding buffer with the predefined vertical position.

Label Drawing:
After processing the data, it calls functions that clear any previous label objects and draw new ones for each timeframe along with the computed trend signal. The label text and color are determined using helper functions.

Helper Functions
CalculateTimeframe:
Processes a specific timeframe for the given bar by computing EMA values and updating the correct buffers for trend conditions.

ResetBuffersForTimeframe:
Ensures that prior data is cleared before new calculations are performed on each timeframe buffer.

DrawLabels, CreateTimeframeLabel, CreateTrendLabel:
These functions manage chart label creation for each timeframe to show both the timeframe identifier (e.g., "H1") and the current trend status (e.g., "UP" or "DOWN (Correction)").

GetTrendText & GetTrendColor:
Based on the EMA comparisons, these functions return an appropriate description (text) and a corresponding color for the trend condition, which are then used in the label drawing routines.

Customization Options
Users can modify various input parameters such as:

EMA Periods: Customize the Fast, Slow, and Very Slow EMA periods.

Graphical Parameters: Adjust bar length, row height (vertical spacing), and indicator colors for uptrend, downtrend, and corrective movements.

Applied Price & MA Method: Choose the applied price (default: close) and the moving average method (default: exponential).

Installation
Copy the Source File:
Place the MultiTimeFrame Trend Oscillator.mq4 file into your MQL4/Indicators directory.

Compile the Indicator:
Open the file in MetaEditor and compile it.

Attach to Chart:
In MetaTrader 4, navigate to the Navigator panel, and drag the indicator onto a chart. The indicator opens in a separate window where the trend conditions across multiple timeframes will be displayed.

Usage Notes
Data Synchronization:
The indicator uses the symbol's current timeframe data. For accurate multi-timeframe results, ensure that the historical data for all used timeframes is available.

Visual Interpretation:
The histogram and labels aid in quickly identifying the market’s overall trend and potential corrective moves which traders can use to refine entry and exit points.

Performance:
Given that the indicator processes multiple timeframes per bar, performance may vary with the number of bars loaded and the chart's timeframe. Use with a reasonable data set for optimal performance.

License
This indicator is open-source. Please see the LICENSE file for details regarding permitted usage and distribution.

Credits
Developed by Seif Rached. Contributions, suggestions, and improvements are welcome.
