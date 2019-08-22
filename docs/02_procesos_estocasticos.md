<font size="30">Procesos estocásticos</font>

# Diapositivas
* Conceptos superbásicos de análisis funcional: [01_Conceptos_superbasicos_de_analisis_funcional.pdf](../diapositivas/01_Conceptos_superbasicos_de_analisis_funcional.pdf)

* Algunas diapositivas sobre procesos estocásticos:  [03_stochastic_processes.pdf](../diapositivas/03_stochastic_processes.pdf)

# Estimación de los parámetros de un proceso estocástico

## Estimación de la función de correlación de un proceso estocástico
Ejemplo 1: [[file:ex_correlation_1.zip]] 
Ejemplo 2: [[file:ex_correlation_2.zip]]

## Estimación de la PSD utilizando métodos no paramétricos
Leer: http://www.mathworks.com/help/signal/ug/nonparametric-methods.html
Ejemplo: [[file:ex_estimation_PSD_nonparametric.m]] 

Bias and Variability in the Periodogram: http://www.mathworks.com/help/signal/ug/bias-and-variability-in-the-periodogram.html (volverlo a realizar, pero esta vez utilizando como sistema uno masa-resorte-amortiguador)

## Estimación de la spectral coherence and cross PSD
Measure signal similarities in the frequency domain by estimating their spectral coherence.
https://en.wikipedia.org/wiki/Coherence_%28signal_processing%29
cpsd = Cross power spectral density
mscohere = Magnitude-squared coherence
Compare the Frequency Content of Two Signals: http://www.mathworks.com/help/signal/ug/compare-the-frequency-content-of-two-signals.html
Cross PSD and Magnitude-Squared Coherence: http://www.mathworks.com/help/signal/ug/cross-spectrum-and-magnitude-squared-coherence.html
Cross PSD estimation: http://www.mathworks.com/help/signal/ref/cpsd.html
Coherence estimation: http://www.mathworks.com/help/signal/ref/mscohere.html
Measuring signal similarities: http://www.mathworks.com/help/signal/ug/measuring-signal-similarities.html

## Estimación de la PSD a partir de datos muestreados no uniformemente o datos faltantes
Compute power spectra of nonuniformly sampled signals or signals with missing samples using the Lomb-Scargle method.
* Lomb-Scargle periodogram: http://www.mathworks.com/help/signal/ref/plomb.html
* http://www.mathworks.com/help/signal/ug/periodogram-of-data-set-with-missing-samples.html
* http://www.mathworks.com/help/signal/examples/spectral-analysis-of-nonuniformly-sampled-signals.html
* http://www.mathworks.com/help/signal/ug/detect-periodicity-in-a-signal-with-missing-samples.html

## Estimación de la PSD utilizando métodos paramétricos
Leer: http://www.mathworks.com/help/signal/ug/parametric-methods.html
Ejemplo 1: [[file:ex_estimation_PSD_parametric1.m]] 
Ejemplo 2: [[file:ex_estimation_PSD_parametric2.m]] 

## Estimación de la PSD utilizando subspace methods
Subspace methods: these methods obtain high-resolution frequency estimates: multiple signal classification (MUSIC) algorithm, pseudospectrum using eigenvector method. Subspace methods do not produce PSD estimates. Subspace methods are most useful for frequency identification and can be sensitive to model-order misspecification.
http://www.mathworks.com/help/signal/subspace-methods.html


-----------

=Conceptos preliminares=
https://en.wikipedia.org/wiki/Riemann-tieltjes_integral
https://en.wikipedia.org/wiki/Lebesgue-Stieltjes_integration
https://en.wikipedia.org/wiki/Fourier_transform#Fourier-Stieltjes_transform

https://en.wikipedia.org/wiki/Random_variable





https://en.wikipedia.org/wiki/Stochastic_process

https://en.wikipedia.org/wiki/Continuous-time_stochastic_process
https://en.wikipedia.org/wiki/Discrete-time_stochastic_process

https://en.wikipedia.org/wiki/Kolmogorov_extension_theorem

thtps://en.wikipedia.org/wiki/Correlation_function
https://en.wikipedia.org/wiki/Autocorrelation
https://en.wikipedia.org/wiki/Autocovariance
https://en.wikipedia.org/wiki/Cross-correlation

https://en.wikipedia.org/wiki/Cauchy-Schwarz_inequality (ver la sección "Probability theory")

https://en.wikipedia.org/wiki/Characteristic_function_(probability_theory)
https://en.wikipedia.org/wiki/Probability-generating_function
https://en.wikipedia.org/wiki/Moment-generating_function
https://en.wikipedia.org/wiki/Cumulant

