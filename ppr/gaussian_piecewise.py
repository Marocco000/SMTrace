import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

# Parameters
mean = 0
variance = 3
std_dev = np.sqrt(variance)

# Range of i values
i_vals = np.arange(-3, 4)

# Compute corresponding x and y values on the Gaussian
x_points = mean + i_vals * std_dev
# y_points = norm.pdf(x_points, mean, std_dev)
y_points = 1 / (std_dev * 2.5066) * np.exp(-i_vals*i_vals * std_dev * std_dev / 8)

# Plot the connected points
plt.figure(figsize=(8, 4))
plt.plot(x_points, y_points, marker='o', linestyle='-', color='green', linewidth=2, label='Sampled Points')
plt.xticks(x_points, labels=[f'μ{"+%d" % i if i > 0 else "" if i == 0 else "%d" % i}σ' for i in i_vals])

# Annotate each point with the exponential expression
for i, (x, y) in zip(i_vals, zip(x_points, y_points)):
    label = rf'$\exp\left(\frac{{-\sigma^2 + {i}^2}}{{8}}\right)$'
    plt.text(x, y + 0.01, label, ha='center', fontsize=8, color='green')

# Final touches
plt.title('Connected Points on Gaussian Distribution')
plt.xlabel('x (scaled by σ)')
plt.ylabel('Probability Density')
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.savefig('approx.png', dpi=300)
