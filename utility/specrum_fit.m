function [alpha_estimated, kernel_spectrum, omega, y_full, omega_selected, y_selected] = ...
    specrum_fit(blurring_kernel, N, feasible_range)

%%  parameter for frequency response (fft) calculation
n_fft = 1024;
stp = 2*pi/(n_fft);
omega = [-pi: stp: pi-stp];

%%
kernel_spectrum = fftshift(fft(blurring_kernel, n_fft));

%%
if false
    snr_level = 1e-3;
    y_full = conj(kernel_spectrum)./(abs(kernel_spectrum).^2 + snr_level);
else
    y_full = 1./kernel_spectrum;
end

%%  polynomial fitting on the frequency domain
indx = zeros(1, n_fft);
for iteration = 1: size(feasible_range, 1)
    indx = or(indx, and(abs(omega) >= feasible_range(iteration, 1)*pi, abs(omega) <= feasible_range(iteration, 2)*pi));
end
omega_selected = omega(indx);
y_selected = y_full(indx);
if false
    figure
    plot(omega_selected, real(y_selected))
    hold on
    plot(omega_selected, imag(y_selected))
    plot(omega_selected, abs(y_selected)); axis tight
end
y_selected = abs(y_selected);
y_full = abs(y_full);

%%
fitting_type_even = [];
iteration = 0;
for n = 0: floor(N/2)
    iteration = iteration + 1;
    if mod(n, 2) == 0
        fitting_type_even = [fitting_type_even, '+a', num2str(n+1),'*x^',num2str(2*n)];
    else
        fitting_type_even = [fitting_type_even, '-a', num2str(n+1),'*x^',num2str(2*n)];
    end
    coeff_strings{iteration} = ['a', num2str(n+1)];
end
%
fitting_type = [fitting_type_even];
g = fittype(fitting_type,'coeff',coeff_strings);
warning off
FO = fit(omega_selected(:), y_selected(:), g); % 'Trust-Region'
warning on
for n = 0: floor(N/2)
    alpha_estimated(n+1) = eval(['FO.a',num2str(n+1)]);
end