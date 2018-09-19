# Localization
by David Zhu, 9/19/2018
Data Analysis Part
Run loc.m function with input 1-3: 3 corresponding files in three raspi folders, input 4: lines to read in a file, and input 5: time step, to calculate locations for each MAC address at different time.
This will generate Localization.csv in the current folder. (if file already exists then update it)
Run trace.m function with input 1: the output table from loc.m, and input 2: the specific MAC address (row number) to trace.
This will generate a figure presenting the movement of the user with this MAC address.
