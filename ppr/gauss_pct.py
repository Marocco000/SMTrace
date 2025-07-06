import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

# Parameters
mu = 0
var = 3
sigma = np.sqrt(var)

# x-axis range
x = np.linspace(mu - 5*sigma, mu + 5*sigma, 1000)

# Gaussian distribution
y = norm.pdf(x, mu, sigma)

# Points to mark
points = np.array([1, 2, 4]) * sigma
points = np.concatenate([-points[::-1], [0], points])

# Plot
plt.figure(figsize=(10, 6))
plt.plot(x, y, label='Gaussian N(0, 3)', linewidth=2)
plt.axhline(0, color='black', linewidth=0.5)

# Mark points
for pt in points:
    plt.axvline(pt, color='red', linestyle='--', alpha=0.6)
    plt.plot(pt, norm.pdf(pt, mu, sigma), 'ro')
    plt.text(pt, norm.pdf(pt, mu, sigma) + 0.005, f'{pt:.2f}', ha='center')

plt.title('Gaussian Distribution N(0, 3) with ±σ, ±2σ, ±4σ')
plt.xlabel('x')
plt.ylabel('Probability Density')
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.savefig('plot-gaussian-points.png', dpi=300)
