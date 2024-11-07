import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from numpy.polynomial.polynomial import Polynomial

# Step 1: Load the data
file_path = 'lala.csv'  # Adjust this path if necessary

# Load data without assuming there is a header
try:
    # Use header=None to indicate that there is no header row in the CSV file
    data = pd.read_csv(file_path, encoding='ISO-8859-1', delimiter=';', header=None)
    print("Data Loaded Successfully")
except Exception as e:
    print(f"Error loading data: {e}")
    exit(1)

# Step 2: Manually assign column names since there is no header in the file
data.columns = ['grader', 'nucelous']

# Step 3: Extract relevant columns ('grader' and 'nucelous')
grader = pd.to_numeric(data['grader'], errors='coerce')  # Convert 'grader' to numeric
nucelous = pd.to_numeric(data['nucelous'], errors='coerce')  # Convert 'nucelous' to numeric

# Step 4: Filter out invalid (NaN) data
valid_data = grader.notna() & nucelous.notna()
grader_clean = grader[valid_data]
nucelous_clean = nucelous[valid_data]

# Step 5: Create bins for grader values and calculate mean nucelous values per bin
bins = np.linspace(grader_clean.min(), grader_clean.max(), 30)  # Adjust number of bins if needed
bin_indices = np.digitize(grader_clean, bins)  # Get bin indices for each grader value

# Calculate the mean nucelous value for each bin
bin_means = [nucelous_clean[bin_indices == i].mean() for i in range(1, len(bins))]

# Mean and standard deviation for bell curve calculations
mean_nucelous = np.mean(nucelous_clean)
std_nucelous = np.std(nucelous_clean)

# Prepare x values for the bell curve
domains = np.linspace(grader_clean.min(), grader_clean.max(), 100)
bell_curve = (1/(std_nucelous * np.sqrt(2 * np.pi))) * np.exp(-0.5 * ((domains - mean_nucelous) / std_nucelous)**2)

# Step 6: Fit a polynomial regression for a smooth trendline
degree = 3  # Degree of the polynomial (adjust if needed)
p = Polynomial.fit(grader_clean, nucelous_clean, degree)

# Generate smooth x values (domains) and corresponding y values using the polynomial fit
trendline_x = np.linspace(grader_clean.min(), grader_clean.max(), 100)
trendline_y = p(trendline_x)

# Step 7: Plotting the bar chart with bell curve overlay and trendline
plt.figure(figsize=(10, 6))

# Create the bar chart
plt.bar(bins[:-1], bin_means, width=np.diff(bins), align='edge', color='b', edgecolor='black', alpha=0.6)

# Bell curve overlay - Normalize bell_curve for better visualization on the same axes
normalized_bell_curve = bell_curve / np.max(bell_curve) * np.max(bin_means)  # Scale to max bin mean
plt.plot(domains, normalized_bell_curve, color='red', linewidth=2)

# Plot the smooth polynomial trendline over the entire range of x values (grader), now in red
plt.plot(trendline_x, trendline_y, color='red', linewidth=2)

# Customize the plot
plt.title('Nucelous Values vs Degrees with Polynomial Trendline')
plt.xlabel('Degrees')  # Simplified axis label to just "Degrees"
plt.ylabel('Mean Nucelous Value')

# Adjust y-axis to start at minimum nucelous value instead of zero to remove whitespace below bars
plt.ylim(min(bin_means), np.max(bin_means) * 1.1)

plt.grid(True)

# Show the plot without legend or notes in top-right corner
plt.show()