=2.4 Classification based upon regularity=
=2.4.1 Stationary and weakly stationary processes=
https://en.wikipedia.org/wiki/Stationary_process

==Ejemplo 2.6:==
https://en.wikipedia.org/wiki/Burst_noise (esto es Random Telegraph Signal)
https://en.wikipedia.org/wiki/Telegraph_process

https://en.wikipedia.org/wiki/Poisson_point_process
https://en.wikipedia.org/wiki/Counting_process

==Ejemplo 2.8:==
https://en.wikipedia.org/wiki/Complex_number#Polar_form
https://en.wikipedia.org/wiki/Covariance_matrix#Complex_random_vectors

==Ejemplo 2.10:==
Programa de MAXIMA para obtener la ecuación 2.80
[[code]]
kill(all);
Y1 : (U - %i*V)/2;
Y2 : (U + %i*V)/2;
w1 :  w;
w2 : -w;

X : Y1*exp(%i*w1*t) + Y2*exp(%i*w2*t);

/* trigrat: trigonometric simplification (canonical form) */
trigrat(X); 
[[code]]

=2.4.2 Spectral density function and correlation function=
https://en.wikipedia.org/wiki/Uniform_continuity

==Spectral representation theorem for weakly stationary processes==
https://en.wikipedia.org/wiki/Absolute_continuity
http://www.stat.tamu.edu/~suhasini/teaching673/spectral_representations.pdf
http://link.springer.com/chapter/10.1007%2F978-3-662-45750-4_3

==Theorem 2.1:==
https://en.wikipedia.org/wiki/Bochner%27s_theorem
https://en.wikipedia.org/wiki/Spectral_density#Power_spectral_density
https://en.wikipedia.org/wiki/Wiener-Khinchin_theorem

==Some one sided spectral density==
[[code]]
kill(all);

/* Binary noise */
assume(lambda>0);
R(tau) := s^2*exp(-lambda*abs(tau));
G : (2/%pi)*integrate(R(tau)*cos(w*tau), tau, 0, inf);

/* First order Markov Process and Random Telegraph Signal (da diferente que el libro) */
assume(Delta>0);
R(tau) := s^2*(1 - abs(tau)/Delta);
G : (2/%pi)*integrate(R(tau)*cos(w*tau), tau, 0, Delta);

/* Second order Markov Process */
assume(lambda>0);
R(tau) := s^2*exp(-lambda*abs(tau))*(1 + lambda*abs(tau));
G : factor((2/%pi)*integrate(R(tau)*cos(w*tau), tau, 0, inf));
[[code]]

https://en.wikipedia.org/wiki/Dirac_delta_function
https://en.wikipedia.org/wiki/White_noise

=2.4.3 Ergodicity=
https://en.wikipedia.org/wiki/Stationary_ergodic_process
https://en.wikipedia.org/wiki/Ergodic_process

https://en.wikipedia.org/wiki/Almost_surely  (if it happens with probability one)
https://en.wikipedia.org/wiki/Almost_everywhere

https://en.wikipedia.org/wiki/Convergence_of_random_variables
https://en.wikipedia.org/wiki/Convergence_of_random_variables#Convergence_in_probability (se utiliza en la ec 2.121)

==Example 2.13:==
Programa de MAXIMA para realizar el cálculo
[[code]]
R(tau) := s^2 + m^2;
limit((1/T)*integrate((1 - tau/(2*T))*(R(tau) - m^2), tau, 0, 2*T), T, inf);
[[code]]

==Example 2.14:==
Programa de MAXIMA para realizar el cálculo
[[code]]
assume(T>0);
assume(lambda>0);
m : 0;
R(tau) := exp(-lambda*abs(tau));
limit((1/T)*integrate((1 - tau/(2*T))*(R(tau) - m^2), tau, 0, 2*T), T, inf);
[[code]]

==Example 2.15:==
[[code]]
kill(all);
assume(T>0);
m : 0;
R(tau) := s^2*cos(tau);
limit((1/T)*integrate((1 - tau/(2*T))*(R(tau) - m^2), tau, 0, 2*T), T, inf);

x : a1*sin(t) + b1*cos(t);
limit((1/(2*T))*integrate(x^2, t, -T, T), T, inf);
[[code]]

=2.5.2 The Markov process=
https://en.wikipedia.org/wiki/Markov_process
https://en.wikipedia.org/wiki/Random_walk
https://en.wikipedia.org/wiki/Chapman-Kolmogorov_equation



http://www.math.uah.edu/stat/processes/Increments.html Processes with stationary independent increments

https://en.wikipedia.org/wiki/Wiener_process
https://en.wikipedia.org/wiki/Poisson_point_process
https://en.wikipedia.org/wiki/Gaussian_process
