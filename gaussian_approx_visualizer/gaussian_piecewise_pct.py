# import numpy as np
# import matplotlib.pyplot as plt
# from scipy.stats import norm
#
# # Parameters
# mean = 0
# variance = 3
# std_dev = np.sqrt(variance)
#
# # Generate x values
# x = np.linspace(mean - 4*std_dev, mean + 4*std_dev, 500)
#
# # Compute the Gaussian PDF
# y = norm.pdf(x, mean, std_dev)
#
# # Mark mean and ± std_dev
# plt.axvline(mean, color='red', linestyle='--', linewidth=1)
# plt.axvline(mean - std_dev, color='gray', linestyle=':', linewidth=1)
# plt.axvline(mean + std_dev, color='gray', linestyle=':', linewidth=1)
#
# # Annotate the lines
# plt.text(mean, max(y)*0.9, 'Mean (0)', ha='center', color='red')
# plt.text(mean - std_dev, max(y)*0.6, '-1 SD', ha='center', color='gray')
# plt.text(mean + std_dev, max(y)*0.6, '+1 SD', ha='center', color='gray')
#
# # Plot
# plt.figure(figsize=(8, 4))
# plt.plot(x, y, label=f'N(0, 3)', linewidth=2)
# plt.title('Gaussian Distribution (Mean=0, Variance=3)')
# plt.xlabel('x')
# plt.ylabel('Probability Density')
# plt.grid(True)
# plt.legend()
# plt.tight_layout()
# plt.savefig('ploty2.png', dpi=300)

# import numpy as np
# import matplotlib.pyplot as plt
# from scipy.stats import norm
#
# # Parameters
# mean = 0
# variance = 9
# std_dev = np.sqrt(variance)
#
# # Generate x values
# x = np.linspace(mean - 4*std_dev, mean + 4*std_dev, 500)
#
# # Compute the Gaussian PDF
# y = norm.pdf(x, mean, std_dev)
#
# # Plot
# plt.figure(figsize=(8, 4))
# plt.plot(x, y, label='N(0, 3)', linewidth=2)
#
# # Mark mean and ± std_dev
# plt.axvline(mean, color='red', linestyle='--', linewidth=1)
# plt.axvline(mean - std_dev, color='gray', linestyle=':', linewidth=1)
# plt.axvline(mean + std_dev, color='gray', linestyle=':', linewidth=1)
#
# # Annotate the lines
# plt.text(mean, max(y)*0.9, 'Mean (0)', ha='center', color='red')
# plt.text(mean - std_dev, max(y)*0.6, '-1 SD', ha='center', color='gray')
# plt.text(mean + std_dev, max(y)*0.6, '+1 SD', ha='center', color='gray')
#
# # Labels and saving
# plt.title('Gaussian Distribution (Mean=0, Variance=3)')
# plt.xlabel('x')
# plt.ylabel('Probability Density')
# plt.grid(True)
# plt.legend()
# plt.tight_layout()
# plt.savefig('gaussian_distribution_with_markers.png', dpi=300)

import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

# Parameters
mean = 0
variance = 3
std_dev = np.sqrt(variance)

# Generate x values
x = np.linspace(mean - 4*std_dev, mean + 4*std_dev, 500)

# Compute the Gaussian PDF
y = norm.pdf(x, mean, std_dev)

# Plot
plt.figure(figsize=(8, 4))
plt.plot(x, y, label='N(0, 3)', linewidth=2)

# Mark mean and ± std_dev
plt.axvline(mean, color='red', linestyle='--', linewidth=1)
plt.axvline(mean - std_dev, color='gray', linestyle=':', linewidth=1)
plt.axvline(mean + std_dev, color='gray', linestyle=':', linewidth=1)

# Annotate mean and std dev lines
plt.text(mean, max(y)*0.9, 'Mean (0)', ha='center', color='red')
plt.text(mean - std_dev, max(y)*0.6, r'$-1\sigma$', ha='center', color='gray')
plt.text(mean + std_dev, max(y)*0.6, r'$+1\sigma$', ha='center', color='gray')

# for i in range(0,3):
#     # Mark mean + 3*std_dev
#     x_point = mean + 3*std_dev
#     y_point = norm.pdf(x_point, mean, std_dev)
#
#     plt.plot(x_point, y_point, marker='x', color='blue', markersize=8, label='Marked point')
#     plt.text(x_point, y_point + 0.05,
#              r'$ \exp\left(\frac{-\sigma^2 + 3^2}{8}\right)$',
#              ha='center', color='blue', fontsize=9)

# Mark and annotate points at mu + i*sigma
for i in range(-3, 4):
    x_point = mean + i * std_dev
    # y_point = norm.pdf(x_point, mean, std_dev)
    y_point = 1/(std_dev * 2.5066) * np.exp(-i * i * std_dev * std_dev/ 8)
    # Plot marker
    plt.plot(x_point, y_point, marker='x', color='blue', markersize=8)

    # Dynamic formula label
    formula = rf'$\exp\left(\frac{{-\sigma^2 \cdot {i}^2}}{{8}}\right)$'

    y_offset = 0.03 + 0.005 * abs(i)  # more offset for outer points
    ha = 'left' if i < 0 else 'right' if i > 0 else 'center'

    # Raise text to avoid overlap
    plt.text(x_point, y_point + y_offset, formula,
             ha='center', color='blue', fontsize=9)

# Labels and saving
plt.title('Gaussian Distribution (Mean=0, Variance=3)')
plt.xlabel('x')
plt.ylabel('Probability Density')
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.savefig('gaussian_with_formula_label.png', dpi=300)