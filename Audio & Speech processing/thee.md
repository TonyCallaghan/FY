# Assignment 1: Discrete Fourier Transform (DFT) and Short-Time Fourier Transform (STFT)

## Part A: Coding (Use Jupyter Notebook)


### Task 1: Discrete Fourier Transform (DFT)
#### Signal Creation: 
- Create a time series input with 200 sample points (representing 1 second of audio at a sampling rate of 200 Hz).
- Generate a composite signal that includes a fundamental sin/cos wave and at least 3 harmonics.


#### Manual DFT Calculation:
- Manually compute the DFT of your signal using complex exponential and matrix multiplication methods. You can refer to the DFT Python code provided in Moodle for guidance.
- Use the `numpy.fft` function to compute the DFT of the same signal.
- Compare your manually calculated DFT with the output from `numpy.fft` to verify.
- Measure and compare the computation time between the manual DFT and `numpy.fft`.
 
#### Visualization:
- Plot all the necessary steps. You can use matplotlib or seaborn.

### Task 2: Short-Time Fourier Transform (STFT)
#### Signal Creation: 
- Generate a chirp signal using `scipy.signal.chirp.` (1000 or more samples points)
#### STFT Computation:
- Extend your previous code to manually compute the STFT of the chirp signal. You can use `numpy.fft` for computing DFT. Utilize the
Hanning window function from `numpy` for windowing.

#### Visualization:
- Use a colormap to visualize the calculated magnitude STFT of the chirp signal.

  
*Note: Comment your code thoroughly to explain each step of the process.*
