import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

# Parameters
mu = 0
var = 3
sigma = np.sqrt(var)

# x values for the curve
x = np.linspace(mu - 5*sigma, mu + 5*sigma, 1000)
y = norm.pdf(x, mu, sigma)

# Marked points: ±σ, ±2σ, ±4σ
sigmas = np.array([-4, -2, -1, 0, 1, 2, 4]) * sigma
points = [(s, norm.pdf(s, mu, sigma)) for s in sigmas]

# Plot
plt.figure(figsize=(10, 6))
plt.plot(x, y, label='Gaussian N(0, 3)', linewidth=2)

# Plot the points
for px, py in points:
    plt.plot(px, py, 'ro')
    plt.text(px, py + 0.005, f'({px:.2f}, {py:.3f})', ha='center', fontsize=8)

# Connect the points with linear lines
for i in range(len(points) - 1):
    x_vals = [points[i][0], points[i+1][0]]
    y_vals = [points[i][1], points[i+1][1]]
    # Only add label on the first segment
    if i == 0:
        plt.plot(x_vals, y_vals, 'r--', linewidth=1, label='Gaussian approximation')
    else:
        plt.plot(x_vals, y_vals, 'r--', linewidth=1)

plt.title('Piecewise linear approximation of Gaussian distribution')
plt.xlabel('x')
plt.ylabel('Probability Density')
plt.grid(True)
plt.legend()
plt.tight_layout()

plt.savefig('plot-gaussian-lines.png', dpi=300)
